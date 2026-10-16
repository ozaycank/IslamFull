import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import 'app.dart';
import 'core/di/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Prayer calculations and timezone conversion require timezone data.
  tz.initializeTimeZones();

  await configureDependencies();

  // Render the app without waiting for native notification initialization.
  // Notification startup is coordinated after the first Flutter frame.
  runApp(
    const ProviderScope(
      child: NoorLifeApp(),
    ),
  );
}
