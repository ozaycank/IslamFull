import 'package:flutter_test/flutter_test.dart';
import 'package:noor_life/core/services/notification_schedule_policy.dart';
import 'package:noor_life/features/prayer/prayer_times/domain/value_objects/prayer_name.dart';

void main() {
  group('NotificationSchedulePolicy', () {
    test('creates unique prayer IDs across prayers and calendar days', () {
      final ids = <int>{};

      for (var day = 1; day <= 31; day++) {
        final date = DateTime(2026, 1, day, 12);

        for (final prayer in PrayerName.values) {
          ids.add(
            NotificationSchedulePolicy.prayerNotificationId(
              prayer,
              date,
            ),
          );
        }
      }

      expect(
        ids.length,
        31 * PrayerName.values.length,
      );
    });

    test('prevents the collision present in the legacy ID algorithm', () {
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
      expect(legacyIshaId, legacyFajrId);

      final newIshaId = NotificationSchedulePolicy.prayerNotificationId(
        PrayerName.isha,
        ishaOnSeptember18,
      );

      final newFajrId = NotificationSchedulePolicy.prayerNotificationId(
        PrayerName.fajr,
        fajrOnSeptember23,
      );

      expect(newIshaId, isNot(newFajrId));
    });

    test('applies reminder offset to Fajr as well', () {
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
        DateTime(2026, 9, 18, 5),
      );
    });

    test('rejects negative reminder offsets', () {
      expect(
        () => NotificationSchedulePolicy.prayerReminderDateTime(
          DateTime(2026, 9, 18, 12),
          -1,
        ),
        throwsRangeError,
      );
    });

    test('rejects reminder offsets above supported range', () {
      expect(
        () => NotificationSchedulePolicy.prayerReminderDateTime(
          DateTime(2026, 9, 18, 12),
          181,
        ),
        throwsRangeError,
      );
    });
  });
  group('daily verse notification IDs', () {
    test(
      'are unique across different calendar dates',
      () {
        final ids = <int>{};

        for (var day = 1; day <= 30; day++) {
          final date = DateTime(
            2026,
            9,
            day,
          );

          const id = NotificationSchedulePolicy.dailyVerseNotificationId;
          expect(
            ids.add(id),
            isTrue,
            reason: 'Duplicate daily verse ID for $date',
          );
        }
      },
    );

    test(
      'do not collide with prayer notification IDs',
      () {
        for (var day = 1; day <= 30; day++) {
          final date = DateTime(
            2026,
            9,
            day,
          );

          for (final prayer in PrayerName.values) {
            final prayerId = NotificationSchedulePolicy.prayerNotificationId(
              prayer,
              date,
            );
            const verseId = NotificationSchedulePolicy.dailyVerseNotificationId;
            expect(
              verseId,
              isNot(prayerId),
            );
          }
        }
      },
    );
  });
}
