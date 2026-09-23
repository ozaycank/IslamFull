import 'package:injectable/injectable.dart';

import '../../../core/base/result.dart';
import '../domain/activity_models.dart';
import 'datasources/activity_local_data_source.dart';

@LazySingleton(
  as: ActivityRepository,
)
class ActivityRepositoryImpl implements ActivityRepository {
  final ActivityLocalDataSource _dataSource;

  ActivityRepositoryImpl(
    this._dataSource,
  );

  @override
  Future<Result<DailyActivity, ActivityFailure>> getDailyActivity(
    String date,
  ) async {
    try {
      final allRecords = await _dataSource.loadAllRecords();

      if (!allRecords.containsKey(date)) {
        return Success(
          DailyActivity(
            date: date,
          ),
        );
      }

      final jsonRecord = allRecords[date];

      if (jsonRecord is! Map<String, dynamic>) {
        return const ResultFailure(
          ActivityFailure(
            'Failed to read activity',
            code: 'activityReadFailed',
          ),
        );
      }

      return Success(
        DailyActivity.fromJson(
          jsonRecord,
          fallbackDate: date,
        ),
      );
    } catch (_) {
      return const ResultFailure(
        ActivityFailure(
          'Failed to read activity',
          code: 'activityReadFailed',
        ),
      );
    }
  }

  @override
  Future<Result<List<DailyActivity>, ActivityFailure>>
      getAllActivities() async {
    try {
      final allRecords = await _dataSource.loadAllRecords();

      final activities = <DailyActivity>[];

      for (final entry in allRecords.entries) {
        final value = entry.value;

        if (value is! Map<String, dynamic>) {
          throw const FormatException(
            'Invalid activity record.',
          );
        }

        activities.add(
          DailyActivity.fromJson(
            value,
            fallbackDate: entry.key,
          ),
        );
      }

      activities.sort(
        (first, second) => second.date.compareTo(
          first.date,
        ),
      );

      return Success(
        activities,
      );
    } catch (_) {
      return const ResultFailure(
        ActivityFailure(
          'Failed to load history',
          code: 'activityHistoryFailed',
        ),
      );
    }
  }

  @override
  Future<Result<void, ActivityFailure>> saveDailyActivity(
    DailyActivity activity,
  ) async {
    try {
      final allRecords = await _dataSource.loadAllRecords();

      allRecords[activity.date] = activity.toJson();

      await _dataSource.saveAllRecords(
        allRecords,
      );

      return const Success(
        null,
      );
    } catch (_) {
      return const ResultFailure(
        ActivityFailure(
          'Failed to save activity',
          code: 'activityWriteFailed',
        ),
      );
    }
  }
}
