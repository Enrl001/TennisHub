import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/extensions.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/booking_card.dart';
import '../../../shared/widgets/loading_shimmer.dart';
import '../../auth/providers/auth_provider.dart';
import '../../booking/providers/booking_provider.dart';
import '../../coach/providers/coach_provider.dart';
import '../widgets/earnings_card.dart';

class CoachDashboardScreen extends ConsumerWidget {
  const CoachDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final profile = ref.watch(currentProfileProvider);
    final bookingsAsync = ref.watch(coachBookingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dashboard),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: l10n.addService,
            onPressed: () => context.push('/add-service'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(coachBookingsProvider.future),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'Hello, ${profile?.fullName?.split(' ').first ?? 'Coach'} 👋',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),

              // Earnings card
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: EarningsCard(),
              ),
              const SizedBox(height: 20),

              // Quick actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(children: [
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.add_box_outlined,
                      label: l10n.addService,
                      color: AppColors.primary,
                      onTap: () => context.push('/add-service'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.schedule_outlined,
                      label: l10n.addSlot,
                      color: AppColors.virtualSession,
                      onTap: () => context.push('/add-slot'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.person_outline,
                      label: 'Profile',
                      color: AppColors.groupLesson,
                      onTap: () => context.push('/edit-coach-profile'),
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 24),

              // Upcoming bookings
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(l10n.upcomingSessions,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 8),
              bookingsAsync.when(
                loading: () => Column(
                  children: List.generate(3, (_) => const CoachCardShimmer()),
                ),
                error: (e, __) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(e.toString(), style: const TextStyle(color: Colors.grey)),
                ),
                data: (bookings) {
                  final upcoming = bookings
                      .where((b) => b.status == 'confirmed' || b.status == 'pending')
                      .toList();
                  if (upcoming.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(
                        child: Column(children: [
                          Icon(Icons.event_available_outlined, size: 48, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('No upcoming sessions', style: TextStyle(color: Colors.grey)),
                        ]),
                      ),
                    );
                  }
                  return Column(
                    children: upcoming
                        .take(5)
                        .map((b) => BookingCard(booking: b, isCoach: true))
                        .toList(),
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, required this.label, required this.color, required this.onTap});
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Column(children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
          ]),
        ),
      );
}
