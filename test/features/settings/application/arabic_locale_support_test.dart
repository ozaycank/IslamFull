import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:islamfull/features/prayer/prayer_times/domain/value_objects/prayer_name.dart';
import 'package:islamfull/features/settings/application/services/app_locale_policy.dart';
import 'package:islamfull/features/settings/application/services/prayer_notification_text.dart';
import 'package:islamfull/l10n/generated/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'Arabic device locale selects Arabic',
    () {
      expect(
        AppLocalePolicy.fromDeviceLocale(const Locale('ar', 'SA')),
        const Locale('ar'),
      );
    },
  );

  test(
    'Arabic language selection is stored as the normalized locale',
    () {
      expect(
        AppLocalePolicy.fromSavedCode('ar'),
        const Locale('ar'),
      );

      expect(
        AppLocalePolicy.validateSelection(const Locale('ar', 'EG')),
        const Locale('ar'),
      );
    },
  );

  test(
    'unsupported device language retains English fallback',
    () {
      expect(
        AppLocalePolicy.fromDeviceLocale(const Locale('fr', 'FR')),
        const Locale('en'),
      );
    },
  );

  test(
    'Arabic reminders include an Arabic title and prayer name',
    () async {
      final localizations = await AppLocalizations.delegate.load(
        const Locale('ar'),
      );

      final reminder = PrayerNotificationText.forPrayer(
        prayer: PrayerName.asr,
        minutes: 30,
        localizations: localizations,
      );

      expect(reminder.title, localizations.prayerReminders);
      expect(
        reminder.body,
        localizations.prayerNotificationApproaching(
          localizations.prayerAsr,
          30,
        ),
      );
    },
  );

  testWidgets(
    'Arabic MaterialApp lays out content right to left',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          locale: Locale('ar'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: Scaffold(
            body: Center(
              child: Text('مرحبا'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final textContext = tester.element(find.text('مرحبا'));

      expect(
        Directionality.of(textContext),
        TextDirection.rtl,
      );

      expect(
        AppLocalizations.of(textContext)!.settingsTitle,
        'الإعدادات',
      );
    },
  );
}
