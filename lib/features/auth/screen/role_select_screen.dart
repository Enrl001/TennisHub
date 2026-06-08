import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';

class RoleSelectScreen extends ConsumerStatefulWidget {
  const RoleSelectScreen({super.key});

  @override
  ConsumerState<RoleSelectScreen> createState() => _RoleSelectScreenState();
}

class _RoleSelectScreenState extends ConsumerState<RoleSelectScreen> {
  String? _selected;
  bool _loading = false;

  Future<void> _confirm() async {
    if (_selected == null) return;
    setState(() => _loading = true);
    try {
      await ref.read(authProvider.notifier).updateProfile({'role': _selected});
      if (!mounted) return;
      if (_selected == 'coach') {
        context.go('/edit-coach-profile');
      } else {
        context.go('/home');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.statusCancelled));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Text(l10n.roleSelectTitle,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(l10n.roleSelectSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey)),
              const SizedBox(height: 40),
              _RoleCard(
                icon: Icons.sports_tennis,
                title: l10n.roleCoach,
                desc: l10n.roleCoachDesc,
                color: AppColors.primary,
                selected: _selected == 'coach',
                onTap: () => setState(() => _selected = 'coach'),
              ),
              const SizedBox(height: 16),
              _RoleCard(
                icon: Icons.person,
                title: l10n.roleCustomer,
                desc: l10n.roleCustomerDesc,
                color: AppColors.virtualSession,
                selected: _selected == 'customer',
                onTap: () => setState(() => _selected = 'customer'),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: (_selected == null || _loading) ? null : _confirm,
                child: _loading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text(l10n.confirm),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.icon,
    required this.title,
    required this.desc,
    required this.color,
    required this.selected,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final String desc;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: selected ? color.withOpacity(0.08) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected ? color : AppColors.cardBorder,
          width: selected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(desc,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
                  ],
                ),
              ),
              if (selected) Icon(Icons.check_circle_rounded, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
