import '../../features/prayer/prayer_times/domain/value_objects/prayer_name.dart';

/// Defines deterministic scheduling rules for local notifications.
///
/// Keeping notification ID generation and scheduling calculations outside of
/// platform code makes the behavior testable without Flutter platform channels.
final class NotificationSchedulePolicy {
  NotificationSchedulePolicy._();

  /// Stable ID reserved for the recurring daily verse notification.
  static const int dailyVerseNotificationId = 999900001;

  /// Maximum prayer reminder offset currently supported by the application.
  static const int maxPrayerReminderMinutes = 180;

  /// Creates a collision-safe deterministic prayer notification ID.
  static int prayerNotificationId(
    PrayerName name,
    DateTime prayerTime,
  ) {
    final dateKey = _dateKey(prayerTime);
    return (dateKey * 10) + name.index;
  }

  /// Returns the ID format used by the legacy implementation.
  ///
  /// Kept temporarily so notifications created by previous versions can be
  /// removed safely.
  static int legacyPrayerNotificationId(
    PrayerName name,
    DateTime prayerTime,
  ) {
    return _dateKey(prayerTime) + name.index;
  }

  /// Calculates when a prayer reminder must be displayed.
  ///
  /// The same rule applies to every prayer, including Fajr.
  static DateTime prayerReminderDateTime(
    DateTime prayerTime,
    int reminderMinutes,
  ) {
    if (reminderMinutes < 0 || reminderMinutes > maxPrayerReminderMinutes) {
      throw RangeError.range(
        reminderMinutes,
        0,
        maxPrayerReminderMinutes,
        'reminderMinutes',
      );
    }

    return prayerTime.subtract(
      Duration(minutes: reminderMinutes),
    );
  }

  static int _dateKey(DateTime dateTime) {
    return (dateTime.year * 10000) + (dateTime.month * 100) + dateTime.day;
  }
}
