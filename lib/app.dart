import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/di/injection_container.dart';
import 'core/logging/logger_service.dart';
import 'core/notifications/notification_payload.dart';
import 'core/notifications/notification_startup_coordinator.dart';
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

class IslamFullApp extends ConsumerStatefulWidget {
  const IslamFullApp({
    super.key,
  });

  @override
  ConsumerState<IslamFullApp> createState() => _IslamFullAppState();
}

class _IslamFullAppState extends ConsumerState<IslamFullApp> {
  late final GoRouter _router;

  StreamSubscription<String>? _notificationPayloadSubscription;
  NotificationStartupCoordinator? _notificationStartup;

  bool _notificationsReady = false;

  @override
  void initState() {
    super.initState();

    LocalNotificationService? localNotificationService;
    String? initialLocation;

    if (getIt.isRegistered<LocalNotificationService>()) {
      try {
        localNotificationService = getIt<LocalNotificationService>();

        // Preserve compatibility with an already initialized service.
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
          'Initial notification service unavailable.',
        );
      }
    }

    _router = AppRouter.createRouter(
      initialLocation: initialLocation,
    );

    if (localNotificationService == null) {
      _notificationsReady = true;
      return;
    }

    final service = localNotificationService;

    // Register the listener before starting native initialization.
    _notificationPayloadSubscription = service.notificationPayloads.listen(
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

    _notificationStartup = NotificationStartupCoordinator(
      initialize: service.init,
      takeInitialPayload: service.takeInitialNotificationPayload,
      handleInitialPayload: _handleNotificationPayload,
    );

    // Draw the IslamFull Flutter splash before native plugin startup.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      unawaited(
        _completeNotificationStartup(),
      );
    });
  }

  Future<void> _completeNotificationStartup() async {
    final startup = _notificationStartup;

    if (startup == null) {
      return;
    }

    try {
      await startup.start();
    } catch (_) {
      _logNavigationNotice(
        '[NOTIFICATIONS] '
        'Initialization failed; application startup will continue.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _notificationsReady = true;
        });
      }
    }
  }

  void _handleNotificationPayload(
    String rawPayload,
  ) {
    if (!mounted) {
      return;
    }

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
    _notificationStartup?.dispose();
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

    // Notification scheduling cannot race with plugin initialization.
    if (_notificationsReady) {
      ref.watch(
        notificationCoordinatorProvider,
      );
    }

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
