import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/extensions.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/models/models.dart';
import '../../../shared/widgets/slot_picker.dart';
import '../../booking/providers/booking_provider.dart';
import '../../../shared/extensions/local_ext.dart';

class BookingScreen extends ConsumerStatefulWidget {
  const BookingScreen({super.key, required this.serviceId});

  final String serviceId;

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  TimeSlot? _selectedSlot;
  bool _loading = false;

  Future<void> _proceed(Service service) async {
    if (_selectedSlot == null) return;
    setState(() => _loading = true);
    try {
      final booking = await ref.read(bookingProvider.notifier).createBooking(
            slotId: _selectedSlot!.id,
            serviceId: service.id,
            coachId: service.coachId,
            amount: service.priceAmount ?? 0,
            currency: service.currency ?? 'USD',
          );
      if (!mounted) return;
      context.push(
        '/payment/${booking.id}',
        extra: {'amount': service.priceAmount ?? 0, 'currency': service.currency ?? 'USD'},
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.statusCancelled));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final slotsAsync = ref.watch(serviceSlotsProvider(widget.serviceId));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.selectSlot)),
      body: slotsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, __) => Center(child: Text(e.toString())),
        data: (slots) {
          if (slots.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.event_busy, size: 56, color: Colors.grey),
                  const SizedBox(height: 12),
                  Text(l10n.noBookingsToday, style: const TextStyle(color: Colors.grey, fontSize: 16)),
                ],
              ),
            );
          }
          final service = slots.first.service;
          final maxParticipants = service?.maxParticipants ?? 1;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (service != null) ...[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(children: [
                                Expanded(child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(service.localTitle(locale),
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                                    if (service.durationMinutes != null)
                                      Text(l10n.minutes(service.durationMinutes!),
                                          style: const TextStyle(color: Colors.grey, fontSize: 13)),
                                  ],
                                )),
                                if (service.priceAmount != null)
                                  Text(
                                    '${service.priceAmount!.toStringAsFixed(0)} ${service.currency ?? 'USD'}',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                              ]),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                      const SizedBox(height: 8),
                      SlotPicker(
                        slots: slots,
                        maxParticipants: maxParticipants,
                        onSlotSelected: (s) => setState(() => _selectedSlot = s),
                      ),
                      if (_selectedSlot != null) ...[
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(l10n.bookingDetails,
                                      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 12),
                                  _DetailRow(label: l10n.date, value: _selectedSlot!.startsAt.toDisplayDate()),
                                  const SizedBox(height: 6),
                                  _DetailRow(label: l10n.time, value:
                                      '${_selectedSlot!.startsAt.toDisplayTime()} – ${_selectedSlot!.endsAt.toDisplayTime()}'),
                                  if (service != null) ...[
                                    const SizedBox(height: 6),
                                    _DetailRow(label: l10n.total,
                                        value: '${service.priceAmount?.toStringAsFixed(0) ?? '0'} ${service.currency ?? 'USD'}'),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: (_selectedSlot == null || _loading || service == null)
                      ? null
                      : () => _proceed(service),
                  child: _loading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text(l10n.proceed),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      );
}
