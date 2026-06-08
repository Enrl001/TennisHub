import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/models/models.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/coach_provider.dart';

class AddSlotScreen extends ConsumerStatefulWidget {
  const AddSlotScreen({super.key, this.serviceId});

  final String? serviceId;

  @override
  ConsumerState<AddSlotScreen> createState() => _AddSlotScreenState();
}

class _AddSlotScreenState extends ConsumerState<AddSlotScreen> {
  static const _pageBg = Color(0xFFF5F6F8);

  DateTime? _selectedDate = DateTime.now();
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  String? _selectedServiceId;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _selectedServiceId = widget.serviceId;
  }

  Service? _selectedService(List<Service> services) {
    for (final service in services) {
      if (service.id == _selectedServiceId) return service;
    }
    return null;
  }

  int _durationForSelectedService(List<Service> services) {
    final service = _selectedService(services);
    final duration = service?.durationMinutes ?? 60;
    return duration > 0 ? duration : 60;
  }

  TimeOfDay _endTimeForDuration(int durationMinutes) {
    final safeDuration = durationMinutes > 0 ? durationMinutes : 60;
    final totalMinutes =
        (_startTime.hour * 60) + _startTime.minute + safeDuration;
    return TimeOfDay(
      hour: (totalMinutes ~/ 60) % 24,
      minute: totalMinutes % 60,
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (picked != null) {
      setState(() => _startTime = picked);
    }
  }

  Future<void> _create() async {
    final locale = ref.read(localeProvider);
    final isMn = locale == 'mn';
    if (_selectedServiceId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isMn
                ? 'Эхлээд үйлчилгээ сонгоно уу'
                : 'Please select a service first',
          ),
        ),
      );
      return;
    }
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isMn ? 'Огноо сонгоно уу' : 'Please select a date'),
        ),
      );
      return;
    }

    final l10n = AppLocalizations.of(context);
    setState(() => _loading = true);
    try {
      final services = await ref.read(myCoachServicesProvider.future);
      final durationMinutes = _durationForSelectedService(services);
      final profile = ref.read(currentProfileProvider);
      if (profile == null) return;
      final coachId = await ref
          .read(coachProfileProvider.notifier)
          .ensureCoachRecord(profile.id);
      final date = _selectedDate!;
      final start = DateTime(
        date.year,
        date.month,
        date.day,
        _startTime.hour,
        _startTime.minute,
      );
      final end = start.add(Duration(minutes: durationMinutes));
      final slot = <String, dynamic>{
        'coach_id': coachId,
        'service_id': _selectedServiceId,
        'starts_at': start.toIso8601String(),
        'ends_at': end.toIso8601String(),
        'booked_count': 0,
        'is_cancelled': false,
      };

      await ref.read(coachProfileProvider.notifier).addTimeSlots([slot]);

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.slotCreated)));
      context.pop();
    } on DuplicateCoachSlotException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.duplicateSlot),
          backgroundColor: AppColors.statusCancelled,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      final message = e.toString().contains('time_slots_coach_service_start_unique') ||
              e.toString().contains('duplicate key')
          ? l10n.duplicateSlot
          : (isMn
              ? 'Цаг нэмэж чадсангүй. Дахин оролдоно уу.'
              : 'Could not add slot. Please try again.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.statusCancelled,
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final isMn = locale == 'mn';
    final servicesAsync = ref.watch(myCoachServicesProvider);

    return Scaffold(
      backgroundColor: _pageBg,
      appBar: AppBar(
        backgroundColor: _pageBg,
        title: Text(isMn ? 'Хичээл нийтлэх' : 'Session'),
      ),
      body: SafeArea(
        child: servicesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => _EmptyServices(isMn: isMn),
          data: (services) {
            if (_selectedServiceId != null &&
                !services.any((s) => s.id == _selectedServiceId)) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) setState(() => _selectedServiceId = null);
              });
            }

            final selectedService = _selectedService(services);
            final durationMinutes = _durationForSelectedService(services);
            final endTime = _endTimeForDuration(durationMinutes);
            final price = selectedService?.priceAmount;
            final currency = selectedService?.currency ?? 'USD';
            final capacity = selectedService?.maxParticipants ?? 1;

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
              children: [
                Text(
                  isMn ? 'Хичээл' : 'Session',
                  style: const TextStyle(
                    color: Color(0xFF181A20),
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isMn
                      ? 'Клубын гишүүдэд зориулж шинэ цаг нийтлээрэй.'
                      : 'Schedule a new training session for club members.',
                  style: const TextStyle(
                    color: Color(0xFF3F453E),
                    fontSize: 16,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFD8DDCD)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FieldLabel(isMn ? 'Үйлчилгээ' : 'Service'),
                      DropdownButtonFormField<String>(
                        value: _selectedServiceId,
                        decoration: InputDecoration(
                          hintText: isMn
                              ? 'Үйлчилгээ сонгох'
                              : 'Select service',
                        ),
                        items: services
                            .map(
                              (service) => DropdownMenuItem(
                                value: service.id,
                                child: Text(
                                  isMn
                                      ? (service.titleMn ?? service.title)
                                      : service.title,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: services.isEmpty
                            ? null
                            : (value) =>
                                  setState(() => _selectedServiceId = value),
                      ),
                      if (services.isEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          isMn ? 'Үйлчилгээ алга' : 'No services yet',
                          style: const TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 13,
                          ),
                        ),
                      ],
                      const SizedBox(height: 18),
                      _FieldLabel(isMn ? 'Огноо' : 'Date'),
                      _PickerField(
                        text: _selectedDate == null
                            ? 'dd/mm/yyyy'
                            : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                        icon: Icons.calendar_today_outlined,
                        onTap: _pickDate,
                      ),
                      const SizedBox(height: 18),
                      _FieldLabel(isMn ? 'Эхлэх цаг' : 'Start Time'),
                      _PickerField(
                        text: _startTime.format(context),
                        icon: Icons.schedule,
                        onTap: _pickStartTime,
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: _ReadOnlyMetric(
                              label: isMn ? 'Үргэлжлэх хугацаа' : 'Duration',
                              value: '$durationMinutes min',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ReadOnlyMetric(
                              label: isMn ? 'Дуусах цаг' : 'End Time',
                              value: endTime.format(context),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _ReadOnlyMetric(
                              label: isMn ? 'Үнэ' : 'Price',
                              value:
                                  '${price?.toStringAsFixed(0) ?? '0'} $currency',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ReadOnlyMetric(
                              label: isMn ? 'Хүчин чадал' : 'Max Capacity',
                              value: '$capacity',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      ElevatedButton.icon(
                        onPressed: _loading ? null : _create,
                        icon: _loading
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFF1A3A10),
                                ),
                              )
                            : const Icon(Icons.send_outlined),
                        label: Text(
                          isMn ? 'Хичээл нийтлэх' : 'Publish Session',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _EmptyServices extends StatelessWidget {
  const _EmptyServices({required this.isMn});

  final bool isMn;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        isMn ? 'Үйлчилгээ алга' : 'No services yet',
        style: const TextStyle(color: Color(0xFF9CA3AF)),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF41506B),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _PickerField extends StatelessWidget {
  const _PickerField({
    required this.text,
    required this.icon,
    required this.onTap,
  });

  final String text;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFBFC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFD8DDCD)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Color(0xFF1F2933), fontSize: 15),
              ),
            ),
            Icon(icon, size: 18, color: const Color(0xFF111827)),
          ],
        ),
      ),
    );
  }
}

class _ReadOnlyMetric extends StatelessWidget {
  const _ReadOnlyMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFBFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD8DDCD)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF647086),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF181A20),
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
