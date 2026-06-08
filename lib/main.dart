import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/constants/app_constants.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/providers/auth_provider.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );

  runApp(const ProviderScope(child: MyClubApp()));
}

class MyClubApp extends ConsumerWidget {
  const MyClubApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final localeCode = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'MyClub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      locale: Locale(localeCode),
      localeListResolutionCallback: (locales, supported) {
        if (locales != null) {
          for (final locale in locales) {
            if (locale.languageCode == 'mn') return const Locale('mn');
            if (locale.languageCode == 'en') return const Locale('en');
          }
        }
        return Locale(AppConstants.defaultLocale);
      },
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('mn'),
        Locale('en'),
      ],
      routerConfig: router,
    );
  }
}
