import 'package:flutter_test/flutter_test.dart';
import 'package:noor_life/core/services/notification_schedule_policy.dart';
import 'package:noor_life/features/prayer/prayer_times/domain/value_objects/prayer_name.dart';

void main() {
  group('NotificationSchedulePolicy - prayer notifications', () {
    test(
      'creates unique prayer IDs across prayers and calendar days',
      () {
        final ids = <int>{};

        for (var day = 1; day <= 31; day++) {
          final date = DateTime(
            2026,
            1,
            day,
            12,
          );

          for (final prayer in PrayerName.values) {
            final id = NotificationSchedulePolicy.prayerNotificationId(
              prayer,
              date,
            );

            expect(
              ids.add(id),
              isTrue,
              reason: 'Duplicate prayer notification ID for '
                  '${prayer.name} on $date',
            );
          }
        }

        expect(
          ids.length,
          31 * PrayerName.values.length,
        );
      },
    );

    test(
      'prevents the collision present in the legacy ID algorithm',
      () {
        final ishaOnSeptember18 = DateTime(
          2026,
          9,
          18,
          20,
        );

        final fajrOnSeptember23 = DateTime(
          2026,
          9,
          23,
          5,
        );

        final legacyIshaId =
            NotificationSchedulePolicy.legacyPrayerNotificationId(
          PrayerName.isha,
          ishaOnSeptember18,
        );

        final legacyFajrId =
            NotificationSchedulePolicy.legacyPrayerNotificationId(
          PrayerName.fajr,
          fajrOnSeptember23,
        );

        // Demonstrates the collision in the old implementation.
        expect(
          legacyIshaId,
          legacyFajrId,
        );

        final newIshaId = NotificationSchedulePolicy.prayerNotificationId(
          PrayerName.isha,
          ishaOnSeptember18,
        );

        final newFajrId = NotificationSchedulePolicy.prayerNotificationId(
          PrayerName.fajr,
          fajrOnSeptember23,
        );

        expect(
          newIshaId,
          isNot(newFajrId),
        );
      },
    );

    test(
      'applies reminder offset to Fajr as well',
      () {
        final fajr = DateTime(
          2026,
          9,
          18,
          5,
          30,
        );

        final reminder = NotificationSchedulePolicy.prayerReminderDateTime(
          fajr,
          30,
        );

        expect(
          reminder,
          DateTime(
            2026,
            9,
            18,
            5,
          ),
        );
      },
    );

    test(
      'rejects negative reminder offsets',
      () {
        expect(
          () => NotificationSchedulePolicy.prayerReminderDateTime(
            DateTime(
              2026,
              9,
              18,
              12,
            ),
            -1,
          ),
          throwsRangeError,
        );
      },
    );

    test(
      'rejects reminder offsets above supported range',
      () {
        expect(
          () => NotificationSchedulePolicy.prayerReminderDateTime(
            DateTime(
              2026,
              9,
              18,
              12,
            ),
            181,
          ),
          throwsRangeError,
        );
      },
    );
  });

  group('NotificationSchedulePolicy - daily verse', () {
    test(
      'keeps historical daily verse IDs stable for migration',
      () {
        expect(
          NotificationSchedulePolicy.legacyDailyVerseNotificationId,
          9999,
        );

        expect(
          NotificationSchedulePolicy.dailyVerseNotificationId,
          999900001,
        );

        expect(
          NotificationSchedulePolicy.legacyDailyVerseNotificationId,
          isNot(NotificationSchedulePolicy.dailyVerseNotificationId),
        );
      },
    );
    test(
      'keeps the Phase 1 recurring notification ID stable',
      () {
        expect(
          NotificationSchedulePolicy.dailyVerseNotificationId,
          999900001,
        );
      },
    );

    test(
      'creates a stable ID for the same calendar date',
      () {
        final morning =
            NotificationSchedulePolicy.dailyVerseNotificationIdForDate(
          DateTime(
            2026,
            9,
            18,
            6,
          ),
        );

        final evening =
            NotificationSchedulePolicy.dailyVerseNotificationIdForDate(
          DateTime(
            2026,
            9,
            18,
            22,
            30,
          ),
        );

        expect(
          morning,
          evening,
        );
      },
    );

    test(
      'creates unique IDs across different calendar dates',
      () {
        final ids = <int>{};

        final startDate = DateTime(2026, 1, 1);

        for (var dayOffset = 0; dayOffset < 365; dayOffset++) {
          final date = startDate.add(
            Duration(days: dayOffset),
          );

          final id = NotificationSchedulePolicy.dailyVerseNotificationIdForDate(
            date,
          );

          expect(
            ids.add(id),
            isTrue,
            reason: 'Duplicate daily verse notification ID for $date',
          );
        }

        expect(
          ids.length,
          365,
        );
      },
    );

    test(
      'date-specific daily verse IDs do not collide with prayer IDs',
      () {
        final startDate = DateTime(2026, 1, 1);

        for (var dayOffset = 0; dayOffset < 365; dayOffset++) {
          final date = startDate.add(
            Duration(days: dayOffset),
          );

          final verseId =
              NotificationSchedulePolicy.dailyVerseNotificationIdForDate(
            date,
          );

          for (final prayer in PrayerName.values) {
            final prayerId = NotificationSchedulePolicy.prayerNotificationId(
              prayer,
              date,
            );

            expect(
              verseId,
              isNot(prayerId),
              reason: 'Daily verse ID collided with '
                  '${prayer.name} on $date',
            );
          }
        }
      },
    );

    test(
      'date-specific IDs stay within signed 32-bit integer range',
      () {
        final id = NotificationSchedulePolicy.dailyVerseNotificationIdForDate(
          DateTime(
            9999,
            12,
            31,
          ),
        );

        expect(
          id,
          lessThanOrEqualTo(2147483647),
        );

        expect(
          id,
          greaterThan(0),
        );
      },
    );

    test(
      'legacy recurring daily verse ID does not collide with current prayer IDs',
      () {
        const verseId = NotificationSchedulePolicy.dailyVerseNotificationId;

        for (var month = 1; month <= 12; month++) {
          for (var day = 1; day <= 28; day++) {
            final date = DateTime(
              2026,
              month,
              day,
            );

            for (final prayer in PrayerName.values) {
              final prayerId = NotificationSchedulePolicy.prayerNotificationId(
                prayer,
                date,
              );

              expect(
                verseId,
                isNot(prayerId),
              );
            }
          }
        }
      },
    );
  });
}
