import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'Arabic ARB has the complete EN/TR translation key set',
    () {
      final en = jsonDecode(
        File('lib/l10n/arb/app_en.arb').readAsStringSync(),
      ) as Map<String, dynamic>;

      final tr = jsonDecode(
        File('lib/l10n/arb/app_tr.arb').readAsStringSync(),
      ) as Map<String, dynamic>;

      final ar = jsonDecode(
        File('lib/l10n/arb/app_ar.arb').readAsStringSync(),
      ) as Map<String, dynamic>;

      Set<String> translationKeys(Map<String, dynamic> values) => values.keys
          .where(
            (key) => !key.startsWith('@'),
          )
          .toSet();

      final enKeys = translationKeys(en);
      final trKeys = translationKeys(tr);
      final arKeys = translationKeys(ar);

      expect(enKeys.length, 719);
      expect(trKeys, enKeys);
      expect(arKeys, enKeys);
      expect(ar['@@locale'], 'ar');

      final variables = RegExp(r'\{[A-Za-z][A-Za-z0-9_]*\}');

      for (final key in enKeys) {
        final enText = en[key] as String;
        final trText = tr[key] as String;
        final arText = ar[key] as String;

        expect(arText.trim(), isNotEmpty, reason: key);

        List<String> placeholders(String value) =>
            variables.allMatches(value).map((match) => match.group(0)!).toList()
              ..sort();

        expect(
          placeholders(arText),
          placeholders(enText),
          reason: 'Arabic placeholder mismatch in $key',
        );

        expect(
          placeholders(trText),
          placeholders(enText),
          reason: 'Turkish placeholder mismatch in $key',
        );
      }
    },
  );

  test(
    'Arabic UI strings have no accidental EN/TR fallback text',
    () {
      final ar = jsonDecode(
        File('lib/l10n/arb/app_ar.arb').readAsStringSync(),
      ) as Map<String, dynamic>;

      const allowedNonArabicKeys = <String>{
        'appTitle',
        'languageEnglish',
        'languageTurkish',
        'duaWakeTransliteration',
        'duaSleepTransliteration',
        'duaLeavingHomeTransliteration',
        'duaRestroomTransliteration',
        'duaAfterMealTransliteration',
        'duaTravelTransliteration',
        'duaAfterPrayerDhikrTransliteration',
        'homeShahadaTransliteration',
      };

      final arabicScript = RegExp(r'[\u0600-\u06FF]');

      for (final entry in ar.entries) {
        if (entry.key.startsWith('@') ||
            allowedNonArabicKeys.contains(entry.key)) {
          continue;
        }

        expect(
          arabicScript.hasMatch(entry.value as String),
          isTrue,
          reason: 'Arabic text not found in ${entry.key}',
        );
      }
    },
  );
}
