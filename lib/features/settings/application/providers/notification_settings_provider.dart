import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/services/local_notification_service.dart';
import '../../../../core/services/notification_schedule_policy.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../prayer/prayer_times/application/providers/prayer_times_notifier.dart';
import '../services/prayer_notification_scheduler.dart';
import '../../../prayer/prayer_times/domain/repositories/prayer_times_repository.dart';
import 'language_settings_notifier.dart';

class NotificationSettingsState {
  final bool masterEnabled;
  final int prayerReminderMinutes;
  final bool dailyVerseEnabled;
  final String dailyVerseTime;
  final bool isLoaded;
  final bool platformSupported;

  const NotificationSettingsState({
    this.masterEnabled = false,
    this.prayerReminderMinutes = 30,
    this.dailyVerseEnabled = false,
    this.dailyVerseTime = '20:00',
    this.isLoaded = false,
    this.platformSupported = true,
  });

  NotificationSettingsState copyWith({
    bool? masterEnabled,
    int? prayerReminderMinutes,
    bool? dailyVerseEnabled,
    String? dailyVerseTime,
    bool? isLoaded,
    bool? platformSupported,
  }) {
    return NotificationSettingsState(
      masterEnabled: masterEnabled ?? this.masterEnabled,
      prayerReminderMinutes:
          prayerReminderMinutes ?? this.prayerReminderMinutes,
      dailyVerseEnabled: dailyVerseEnabled ?? this.dailyVerseEnabled,
      dailyVerseTime: dailyVerseTime ?? this.dailyVerseTime,
      isLoaded: isLoaded ?? this.isLoaded,
      platformSupported: platformSupported ?? this.platformSupported,
    );
  }
}

final notificationSettingsProvider =
    NotifierProvider<NotificationSettingsNotifier, NotificationSettingsState>(
  NotificationSettingsNotifier.new,
);

class NotificationSettingsNotifier extends Notifier<NotificationSettingsState> {
  late final SecureStorageService _storage;
  late final LocalNotificationService _notificationService;
  late final PrayerNotificationScheduler _prayerNotificationScheduler;

  // Serialize notification writes. A later language or settings
  // change will always be applied after any earlier operation.
  Future<void> _prayerScheduleTail = Future<void>.value();

  @override
  NotificationSettingsState build() {
    _storage = getIt<SecureStorageService>();
    _notificationService = getIt<LocalNotificationService>();
    _prayerNotificationScheduler = PrayerNotificationScheduler(
      repository: getIt<PrayerTimesRepository>(),
      notificationService: _notificationService,
    );

    // Recreate pending prayer notifications when application language
    // changes, including when a saved language preference is loaded.
    ref.listen<LanguageState>(
      languageSettingsNotifierProvider,
      (previous, next) {
        if (previous?.locale == next.locale || !state.isLoaded) {
          return;
        }

        unawaited(
          syncPrayerSchedule(),
        );
      },
    );

    Future.microtask(
      _loadSettings,
    );

    return NotificationSettingsState(
      platformSupported: _notificationService.isSupportedPlatform,
    );
  }

  Future<void> _loadSettings() async {
    final enabled = await _storage.getNotificationsEnabled();
    final reminderMinutes = await _storage.getPrayerReminderMinutes();
    final dailyVerseEnabled = await _storage.getDailyVerseEnabled();
    final dailyVerseTime = await _storage.getDailyVerseTime();

    state = state.copyWith(
      masterEnabled: enabled,
      prayerReminderMinutes: reminderMinutes,
      dailyVerseEnabled: dailyVerseEnabled,
      dailyVerseTime: dailyVerseTime,
      isLoaded: true,
    );

    await _reschedulePrayerNotifications();
  }

  Future<bool> toggleMaster(
    bool enabled,
  ) async {
    if (!state.platformSupported) {
      return false;
    }

    if (enabled) {
      final granted = await _notificationService.requestPermission();

      if (!granted) {
        state = state.copyWith(
          masterEnabled: false,
        );

        await _storage.setNotificationsEnabled(
          false,
        );

        await _notificationService.cancelAll();

        return false;
      }
    }

    await _storage.setNotificationsEnabled(
      enabled,
    );

    state = state.copyWith(
      masterEnabled: enabled,
    );

    await _reschedulePrayerNotifications();

    return true;
  }

  Future<void> setReminderMinutes(
    int minutes,
  ) async {
    if (minutes < 0 ||
        minutes > NotificationSchedulePolicy.maxPrayerReminderMinutes) {
      throw ArgumentError.value(
        minutes,
        'minutes',
        'Prayer reminder must be between 0 and '
            '${NotificationSchedulePolicy.maxPrayerReminderMinutes} minutes.',
      );
    }

    await _storage.setPrayerReminderMinutes(
      minutes,
    );

    state = state.copyWith(
      prayerReminderMinutes: minutes,
    );

    await _reschedulePrayerNotifications();
  }

  Future<void> toggleDailyVerse(
    bool enabled,
  ) async {
    await _storage.setDailyVerseEnabled(
      enabled,
    );

    state = state.copyWith(
      dailyVerseEnabled: enabled,
    );

    // Daily Verse scheduling is owned by NotificationCoordinator.
  }

  Future<void> setDailyVerseTime(
    String time,
  ) async {
    if (!_isValidTime(time)) {
      throw ArgumentError.value(
        time,
        'time',
        'Time must use the HH:mm 24-hour format.',
      );
    }

    await _storage.setDailyVerseTime(
      time,
    );

    state = state.copyWith(
      dailyVerseTime: time,
    );

    // Daily Verse scheduling is owned by NotificationCoordinator.
  }

  Future<void> syncPrayerSchedule() async {
    if (!state.isLoaded) {
      return;
    }

    await _reschedulePrayerNotifications();
  }

  Future<void> _reschedulePrayerNotifications() {
    final operation = _prayerScheduleTail.then<void>(
      (_) => _applyPrayerSchedule(),
    );

    // Preserve the queue after an error, while still reporting
    // that error to the original operation's caller.
    _prayerScheduleTail = operation.then<void>(
      (_) {},
      onError: (
        Object _,
        StackTrace __,
      ) {},
    );

    return operation;
  }

  Future<void> _applyPrayerSchedule() async {
    if (!state.platformSupported) {
      return;
    }

    if (!state.masterEnabled) {
      // Disabling notifications cancels every notification category,
      // including pending daily-verse notifications.
      await _notificationService.cancelAll();
      return;
    }

    final prayerState = ref.read(
      prayerTimesNotifierProvider,
    );

    if (prayerState.isLoading) {
      return;
    }

    final location = prayerState.location;

    if (location == null || prayerState.schedule == null) {
      final now = DateTime.now();

      await _notificationService.cancelPrayerNotificationsWindow(
        DateTime(now.year, now.month, now.day - 2),
        days: NotificationSchedulePolicy.prayerCleanupWindowDays + 2,
      );
      return;
    }

    final selectedLocale = ref
        .read(
          languageSettingsNotifierProvider,
        )
        .locale;

    final localizations = await AppLocalizations.delegate.load(
      selectedLocale,
    );

    await _prayerNotificationScheduler.reschedule(
      location: location,
      reminderMinutes: state.prayerReminderMinutes,
      localizations: localizations,
    );
  }

  bool _isValidTime(
    String value,
  ) {
    final parts = value.split(':');

    if (parts.length != 2) {
      return false;
    }

    final hour = int.tryParse(
      parts[0],
    );

    final minute = int.tryParse(
      parts[1],
    );

    return hour != null &&
        minute != null &&
        hour >= 0 &&
        hour <= 23 &&
        minute >= 0 &&
        minute <= 59;
  }
}
