import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/features/prayer/prayer_times/domain/value_objects/prayer_name.dart';
import 'package:noor_life/features/settings/application/services/prayer_notification_text.dart';
import 'package:noor_life/l10n/generated/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Turkish prayer reminder uses Turkish text', () async {
    final localizations = await AppLocalizations.delegate.load(
      const Locale('tr'),
    );

    final content = PrayerNotificationText.forPrayer(
      prayer: PrayerName.asr,
      localizations: localizations,
    );

    expect(
      content.title,
      localizations.prayerReminders,
    );

    expect(
      content.body,
      '${localizations.prayerAsr} vaktine az kaldı.',
    );

    expect(
      content.body,
      isNot(contains('is approaching')),
    );
  });

  test('English prayer reminder uses English text', () async {
    final localizations = await AppLocalizations.delegate.load(
      const Locale('en'),
    );

    final content = PrayerNotificationText.forPrayer(
      prayer: PrayerName.isha,
      localizations: localizations,
    );

    expect(
      content.title,
      localizations.prayerReminders,
    );

    expect(
      content.body,
      '${localizations.prayerIsha} is approaching.',
    );
  });

  test('all five prayer reminders receive localized names', () async {
    final localizations = await AppLocalizations.delegate.load(
      const Locale('tr'),
    );

    final expectedNames = <PrayerName, String>{
      PrayerName.fajr: localizations.prayerFajr,
      PrayerName.dhuhr: localizations.prayerDhuhr,
      PrayerName.asr: localizations.prayerAsr,
      PrayerName.maghrib: localizations.prayerMaghrib,
      PrayerName.isha: localizations.prayerIsha,
    };

    for (final entry in expectedNames.entries) {
      final content = PrayerNotificationText.forPrayer(
        prayer: entry.key,
        localizations: localizations,
      );

      expect(
        content.body,
        '${entry.value} vaktine az kaldı.',
      );
    }
  });
}
