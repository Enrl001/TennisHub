import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/star_rating.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/coach_provider.dart';

class CoachProfileScreen extends ConsumerWidget {
  const CoachProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final profile = ref.watch(currentProfileProvider);
    final locale = ref.watch(localeProvider);
    final isMn = locale == 'mn';
    final coachAsync = ref.watch(myCoachProfileProvider);

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
      body: coachAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, __) => Center(child: Text(e.toString())),
        data: (coach) {
          if (coach == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.person_off_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isMn
                        ? 'Дасгалжуулагчийн мэдээлэл олдсонгүй'
                        : 'No coach profile yet',
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => context.push('/edit-coach-profile'),
                    child: Text(l10n.editProfile),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 48,
                        child: Text(
                          (profile?.fullName ?? 'C')[0].toUpperCase(),
                          style: const TextStyle(fontSize: 36),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        profile?.fullName ?? 'Coach',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      StarRating(rating: coach.avgRating ?? 0.0, size: 18),
                      if (coach.location != null)
                        Text(
                          coach.location!,
                          style: const TextStyle(color: Colors.grey),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}
