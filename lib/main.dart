import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import 'app.dart';
import 'core/config/environment_config.dart';
import 'core/di/injection_container.dart';
import 'core/logging/logger_service.dart';
import 'core/services/local_notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EnvironmentConfig.init();

  tz.initializeTimeZones();

  await configureDependencies();

  if (getIt.isRegistered<LocalNotificationService>()) {
    try {
      await getIt<LocalNotificationService>().init();
    } catch (_) {
      if (getIt.isRegistered<LoggerService>()) {
        getIt<LoggerService>().debug(
          '[NOTIFICATIONS] '
          'Initialization failed; application startup will continue.',
        );
      }
    }
  }

  runApp(
    const ProviderScope(
      child: NoorLifeApp(),
    ),
  );
}
