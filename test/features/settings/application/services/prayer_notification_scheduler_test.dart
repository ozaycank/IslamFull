import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islamfull/core/base/result.dart';
import 'package:islamfull/core/services/local_notification_service.dart';
import 'package:islamfull/features/prayer/location/domain/entities/prayer_location.dart';
import 'package:islamfull/features/prayer/prayer_times/domain/entities/prayer_day.dart';
import 'package:islamfull/features/prayer/prayer_times/domain/entities/prayer_time.dart';
import 'package:islamfull/features/prayer/prayer_times/domain/repositories/prayer_times_repository.dart';
import 'package:islamfull/features/prayer/prayer_times/domain/value_objects/prayer_name.dart';
import 'package:islamfull/features/prayer/shared/domain/errors/prayer_failure.dart';
import 'package:islamfull/features/settings/application/providers/notification_settings_provider.dart';
import 'package:islamfull/features/settings/application/services/prayer_notification_scheduler.dart';
import 'package:islamfull/l10n/generated/app_localizations.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() {
  setUpAll(tz.initializeTimeZones);

  test('notification categories are disabled until explicitly enabled', () {
    const settings = NotificationSettingsState();

    expect(settings.masterEnabled, isFalse);
    expect(settings.dailyVerseEnabled, isFalse);
  });

  const location = PrayerLocation(
    latitude: 41.0082,
    longitude: 28.9784,
    cityName: 'Istanbul',
    countryName: 'Türkiye',
    timezoneIdentifier: 'Europe/Istanbul',
  );

  test('schedules a seven-day prayer window and clears stale IDs first',
      () async {
    final repository = _FakePrayerTimesRepository();
    final notifications = _FakeLocalNotificationService();
    final scheduler = PrayerNotificationScheduler(
      repository: repository,
      notificationService: notifications,
    );
    final localizations = await AppLocalizations.delegate.load(
      const Locale('en'),
    );

    await scheduler.reschedule(
      location: location,
      reminderMinutes: 30,
      localizations: localizations,
      referenceNow: DateTime.utc(2026, 9, 18, 10),
    );

    expect(notifications.cancelledWindowStart, DateTime(2026, 9, 17));
    expect(notifications.cancelledWindowDays, 9);
    expect(repository.requestedDates, hasLength(7));
    expect(
      repository.requestedDates,
      List<DateTime>.generate(
        7,
        (offset) => DateTime.utc(2026, 9, 18 + offset),
      ),
    );
    expect(notifications.events.first, 'cancel-window');
    expect(notifications.scheduledPrayers, hasLength(35));
    expect(
      notifications.scheduledPrayers.any(
        (item) => item.name == PrayerName.sunrise,
      ),
      isFalse,
    );
    expect(
      notifications.scheduledPrayers.map((item) => item.time.day).toSet(),
      <int>{18, 19, 20, 21, 22, 23, 24},
    );
  });

  test('continues rebuilding later days if one calculation fails', () async {
    final repository = _FakePrayerTimesRepository(failingDay: 20);
    final notifications = _FakeLocalNotificationService();
    final scheduler = PrayerNotificationScheduler(
      repository: repository,
      notificationService: notifications,
    );
    final localizations = await AppLocalizations.delegate.load(
      const Locale('en'),
    );

    await scheduler.reschedule(
      location: location,
      reminderMinutes: 30,
      localizations: localizations,
      referenceNow: DateTime.utc(2026, 9, 18, 10),
    );

    expect(repository.requestedDates, hasLength(7));
    expect(notifications.scheduledPrayers, hasLength(30));
    expect(
      notifications.scheduledPrayers.any((item) => item.time.day == 20),
      isFalse,
    );
    expect(
      notifications.scheduledPrayers.any((item) => item.time.day == 24),
      isTrue,
    );
  });
}

class _FakePrayerTimesRepository implements PrayerTimesRepository {
  final List<DateTime> requestedDates = [];
  final int? failingDay;

  _FakePrayerTimesRepository({this.failingDay});

  @override
  Future<Result<PrayerDay, PrayerFailure>> getPrayerTimes(
    PrayerLocation location,
    DateTime targetDate,
  ) async {
    requestedDates.add(targetDate);

    if (targetDate.day == failingDay) {
      return const ResultFailure<PrayerDay, PrayerFailure>(
        PrayerCalculationFailure('Simulated date calculation failure.'),
      );
    }

    final timezone = tz.getLocation(location.timezoneIdentifier);
    final prayers = <(PrayerName, int)>[
      (PrayerName.fajr, 5),
      (PrayerName.sunrise, 6),
      (PrayerName.dhuhr, 12),
      (PrayerName.asr, 15),
      (PrayerName.maghrib, 18),
      (PrayerName.isha, 20),
    ];

    return Success(
      PrayerDay(
        targetDate: targetDate,
        prayerTimes: [
          for (final entry in prayers)
            PrayerTime(
              name: entry.$1,
              time: tz.TZDateTime(
                timezone,
                targetDate.year,
                targetDate.month,
                targetDate.day,
                entry.$2,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Future<Result<PrayerDay, PrayerFailure>> refreshPrayerTimes(
    PrayerLocation location,
    DateTime targetDate,
  ) =>
      getPrayerTimes(location, targetDate);
}

class _ScheduledPrayer {
  final PrayerName name;
  final DateTime time;
  final int reminderMinutes;

  const _ScheduledPrayer({
    required this.name,
    required this.time,
    required this.reminderMinutes,
  });
}

class _FakeLocalNotificationService extends LocalNotificationService {
  DateTime? cancelledWindowStart;
  int? cancelledWindowDays;
  final List<String> events = [];
  final List<_ScheduledPrayer> scheduledPrayers = [];

  @override
  bool get isSupportedPlatform => true;

  @override
  Future<void> cancelPrayerNotificationsWindow(
    DateTime startDate, {
    required int days,
  }) async {
    cancelledWindowStart = startDate;
    cancelledWindowDays = days;
    events.add('cancel-window');
  }

  @override
  Future<void> schedulePrayer(
    PrayerTime prayer,
    int reminderMinutes,
    String title,
    String body,
    String timezoneId,
  ) async {
    events.add('schedule-${prayer.name.name}-${prayer.time.day}');
    scheduledPrayers.add(
      _ScheduledPrayer(
        name: prayer.name,
        time: prayer.time,
        reminderMinutes: reminderMinutes,
      ),
    );
  }
}
