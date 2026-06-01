import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/loading_shimmer.dart';
import '../../../shared/widgets/star_rating.dart';
import '../../../shared/widgets/service_chip.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/coach_provider.dart';

class CoachProfileScreen extends ConsumerWidget {
  const CoachProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final profile = ref.watch(currentProfileProvider);
    if (profile == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    // Find coach by profile id
    final coachesAsync = ref.watch(coachesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profile),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.push('/edit-coach-profile'),
          ),
        ],
      ),
      body: coachesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, __) => Center(child: Text(e.toString())),
        data: (coaches) {
          final coach = coaches.firstWhere(
            (c) => c.profileId == profile.id,
            orElse: () => coaches.isEmpty ? coaches.first : coaches.first,
          );
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(children: [
                    CircleAvatar(
                      radius: 48,
                      child: Text(
                        (profile.fullName ?? 'C')[0].toUpperCase(),
                        style: const TextStyle(fontSize: 36),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(profile.fullName ?? 'Coach',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                    StarRating(rating: coach.avgRating ?? 0.0, size: 18),
                  ]),
                ),
                const SizedBox(height: 24),
                if ((coach.services ?? []).isNotEmpty) ...[
                  Text(l10n.services,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  ...(coach.services ?? []).map((s) => Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: ServiceChip(type: s.type, small: true),
                          title: Text(s.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                          trailing: s.priceAmount != null
                              ? Text('\$${s.priceAmount!.toStringAsFixed(0)}',
                                  style: const TextStyle(fontWeight: FontWeight.w600))
                              : null,
                          onTap: () => context.push('/add-slot?serviceId=${s.id}'),
                        ),
                      )),
                  const SizedBox(height: 8),
                ],
                OutlinedButton.icon(
                  onPressed: () => context.push('/add-service'),
                  icon: const Icon(Icons.add),
                  label: Text(l10n.addService),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
