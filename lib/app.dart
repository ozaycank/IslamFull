import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/providers/notification_coordinator_provider.dart';
import 'core/routing/app_router.dart';
import 'core/services/notification_service.dart';
import 'core/theme/dark_theme.dart';
import 'core/theme/light_theme.dart';
import 'core/theme/theme_provider.dart';
import 'features/settings/application/providers/language_settings_notifier.dart';
import 'l10n/generated/app_localizations.dart';

class NoorLifeApp extends ConsumerStatefulWidget {
  const NoorLifeApp({super.key});

  @override
  ConsumerState<NoorLifeApp> createState() => _NoorLifeAppState();
}

class _NoorLifeAppState extends ConsumerState<NoorLifeApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();

    // Keep one router instance for the whole application lifetime.
    // Recreating GoRouter on locale or theme changes may reset navigation state.
    _router = AppRouter.createRouter(ref);
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final localeState = ref.watch(languageSettingsNotifierProvider);

    // Activate application-level notification orchestration.
    ref.watch(notificationCoordinatorProvider);

    return MaterialApp.router(
      title: 'IslamFull',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: NotificationService.messengerKey,
      theme: LightTheme.theme,
      darkTheme: DarkTheme.theme,
      themeMode: themeMode,
      routerConfig: _router,
      locale: localeState.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
