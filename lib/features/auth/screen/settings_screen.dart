import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final profile = ref.watch(currentProfileProvider);
    final locale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Avatar + name
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    backgroundImage: profile?.avatarUrl != null
                        ? CachedNetworkImageProvider(profile!.avatarUrl!)
                        : null,
                    child: profile?.avatarUrl == null
                        ? const Icon(Icons.person, size: 44, color: AppColors.primary)
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    profile?.fullName ?? profile?.id.substring(0, 8) ?? '',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    profile?.role == 'coach' ? 'Tennis Coach' : 'Player',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Language
            _SectionHeader(title: l10n.language),
            _SettingsTile(
              icon: Icons.language,
              title: l10n.language,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _LocaleChip(
                    label: 'EN',
                    selected: locale == 'en',
                    onTap: () => ref.read(localeProvider.notifier).setLocale('en'),
                  ),
                  const SizedBox(width: 8),
                  _LocaleChip(
                    label: 'MN',
                    selected: locale == 'mn',
                    onTap: () => ref.read(localeProvider.notifier).setLocale('mn'),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, indent: 16),

            // Profile
            _SectionHeader(title: l10n.profile),
            _SettingsTile(
              icon: Icons.edit_outlined,
              title: l10n.editProfile,
              onTap: () => context.push(
                  profile?.role == 'coach' ? '/edit-coach-profile' : '/settings'),
            ),
            if (profile?.role == 'coach') ...[
              const Divider(height: 1, indent: 16),
              _SettingsTile(
                icon: Icons.sports_tennis,
                title: 'Coach Profile',
                onTap: () => context.push('/coach-profile'),
              ),
            ],
            const Divider(height: 1, indent: 16),

            // Logout
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: OutlinedButton.icon(
                onPressed: () async {
                  await ref.read(authProvider.notifier).signOut();
                  if (context.mounted) context.go('/onboarding');
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.statusCancelled,
                  side: const BorderSide(color: AppColors.statusCancelled),
                ),
                icon: const Icon(Icons.logout),
                label: Text(l10n.logout),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.grey,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      );
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({required this.icon, required this.title, this.trailing, this.onTap});
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title),
        trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right) : null),
        onTap: onTap,
      );
}

class _LocaleChip extends StatelessWidget {
  const _LocaleChip({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.background,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: selected ? AppColors.primary : AppColors.cardBorder),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.grey,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      );
}
