import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islamfull/features/prayer/prayer_times/domain/value_objects/prayer_name.dart';
import 'package:islamfull/features/settings/application/services/prayer_notification_text.dart';
import 'package:islamfull/l10n/generated/app_localizations.dart';

void main() {
  test('keeps the existing before-prayer reminder text', () async {
    final localizations = await AppLocalizations.delegate.load(
      const Locale('tr'),
    );

    final content = PrayerNotificationText.forPrayer(
      prayer: PrayerName.dhuhr,
      minutes: 15,
      localizations: localizations,
    );

    expect(content.title, localizations.prayerReminders);
    expect(
      content.body,
      localizations.prayerNotificationApproaching(
        localizations.prayerDhuhr,
        15,
      ),
    );
  });

  test('builds a localized notification for the exact prayer time', () async {
    final localizations = await AppLocalizations.delegate.load(
      const Locale('tr'),
    );

    final content = PrayerNotificationText.atPrayerTime(
      prayer: PrayerName.dhuhr,
      localizations: localizations,
    );

    expect(content.title, localizations.prayerReminders);
    expect(
      content.body,
      localizations.prayerNotificationAtTime(
        localizations.prayerDhuhr,
      ),
    );
    expect(content.body, contains('Öğle'));
    expect(content.body, contains('vakti'));
  });
}
