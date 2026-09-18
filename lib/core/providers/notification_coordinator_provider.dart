import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/prayer/prayer_times/application/providers/prayer_times_notifier.dart';
import '../../features/settings/application/providers/notification_settings_provider.dart';

/// Coordinates notification scheduling across independent application features.
///
/// The prayer feature must not know about notification settings. Instead, this
/// application-level coordinator reacts to prayer-state changes and requests a
/// notification schedule refresh.
final notificationCoordinatorProvider = Provider<void>((ref) {
  ref.watch(notificationSettingsProvider);

  ref.listen(
    prayerTimesNotifierProvider,
    (previous, next) {
      final scheduleAvailable = next.schedule != null && next.location != null;

      if (!scheduleAvailable) {
        return;
      }

      final scheduleChanged = previous?.schedule != next.schedule ||
          previous?.location != next.location;

      if (!scheduleChanged) {
        return;
      }

      unawaited(
        ref
            .read(
              notificationSettingsProvider.notifier,
            )
            .syncPrayerSchedule(),
      );
    },
  );
});
