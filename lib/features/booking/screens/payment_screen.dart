import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../providers/payment_provider.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({
    super.key,
    required this.bookingId,
    required this.amount,
    required this.currency,
  });

  final String bookingId;
  final double amount;
  final String currency;

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  bool _launched = false;
  Timer? _timer;

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
          description: 'Tennis Hub booking',
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
      final status = await ref
          .read(paymentProvider.notifier)
          .checkBookingStatus(widget.bookingId);
      if (!mounted) return;
      if (status == 'confirmed') {
        _timer?.cancel();
        context.go('/booking-success/${widget.bookingId}');
      } else if (status == 'cancelled') {
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

    return Scaffold(
      appBar: AppBar(title: Text(l10n.payment)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: _launched
              ? _PollingView(onRefresh: _checkStatus)
              : _InvoiceView(
                  l10n: l10n,
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
    required this.amount,
    required this.currency,
    required this.isLoading,
    required this.onPay,
    this.error,
  });

  final AppLocalizations l10n;
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
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(20),
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
            backgroundColor: const Color(0xFFFF6B00),
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
  const _PollingView({required this.onRefresh});

  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 60),
        const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(AppColors.primary)),
        const SizedBox(height: 32),
        Text(
          'Төлбөр хүлээж байна...',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(
          'Smartpay-д төлбөрөө гүйцэтгэнэ үү.\nТөлбөр хийсний дараа автоматаар шинэчлэгдэнэ.',
          textAlign: TextAlign.center,
          style:
              Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
        const SizedBox(height: 32),
        OutlinedButton.icon(
          onPressed: onRefresh,
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: const Text('Дахин шалгах'),
        ),
      ],
    );
  }
}


