import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../features/notification/providers/notification_provider.dart';
import '../../l10n/app_localizations.dart';

class CustomerShell extends ConsumerWidget {
  const CustomerShell({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final unread = ref.watch(unreadCountProvider);
    final location = GoRouterState.of(context).matchedLocation;

    int currentIndex = 0;
    if (location.startsWith('/calendar')) currentIndex = 1;
    if (location.startsWith('/notifications')) currentIndex = 2;
    if (location.startsWith('/settings')) currentIndex = 3;

    return Scaffold(
      backgroundColor: HubStyle.pageBg,
      body: child,
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: HubStyle.cardBorder)),
        ),
        child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) {
          switch (i) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/calendar');
              break;
            case 2:
              context.go('/notifications');
              break;
            case 3:
              context.go('/settings');
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: l10n.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_month_outlined),
            activeIcon: const Icon(Icons.calendar_month),
            label: l10n.calendar,
          ),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: unread > 0,
              label: Text('$unread'),
              child: const Icon(Icons.notifications_outlined),
            ),
            activeIcon: Badge(
              isLabelVisible: unread > 0,
              label: Text('$unread'),
              child: const Icon(Icons.notifications),
            ),
            label: l10n.notifications,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: l10n.profile,
          ),
        ],
      ),
      ),
    );
  }
}

class CoachShell extends ConsumerWidget {
  const CoachShell({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isMn = Localizations.localeOf(context).languageCode == 'mn';
    final unread = ref.watch(unreadCountProvider);
    final location = GoRouterState.of(context).matchedLocation;

    int currentIndex = 0;
    if (location.startsWith('/coach-dashboard')) currentIndex = 1;
    if (location.startsWith('/coach-calendar')) currentIndex = 2;
    if (location.startsWith('/coach-notifications')) currentIndex = 3;
    if (location.startsWith('/coach-settings')) currentIndex = 4;

    return Scaffold(
      backgroundColor: HubStyle.pageBg,
      body: child,
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: HubStyle.cardBorder)),
        ),
        child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) {
          switch (i) {
            case 0:
              context.go('/coach-home');
              break;
            case 1:
              context.go('/coach-dashboard');
              break;
            case 2:
              context.go('/coach-calendar');
              break;
            case 3:
              context.go('/coach-notifications');
              break;
            case 4:
              context.go('/coach-settings');
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: l10n.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard_outlined),
            activeIcon: const Icon(Icons.dashboard),
            label: isMn ? 'Самбар' : 'Dash',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_month_outlined),
            activeIcon: const Icon(Icons.calendar_month),
            label: l10n.calendar,
          ),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: unread > 0,
              label: Text('$unread'),
              child: const Icon(Icons.notifications_outlined),
            ),
            activeIcon: Badge(
              isLabelVisible: unread > 0,
              label: Text('$unread'),
              child: const Icon(Icons.notifications),
            ),
            label: isMn ? 'Мэдээ' : 'Alerts',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: l10n.profile,
          ),
        ],
      ),
      ),
    );
  }
}
