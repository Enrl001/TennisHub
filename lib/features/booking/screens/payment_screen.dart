import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../booking_flow.dart';
import '../providers/booking_provider.dart';
import '../providers/payment_provider.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({
    super.key,
    required this.bookingId,
    required this.amount,
    required this.currency,
    this.autoPay = false,
  });

  final String bookingId;
  final double amount;
  final String currency;
  final bool autoPay;

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  bool _launched = false;
  bool _autoPayStarted = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.autoPay) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _tryAutoPay());
    }
  }

  Future<void> _tryAutoPay() async {
    if (_autoPayStarted || _launched || !mounted) return;
    _autoPayStarted = true;
    await _openSmartpay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _openSmartpay() async {
    final url = await ref
        .read(paymentProvider.notifier)
        .createSmartpayInvoice(
          bookingId: widget.bookingId,
          amount: widget.amount,
          description: 'MyClub booking',
        );
    if (url == null || !mounted) return;

    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Could not open payment page'),
        backgroundColor: AppColors.statusCancelled,
      ));
      return;
    }
    setState(() => _launched = true);
    _startPolling();
  }

  void _startPolling() {
    _timer = Timer.periodic(const Duration(seconds: 3), (_) => _checkStatus());
  }

  Future<void> _checkStatus() async {
    try {
      final notifier = ref.read(paymentProvider.notifier);
      final paid = await notifier.checkPaymentComplete(widget.bookingId);
      if (!mounted) return;
      if (paid) {
        _timer?.cancel();
        ref.invalidate(myBookingsProvider);
        ref.invalidate(bookingDetailProvider(widget.bookingId));
        ref.invalidate(bookingPaidProvider(widget.bookingId));
        goBookingSuccess(context, widget.bookingId);
        return;
      }
      final status = await notifier.bookingStatus(widget.bookingId);
      if (!mounted) return;
      if (status == 'cancelled') {
        _timer?.cancel();
        setState(() => _launched = false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Booking was cancelled'),
          backgroundColor: AppColors.statusCancelled,
        ));
      }
    } catch (_) {
      // Silently retry on network errors
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final payState = ref.watch(paymentProvider);
    final isLoading = payState.isLoading;

    final isMn = Localizations.localeOf(context).languageCode == 'mn';

    return Scaffold(
      backgroundColor: HubStyle.pageBg,
      appBar: AppBar(
        backgroundColor: HubStyle.pageBg,
        title: Text(
          l10n.payment,
          style: const TextStyle(
            color: HubStyle.hubOlive,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
          ),
        ),
        iconTheme: const IconThemeData(color: HubStyle.hubOlive),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: _launched
              ? _PollingView(isMn: isMn, onRefresh: _checkStatus)
              : _InvoiceView(
                  l10n: l10n,
                  isMn: isMn,
                  amount: widget.amount,
                  currency: widget.currency,
                  isLoading: isLoading,
                  onPay: _openSmartpay,
                  error: payState.hasError ? payState.error.toString() : null,
                ),
        ),
      ),
    );
  }
}

// ─── Invoice / Pay button view ────────────────────────────────────────────────

class _InvoiceView extends StatelessWidget {
  const _InvoiceView({
    required this.l10n,
    required this.isMn,
    required this.amount,
    required this.currency,
    required this.isLoading,
    required this.onPay,
    this.error,
  });

  final AppLocalizations l10n;
  final bool isMn;
  final double amount;
  final String currency;
  final bool isLoading;
  final VoidCallback onPay;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        // Amount summary card
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: HubStyle.darkPanel,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.total,
                  style: const TextStyle(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 6),
              Text(
                '${amount.round()} $currency',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w700),
              ),
              if (currency.toUpperCase() != 'MNT') ...[
                const SizedBox(height: 8),
                Text(
                  isMn
                      ? 'Smartpay: ${(amount * AppConstants.smartpayMntPerUsd).round()} ₮'
                      : 'Smartpay charge: ${(amount * AppConstants.smartpayMntPerUsd).round()} MNT',
                  style: const TextStyle(color: Colors.white60, fontSize: 13),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 32),

        // Smartpay provider row
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B00).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.payment_rounded,
                  color: Color(0xFFFF6B00), size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Smartpay',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  Text(l10n.paymentInstructions,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Accepted bank chips
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: const [
            _BankChip(label: 'QPay'),
            _BankChip(label: 'Хаан банк'),
            _BankChip(label: 'Голомт'),
            _BankChip(label: 'Хас'),
            _BankChip(label: 'Тэнгэр'),
          ],
        ),
        const SizedBox(height: 32),

        if (error != null)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: AppColors.statusCancelled.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: AppColors.statusCancelled.withValues(alpha: 0.3)),
            ),
            child: Text(error!,
                style: const TextStyle(
                    color: AppColors.statusCancelled, fontSize: 13)),
          ),

        ElevatedButton.icon(
          onPressed: isLoading ? null : onPay,
          icon: isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white))
              : const Icon(Icons.open_in_new_rounded, size: 20),
          label: Text(l10n.payWithSmartpay),
          style: ElevatedButton.styleFrom(
            backgroundColor: HubStyle.hubOlive,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: const [
            Icon(Icons.lock_outline, size: 13, color: Colors.grey),
            SizedBox(width: 4),
            Text('Secured by Smartpay',
                style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ],
    );
  }
}

class _BankChip extends StatelessWidget {
  const _BankChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 11)),
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      backgroundColor: AppColors.cardBorder,
    );
  }
}

// ─── Waiting / polling view ───────────────────────────────────────────────────

class _PollingView extends StatelessWidget {
  const _PollingView({required this.isMn, required this.onRefresh});

  final bool isMn;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 60),
        const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(HubStyle.hubOlive)),
        const SizedBox(height: 32),
        Text(
          isMn ? 'Төлбөр хүлээж байна...' : 'Waiting for payment...',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        Text(
          isMn
              ? 'Smartpay-д төлбөрөө гүйцэтгэнэ үү.\nТөлбөр хийсний дараа автоматаар шинэчлэгдэнэ.'
              : 'Complete payment in Smartpay.\nThis screen updates automatically.',
          textAlign: TextAlign.center,
          style:
              Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
        const SizedBox(height: 32),
        OutlinedButton.icon(
          onPressed: onRefresh,
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: Text(isMn ? 'Дахин шалгах' : 'Check again'),
          style: OutlinedButton.styleFrom(
            foregroundColor: HubStyle.hubOlive,
            side: const BorderSide(color: HubStyle.hubOlive),
          ),
        ),
      ],
    );
  }
}


