import 'package:equatable/equatable.dart';

import '../../../core/base/result.dart';
import '../../../core/errors/failure.dart';
import '../utils/activity_date_utils.dart';
import 'activity_prayer_type.dart';

class ActivityFailure extends Failure {
  const ActivityFailure(
    super.message, {
    super.code,
  });
}

class DailyActivity extends Equatable {
  final String date;

  final Map<ActivityPrayerType, bool> completedPrayers;

  final bool quranReadingOccurred;

  const DailyActivity({
    required this.date,
    this.completedPrayers = const {},
    this.quranReadingOccurred = false,
  });

  DailyActivity copyWith({
    String? date,
    Map<ActivityPrayerType, bool>? completedPrayers,
    bool? quranReadingOccurred,
  }) {
    return DailyActivity(
      date: date ?? this.date,
      completedPrayers: completedPrayers ?? this.completedPrayers,
      quranReadingOccurred: quranReadingOccurred ?? this.quranReadingOccurred,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'prayers': completedPrayers.map(
        (key, value) => MapEntry(
          key.name,
          value,
        ),
      ),
      'quran': quranReadingOccurred,
    };
  }

  factory DailyActivity.fromJson(
    Map<String, dynamic> json, {
    String? fallbackDate,
  }) {
    final rawPrayers = json['prayers'];

    if (rawPrayers != null && rawPrayers is! Map<String, dynamic>) {
      throw const FormatException(
        'Invalid activity prayer data.',
      );
    }

    final prayersMap = rawPrayers as Map<String, dynamic>? ?? {};

    final parsedPrayers = <ActivityPrayerType, bool>{};

    for (final entry in prayersMap.entries) {
      try {
        final prayerType = ActivityPrayerType.values.firstWhere(
          (type) => type.name == entry.key,
        );

        if (entry.value is bool) {
          parsedPrayers[prayerType] = entry.value as bool;
        }
      } catch (_) {
        // Unknown prayer identifiers from a future
        // application version are safely ignored.
      }
    }

    for (final prayer in ActivityPrayerType.values) {
      parsedPrayers.putIfAbsent(
        prayer,
        () => false,
      );
    }

    final rawDate = json['date'];

    late final String safeDate;

    if (rawDate is String &&
        ActivityDateUtils.isValidFormat(
          rawDate,
        )) {
      safeDate = rawDate;
    } else if (fallbackDate != null) {
      if (!ActivityDateUtils.isValidFormat(
        fallbackDate,
      )) {
        throw const FormatException(
          'Invalid activity date.',
        );
      }

      // Persistent records recover their date from the
      // validated storage key when the embedded legacy
      // date is missing or malformed.
      safeDate = fallbackDate;
    } else {
      // Preserve the domain model's backward-compatible
      // deserialization behavior for callers that do not
      // represent a persisted storage record.
      safeDate = ActivityDateUtils.today();
    }

    return DailyActivity(
      date: safeDate,
      completedPrayers: parsedPrayers,
      quranReadingOccurred: json['quran'] == true,
    );
  }

  @override
  List<Object?> get props => [
        date,
        completedPrayers,
        quranReadingOccurred,
      ];
}

abstract class ActivityRepository {
  Future<Result<DailyActivity, ActivityFailure>> getDailyActivity(
    String date,
  );

  Future<Result<List<DailyActivity>, ActivityFailure>> getAllActivities();

  Future<Result<void, ActivityFailure>> saveDailyActivity(
    DailyActivity activity,
  );
}
