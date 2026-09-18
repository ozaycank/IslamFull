import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import 'app.dart';
import 'core/config/environment_config.dart';
import 'core/di/injection_container.dart';
import 'core/services/local_notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EnvironmentConfig.init();

  tz.initializeTimeZones();

  await configureDependencies();

  await getIt<LocalNotificationService>().init();

  runApp(
    const ProviderScope(
      child: NoorLifeApp(),
    ),
  );
}
