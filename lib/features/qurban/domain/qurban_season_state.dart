import 'package:equatable/equatable.dart';

enum QurbanSeasonPhase {
  unavailable,
  outsideSeason,
  firstEightDays,
  arafah,
  eid,
}

class QurbanSeasonState extends Equatable {
  final QurbanSeasonPhase phase;

  /// Current time in the selected prayer location timezone.
  final DateTime? targetNow;

  /// Religiously current Hijri date.
  ///
  /// After Maghrib this may refer to the following civil day's Hijri date
  /// because the Islamic day begins at sunset.
  final String? hijriDateString;

  /// Current Dhul Hijjah day when the religious date is between 1 and 13.
  final int? dhulHijjahDay;

  const QurbanSeasonState({
    required this.phase,
    this.targetNow,
    this.hijriDateString,
    this.dhulHijjahDay,
  });

  const QurbanSeasonState.unavailable()
      : this(
          phase: QurbanSeasonPhase.unavailable,
        );

  const QurbanSeasonState.outsideSeason({
    DateTime? targetNow,
    String? hijriDateString,
  }) : this(
          phase: QurbanSeasonPhase.outsideSeason,
          targetNow: targetNow,
          hijriDateString: hijriDateString,
        );

  bool get isSeasonContext =>
      phase == QurbanSeasonPhase.firstEightDays ||
      phase == QurbanSeasonPhase.arafah ||
      phase == QurbanSeasonPhase.eid;

  int? get eidDay {
    if (phase != QurbanSeasonPhase.eid || dhulHijjahDay == null) {
      return null;
    }

    return dhulHijjahDay! - 9;
  }

  @override
  List<Object?> get props => [
        phase,
        targetNow,
        hijriDateString,
        dhulHijjahDay,
      ];
}
