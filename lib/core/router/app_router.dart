import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/auth/screen/login_screen.dart';
import '../../features/auth/screen/onboarding_screen.dart';
import '../../features/auth/screen/register_screen.dart';
import '../../features/auth/screen/role_select_screen.dart';
import '../../features/auth/screen/settings_screen.dart';
import '../../features/auth/screen/splash_screen.dart';
import '../../features/booking/booking_flow.dart';
import '../../features/booking/screens/booking_requested_screen.dart';
import '../../features/booking/screens/booking_screen.dart';
import '../../features/booking/screens/booking_success_screen.dart';
import '../../features/booking/screens/payment_screen.dart';
import '../../features/calendar/screens/calendar_screen.dart';
import '../../features/coach/screens/add_service_screen.dart';
import '../../features/coach/screens/add_slot_screen.dart';
import '../../features/coach/screens/coach_dashboard_screen.dart';
import '../../features/coach/screens/coach_profile_screen.dart';
import '../../features/coach/screens/edit_coach_profile_screen.dart';
import '../../features/customer/screens/coach_detail_screen.dart';
import '../../features/customer/screens/home_screen.dart';
import '../../features/notification/screens/notifications_screen.dart';
import '../../shared/widgets/main_shell.dart';

part 'app_router.g.dart';

/// Notifies GoRouter when auth state changes, without rebuilding the router.
class _AuthChangeNotifier extends ChangeNotifier {
  _AuthChangeNotifier(Ref ref) {
    ref.listen<AsyncValue<dynamic>>(authProvider, (_, __) {
      notifyListeners();
    });
  }
}

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  // GoRouter is created ONCE. Auth changes trigger refreshListenable
  // so redirect is re-evaluated without rebuilding the whole router.
  final notifier = _AuthChangeNotifier(ref);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: notifier,
    redirect: (context, state) {
      final authState = ref.read(authProvider);

      if (authState.isLoading) return '/splash';

      final profile = authState.value;
      final loc = state.matchedLocation;

      final publicRoutes = ['/splash', '/onboarding', '/login', '/register', '/role-select'];
      final isPublic = publicRoutes.any((r) => loc.startsWith(r));

      if (profile == null && !isPublic) return '/onboarding';
      if (profile != null && isPublic && loc != '/splash') {
        return profile.role == 'coach' ? '/coach-home' : '/home';
      }

      final path = state.uri.path;
      final legacyBooking = legacyBookingPathRedirect(path);
      if (legacyBooking != null) return legacyBooking;
      final legacyCoach = legacyCoachPathRedirect(path);
      if (legacyCoach != null) return legacyCoach;

      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
      GoRoute(path: '/role-select', builder: (_, __) => const RoleSelectScreen()),

      // Customer shell
      ShellRoute(
        builder: (context, state, child) =>
            CustomerShell(child: child),
        routes: [
          GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
          GoRoute(path: '/calendar', builder: (_, __) => const CalendarScreen()),
          GoRoute(path: '/notifications', builder: (_, __) => const NotificationsScreen()),
          GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
        ],
      ),

      // Coach shell
      ShellRoute(
        builder: (context, state, child) =>
            CoachShell(child: child),
        routes: [
          GoRoute(path: '/coach-home', builder: (_, __) => const HomeScreen()),
          GoRoute(path: '/coach-dashboard', builder: (_, __) => const CoachDashboardScreen()),
          GoRoute(path: '/coach-calendar', builder: (_, __) => const CalendarScreen()),
          GoRoute(path: '/coach-notifications', builder: (_, __) => const NotificationsScreen()),
          GoRoute(path: '/coach-settings', builder: (_, __) => const SettingsScreen()),
        ],
      ),

      // Standalone routes
      GoRoute(
        name: 'coachDetail',
        path: '/coach',
        builder: (_, state) {
          final coachId = state.uri.queryParameters['coachId'];
          if (coachId == null || coachId.isEmpty) {
            return const Scaffold(
              body: Center(child: Text('Missing coach')),
            );
          }
          return CoachDetailScreen(coachId: Uri.decodeComponent(coachId));
        },
      ),
      GoRoute(
        name: 'booking',
        path: '/booking',
        builder: (_, state) {
          final serviceId = state.uri.queryParameters['serviceId'];
          if (serviceId == null || serviceId.isEmpty) {
            return const Scaffold(
              body: Center(child: Text('Missing service')),
            );
          }
          return BookingScreen(
            serviceId: Uri.decodeComponent(serviceId),
          );
        },
      ),
      GoRoute(
        name: 'payment',
        path: '/payment',
        builder: (_, state) {
          final bookingId = state.uri.queryParameters['bookingId'];
          if (bookingId == null || bookingId.isEmpty) {
            return const Scaffold(
              body: Center(child: Text('Missing booking')),
            );
          }
          return PaymentScreen(
            bookingId: Uri.decodeComponent(bookingId),
            amount: double.parse(state.uri.queryParameters['amount'] ?? '0'),
            currency: state.uri.queryParameters['currency'] ?? 'MNT',
            autoPay: state.uri.queryParameters['autoPay'] == 'true',
          );
        },
      ),
      GoRoute(
        path: '/booking-requested',
        builder: (_, state) => BookingRequestedScreen(
          bookingId: state.uri.queryParameters['bookingId'],
        ),
      ),
      GoRoute(
        name: 'bookingSuccess',
        path: '/booking-success',
        builder: (_, state) {
          final bookingId = state.uri.queryParameters['bookingId'];
          if (bookingId == null || bookingId.isEmpty) {
            return const Scaffold(
              body: Center(child: Text('Missing booking')),
            );
          }
          return BookingSuccessScreen(
            bookingId: Uri.decodeComponent(bookingId),
          );
        },
      ),
      GoRoute(
        path: '/coach-profile',
        builder: (_, __) => const CoachProfileScreen(),
      ),
      GoRoute(
        path: '/edit-coach-profile',
        builder: (_, __) => const EditCoachProfileScreen(),
      ),
      GoRoute(
        path: '/add-service',
        builder: (_, __) => const AddServiceScreen(),
      ),
      GoRoute(
        path: '/add-slot',
        builder: (_, state) => AddSlotScreen(
            serviceId: state.uri.queryParameters['serviceId']),
      ),
    ],
  );
}
