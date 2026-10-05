import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/base/result.dart';
import '../../../core/di/injection_container.dart';
import '../../quran/application/providers/quran_progress_provider.dart';
import '../domain/activity_models.dart';
import '../domain/activity_prayer_type.dart';
import '../domain/activity_statistics.dart';
import '../utils/activity_date_utils.dart';

class ActivityState {
  final bool isLoading;
  final bool isSaving;
  final DailyActivity? dailyActivity;
  final List<DailyActivity> history;
  final ActivityStatistics? statistics;
  final ActivityFailure? failure;

  const ActivityState({
    this.isLoading = false,
    this.isSaving = false,
    this.dailyActivity,
    this.history = const [],
    this.statistics,
    this.failure,
  });

  ActivityState copyWith({
    bool? isLoading,
    bool? isSaving,
    DailyActivity? Function()? dailyActivity,
    List<DailyActivity>? history,
    ActivityStatistics? Function()? statistics,
    ActivityFailure? Function()? failure,
  }) {
    return ActivityState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      dailyActivity:
          dailyActivity != null ? dailyActivity() : this.dailyActivity,
      history: history ?? this.history,
      statistics: statistics != null ? statistics() : this.statistics,
      failure: failure != null ? failure() : this.failure,
    );
  }
}

class ActivityNotifier extends StateNotifier<ActivityState> {
  final ActivityRepository _repository;

  String _currentDate;
  int _loadGeneration = 0;

  ActivityNotifier(
    this._repository,
  )   : _currentDate = ActivityDateUtils.today(),
        super(const ActivityState()) {
    unawaited(
      loadDate(
        _currentDate,
      ),
    );
  }

  Future<void> loadToday() {
    return loadDate(
      ActivityDateUtils.today(),
    );
  }

  Future<void> loadDate(
    String date,
  ) async {
    if (!ActivityDateUtils.isValidFormat(date)) {
      state = state.copyWith(
        isLoading: false,
        failure: () => const ActivityFailure(
          'Invalid activity date.',
          code: 'invalidActivityDate',
        ),
      );

      return;
    }

    final requestGeneration = ++_loadGeneration;
    final dateChanged = date != _currentDate;

    _currentDate = date;

    state = state.copyWith(
      isLoading: true,
      dailyActivity: dateChanged ? () => null : null,
      failure: () => null,
    );

    try {
      final activityResult = await _repository.getDailyActivity(
        date,
      );

      final historyResult = await _repository.getAllActivities();

      if (requestGeneration != _loadGeneration) {
        return;
      }

      var nextHistory = state.history;
      var nextStatistics = state.statistics;
      ActivityFailure? secondaryFailure;

      switch (historyResult) {
        case Success(value: final history):
          nextHistory = List.unmodifiable(
            history,
          );

          nextStatistics = ActivityStatisticsCalculator.calculate(
            nextHistory,
            ActivityDateUtils.today(),
          );

        case ResultFailure(failure: final error):
          // History is secondary to today's record. Preserve the previous
          // history/statistics rather than replacing them with empty data.
          secondaryFailure = error;
      }

      switch (activityResult) {
        case Success(value: final activity):
          state = state.copyWith(
            isLoading: false,
            dailyActivity: () => activity,
            history: nextHistory,
            statistics: () => nextStatistics,
            failure: () => secondaryFailure,
          );

        case ResultFailure(failure: final error):
          state = state.copyWith(
            isLoading: false,
            history: nextHistory,
            statistics: () => nextStatistics,
            failure: () => error,
          );
      }
    } catch (_) {
      if (requestGeneration != _loadGeneration) {
        return;
      }

      state = state.copyWith(
        isLoading: false,
        failure: () => const ActivityFailure(
          'Failed to load activity data.',
          code: 'activityReadFailed',
        ),
      );
    }
  }

  Future<void> togglePrayer(
    ActivityPrayerType prayer,
  ) async {
    final currentActivity = state.dailyActivity;

    if (currentActivity == null || state.isSaving || state.isLoading) {
      return;
    }

    final currentStatus = currentActivity.completedPrayers[prayer] ?? false;

    final updatedPrayers = Map<ActivityPrayerType, bool>.from(
      currentActivity.completedPrayers,
    );

    updatedPrayers[prayer] = !currentStatus;

    final updatedActivity = currentActivity.copyWith(
      completedPrayers: updatedPrayers,
    );

    await _saveActivityUpdate(
      previousActivity: currentActivity,
      updatedActivity: updatedActivity,
    );
  }

  Future<void> markQuranRead() async {
    final currentActivity = state.dailyActivity;

    if (currentActivity == null ||
        currentActivity.quranReadingOccurred ||
        state.isSaving ||
        state.isLoading) {
      return;
    }

    final updatedActivity = currentActivity.copyWith(
      quranReadingOccurred: true,
    );

    await _saveActivityUpdate(
      previousActivity: currentActivity,
      updatedActivity: updatedActivity,
    );
  }

  Future<void> _saveActivityUpdate({
    required DailyActivity previousActivity,
    required DailyActivity updatedActivity,
  }) async {
    // Invalidate any older load request so that it cannot overwrite the
    // optimistic activity state when it completes later.
    _loadGeneration++;

    state = state.copyWith(
      isSaving: true,
      dailyActivity: () => updatedActivity,
      failure: () => null,
    );

    try {
      final result = await _repository.saveDailyActivity(
        updatedActivity,
      );

      switch (result) {
        case Success():
          final updatedHistory = _upsertHistory(
            state.history,
            updatedActivity,
          );

          final updatedStatistics = ActivityStatisticsCalculator.calculate(
            updatedHistory,
            ActivityDateUtils.today(),
          );

          state = state.copyWith(
            isSaving: false,
            dailyActivity: () => updatedActivity,
            history: updatedHistory,
            statistics: () => updatedStatistics,
            failure: () => null,
          );

        case ResultFailure(failure: final error):
          state = state.copyWith(
            isSaving: false,
            dailyActivity: () => previousActivity,
            failure: () => error,
          );
      }
    } catch (_) {
      state = state.copyWith(
        isSaving: false,
        dailyActivity: () => previousActivity,
        failure: () => const ActivityFailure(
          'Failed to save activity.',
          code: 'activityWriteFailed',
        ),
      );
    }
  }

  List<DailyActivity> _upsertHistory(
    List<DailyActivity> currentHistory,
    DailyActivity activity,
  ) {
    final updated = List<DailyActivity>.from(
      currentHistory,
    );

    final existingIndex = updated.indexWhere(
      (entry) => entry.date == activity.date,
    );

    if (existingIndex >= 0) {
      updated[existingIndex] = activity;
    } else {
      updated.add(activity);
    }

    updated.sort(
      (a, b) => b.date.compareTo(a.date),
    );

    return List.unmodifiable(
      updated,
    );
  }
}

final activityNotifierProvider =
    StateNotifierProvider<ActivityNotifier, ActivityState>(
  (ref) {
    return ActivityNotifier(
      getIt<ActivityRepository>(),
    );
  },
);

final quranActivityBridgeProvider = Provider<void>(
  (ref) {
    ref.listen(
      quranProgressNotifierProvider,
      (
        previous,
        next,
      ) {
        if (next.lastRead == null) {
          return;
        }

        final previousLastRead = previous?.lastRead;

        final isInitialLoad = previousLastRead == null;

        final ayahAdvanced =
            previousLastRead?.ayahNumber != next.lastRead?.ayahNumber;

        final surahAdvanced =
            previousLastRead?.surahNumber != next.lastRead?.surahNumber;

        if (!isInitialLoad && (ayahAdvanced || surahAdvanced)) {
          unawaited(
            ref
                .read(
                  activityNotifierProvider.notifier,
                )
                .markQuranRead(),
          );
        }
      },
    );
  },
);
