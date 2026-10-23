import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SecureStorageService {
  final FlutterSecureStorage _storage;

  // Serialize sensitive writes with withdrawal cleanup. A consent epoch
  // prevents an old queued operation from writing after fresh consent.
  Future<void> _religiousProgressWriteTail = Future<void>.value();
  int _religiousProgressConsentEpoch = 0;

  SecureStorageService()
      : _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(
            encryptedSharedPreferences: true,
          ),
          iOptions: IOSOptions(
            accessibility: KeychainAccessibility.first_unlock_this_device,
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

  // Optional religious-progress privacy preference. A legacy plain 'true'
  // acknowledged the activity/journey-only scope and must not authorize the
  // expanded Quran + activity + journey scope.
  static const String keyReligiousProgressConsent =
      'sec_key_privacy_religious_progress_consent_v1';

  // Bump this whenever the scope or purposes of the consent change.
  // The current version covers worship activity, New Muslim Journey progress,
  // last-read Quran verse, and Quran bookmarks, all saved locally.
  static const String currentReligiousProgressConsentVersion =
      'religious-progress-v2';

  static const String _currentConsentGrantValue =
      'granted:$currentReligiousProgressConsentVersion';

  // Sensitive local activity progress
  static const String keyActivityRecords = 'noorlife_activity_records_v2';

  // Quran reading place and verse bookmarks (including legacy records)
  static const String keyQuranLastRead = 'quran_last_read';
  static const String keyQuranBookmarks = 'quran_bookmarks';

  // New Muslim journey progress
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

    return value == 'true';
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

    return value == 'true';
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

  Future<bool> getReligiousProgressConsent() async {
    final value = await read(
      key: keyReligiousProgressConsent,
    );

    // Deny missing, old unversioned, and unknown future consent values.
    // A previous consent is not silently reused for a changed scope.
    return value == _currentConsentGrantValue;
  }

  /// Serialize optional religious-progress writes so withdrawal cleanup
  /// cannot be overtaken by a previously queued storage operation.
  Future<void> writeReligiousProgressData({
    required String key,
    required String value,
  }) {
    final writeEpoch = _religiousProgressConsentEpoch;

    final operation = _religiousProgressWriteTail.then<void>((_) async {
      if (writeEpoch != _religiousProgressConsentEpoch ||
          !await getReligiousProgressConsent()) {
        return;
      }

      try {
        await write(key: key, value: value);
      } finally {
        var stillGranted = false;
        try {
          stillGranted = await getReligiousProgressConsent();
        } finally {
          if (!stillGranted || writeEpoch != _religiousProgressConsentEpoch) {
            await delete(key: key);
          }
        }
      }
    });

    // Keep the queue usable after a failed platform write, while propagating
    // that failure to the original caller.
    _religiousProgressWriteTail = operation.then<void>(
      (_) {},
      onError: (Object _, StackTrace __) {},
    );
    return operation;
  }

  /// Read optional religious progress only with consent. A withdrawal
  /// during platform storage access must not reveal a previously read value.
  Future<String?> readReligiousProgressData({
    required String key,
  }) async {
    if (!await getReligiousProgressConsent()) {
      return null;
    }

    final value = await read(key: key);

    if (!await getReligiousProgressConsent()) {
      return null;
    }

    return value;
  }

  Future<void> setReligiousProgressConsent(
    bool value,
  ) async {
    if (!value) {
      ++_religiousProgressConsentEpoch;
    }

    await write(
      key: keyReligiousProgressConsent,
      value: value ? _currentConsentGrantValue : 'false',
    );
  }

  Future<void> clearReligiousProgressData() async {
    await _religiousProgressWriteTail;

    await delete(
      key: keyActivityRecords,
    );

    await delete(
      key: keyJourneyReviewedSteps,
    );

    await delete(
      key: keyJourneyLastVisitedStep,
    );

    await delete(
      key: keyQuranLastRead,
    );

    await delete(
      key: keyQuranBookmarks,
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
    await writeReligiousProgressData(
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

    await writeReligiousProgressData(
      key: keyJourneyLastVisitedStep,
      value: value,
    );
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
