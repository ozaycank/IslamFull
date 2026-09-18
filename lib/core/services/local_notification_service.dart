import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../features/prayer/prayer_times/domain/entities/prayer_time.dart';
import '../../features/prayer/prayer_times/domain/value_objects/prayer_name.dart';
import 'notification_schedule_policy.dart';

@lazySingleton
class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  /// flutter_local_notifications in the current project is configured only for
  /// Android and iOS. Windows support will be provided by the cross-platform
  /// notification backend introduced in Phase 2.
  bool get isSupportedPlatform {
    if (kIsWeb) return false;

    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  Future<void> init() async {
    if (_isInitialized) return;

    // Mark unsupported platforms as initialized so repeated calls remain cheap.
    if (!isSupportedPlatform) {
      _isInitialized = true;
      return;
    }

    tz.initializeTimeZones();

    const androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosInitializationSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _plugin.initialize(initializationSettings);
    _isInitialized = true;
  }

  Future<bool> requestPermission() async {
    if (!isSupportedPlatform) return false;

    await _ensureInitialized();

    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      final notificationPermission =
          await androidPlugin.requestNotificationsPermission();

      // Exact alarms improve prayer reminder precision on supported Android
      // versions. Scheduling still has an inexact fallback if this permission
      // is unavailable.
      try {
        await androidPlugin.requestExactAlarmsPermission();
      } on PlatformException {
        // Notification permission and exact alarm permission are independent.
        // Do not disable all notifications merely because exact alarms were
        // rejected by the operating system.
      }

      return notificationPermission ?? false;
    }

    final iosPlugin = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();

    if (iosPlugin != null) {
      final granted = await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

      return granted ?? false;
    }

    return false;
  }

  Future<void> cancelAll() async {
    if (!isSupportedPlatform) return;

    await _ensureInitialized();
    await _plugin.cancelAll();
  }

  Future<void> cancelDailyVerse() async {
    if (!isSupportedPlatform) return;

    await _ensureInitialized();
    await _plugin.cancel(
      NotificationSchedulePolicy.dailyVerseNotificationId,
    );
  }

  Future<void> cancelPrayer(PrayerTime prayer) async {
    if (!isSupportedPlatform) return;

    await _ensureInitialized();

    final currentId = NotificationSchedulePolicy.prayerNotificationId(
      prayer.name,
      prayer.time,
    );

    final legacyId = NotificationSchedulePolicy.legacyPrayerNotificationId(
      prayer.name,
      prayer.time,
    );

    await _plugin.cancel(currentId);

    if (legacyId != currentId) {
      await _plugin.cancel(legacyId);
    }
  }

  Future<void> schedulePrayer(
    PrayerTime prayer,
    int reminderMinutes,
    String title,
    String body,
    String timezoneId,
  ) async {
    if (!isSupportedPlatform) return;

    // Sunrise is displayed in prayer schedules but it is not a prayer reminder.
    if (prayer.name == PrayerName.sunrise) return;

    await _ensureInitialized();

    final location = _resolveLocation(timezoneId);

    // A prayer notification at the wrong timezone is more harmful than a
    // skipped notification, so fail safely if the timezone cannot be resolved.
    if (location == null) return;

    final prayerDateTime = tz.TZDateTime.from(
      prayer.time,
      location,
    );

    final reminderDateTime = NotificationSchedulePolicy.prayerReminderDateTime(
      prayerDateTime,
      reminderMinutes,
    );

    final scheduledDate = tz.TZDateTime.from(
      reminderDateTime,
      location,
    );

    final now = tz.TZDateTime.now(location);

    if (!scheduledDate.isAfter(now)) {
      return;
    }

    final id = NotificationSchedulePolicy.prayerNotificationId(
      prayer.name,
      prayer.time,
    );

    // Remove both the Phase 1 ID and the legacy ID before replacing the
    // notification. This prevents duplicate reminders during app upgrades.
    await cancelPrayer(prayer);

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'prayer_reminders',
        'Prayer Reminders',
        channelDescription: 'Reminders before daily prayer times',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _scheduleWithAndroidFallback(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      details: details,
      payload: 'prayer:${prayer.name.name}',
    );
  }

  /// Schedules the existing recurring daily-verse reminder.
  ///
  /// Phase 2 will replace this recurring static notification with a rolling
  /// schedule containing the actual deterministic verse and localized
  /// translation for each calendar day.
  Future<void> scheduleDailyVerse(
    String timeString,
    String title,
    String body,
    String timezoneId,
  ) async {
    if (!isSupportedPlatform) return;

    await _ensureInitialized();

    final parsedTime = _parseTime(timeString);
    if (parsedTime == null) return;

    final location = _resolveLocation(timezoneId);
    if (location == null) return;

    final now = tz.TZDateTime.now(location);

    var scheduledDate = tz.TZDateTime(
      location,
      now.year,
      now.month,
      now.day,
      parsedTime.hour,
      parsedTime.minute,
    );

    if (!scheduledDate.isAfter(now)) {
      scheduledDate = tz.TZDateTime(
        location,
        now.year,
        now.month,
        now.day + 1,
        parsedTime.hour,
        parsedTime.minute,
      );
    }

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_verse',
        'Daily Verse',
        channelDescription: 'Daily Quran verse reminders',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        styleInformation: BigTextStyleInformation(body),
      ),
      iOS: const DarwinNotificationDetails(),
    );

    await _plugin.cancel(
      NotificationSchedulePolicy.dailyVerseNotificationId,
    );

    await _scheduleWithAndroidFallback(
      id: NotificationSchedulePolicy.dailyVerseNotificationId,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      details: details,
      payload: 'daily-verse',
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> _scheduleWithAndroidFallback({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
    required NotificationDetails details,
    String? payload,
    DateTimeComponents? matchDateTimeComponents,
  }) async {
    try {
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        details,
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: matchDateTimeComponents,
      );
    } on PlatformException {
      if (defaultTargetPlatform != TargetPlatform.android) {
        rethrow;
      }

      // Android can deny exact-alarm access even when ordinary notification
      // permission is granted. Falling back keeps the reminder functional.
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        details,
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: matchDateTimeComponents,
      );
    }
  }

  tz.Location? _resolveLocation(String timezoneId) {
    if (timezoneId.trim().isEmpty) {
      return null;
    }

    try {
      return tz.getLocation(timezoneId);
    } catch (_) {
      return null;
    }
  }

  ({int hour, int minute})? _parseTime(String value) {
    final parts = value.split(':');

    if (parts.length != 2) {
      return null;
    }

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);

    if (hour == null ||
        minute == null ||
        hour < 0 ||
        hour > 23 ||
        minute < 0 ||
        minute > 59) {
      return null;
    }

    return (hour: hour, minute: minute);
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await init();
    }
  }
}
