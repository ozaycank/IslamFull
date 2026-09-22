import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService()
      : _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(
            encryptedSharedPreferences: true,
          ),
          iOptions: IOSOptions(
            accessibility: KeychainAccessibility.first_unlock,
          ),
        );

  // Notification preferences
  static const String keyNotificationsEnabled = 'sec_key_notif_enabled';

  static const String keyPrayerReminderMinutes = 'sec_key_notif_prayer_mins';

  static const String keyDailyVerseEnabled = 'sec_key_notif_verse_enabled';

  static const String keyDailyVerseTime = 'sec_key_notif_verse_time';

  // Appearance preferences
  static const String keyThemeMode = 'sec_key_theme_mode';

  // User preferences
  static const String keyHapticFeedbackEnabled = 'sec_key_pref_haptic_feedback';

  static const String keyShowDailyVerseOnHome =
      'sec_key_pref_show_daily_verse_home';

  // New Muslim journey
  static const String keyJourneyReviewedSteps =
      'sec_key_journey_reviewed_steps_v1';

  static const String keyJourneyLastVisitedStep =
      'sec_key_journey_last_visited_step_v1';

  Future<void> write({
    required String key,
    required String value,
  }) async {
    await _storage.write(
      key: key,
      value: value,
    );
  }

  Future<String?> read({
    required String key,
  }) {
    return _storage.read(
      key: key,
    );
  }

  Future<void> delete({
    required String key,
  }) async {
    await _storage.delete(
      key: key,
    );
  }

  Future<bool> getNotificationsEnabled() async {
    final value = await read(
      key: keyNotificationsEnabled,
    );

    return value != 'false';
  }

  Future<void> setNotificationsEnabled(
    bool value,
  ) async {
    await write(
      key: keyNotificationsEnabled,
      value: value.toString(),
    );
  }

  Future<int> getPrayerReminderMinutes() async {
    final value = await read(
      key: keyPrayerReminderMinutes,
    );

    return value != null ? int.tryParse(value) ?? 30 : 30;
  }

  Future<void> setPrayerReminderMinutes(
    int value,
  ) async {
    await write(
      key: keyPrayerReminderMinutes,
      value: value.toString(),
    );
  }

  Future<bool> getDailyVerseEnabled() async {
    final value = await read(
      key: keyDailyVerseEnabled,
    );

    return value != 'false';
  }

  Future<void> setDailyVerseEnabled(
    bool value,
  ) async {
    await write(
      key: keyDailyVerseEnabled,
      value: value.toString(),
    );
  }

  Future<String> getDailyVerseTime() async {
    final value = await read(
      key: keyDailyVerseTime,
    );

    return value ?? '20:00';
  }

  Future<void> setDailyVerseTime(
    String value,
  ) async {
    await write(
      key: keyDailyVerseTime,
      value: value,
    );
  }

  Future<String?> getThemeModePreference() {
    return read(
      key: keyThemeMode,
    );
  }

  Future<void> setThemeModePreference(
    String value,
  ) async {
    if (value != 'system' && value != 'light' && value != 'dark') {
      throw ArgumentError.value(
        value,
        'value',
        'Unsupported theme mode.',
      );
    }

    await write(
      key: keyThemeMode,
      value: value,
    );
  }

  Future<bool> getHapticFeedbackEnabled() async {
    final value = await read(
      key: keyHapticFeedbackEnabled,
    );

    return value != 'false';
  }

  Future<void> setHapticFeedbackEnabled(
    bool value,
  ) async {
    await write(
      key: keyHapticFeedbackEnabled,
      value: value.toString(),
    );
  }

  Future<bool> getShowDailyVerseOnHome() async {
    final value = await read(
      key: keyShowDailyVerseOnHome,
    );

    return value != 'false';
  }

  Future<void> setShowDailyVerseOnHome(
    bool value,
  ) async {
    await write(
      key: keyShowDailyVerseOnHome,
      value: value.toString(),
    );
  }

  Future<String?> getJourneyReviewedSteps() {
    return read(
      key: keyJourneyReviewedSteps,
    );
  }

  Future<void> setJourneyReviewedSteps(
    String value,
  ) async {
    await write(
      key: keyJourneyReviewedSteps,
      value: value,
    );
  }

  Future<String?> getJourneyLastVisitedStep() {
    return read(
      key: keyJourneyLastVisitedStep,
    );
  }

  Future<void> setJourneyLastVisitedStep(
    String? value,
  ) async {
    if (value == null) {
      await delete(
        key: keyJourneyLastVisitedStep,
      );
      return;
    }

    await write(
      key: keyJourneyLastVisitedStep,
      value: value,
    );
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
