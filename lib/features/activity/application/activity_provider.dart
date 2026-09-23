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
  final DailyActivity? dailyActivity;
  final List<DailyActivity> history;
  final ActivityStatistics? statistics;
  final ActivityFailure? failure;

  const ActivityState({
    this.isLoading = false,
    this.dailyActivity,
    this.history = const [],
    this.statistics,
    this.failure,
  });

  ActivityState copyWith({
    bool? isLoading,
    DailyActivity? dailyActivity,
    List<DailyActivity>? history,
    ActivityStatistics? statistics,
    ActivityFailure? failure,
    bool clearFailure = false,
  }) {
    return ActivityState(
      isLoading: isLoading ?? this.isLoading,
      dailyActivity: dailyActivity ?? this.dailyActivity,
      history: history ?? this.history,
      statistics: statistics ?? this.statistics,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }
}

class ActivityNotifier extends StateNotifier<ActivityState> {
  final ActivityRepository _repository;

  String _currentDate;

  bool _isSaving = false;

  ActivityNotifier(
    this._repository,
  )   : _currentDate = ActivityDateUtils.today(),
        super(const ActivityState()) {
    loadDate(_currentDate);
  }

  Future<void> loadToday() async {
    await loadDate(
      ActivityDateUtils.today(),
    );
  }

  Future<void> loadDate(
    String date,
  ) async {
    state = state.copyWith(
      isLoading: true,
      clearFailure: true,
    );

    _currentDate = date;

    final result = await _repository.getDailyActivity(
      date,
    );

    final historyResult = await _repository.getAllActivities();

    List<DailyActivity> history = [];
    ActivityStatistics? statistics;

    if (historyResult is Success<List<DailyActivity>, ActivityFailure>) {
      history = historyResult.value;

      statistics = ActivityStatisticsCalculator.calculate(
        history,
        ActivityDateUtils.today(),
      );
    }

    switch (result) {
      case Success(value: final activity):
        state = state.copyWith(
          isLoading: false,
          dailyActivity: activity,
          history: history,
          statistics: statistics,
        );

      case ResultFailure(
          failure: final error,
        ):
        state = state.copyWith(
          isLoading: false,
          history: history,
          statistics: statistics,
          failure: error,
        );
    }
  }

  Future<void> togglePrayer(
    ActivityPrayerType prayer,
  ) async {
    if (state.dailyActivity == null || _isSaving) {
      return;
    }

    _isSaving = true;

    final currentActivity = state.dailyActivity!;

    final currentStatus = currentActivity.completedPrayers[prayer] ?? false;

    final newPrayers = Map<ActivityPrayerType, bool>.from(
      currentActivity.completedPrayers,
    );

    newPrayers[prayer] = !currentStatus;

    final newActivity = currentActivity.copyWith(
      completedPrayers: newPrayers,
    );

    state = state.copyWith(
      dailyActivity: newActivity,
      clearFailure: true,
    );

    try {
      final result = await _repository.saveDailyActivity(
        newActivity,
      );

      switch (result) {
        case Success():
          await loadDate(
            _currentDate,
          );

        case ResultFailure(
            failure: final error,
          ):
          state = state.copyWith(
            dailyActivity: currentActivity,
            failure: error,
          );
      }
    } catch (_) {
      state = state.copyWith(
        dailyActivity: currentActivity,
        failure: const ActivityFailure(
          'Failed to save activity',
          code: 'activityWriteFailed',
        ),
      );
    } finally {
      _isSaving = false;
    }
  }

  Future<void> markQuranRead() async {
    if (state.dailyActivity == null || _isSaving) {
      return;
    }

    final currentActivity = state.dailyActivity!;

    if (currentActivity.quranReadingOccurred) {
      return;
    }

    _isSaving = true;

    final newActivity = currentActivity.copyWith(
      quranReadingOccurred: true,
    );

    state = state.copyWith(
      dailyActivity: newActivity,
      clearFailure: true,
    );

    try {
      final result = await _repository.saveDailyActivity(
        newActivity,
      );

      switch (result) {
        case Success():
          await loadDate(
            _currentDate,
          );

        case ResultFailure(
            failure: final error,
          ):
          state = state.copyWith(
            dailyActivity: currentActivity,
            failure: error,
          );
      }
    } catch (_) {
      state = state.copyWith(
        dailyActivity: currentActivity,
        failure: const ActivityFailure(
          'Failed to save activity',
          code: 'activityWriteFailed',
        ),
      );
    } finally {
      _isSaving = false;
    }
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

        final isInitialLoad = previous?.lastRead == null;

        final ayahAdvanced =
            previous?.lastRead?.ayahNumber != next.lastRead?.ayahNumber;

        final surahAdvanced =
            previous?.lastRead?.surahNumber != next.lastRead?.surahNumber;

        if (!isInitialLoad && (ayahAdvanced || surahAdvanced)) {
          ref
              .read(
                activityNotifierProvider.notifier,
              )
              .markQuranRead();
        }
      },
    );
  },
);
