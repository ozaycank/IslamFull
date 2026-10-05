import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/core/routing/app_routes.dart';
import 'package:noor_life/core/routing/route_location_policy.dart';

void main() {
  group(
    'RouteLocationPolicy',
    () {
      test(
        'accepts known static app route',
        () {
          expect(
            RouteLocationPolicy.sanitizeNotificationLocation(
              AppRoutes.qibla,
            ),
            AppRoutes.qibla,
          );
        },
      );

      test(
        'rejects unknown application route',
        () {
          expect(
            RouteLocationPolicy.sanitizeNotificationLocation(
              '/definitely-not-a-route',
            ),
            isNull,
          );
        },
      );

      test(
        'rejects absolute external URL',
        () {
          expect(
            RouteLocationPolicy.sanitizeNotificationLocation(
              'https://example.com/settings',
            ),
            isNull,
          );
        },
      );

      test(
        'rejects protocol-relative external destination',
        () {
          expect(
            RouteLocationPolicy.sanitizeNotificationLocation(
              '//example.com/settings',
            ),
            isNull,
          );
        },
      );

      test(
        'accepts valid surah route and keeps only valid ayah parameter',
        () {
          expect(
            RouteLocationPolicy.sanitizeNotificationLocation(
              '/quran/surah/2?ayah=255&token=secret',
            ),
            '/quran/surah/2?ayah=255',
          );
        },
      );

      test(
        'rejects invalid surah number',
        () {
          expect(
            RouteLocationPolicy.sanitizeNotificationLocation(
              '/quran/surah/115',
            ),
            isNull,
          );

          expect(
            RouteLocationPolicy.sanitizeNotificationLocation(
              '/quran/surah/0',
            ),
            isNull,
          );
        },
      );

      test(
        'invalid ayah parameter is removed without rejecting valid surah',
        () {
          expect(
            RouteLocationPolicy.sanitizeNotificationLocation(
              '/quran/surah/36?ayah=-4',
            ),
            '/quran/surah/36',
          );
        },
      );

      test(
        'surah parser accepts only Quran range',
        () {
          expect(
            RouteLocationPolicy.tryParseSurahNumber(
              '1',
            ),
            1,
          );

          expect(
            RouteLocationPolicy.tryParseSurahNumber(
              '114',
            ),
            114,
          );

          expect(
            RouteLocationPolicy.tryParseSurahNumber(
              '999',
            ),
            isNull,
          );

          expect(
            RouteLocationPolicy.tryParseSurahNumber(
              'abc',
            ),
            isNull,
          );
        },
      );
    },
  );
}
