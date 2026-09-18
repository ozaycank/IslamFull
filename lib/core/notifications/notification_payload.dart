import '../../features/prayer/prayer_times/domain/value_objects/prayer_name.dart';
import '../routing/app_routes.dart';

/// Represents a notification payload that can be safely interpreted by the
/// application.
///
/// Parsing is intentionally strict. Unknown or malformed notification payloads
/// are ignored instead of being allowed to affect application navigation.
sealed class NotificationPayload {
  const NotificationPayload();

  /// Application route that should be opened when this notification is tapped.
  String get location;

  static NotificationPayload? tryParse(
    String? rawPayload,
  ) {
    final payload = rawPayload?.trim();

    if (payload == null || payload.isEmpty) {
      return null;
    }

    final parts = payload.split(':');

    if (parts.isEmpty) {
      return null;
    }

    switch (parts.first) {
      case 'daily-verse':
        return _parseDailyVerse(parts);

      case 'prayer':
        return _parsePrayer(parts);

      default:
        return null;
    }
  }

  static DailyVerseNotificationPayload? _parseDailyVerse(
    List<String> parts,
  ) {
    if (parts.length != 3) {
      return null;
    }

    final surahNumber = int.tryParse(
      parts[1],
    );

    final ayahNumber = int.tryParse(
      parts[2],
    );

    if (surahNumber == null ||
        ayahNumber == null ||
        surahNumber < 1 ||
        surahNumber > 114 ||
        ayahNumber < 1) {
      return null;
    }

    return DailyVerseNotificationPayload(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
    );
  }

  static PrayerNotificationPayload? _parsePrayer(
    List<String> parts,
  ) {
    if (parts.length != 2) {
      return null;
    }

    final prayerValue = parts[1];

    for (final prayerName in PrayerName.values) {
      if (prayerName.name == prayerValue) {
        return PrayerNotificationPayload(
          prayerName: prayerName,
        );
      }
    }

    return null;
  }
}

final class DailyVerseNotificationPayload extends NotificationPayload {
  final int surahNumber;
  final int ayahNumber;

  const DailyVerseNotificationPayload({
    required this.surahNumber,
    required this.ayahNumber,
  });

  @override
  String get location =>
      '${AppRoutes.quran}/surah/$surahNumber?ayah=$ayahNumber';
}

final class PrayerNotificationPayload extends NotificationPayload {
  final PrayerName prayerName;

  const PrayerNotificationPayload({
    required this.prayerName,
  });

  @override
  String get location => AppRoutes.prayer;
}
