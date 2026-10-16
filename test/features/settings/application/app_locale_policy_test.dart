import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/features/settings/application/services/app_locale_policy.dart';

void main() {
  group('AppLocalePolicy', () {
    test('Turkish device locale resolves to Turkish', () {
      expect(
        AppLocalePolicy.fromDeviceLocale(
          const Locale('tr', 'TR'),
        ),
        const Locale('tr'),
      );
    });

    test('English device variants resolve to English', () {
      expect(
        AppLocalePolicy.fromDeviceLocale(
          const Locale('en', 'GB'),
        ),
        const Locale('en'),
      );

      expect(
        AppLocalePolicy.fromDeviceLocale(
          const Locale('en', 'US'),
        ),
        const Locale('en'),
      );
    });

    test('unsupported device languages default to English', () {
      for (final code in <String>[
        'ar',
        'de',
        'fr',
        'und',
      ]) {
        expect(
          AppLocalePolicy.fromDeviceLocale(
            Locale(code),
          ),
          const Locale('en'),
        );
      }
    });

    test('stored Turkish and English preferences are recognized', () {
      expect(
        AppLocalePolicy.fromSavedCode('tr'),
        const Locale('tr'),
      );

      expect(
        AppLocalePolicy.fromSavedCode('en'),
        const Locale('en'),
      );
    });

    test('unknown or empty stored preferences are ignored', () {
      expect(
        AppLocalePolicy.fromSavedCode(null),
        isNull,
      );

      expect(
        AppLocalePolicy.fromSavedCode(''),
        isNull,
      );

      expect(
        AppLocalePolicy.fromSavedCode('ar'),
        isNull,
      );
    });

    test('manual choices are normalized and validated', () {
      expect(
        AppLocalePolicy.validateSelection(
          const Locale('tr', 'TR'),
        ),
        const Locale('tr'),
      );

      expect(
        () => AppLocalePolicy.validateSelection(
          const Locale('ar'),
        ),
        throwsArgumentError,
      );
    });
  });
}
