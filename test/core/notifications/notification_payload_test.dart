import 'package:flutter_test/flutter_test.dart';
import 'package:noor_life/core/notifications/notification_payload.dart';
import 'package:noor_life/features/prayer/prayer_times/domain/value_objects/prayer_name.dart';

void main() {
  group(
    'NotificationPayload - Daily Verse',
    () {
      test(
        'parses a valid daily verse payload',
        () {
          final payload = NotificationPayload.tryParse(
            'daily-verse:112:3',
          );

          expect(
            payload,
            isA<DailyVerseNotificationPayload>(),
          );

          final dailyVerse = payload! as DailyVerseNotificationPayload;

          expect(
            dailyVerse.surahNumber,
            112,
          );

          expect(
            dailyVerse.ayahNumber,
            3,
          );

          expect(
            dailyVerse.location,
            '/quran/surah/112?ayah=3',
          );
        },
      );

      test(
        'rejects malformed daily verse payloads',
        () {
          const invalidPayloads = [
            'daily-verse',
            'daily-verse:1',
            'daily-verse:1:2:3',
            'daily-verse:test:1',
            'daily-verse:1:test',
            'daily-verse:0:1',
            'daily-verse:115:1',
            'daily-verse:1:0',
          ];

          for (final rawPayload in invalidPayloads) {
            expect(
              NotificationPayload.tryParse(
                rawPayload,
              ),
              isNull,
              reason: 'Payload should be rejected: $rawPayload',
            );
          }
        },
      );
    },
  );

  group(
    'NotificationPayload - Prayer',
    () {
      test(
        'parses a valid prayer payload',
        () {
          final payload = NotificationPayload.tryParse(
            'prayer:isha',
          );

          expect(
            payload,
            isA<PrayerNotificationPayload>(),
          );

          final prayer = payload! as PrayerNotificationPayload;

          expect(
            prayer.prayerName,
            PrayerName.isha,
          );

          expect(
            prayer.location,
            '/prayer',
          );
        },
      );

      test(
        'rejects an unknown prayer name',
        () {
          expect(
            NotificationPayload.tryParse(
              'prayer:not-a-prayer',
            ),
            isNull,
          );
        },
      );
    },
  );

  test(
    'ignores empty and unknown notification payloads',
    () {
      expect(
        NotificationPayload.tryParse(
          null,
        ),
        isNull,
      );

      expect(
        NotificationPayload.tryParse(
          '',
        ),
        isNull,
      );

      expect(
        NotificationPayload.tryParse(
          '   ',
        ),
        isNull,
      );

      expect(
        NotificationPayload.tryParse(
          'unknown:payload',
        ),
        isNull,
      );
    },
  );
}
