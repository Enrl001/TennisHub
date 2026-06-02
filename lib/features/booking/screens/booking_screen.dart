import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/extensions/local_ext.dart';
import '../../../shared/models/models.dart';
import '../../../shared/widgets/slot_picker.dart';
import '../booking_flow.dart';
import '../providers/booking_provider.dart';

class BookingScreen extends ConsumerStatefulWidget {
  const BookingScreen({super.key, required this.serviceId});

  final String serviceId;

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  TimeSlot? _selectedSlot;
  bool _loading = false;
  bool _slotsRefreshed = false;

  String get _serviceId {
    final raw = widget.serviceId.trim();
    return isValidUuid(raw) ? normalizeUuid(raw) : raw;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_slotsRefreshed) return;
    _slotsRefreshed = true;
    ref.invalidate(serviceSlotsProvider(_serviceId));
  }

  String _bookingErrorMessage(Object error, String locale) {
    final message = error.toString();
    final normalizedMessage = message.toLowerCase();
    final isMn = locale == 'mn';
    if (message.contains('time_slot_unavailable') ||
        message.contains('Time slot not found') ||
        (normalizedMessage.contains('foreign key constraint') &&
            normalizedMessage.contains('slot_id'))) {
      return isMn
          ? 'Энэ цаг боломжгүй болсон байна. Өөр цаг сонгоно уу.'
          : 'This time slot is no longer available. Please choose another slot.';
    }
    if (message.contains('time_slot_full') ||
        message.contains('Not enough available places') ||
        message.contains('already full')) {
      return isMn
          ? 'Энэ цагийн сул орон зай дууссан байна.'
          : 'This time slot is already full.';
    }
    if (message.contains('profile_missing')) {
      return isMn
          ? 'Профайл бүртгэл дутуу байна. Гараад дахин нэвтэрнэ үү.'
          : 'Your profile is not set up. Please sign out and sign in again.';
    }
    if (message.contains('booking_permission_denied')) {
      return isMn
          ? 'Захиалга хийх эрхгүй байна. Админтай холбогдоно уу.'
          : 'Booking could not be saved (server permissions). Ask admin to run the latest database migration.';
    }
    if (message.contains('invalid_booking_id') ||
        message.contains('invalid_booking_ids')) {
      return isMn
          ? 'Захиалгын мэдээлэл буруу байна. Дахин цаг сонгоно уу.'
          : 'Invalid booking data. Please re-select a time slot.';
    }
    if (message.contains('booking_rpc_missing')) {
      return isMn
          ? 'Серверийн шинэчлэл хэрэгтэй. supabase db push ажиллуулна уу.'
          : 'Server update required. Run: supabase db push';
    }
    if (message.startsWith('Exception: booking_failed:')) {
      final detail = message.replaceFirst('Exception: booking_failed:', '').trim();
      if (detail.isNotEmpty && detail.length < 120) {
        return isMn ? 'Алдаа: $detail' : detail;
      }
    }
    return isMn
        ? 'Захиалга илгээж чадсангүй. Дахин оролдоно уу.'
        : 'Could not complete booking. Please try again.';
  }

  Future<void> _book(Service service) async {
    if (_selectedSlot == null) return;
    setState(() => _loading = true);
    final locale = Localizations.localeOf(context).languageCode;
    try {
      final slot = _selectedSlot!;
      final slotId = tryResolveUuid(slot.id) ?? slot.id.trim();
      final serviceId = tryResolveUuid(service.id) ?? service.id.trim();
      final coachId =
          tryResolveUuid(slot.coachId) ??
          tryResolveUuid(service.coachId) ??
          slot.coachId.trim();
      final booking = await ref.read(bookingProvider.notifier).createBooking(
            slotId: slotId,
            serviceId: serviceId,
            coachId: coachId,
            amount: service.priceAmount ?? 0,
            currency: service.currency ?? AppConstants.defaultCurrency,
          );
      if (!mounted) return;
      navigateAfterBooking(context, booking: booking, service: service);
    } catch (e) {
      if (!mounted) return;
      ref.invalidate(serviceSlotsProvider(service.id));
      setState(() => _selectedSlot = null);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_bookingErrorMessage(e, locale)),
          backgroundColor: AppColors.statusCancelled,
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final serviceAsync = ref.watch(serviceDetailProvider(_serviceId));
    final slotsAsync = ref.watch(serviceSlotsProvider(_serviceId));

    return Scaffold(
      backgroundColor: HubStyle.pageBg,
      appBar: AppBar(
        backgroundColor: HubStyle.pageBg,
        title: Text(
          l10n.selectSlot,
          style: const TextStyle(
            color: HubStyle.hubOlive,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
          ),
        ),
        iconTheme: const IconThemeData(color: HubStyle.hubOlive),
      ),
      body: serviceAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (service) {
          if (service == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  locale == 'mn'
                      ? 'Үйлчилгээ олдсонгүй. Буцаад дахин оролдоно уу.'
                      : 'Service not found. Please go back and try again.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return slotsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => _EmptySlots(locale: locale),
            data: (slots) {
              final maxParticipants = service.maxParticipants ?? 1;
              final hasSlots = slots.isNotEmpty;
              final selectedSlot =
                  hasSlots &&
                      _selectedSlot != null &&
                      slots.any((slot) => slot.id == _selectedSlot!.id)
                  ? _selectedSlot
                  : null;
              if (_selectedSlot != null && selectedSlot == null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) setState(() => _selectedSlot = null);
                });
              }

              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _ServiceSummary(service: service, locale: locale),
                          const SizedBox(height: 16),
                          if (hasSlots)
                            SlotPicker(
                              slots: slots,
                              maxParticipants: maxParticipants,
                              onSlotSelected: (slot) =>
                                  setState(() => _selectedSlot = slot),
                            )
                          else
                            _EmptySlots(locale: locale),
                          if (selectedSlot != null) ...[
                            const SizedBox(height: 16),
                            _BookingDetails(
                              slot: selectedSlot,
                              service: service,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  if (selectedSlot != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _loading ? null : () => _book(service),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: HubStyle.hubOlive,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _loading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  l10n.book,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _ServiceSummary extends StatelessWidget {
  const _ServiceSummary({required this.service, required this.locale});

  final Service service;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: HubStyle.cardBorder),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.localTitle(locale),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (service.durationMinutes != null)
                    Text(
                      l10n.minutes(service.durationMinutes!),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                ],
              ),
            ),
            if (service.priceAmount != null)
              Text(
                '${service.priceAmount!.toStringAsFixed(0)} ${service.currency ?? 'USD'}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _EmptySlots extends StatelessWidget {
  const _EmptySlots({required this.locale});

  final String locale;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.event_busy, size: 56, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              locale == 'mn'
                  ? 'Цагийн хуваарь алга'
                  : 'No time slots available',
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingDetails extends StatelessWidget {
  const _BookingDetails({required this.slot, required this.service});

  final TimeSlot slot;
  final Service service;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dateFormat = DateFormat('EEE, MMM d, yyyy');
    final timeFormat = DateFormat('h:mm a');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: HubStyle.cardBorder),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.bookingDetails,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            _DetailRow(
              label: l10n.date,
              value: dateFormat.format(slot.startsAt),
            ),
            const SizedBox(height: 6),
            _DetailRow(
              label: l10n.time,
              value:
                  '${timeFormat.format(slot.startsAt)} - ${timeFormat.format(slot.endsAt)}',
            ),
            const SizedBox(height: 6),
            _DetailRow(
              label: l10n.total,
              value:
                    '${service.priceAmount?.toStringAsFixed(0) ?? '0'} ${service.currency ?? AppConstants.defaultCurrency}',
            ),
          ],
        ),
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
      Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
      ),
    ],
  );
}
