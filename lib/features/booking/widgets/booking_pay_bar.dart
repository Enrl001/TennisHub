import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../booking_flow.dart';
import '../providers/booking_provider.dart';
import '../providers/payment_provider.dart';

/// Pay-now action when a booking is approved but not yet paid.
class BookingPayBar extends ConsumerWidget {
  const BookingPayBar({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final bookingAsync = ref.watch(bookingDetailProvider(bookingId));
    final paidAsync = ref.watch(bookingPaidProvider(bookingId));

    final booking = bookingAsync.value;
    if (booking == null) return const SizedBox.shrink();
    if (!bookingHasPrice(booking)) return const SizedBox.shrink();
    if (booking.status == 'cancelled') return const SizedBox.shrink();
    if (paidAsync.value == true) return const SizedBox.shrink();
    if (booking.status != 'confirmed' && booking.status != 'pending') {
      return const SizedBox.shrink();
    }
    // Private lessons: pay only after coach confirms.
    if (booking.status == 'pending') return const SizedBox.shrink();

    final amount = booking.amountPaid ?? 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => openPayment(
            context,
            bookingId: bookingId,
            amount: amount,
            currency: booking.currency ?? 'MNT',
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: HubStyle.hubOlive,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10),
            visualDensity: VisualDensity.compact,
          ),
          child: Text(l10n.payNow, style: const TextStyle(fontSize: 13)),
        ),
      ),
    );
  }
}
