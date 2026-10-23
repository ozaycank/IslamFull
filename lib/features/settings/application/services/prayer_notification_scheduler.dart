import 'dart:developer' as developer;

import 'package:timezone/timezone.dart' as tz;

import '../../../../core/base/result.dart';
import '../../../../core/services/local_notification_service.dart';
import '../../../../core/services/notification_schedule_policy.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../prayer/location/domain/entities/prayer_location.dart';
import '../../../prayer/prayer_times/domain/entities/prayer_day.dart';
import '../../../prayer/prayer_times/domain/repositories/prayer_times_repository.dart';
import '../../../prayer/prayer_times/domain/value_objects/prayer_name.dart';
import 'prayer_notification_text.dart';

/// Rebuilds a rolling window of local prayer notifications.
///
/// Prayer times are calculated for each selected-location calendar date so
/// reminders continue to exist when the app is not opened daily.
class PrayerNotificationScheduler {
  final PrayerTimesRepository _repository;
  final LocalNotificationService _notificationService;

  const PrayerNotificationScheduler({
    required PrayerTimesRepository repository,
    required LocalNotificationService notificationService,
  })  : _repository = repository,
        _notificationService = notificationService;

  Future<void> reschedule({
    required PrayerLocation location,
    required int reminderMinutes,
    required AppLocalizations localizations,
    DateTime? referenceNow,
  }) async {
    final timezone = _resolveLocation(location.timezoneIdentifier);

    if (timezone == null) {
      developer.log(
        'Prayer notification scheduling skipped because timezone could not be resolved.',
        name: 'PrayerNotificationScheduler',
      );
      return;
    }

    final now = referenceNow == null
        ? tz.TZDateTime.now(timezone)
        : tz.TZDateTime.from(referenceNow, timezone);
    final today = DateTime(now.year, now.month, now.day);

    await _notificationService.cancelPrayerNotificationsWindow(
      DateTime(today.year, today.month, today.day - 1),
      days: NotificationSchedulePolicy.prayerCleanupWindowDays,
    );

    for (var offset = 0;
        offset < NotificationSchedulePolicy.prayerRollingWindowDays;
        offset++) {
      final targetDate = DateTime.utc(
        today.year,
        today.month,
        today.day + offset,
      );

      final PrayerDay prayerDay;

      try {
        final result = await _repository.getPrayerTimes(
          location,
          targetDate,
        );

        switch (result) {
          case Success(value: final day):
            prayerDay = day;
          case ResultFailure(failure: final failure):
            developer.log(
              'Prayer notification calculation failed for $targetDate.',
              name: 'PrayerNotificationScheduler',
              error: failure,
            );
            continue;
        }
      } catch (error, stackTrace) {
        developer.log(
          'Prayer notification preparation failed for $targetDate.',
          name: 'PrayerNotificationScheduler',
          error: error,
          stackTrace: stackTrace,
        );
        continue;
      }

      for (final prayer in prayerDay.prayerTimes) {
        if (prayer.name == PrayerName.sunrise) {
          continue;
        }

        final content = PrayerNotificationText.forPrayer(
          prayer: prayer.name,
          minutes: reminderMinutes,
          localizations: localizations,
        );

        try {
          await _notificationService.schedulePrayer(
            prayer,
            reminderMinutes,
            content.title,
            content.body,
            location.timezoneIdentifier,
          );
        } catch (error, stackTrace) {
          developer.log(
            'Failed to schedule ${prayer.name.name} on $targetDate.',
            name: 'PrayerNotificationScheduler',
            error: error,
            stackTrace: stackTrace,
          );
        }
      }
    }
  }

  tz.Location? _resolveLocation(String timezoneId) {
    if (timezoneId.trim().isEmpty) {
      return null;
    }

    try {
      return tz.getLocation(timezoneId);
    } catch (_) {
      return null;
    }
  }
}
