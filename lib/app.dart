import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/di/injection_container.dart';
import 'core/logging/logger_service.dart';
import 'core/notifications/notification_payload.dart';
import 'core/providers/notification_coordinator_provider.dart';
import 'core/routing/app_router.dart';
import 'core/routing/route_location_policy.dart';
import 'core/services/local_notification_service.dart';
import 'core/services/notification_service.dart';
import 'core/theme/dark_theme.dart';
import 'core/theme/light_theme.dart';
import 'core/theme/theme_provider.dart';
import 'features/settings/application/providers/language_settings_notifier.dart';
import 'l10n/generated/app_localizations.dart';

class NoorLifeApp extends ConsumerStatefulWidget {
  const NoorLifeApp({
    super.key,
  });

  @override
  ConsumerState<NoorLifeApp> createState() => _NoorLifeAppState();
}

class _NoorLifeAppState extends ConsumerState<NoorLifeApp> {
  late final GoRouter _router;

  StreamSubscription<String>? _notificationPayloadSubscription;

  @override
  void initState() {
    super.initState();

    LocalNotificationService? localNotificationService;
    String? initialLocation;

    if (getIt.isRegistered<LocalNotificationService>()) {
      try {
        localNotificationService = getIt<LocalNotificationService>();

        final initialPayload =
            localNotificationService.takeInitialNotificationPayload();

        final parsedPayload = NotificationPayload.tryParse(
          initialPayload,
        );

        initialLocation = RouteLocationPolicy.sanitizeNotificationLocation(
          parsedPayload?.location,
        );
      } catch (_) {
        localNotificationService = null;

        _logNavigationNotice(
          '[NOTIFICATION NAVIGATION] '
          'Initial notification payload unavailable.',
        );
      }
    }

    _router = AppRouter.createRouter(
      initialLocation: initialLocation,
    );

    if (localNotificationService != null) {
      _notificationPayloadSubscription =
          localNotificationService.notificationPayloads.listen(
        _handleNotificationPayload,
        onError: (
          Object _,
          StackTrace __,
        ) {
          _logNavigationNotice(
            '[NOTIFICATION NAVIGATION] '
            'Notification payload stream error.',
          );
        },
      );
    }
  }

  void _handleNotificationPayload(
    String rawPayload,
  ) {
    final payload = NotificationPayload.tryParse(
      rawPayload,
    );

    if (payload == null) {
      return;
    }

    final location = RouteLocationPolicy.sanitizeNotificationLocation(
      payload.location,
    );

    if (location == null) {
      _logNavigationNotice(
        '[NOTIFICATION NAVIGATION] '
        'Ignored invalid notification destination.',
      );

      return;
    }

    final currentLocation =
        _router.routeInformationProvider.value.uri.toString();

    if (currentLocation == location) {
      return;
    }

    _router.go(
      location,
    );
  }

  void _logNavigationNotice(
    String message,
  ) {
    if (!getIt.isRegistered<LoggerService>()) {
      return;
    }

    getIt<LoggerService>().debug(
      message,
    );
  }

  @override
  void dispose() {
    _notificationPayloadSubscription?.cancel();
    _router.dispose();

    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final themeMode = ref.watch(
      themeModeProvider,
    );

    final localeState = ref.watch(
      languageSettingsNotifierProvider,
    );

    ref.watch(
      notificationCoordinatorProvider,
    );

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
