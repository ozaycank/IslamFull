import '../../../../l10n/generated/app_localizations.dart';
import '../../../prayer/prayer_times/domain/value_objects/prayer_name.dart';

/// Language-aware title and body for a scheduled prayer reminder.
///
/// Prayer names and reminder titles reuse existing ARB translations.
/// Additional languages can extend the body template in a later phase.
class PrayerNotificationText {
  final String title;
  final String body;

  const PrayerNotificationText({
    required this.title,
    required this.body,
  });

  factory PrayerNotificationText.forPrayer({
    required PrayerName prayer,
    required AppLocalizations localizations,
  }) {
    final prayerName = switch (prayer) {
      PrayerName.fajr => localizations.prayerFajr,
      PrayerName.sunrise => localizations.prayerSunrise,
      PrayerName.dhuhr => localizations.prayerDhuhr,
      PrayerName.asr => localizations.prayerAsr,
      PrayerName.maghrib => localizations.prayerMaghrib,
      PrayerName.isha => localizations.prayerIsha,
    };

    final languageCode = localizations.localeName.split('_').first;

    final body = switch (languageCode) {
      'tr' => '$prayerName vaktine az kaldı.',
      _ => '$prayerName is approaching.',
    };

    return PrayerNotificationText(
      title: localizations.prayerReminders,
      body: body,
    );
  }
}
