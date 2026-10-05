import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/core/base/result.dart';
import 'package:noor_life/features/activity/application/activity_provider.dart';
import 'package:noor_life/features/activity/domain/activity_models.dart';
import 'package:noor_life/features/activity/domain/activity_prayer_type.dart';
import 'package:noor_life/features/activity/utils/activity_date_utils.dart';

class FakeActivityRepository implements ActivityRepository {
  late Result<DailyActivity, ActivityFailure> dailyResult;

  Result<List<DailyActivity>, ActivityFailure> historyResult =
      const Success([]);

  Result<void, ActivityFailure> saveResult = const Success(null);

  Completer<Result<void, ActivityFailure>>? pendingSave;

  int saveCalls = 0;

  @override
  Future<Result<DailyActivity, ActivityFailure>> getDailyActivity(
    String date,
  ) async {
    return dailyResult;
  }

  @override
  Future<Result<List<DailyActivity>, ActivityFailure>>
      getAllActivities() async {
    return historyResult;
  }

  @override
  Future<Result<void, ActivityFailure>> saveDailyActivity(
    DailyActivity activity,
  ) {
    saveCalls++;

    final pending = pendingSave;

    if (pending != null) {
      return pending.future;
    }

    return Future.value(
      saveResult,
    );
  }
}

void main() {
  late FakeActivityRepository repository;

  late String today;

  setUp(() {
    today = ActivityDateUtils.today();

    repository = FakeActivityRepository();

    repository.dailyResult = Success(
      DailyActivity(
        date: today,
      ),
    );
  });

  test(
    'initial load exposes daily activity and history',
    () async {
      final previousDate = DateTime.parse(today)
          .subtract(
            const Duration(
              days: 1,
            ),
          )
          .toIso8601String()
          .substring(
            0,
            10,
          );

      repository.historyResult = Success(
        [
          DailyActivity(
            date: previousDate,
          ),
        ],
      );

      final notifier = ActivityNotifier(
        repository,
      );

      addTearDown(
        notifier.dispose,
      );

      await pumpEventQueue();

      expect(
        notifier.state.isLoading,
        isFalse,
      );

      expect(
        notifier.state.dailyActivity?.date,
        today,
      );

      expect(
        notifier.state.history,
        hasLength(1),
      );

      expect(
        notifier.state.failure,
        isNull,
      );
    },
  );

  test(
    'failed optimistic prayer save rolls back record',
    () async {
      repository.saveResult = const ResultFailure(
        ActivityFailure(
          'Write failed',
          code: 'activityWriteFailed',
        ),
      );

      final notifier = ActivityNotifier(
        repository,
      );

      addTearDown(
        notifier.dispose,
      );

      await pumpEventQueue();

      await notifier.togglePrayer(
        ActivityPrayerType.fajr,
      );

      expect(
        notifier.state.dailyActivity
                ?.completedPrayers[ActivityPrayerType.fajr] ??
            false,
        isFalse,
      );

      expect(
        notifier.state.isSaving,
        isFalse,
      );

      expect(
        notifier.state.failure?.code,
        'activityWriteFailed',
      );
    },
  );

  test(
    'duplicate interaction is ignored while save is pending',
    () async {
      final completer = Completer<Result<void, ActivityFailure>>();

      repository.pendingSave = completer;

      final notifier = ActivityNotifier(
        repository,
      );

      addTearDown(
        notifier.dispose,
      );

      await pumpEventQueue();

      final firstSave = notifier.togglePrayer(
        ActivityPrayerType.fajr,
      );

      await pumpEventQueue();

      expect(
        notifier.state.isSaving,
        isTrue,
      );

      await notifier.togglePrayer(
        ActivityPrayerType.dhuhr,
      );

      expect(
        repository.saveCalls,
        1,
      );

      completer.complete(
        const Success(null),
      );

      await firstSave;

      expect(
        notifier.state.isSaving,
        isFalse,
      );

      expect(
        repository.saveCalls,
        1,
      );
    },
  );

  test(
    'history failure preserves daily record and surfaces secondary failure',
    () async {
      repository.historyResult = const ResultFailure(
        ActivityFailure(
          'History failed',
          code: 'historyReadFailed',
        ),
      );

      final notifier = ActivityNotifier(
        repository,
      );

      addTearDown(
        notifier.dispose,
      );

      await pumpEventQueue();

      expect(
        notifier.state.dailyActivity,
        isNotNull,
      );

      expect(
        notifier.state.failure?.code,
        'historyReadFailed',
      );
    },
  );
}
