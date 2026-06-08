import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    final profile = await ref.read(authProvider.future);
    if (!mounted) return;
    if (profile == null) {
      context.go('/onboarding');
    } else if (profile.role == 'coach') {
      context.go('/coach-dashboard');
    } else {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: HubStyle.pageBg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: HubStyle.accentLime,
                borderRadius: BorderRadius.circular(HubStyle.radiusSm),
              ),
              child: const Icon(
                Icons.sports_tennis,
                size: 48,
                color: HubStyle.hubOlive,
              ),
            ),
            const SizedBox(height: 24),
            const Text('MY CLUB', style: HubStyle.brandTitle),
            const SizedBox(height: 8),
            Text(
              l10n.splashTagline,
              style: HubStyle.bodyMuted.copyWith(fontSize: 15),
            ),
            const SizedBox(height: 56),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: HubStyle.hubOlive,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
