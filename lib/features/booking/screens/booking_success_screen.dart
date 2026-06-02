import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/extensions/local_ext.dart';
import '../../../shared/models/models.dart';
import '../../booking/providers/booking_provider.dart';
import '../../calendar/providers/calendar_service.dart';

class BookingSuccessScreen extends ConsumerWidget {
  const BookingSuccessScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final bookingAsync = ref.watch(bookingDetailProvider(bookingId));

    return Scaffold(
      backgroundColor: HubStyle.pageBg,
      body: SafeArea(
        child: bookingAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => _SuccessBody(
            l10n: l10n,
            booking: null,
            locale: locale,
            bookingId: bookingId,
          ),
          data: (booking) => _SuccessBody(
            l10n: l10n,
            booking: booking,
            locale: locale,
            bookingId: bookingId,
          ),
        ),
      ),
    );
  }
}

class _SuccessBody extends StatelessWidget {
  const _SuccessBody({
    required this.l10n,
    required this.booking,
    required this.locale,
    required this.bookingId,
  });

  final AppLocalizations l10n;
  final Booking? booking;
  final String locale;
  final String bookingId;

  @override
  Widget build(BuildContext context) {
    final b = booking;
    final service = b?.service ?? b?.slot?.service;
    final slot = b?.slot;
    final amountPaid = b?.amountPaid;
    final title = service != null
        ? service.localTitle(locale)
        : (locale == 'mn' ? 'Сесс' : 'Session');

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Spacer(),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: HubStyle.hubOlive.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: HubStyle.hubOlive,
              size: 72,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.bookingConfirmed,
            style: const TextStyle(
              color: HubStyle.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.thankYou,
            style: const TextStyle(color: HubStyle.textMuted, fontSize: 15),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: HubStyle.cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.confirmation_number_outlined,
                      color: HubStyle.hubOlive,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.bookingReference,
                      style: const TextStyle(
                        color: HubStyle.textMuted,
                        fontSize: 13,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      bookingId.substring(0, 8).toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                if (slot != null) ...[
                  const Divider(height: 20),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: HubStyle.textMuted,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('EEE, MMM d · h:mm a').format(slot.startsAt),
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ],
                if (service != null) ...[
                  const Divider(height: 20),
                  Row(
                    children: [
                      const Icon(
                        Icons.sports_tennis,
                        size: 14,
                        color: HubStyle.textMuted,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(title, style: const TextStyle(fontSize: 13)),
                      ),
                    ],
                  ),
                ],
                if (amountPaid != null) ...[
                  const Divider(height: 20),
                  Row(
                    children: [
                      const Icon(
                        Icons.payments_outlined,
                        size: 14,
                        color: HubStyle.textMuted,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${amountPaid.toStringAsFixed(0)} ${b?.currency ?? 'USD'}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const Spacer(),
          if (b != null)
            OutlinedButton.icon(
              onPressed: () => CalendarService.showCalendarPicker(context, b),
              icon: const Icon(Icons.event_outlined),
              label: Text(l10n.addToCalendar),
              style: OutlinedButton.styleFrom(
                foregroundColor: HubStyle.hubOlive,
                side: const BorderSide(color: HubStyle.hubOlive),
                minimumSize: const Size(double.infinity, 44),
              ),
            ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => context.go('/home'),
            style: ElevatedButton.styleFrom(
              backgroundColor: HubStyle.hubOlive,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
            ),
            child: Text(l10n.backToHome),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
