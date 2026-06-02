import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/models/models.dart';
import '../booking_flow.dart';
import '../providers/booking_provider.dart';
import '../providers/payment_provider.dart';

class BookingRequestedScreen extends ConsumerWidget {
  const BookingRequestedScreen({super.key, this.bookingId});

  final String? bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isMn = Localizations.localeOf(context).languageCode == 'mn';
    final bookingAsync = bookingId != null
        ? ref.watch(bookingDetailProvider(bookingId!))
        : null;
    final paidAsync = bookingId != null
        ? ref.watch(bookingPaidProvider(bookingId!))
        : null;

    final booking = bookingAsync?.value;
    final amount = booking?.amountPaid ?? 0;
    final canPay = booking != null &&
        bookingHasPrice(booking) &&
        booking.status == 'confirmed' &&
        paidAsync?.value == false;

    return Scaffold(
      backgroundColor: HubStyle.pageBg,
      body: SafeArea(
        child: RefreshIndicator(
          color: HubStyle.hubOlive,
          onRefresh: () async {
            if (bookingId == null) return;
            ref.invalidate(bookingDetailProvider(bookingId!));
            ref.invalidate(bookingPaidProvider(bookingId!));
            await ref.read(bookingDetailProvider(bookingId!).future);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.85,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: HubStyle.hubOlive.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.schedule_send_outlined,
                    size: 48,
                    color: HubStyle.hubOlive,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  canPay
                      ? (isMn ? 'Захиалга баталгаажлаа!' : 'Booking Approved!')
                      : (isMn ? 'Захиалга илгээгдлээ!' : 'Booking Requested!'),
                  style: const TextStyle(
                    color: HubStyle.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  canPay
                      ? (isMn
                          ? 'Төлбөрөө төлсний дараа захиалга бүрэн баталгаажна.'
                          : 'Complete payment to finalize your booking.')
                      : (isMn
                          ? 'Тренер таны захиалгыг хянаж байна. Баталгаажсаны дараа мэдэгдэл ирнэ.'
                          : 'Your coach will review your request. You\'ll be notified once it\'s approved.'),
                  style: const TextStyle(
                    color: HubStyle.textMuted,
                    fontSize: 15,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (booking != null && booking.slot != null) ...[
                  const SizedBox(height: 24),
                  _SummaryCard(booking: booking, isMn: isMn),
                ],
                const SizedBox(height: 40),
                if (canPay && bookingId != null)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => goPayment(
                        context,
                        bookingId: bookingId!,
                        amount: amount,
                        currency: booking.currency ?? 'USD',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HubStyle.hubOlive,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(l10n.payNow),
                    ),
                  ),
                if (canPay) const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => context.go('/home'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: HubStyle.hubOlive,
                      side: const BorderSide(color: HubStyle.hubOlive),
                    ),
                    child: Text(l10n.backToHome),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => context.go('/notifications'),
                  child: Text(
                    isMn ? 'Мэдэгдэл харах' : 'View Notifications',
                    style: const TextStyle(color: HubStyle.hubOlive),
                  ),
                ),
                ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.booking, required this.isMn});

  final Booking booking;
  final bool isMn;

  @override
  Widget build(BuildContext context) {
    final service = booking.service ?? booking.slot?.service;
    final title = isMn
        ? (service?.titleMn ?? service?.title ?? 'Session')
        : (service?.title ?? 'Session');
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: HubStyle.cardBorder),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 15,
          color: HubStyle.textPrimary,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
