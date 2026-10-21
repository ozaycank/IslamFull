import '../../../../l10n/generated/app_localizations.dart';
import '../../../prayer/prayer_times/domain/value_objects/prayer_name.dart';

/// Builds prayer notifications using the selected application locale.
class PrayerNotificationText {
  final String title;
  final String body;

  const PrayerNotificationText({
    required this.title,
    required this.body,
  });

  factory PrayerNotificationText.forPrayer({
    required PrayerName prayer,
    required int minutes,
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

    return PrayerNotificationText(
      title: localizations.prayerReminders,
      body: localizations.prayerNotificationApproaching(
        prayerName,
        minutes,
      ),
    );
  }
}
