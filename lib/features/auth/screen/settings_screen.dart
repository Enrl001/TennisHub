import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../coach/providers/coach_provider.dart';
import '../providers/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final profile = ref.watch(currentProfileProvider);
    final locale = ref.watch(localeProvider);
    final isMn = locale == 'mn';
    final isCoach = profile?.role == 'coach';

    return Scaffold(
      backgroundColor: HubStyle.pageBg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: HubStyle.darkPanel,
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      CircleAvatar(
                        radius: 42,
                        backgroundColor: Colors.white24,
                        backgroundImage: profile?.avatarUrl != null
                            ? CachedNetworkImageProvider(profile!.avatarUrl!)
                            : null,
                        child: profile?.avatarUrl == null
                            ? Text(
                                (profile?.fullName ?? 'U')[0].toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 34,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        profile?.fullName ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: HubStyle.accentLime,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isCoach
                              ? (isMn ? 'Дасгалжуулагч' : 'Coach')
                              : (isMn ? 'Тоглогч' : 'Player'),
                          style: const TextStyle(
                            color: HubStyle.hubOliveDark,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: Colors.white),
                tooltip: l10n.editProfile,
                onPressed: () => context.push('/edit-coach-profile'),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isCoach) _CoachSection(isMn: isMn),
                const Divider(height: 1, indent: 16),
                // Language
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.language,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        l10n.language,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      _LocaleChip(
                        label: 'EN',
                        selected: !isMn,
                        onTap: () =>
                            ref.read(localeProvider.notifier).setLocale('en'),
                      ),
                      const SizedBox(width: 8),
                      _LocaleChip(
                        label: 'MN',
                        selected: isMn,
                        onTap: () =>
                            ref.read(localeProvider.notifier).setLocale('mn'),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, indent: 16),
                if (!isCoach) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: _BecomeCoachCard(isMn: isMn),
                  ),
                ],
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await ref.read(authProvider.notifier).signOut();
                        if (context.mounted) context.go('/onboarding');
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.statusCancelled,
                        side: const BorderSide(
                          color: AppColors.statusCancelled,
                        ),
                      ),
                      icon: const Icon(Icons.logout),
                      label: Text(l10n.logout),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BecomeCoachCard extends ConsumerWidget {
  const _BecomeCoachCard({required this.isMn});
  final bool isMn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: AppColors.tennisGreen.withOpacity(0.6)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _confirm(context, ref),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.tennisGreen.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.sports_tennis,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isMn ? 'Дасгалжуулагч болох' : 'Become a Coach',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isMn
                          ? 'Теннисний хичээл зааж орлого олох'
                          : 'Start offering tennis lessons and earn',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirm(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          ref.read(localeProvider) == 'mn'
              ? 'Дасгалжуулагч болох уу?'
              : 'Become a Coach?',
        ),
        content: Text(
          ref.read(localeProvider) == 'mn'
              ? 'Таны бүртгэл дасгалжуулагчийн бүртгэл болж шилжинэ. Хичээл нэмж, хуваарь гаргах боломжтой.'
              : 'Your account will be upgraded to a coach account. You can then add services and manage your schedule.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(isMn ? 'Болих' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: Text(isMn ? 'Шилжих' : 'Upgrade'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await ref.read(authProvider.notifier).updateProfile({'role': 'coach'});
    }
  }
}

class _CoachSection extends ConsumerWidget {
  const _CoachSection({required this.isMn});
  final bool isMn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final coachAsync = ref.watch(myCoachProfileProvider);

    return coachAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => const SizedBox(),
      data: (coach) {
        if (coach == null) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: OutlinedButton.icon(
              onPressed: () => context.push('/edit-coach-profile'),
              icon: const Icon(Icons.add),
              label: Text(
                isMn ? 'Дасгалжуулагчийн мэдээлэл нэмэх' : 'Complete coach profile',
              ),
            ),
          );
        }

        final bio = isMn ? (coach.bioMn ?? coach.bio) : coach.bio;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Wrap(
                spacing: 20,
                runSpacing: 8,
                children: [
                  _StatItem(
                    icon: Icons.star_rounded,
                    color: Colors.amber,
                    label: (coach.avgRating ?? 0.0).toStringAsFixed(1),
                    sub: isMn ? 'Үнэлгээ' : 'Rating',
                  ),
                  _StatItem(
                    icon: Icons.rate_review_outlined,
                    color: AppColors.primary,
                    label: '${coach.totalReviews ?? 0}',
                    sub: isMn ? 'Сэтгэгдэл' : 'Reviews',
                  ),
                  if (coach.yearsExperience != null)
                    _StatItem(
                      icon: Icons.workspace_premium_outlined,
                      color: AppColors.virtualSession,
                      label: '${coach.yearsExperience}',
                      sub: isMn ? 'Жил туршлага' : 'Yrs exp',
                    ),
                ],
              ),
            ),
            if (coach.location != null) ...[
              const Divider(height: 1, indent: 16),
              ListTile(
                leading: const Icon(
                  Icons.location_on_outlined,
                  color: AppColors.primary,
                ),
                title: Text(coach.location!),
                dense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ],
            if (bio != null && bio.isNotEmpty) ...[
              const Divider(height: 1, indent: 16),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Text(
                  bio,
                  style: const TextStyle(height: 1.6, color: Colors.black87),
                ),
              ),
            ],
            if ((coach.certifications ?? []).isNotEmpty) ...[
              const Divider(height: 1, indent: 16),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
                child: Text(
                  l10n.certifications,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: coach.certifications!
                      .map(
                        (c) => Chip(
                          label: Text(c, style: const TextStyle(fontSize: 12)),
                          backgroundColor: AppColors.tennisGreen.withOpacity(
                            0.20,
                          ),
                          side: const BorderSide(
                            color: AppColors.tennisGreen,
                            width: 1,
                          ),
                          labelStyle: const TextStyle(color: Color(0xFF1A3A10)),
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.color,
    required this.label,
    required this.sub,
  });
  final IconData icon;
  final Color color;
  final String label;
  final String sub;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: color,
              fontSize: 15,
            ),
          ),
        ],
      ),
      Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 11)),
    ],
  );
}

class _LocaleChip extends StatelessWidget {
  const _LocaleChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? AppColors.tennisGreen : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected ? AppColors.tennisGreen : Colors.grey.shade300,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: selected ? const Color(0xFF1A3A10) : Colors.grey,
          fontSize: 13,
        ),
      ),
    ),
  );
}
