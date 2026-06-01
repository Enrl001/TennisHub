import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/extensions.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/models/models.dart';
import '../../booking/providers/booking_provider.dart';
import '../../calendar/providers/calendar_service.dart';

class BookingSuccessScreen extends ConsumerWidget {
  const BookingSuccessScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final bookingsAsync = ref.watch(myBookingsProvider);

    final booking = bookingsAsync.value?.firstWhere(
      (b) => b.id == bookingId,
      orElse: () => Booking(
        id: bookingId,
        slotId: '',
        serviceId: '',
        coachId: '',
        customerId: '',
        status: 'confirmed',
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              // Animation
              SizedBox(
                height: 200,
                child: Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.primary,
                      size: 72,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.bookingConfirmed,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.thankYou,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Summary card
              if (booking != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          const Icon(Icons.confirmation_number_outlined, color: AppColors.primary, size: 18),
                          const SizedBox(width: 8),
                          Text(l10n.bookingReference,
                              style: const TextStyle(color: Colors.grey, fontSize: 13)),
                          const Spacer(),
                          Text(
                            bookingId.substring(0, 8).toUpperCase(),
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                          ),
                        ]),
                        if (booking.slot != null) ...[
                          const Divider(height: 20),
                          Row(children: [
                            const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(booking.slot!.startsAt.toDisplayDateTime(),
                                style: const TextStyle(fontSize: 13)),
                          ]),
                        ],
                        if (booking.service != null || booking.slot?.service != null) ...[
                          const Divider(height: 20),
                          Row(children: [
                            const Icon(Icons.sports_tennis, size: 14, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              (booking.service ?? booking.slot?.service)?.title ?? 'Session',
                              style: const TextStyle(fontSize: 13),
                            ),
                          ]),
                        ],
                        if (booking.amountPaid != null) ...[
                          const Divider(height: 20),
                          Row(children: [
                            const Icon(Icons.payments_outlined, size: 14, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                                '${booking.amountPaid!.toStringAsFixed(0)} ${booking.currency ?? 'USD'}',
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          ]),
                        ],
                      ],
                    ),
                  ),
                ),
              const Spacer(),

              // Add to calendar
              if (booking != null)
                OutlinedButton.icon(
                  onPressed: () => CalendarService.showCalendarPicker(context, booking),
                  icon: const Icon(Icons.event_outlined),
                  label: Text(l10n.addToCalendar),
                ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => context.go('/home'),
                child: Text(l10n.backToHome),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
