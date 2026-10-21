import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  Map<String, dynamic> loadArb(String languageCode) {
    final file = File('lib/l10n/arb/app_$languageCode.arb');
    return jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  }

  test(
    'Arabic language and prayer notification metadata exist for all locales',
    () {
      for (final languageCode in <String>['en', 'tr', 'ar']) {
        final arb = loadArb(languageCode);
        final languageMetadata =
            arb['@languageArabic'] as Map<String, dynamic>?;
        final prayerMetadata =
            arb['@prayerNotificationApproaching'] as Map<String, dynamic>?;

        expect(
          languageMetadata?['description'],
          isNotEmpty,
          reason: languageCode,
        );

        expect(
          prayerMetadata?['description'],
          isNotEmpty,
          reason: languageCode,
        );

        final placeholders =
            prayerMetadata?['placeholders'] as Map<String, dynamic>?;

        expect(
          placeholders?['prayerName'],
          isNotNull,
          reason: languageCode,
        );
      }
    },
  );

  test(
    'Turkish locale retains correct Unicode in newly added strings',
    () {
      final tr = loadArb('tr');

      expect(
        tr['languageArabic'],
        'Arapça',
      );

      expect(
        tr['prayerNotificationApproaching'],
        '{prayerName} vaktine {minutes} dakika kaldı.',
      );
    },
  );
}
