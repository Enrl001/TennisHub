import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/coach_provider.dart';

class AddSlotScreen extends ConsumerStatefulWidget {
  const AddSlotScreen({super.key, this.serviceId});

  final String? serviceId;

  @override
  ConsumerState<AddSlotScreen> createState() => _AddSlotScreenState();
}

class _AddSlotScreenState extends ConsumerState<AddSlotScreen> {
  final _selectedDates = <DateTime>{};
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 10, minute: 0);
  DateTime _focusedDay = DateTime.now();
  bool _loading = false;

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Future<void> _create() async {
    if (_selectedDates.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one date')));
      return;
    }
    final l10n = AppLocalizations.of(context);
    setState(() => _loading = true);
    try {
      final profile = ref.read(currentProfileProvider);
      if (profile == null) return;
      final coachId = await ref
          .read(coachProfileProvider.notifier)
          .ensureCoachRecord(profile.id);

      final slots = _selectedDates.map((date) {
        final start = DateTime(date.year, date.month, date.day,
            _startTime.hour, _startTime.minute);
        final end = DateTime(
            date.year, date.month, date.day, _endTime.hour, _endTime.minute);
        return <String, dynamic>{
          'coach_id': coachId,
          if (widget.serviceId != null) 'service_id': widget.serviceId,
          'starts_at': start.toIso8601String(),
          'ends_at': end.toIso8601String(),
          'booked_count': 0,
          'is_cancelled': false,
        };
      }).toList();

      await ref.read(coachProfileProvider.notifier).addTimeSlots(slots);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.slotCreated)));
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: AppColors.statusCancelled,
      ));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.addSlot)),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TableCalendar(
                      firstDay: DateTime.now(),
                      lastDay: DateTime.now().add(const Duration(days: 365)),
                      focusedDay: _focusedDay,
                      calendarFormat: CalendarFormat.month,
                      selectedDayPredicate: (day) => _selectedDates
                          .any((d) => isSameDay(d, day)),
                      onDaySelected: (selected, focused) {
                        setState(() {
                          _focusedDay = focused;
                          final existing = _selectedDates
                              .where((d) => isSameDay(d, selected))
                              .toList();
                          if (existing.isNotEmpty) {
                            _selectedDates.removeWhere((d) => isSameDay(d, selected));
                          } else {
                            _selectedDates.add(selected);
                          }
                        });
                      },
                      onPageChanged: (focused) =>
                          setState(() => _focusedDay = focused),
                      calendarStyle: CalendarStyle(
                        selectedDecoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        markerDecoration: const BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      headerStyle: const HeaderStyle(formatButtonVisible: false),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_selectedDates.isNotEmpty) ...[
                            Text('${_selectedDates.length} date(s) selected',
                                style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary)),
                            const SizedBox(height: 16),
                          ],
                          Row(children: [
                            Expanded(
                              child: _TimeTile(
                                label: l10n.startTime,
                                time: _startTime,
                                onTap: () => _pickTime(true),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _TimeTile(
                                label: l10n.endTime,
                                time: _endTime,
                                onTap: () => _pickTime(false),
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: _loading ? null : _create,
                child: _loading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text(l10n.createSlot),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeTile extends StatelessWidget {
  const _TimeTile({required this.label, required this.time, required this.onTap});
  final String label;
  final TimeOfDay time;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 4),
              Text(
                time.format(context),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      );
}
