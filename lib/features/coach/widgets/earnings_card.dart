import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../booking/providers/booking_provider.dart';

class EarningsCard extends ConsumerWidget {
  const EarningsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final bookingsAsync = ref.watch(coachBookingsProvider);

    final bookings = bookingsAsync.value ?? [];
    final now = DateTime.now();
    final thisMonthBookings = bookings.where((b) {
      if (b.status != 'confirmed' && b.status != 'completed') return false;
      final created = b.createdAt;
      return created != null && created.month == now.month && created.year == now.year;
    }).toList();

    final monthlyEarnings = thisMonthBookings.fold<double>(
        0, (sum, b) => sum + (b.amountPaid ?? 0));
    final totalEarnings = bookings
        .where((b) => b.status == 'confirmed' || b.status == 'completed')
        .fold<double>(0, (sum, b) => sum + (b.amountPaid ?? 0));

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF1B4332)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.account_balance_wallet_outlined, color: Colors.white70, size: 18),
            const SizedBox(width: 8),
            Text(l10n.totalEarnings,
                style: const TextStyle(color: Colors.white70, fontSize: 13)),
          ]),
          const SizedBox(height: 8),
          Text(
            '\$${totalEarnings.toStringAsFixed(0)}',
            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          Container(height: 1, color: Colors.white24),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(l10n.thisMonth,
                    style: const TextStyle(color: Colors.white70, fontSize: 12)),
                Text('\$${monthlyEarnings.toStringAsFixed(0)}',
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
              ]),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(l10n.sessions,
                    style: const TextStyle(color: Colors.white70, fontSize: 12)),
                Text('${thisMonthBookings.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}
