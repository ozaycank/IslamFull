import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/prayer/prayer_times/application/providers/prayer_times_notifier.dart';
import '../../features/quran/application/services/daily_verse_notification_content_service.dart';
import '../../features/quran/application/services/daily_verse_notification_scheduler.dart';
import '../../features/quran/domain/repositories/quran_repository.dart';
import '../../features/quran/domain/repositories/quran_translation_repository.dart';
import '../../features/settings/application/providers/language_settings_notifier.dart';
import '../../features/settings/application/providers/notification_settings_provider.dart';
import '../../l10n/generated/app_localizations.dart';
import '../di/injection_container.dart';
import '../services/local_notification_service.dart';

/// Coordinates notification behavior between otherwise independent features.
///
/// Settings owns user preferences, Prayer owns calculated prayer data, Quran
/// owns verse content, and this provider is the application-level composition
/// point that connects them.
final notificationCoordinatorProvider = Provider<void>((ref) {
  final notificationService = getIt<LocalNotificationService>();

  final contentService = DailyVerseNotificationContentService(
    quranRepository: getIt<QuranRepository>(),
    translationRepository: getIt<QuranTranslationRepository>(),
  );

  final dailyVerseScheduler = DailyVerseNotificationScheduler(
    contentService: contentService,
    notificationService: notificationService,
  );

  final dailyVerseController = _DailyVerseSyncController(
    scheduler: dailyVerseScheduler,
  );

  void enqueueDailyVerseSync() {
    final settings = ref.read(
      notificationSettingsProvider,
    );

    final prayerState = ref.read(
      prayerTimesNotifierProvider,
    );

    final languageCode = ref
        .read(
          languageSettingsNotifierProvider,
        )
        .locale
        .languageCode;

    dailyVerseController.enqueue(
      _DailyVerseSyncRequest(
        settingsLoaded: settings.isLoaded,
        platformSupported: settings.platformSupported,
        masterEnabled: settings.masterEnabled,
        dailyVerseEnabled: settings.dailyVerseEnabled,
        dailyVerseTime: settings.dailyVerseTime,
        languageCode: languageCode,
        timezoneId: prayerState.location?.timezoneIdentifier,
      ),
    );
  }

  ref.listen(
    notificationSettingsProvider,
    (previous, next) {
      final relevantChange = previous == null ||
          previous.isLoaded != next.isLoaded ||
          previous.platformSupported != next.platformSupported ||
          previous.masterEnabled != next.masterEnabled ||
          previous.dailyVerseEnabled != next.dailyVerseEnabled ||
          previous.dailyVerseTime != next.dailyVerseTime;

      if (relevantChange) {
        enqueueDailyVerseSync();
      }
    },
    fireImmediately: true,
  );

  ref.listen(
    languageSettingsNotifierProvider,
    (previous, next) {
      if (previous?.locale == next.locale) {
        return;
      }

      enqueueDailyVerseSync();
    },
  );

  ref.listen(
    prayerTimesNotifierProvider,
    (previous, next) {
      final scheduleAvailable = next.schedule != null && next.location != null;

      final scheduleChanged = previous?.schedule != next.schedule ||
          previous?.location != next.location;

      if (scheduleAvailable && scheduleChanged) {
        unawaited(
          ref
              .read(
                notificationSettingsProvider.notifier,
              )
              .syncPrayerSchedule(),
        );
      }

      final locationChanged = previous?.location != next.location;

      if (locationChanged) {
        enqueueDailyVerseSync();
      }
    },
  );
});

class _DailyVerseSyncRequest {
  final bool settingsLoaded;
  final bool platformSupported;
  final bool masterEnabled;
  final bool dailyVerseEnabled;
  final String dailyVerseTime;
  final String languageCode;
  final String? timezoneId;

  const _DailyVerseSyncRequest({
    required this.settingsLoaded,
    required this.platformSupported,
    required this.masterEnabled,
    required this.dailyVerseEnabled,
    required this.dailyVerseTime,
    required this.languageCode,
    required this.timezoneId,
  });
}

/// Serializes scheduling requests and keeps only the newest pending state.
///
/// This prevents language, location, and settings changes occurring close
/// together from running multiple notification rebuilds concurrently.
class _DailyVerseSyncController {
  final DailyVerseNotificationScheduler _scheduler;

  _DailyVerseSyncRequest? _pendingRequest;
  bool _isProcessing = false;

  _DailyVerseSyncController({
    required DailyVerseNotificationScheduler scheduler,
  }) : _scheduler = scheduler;

  void enqueue(
    _DailyVerseSyncRequest request,
  ) {
    _pendingRequest = request;

    if (!_isProcessing) {
      unawaited(
        _processQueue(),
      );
    }
  }

  Future<void> _processQueue() async {
    _isProcessing = true;

    try {
      while (_pendingRequest != null) {
        final request = _pendingRequest!;
        _pendingRequest = null;

        try {
          await _execute(
            request,
          );
        } catch (error, stackTrace) {
          // Application startup and preference changes must not crash merely
          // because notification preparation failed.
          developer.log(
            'Daily Verse notification synchronization failed.',
            name: 'NotificationCoordinator',
            error: error,
            stackTrace: stackTrace,
          );
        }
      }
    } finally {
      _isProcessing = false;
    }
  }

  Future<void> _execute(
    _DailyVerseSyncRequest request,
  ) async {
    if (!request.settingsLoaded || !request.platformSupported) {
      return;
    }

    if (!request.masterEnabled || !request.dailyVerseEnabled) {
      await _scheduler.cancel(
        timezoneId: request.timezoneId,
      );

      return;
    }

    final timezoneId = request.timezoneId;

    if (timezoneId == null || timezoneId.trim().isEmpty) {
      // PrayerTimesNotifier will trigger another synchronization once location
      // data becomes available.
      return;
    }

    final localizations = await AppLocalizations.delegate.load(
      Locale(
        request.languageCode,
      ),
    );

    await _scheduler.reschedule(
      notificationTime: request.dailyVerseTime,
      languageCode: request.languageCode,
      timezoneId: timezoneId,
      title: localizations.dailyVerseTitle,
    );
  }
}
