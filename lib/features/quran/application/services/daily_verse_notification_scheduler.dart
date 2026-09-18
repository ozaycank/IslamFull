import 'dart:developer' as developer;

import 'package:timezone/timezone.dart' as tz;

import '../../../../core/services/local_notification_service.dart';
import 'daily_verse_notification_content_service.dart';

class DailyVerseNotificationScheduler {
  static const int rollingWindowDays = 7;

  /// One day before + the seven-day active window + one extra future day.
  ///
  /// This safely cleans nearby schedules when timezone, language, delivery
  /// time, or user preferences change.
  static const int cleanupWindowDays = rollingWindowDays + 2;

  final DailyVerseNotificationContentService _contentService;
  final LocalNotificationService _notificationService;

  const DailyVerseNotificationScheduler({
    required DailyVerseNotificationContentService contentService,
    required LocalNotificationService notificationService,
  })  : _contentService = contentService,
        _notificationService = notificationService;

  /// Rebuilds the complete seven-day Daily Verse notification window.
  ///
  /// Returns the number of notifications successfully accepted by the local
  /// notification service.
  Future<int> reschedule({
    required String notificationTime,
    required String languageCode,
    required String timezoneId,
    required String title,
    DateTime? referenceNow,
  }) async {
    final location = _resolveLocation(
      timezoneId,
    );

    if (location == null) {
      developer.log(
        'Daily Verse scheduling skipped because timezone could not be resolved: '
        '$timezoneId',
        name: 'DailyVerseNotificationScheduler',
      );

      return 0;
    }

    final today = _calendarDateForLocation(
      location,
      referenceNow,
    );

    await _notificationService.cancelLegacyDailyVerseSchedules();

    await _cancelRollingWindow(
      today,
    );

    var scheduledCount = 0;

    for (var offset = 0; offset < rollingWindowDays; offset++) {
      final date = DateTime(
        today.year,
        today.month,
        today.day + offset,
      );

      try {
        final content = await _contentService.buildForDate(
          date: date,
          languageCode: languageCode,
        );

        if (content == null) {
          continue;
        }

        final scheduled = await _notificationService.scheduleDailyVerseForDate(
          date: date,
          timeString: notificationTime,
          title: title,
          body: content.notificationBody,
          timezoneId: timezoneId,
          payload: content.payload,
        );

        if (scheduled) {
          scheduledCount++;
        }
      } catch (error, stackTrace) {
        // One malformed day must not prevent the remaining rolling window from
        // being scheduled.
        developer.log(
          'Failed to prepare Daily Verse notification for $date.',
          name: 'DailyVerseNotificationScheduler',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }

    return scheduledCount;
  }

  /// Removes all Daily Verse schedules controlled by the current and legacy
  /// implementations.
  Future<void> cancel({
    String? timezoneId,
    DateTime? referenceNow,
  }) async {
    await _notificationService.cancelLegacyDailyVerseSchedules();

    final today = _resolveCancellationDate(
      timezoneId,
      referenceNow,
    );

    await _cancelRollingWindow(
      today,
    );
  }

  Future<void> _cancelRollingWindow(
    DateTime today,
  ) async {
    final cleanupStart = DateTime(
      today.year,
      today.month,
      today.day - 1,
    );

    await _notificationService.cancelDailyVerseWindow(
      cleanupStart,
      days: cleanupWindowDays,
    );
  }

  DateTime _resolveCancellationDate(
    String? timezoneId,
    DateTime? referenceNow,
  ) {
    if (timezoneId != null && timezoneId.trim().isNotEmpty) {
      final location = _resolveLocation(
        timezoneId,
      );

      if (location != null) {
        return _calendarDateForLocation(
          location,
          referenceNow,
        );
      }
    }

    final now = referenceNow ?? DateTime.now();

    return DateTime(
      now.year,
      now.month,
      now.day,
    );
  }

  DateTime _calendarDateForLocation(
    tz.Location location,
    DateTime? referenceNow,
  ) {
    final zonedNow = referenceNow == null
        ? tz.TZDateTime.now(location)
        : tz.TZDateTime.from(
            referenceNow,
            location,
          );

    return DateTime(
      zonedNow.year,
      zonedNow.month,
      zonedNow.day,
    );
  }

  tz.Location? _resolveLocation(
    String timezoneId,
  ) {
    if (timezoneId.trim().isEmpty) {
      return null;
    }

    try {
      return tz.getLocation(
        timezoneId,
      );
    } catch (_) {
      return null;
    }
  }
}
