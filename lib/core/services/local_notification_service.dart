import 'dart:async';

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

  final StreamController<String> _notificationPayloadController =
      StreamController<String>.broadcast();

  bool _isInitialized = false;
  String? _initialNotificationPayload;

  bool get isSupportedPlatform {
    if (kIsWeb) {
      return false;
    }

    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  /// Emits notification payloads tapped while the application process is
  /// already running.
  Stream<String> get notificationPayloads =>
      _notificationPayloadController.stream;

  /// Returns and clears the payload that launched the application from a
  /// terminated state.
  ///
  /// The value is consumed only once to prevent duplicate navigation if the
  /// root application widget is rebuilt.
  String? takeInitialNotificationPayload() {
    final payload = _initialNotificationPayload;
    _initialNotificationPayload = null;

    return payload;
  }

  Future<void> init() async {
    if (_isInitialized) {
      return;
    }

    if (!isSupportedPlatform) {
      _isInitialized = true;
      return;
    }

    tz.initializeTimeZones();

    const androidInitializationSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const iosInitializationSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _plugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _handleNotificationResponse,
    );

    await _captureInitialNotificationPayload();

    _isInitialized = true;
  }

  Future<bool> requestPermission() async {
    if (!isSupportedPlatform) {
      return false;
    }

    await _ensureInitialized();

    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      final notificationPermission =
          await androidPlugin.requestNotificationsPermission();

      try {
        await androidPlugin.requestExactAlarmsPermission();
      } on PlatformException {
        // Exact alarm permission is independent from notification permission.
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
    if (!isSupportedPlatform) {
      return;
    }

    await _ensureInitialized();
    await _plugin.cancelAll();
  }

  /// Cancels the recurring daily verse IDs used by implementations before the
  /// date-specific rolling scheduler.
  Future<void> cancelLegacyDailyVerseSchedules() async {
    if (!isSupportedPlatform) {
      return;
    }

    await _ensureInitialized();

    await _plugin.cancel(
      NotificationSchedulePolicy.legacyDailyVerseNotificationId,
    );

    await _plugin.cancel(
      NotificationSchedulePolicy.dailyVerseNotificationId,
    );
  }

  /// Compatibility API used by older application-level callers.
  Future<void> cancelDailyVerse() async {
    await cancelLegacyDailyVerseSchedules();
  }

  /// Cancels the date-specific Daily Verse notification for one calendar day.
  Future<void> cancelDailyVerseForDate(
    DateTime date,
  ) async {
    if (!isSupportedPlatform) {
      return;
    }

    await _ensureInitialized();

    await _plugin.cancel(
      NotificationSchedulePolicy.dailyVerseNotificationIdForDate(
        date,
      ),
    );
  }

  /// Cancels a contiguous range of date-specific Daily Verse notifications.
  Future<void> cancelDailyVerseWindow(
    DateTime startDate, {
    required int days,
  }) async {
    if (days < 1) {
      throw RangeError.value(
        days,
        'days',
        'The cancellation window must contain at least one day.',
      );
    }

    if (!isSupportedPlatform) {
      return;
    }

    await _ensureInitialized();

    for (var offset = 0; offset < days; offset++) {
      final date = DateTime(
        startDate.year,
        startDate.month,
        startDate.day + offset,
      );

      await _plugin.cancel(
        NotificationSchedulePolicy.dailyVerseNotificationIdForDate(
          date,
        ),
      );
    }
  }

  Future<void> cancelPrayer(
    PrayerTime prayer,
  ) async {
    if (!isSupportedPlatform) {
      return;
    }

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
    if (!isSupportedPlatform) {
      return;
    }

    if (prayer.name == PrayerName.sunrise) {
      return;
    }

    await _ensureInitialized();

    final location = _resolveLocation(
      timezoneId,
    );

    if (location == null) {
      return;
    }

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

    final now = tz.TZDateTime.now(
      location,
    );

    if (!scheduledDate.isAfter(now)) {
      return;
    }

    final id = NotificationSchedulePolicy.prayerNotificationId(
      prayer.name,
      prayer.time,
    );

    await cancelPrayer(
      prayer,
    );

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

  /// Current Phase 1 recurring Daily Verse scheduler.
  ///
  /// Kept temporarily for backwards compatibility while rolling scheduling is
  /// being migrated across the application.
  Future<void> scheduleDailyVerse(
    String timeString,
    String title,
    String body,
    String timezoneId,
  ) async {
    if (!isSupportedPlatform) {
      return;
    }

    await _ensureInitialized();

    final parsedTime = _parseTime(
      timeString,
    );

    if (parsedTime == null) {
      return;
    }

    final location = _resolveLocation(
      timezoneId,
    );

    if (location == null) {
      return;
    }

    final now = tz.TZDateTime.now(
      location,
    );

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

    await cancelLegacyDailyVerseSchedules();

    await _scheduleWithAndroidFallback(
      id: NotificationSchedulePolicy.dailyVerseNotificationId,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      details: _dailyVerseNotificationDetails(
        body,
      ),
      payload: 'daily-verse',
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Schedules one Daily Verse notification for one specific calendar date.
  Future<bool> scheduleDailyVerseForDate({
    required DateTime date,
    required String timeString,
    required String title,
    required String body,
    required String timezoneId,
    required String payload,
  }) async {
    if (!isSupportedPlatform) {
      return false;
    }

    await _ensureInitialized();

    final parsedTime = _parseTime(
      timeString,
    );

    if (parsedTime == null) {
      return false;
    }

    final location = _resolveLocation(
      timezoneId,
    );

    if (location == null) {
      return false;
    }

    final scheduledDate = tz.TZDateTime(
      location,
      date.year,
      date.month,
      date.day,
      parsedTime.hour,
      parsedTime.minute,
    );

    final now = tz.TZDateTime.now(
      location,
    );

    if (!scheduledDate.isAfter(now)) {
      return false;
    }

    final id = NotificationSchedulePolicy.dailyVerseNotificationIdForDate(
      date,
    );

    await _plugin.cancel(
      id,
    );

    await _scheduleWithAndroidFallback(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      details: _dailyVerseNotificationDetails(
        body,
      ),
      payload: payload,
    );

    return true;
  }

  NotificationDetails _dailyVerseNotificationDetails(
    String body,
  ) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_verse',
        'Daily Verse',
        channelDescription: 'Daily Quran verse reminders',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        styleInformation: BigTextStyleInformation(
          body,
        ),
      ),
      iOS: const DarwinNotificationDetails(),
    );
  }

  void _handleNotificationResponse(
    NotificationResponse response,
  ) {
    final payload = response.payload?.trim();

    if (payload == null || payload.isEmpty) {
      return;
    }

    _notificationPayloadController.add(
      payload,
    );
  }

  Future<void> _captureInitialNotificationPayload() async {
    try {
      final launchDetails = await _plugin.getNotificationAppLaunchDetails();

      if (!(launchDetails?.didNotificationLaunchApp ?? false)) {
        return;
      }

      final payload = launchDetails?.notificationResponse?.payload?.trim();

      if (payload == null || payload.isEmpty) {
        return;
      }

      _initialNotificationPayload = payload;
    } on PlatformException {
      // Notification launch details are an enhancement. A platform failure
      // must never prevent normal application startup.
    }
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

  tz.Location? _resolveLocation(
    String timezoneId,
  ) {
    if (timezoneId.trim().isEmpty) {
      return null;
    }

    try {
      return tz.getLocation(
        timezoneId,
      );
    } catch (_) {
      return null;
    }
  }

  ({int hour, int minute})? _parseTime(
    String value,
  ) {
    final parts = value.split(':');

    if (parts.length != 2) {
      return null;
    }

    final hour = int.tryParse(
      parts[0],
    );

    final minute = int.tryParse(
      parts[1],
    );

    if (hour == null ||
        minute == null ||
        hour < 0 ||
        hour > 23 ||
        minute < 0 ||
        minute > 59) {
      return null;
    }

    return (
      hour: hour,
      minute: minute,
    );
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await init();
    }
  }
}
