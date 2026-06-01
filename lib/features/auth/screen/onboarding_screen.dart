import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pages = [
      _PageData(
        icon: Icons.search,
        title: l10n.onboardingTitle1,
        desc: l10n.onboardingDesc1,
        color: AppColors.primary,
      ),
      _PageData(
        icon: Icons.calendar_month,
        title: l10n.onboardingTitle2,
        desc: l10n.onboardingDesc2,
        color: AppColors.virtualSession,
      ),
      _PageData(
        icon: Icons.emoji_events_outlined,
        title: l10n.onboardingTitle3,
        desc: l10n.onboardingDesc3,
        color: AppColors.groupLesson,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => context.go('/login'),
                child: Text(l10n.skip),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (_, i) => _OnboardingPage(data: pages[i]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      pages.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _page == i ? 20 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _page == i ? AppColors.primary : AppColors.cardBorder,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      if (_page < pages.length - 1) {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        context.go('/login');
                      }
                    },
                    child: Text(_page < pages.length - 1 ? l10n.next : l10n.getStarted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageData {
  const _PageData({required this.icon, required this.title, required this.desc, required this.color});
  final IconData icon;
  final String title;
  final String desc;
  final Color color;
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.data});
  final _PageData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: data.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Icon(data.icon, size: 60, color: data.color),
          ),
          const SizedBox(height: 40),
          Text(
            data.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            data.desc,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
