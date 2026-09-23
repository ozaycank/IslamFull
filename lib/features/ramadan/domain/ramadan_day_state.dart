import 'package:equatable/equatable.dart';

enum RamadanDayPhase {
  unavailable,
  outsideRamadan,
  beforeImsak,
  fasting,
  afterIftar,
}

class RamadanDayState extends Equatable {
  final RamadanDayPhase phase;

  /// Current time in the selected prayer location timezone.
  final DateTime? targetNow;

  /// Hijri date that is religiously current for the Ramadan context.
  ///
  /// After Maghrib this may refer to the following civil day's Hijri date,
  /// because the Islamic day begins at sunset.
  final String? hijriDateString;

  /// Imsak time for the fasting day currently relevant to the screen.
  final DateTime? imsakTime;

  /// Iftar time for the fasting day currently relevant to the screen.
  final DateTime? iftarTime;

  /// Next Ramadan imsak after today's iftar, when available.
  final DateTime? tomorrowImsakTime;

  /// Remaining time until the contextually relevant event.
  ///
  /// - beforeImsak -> until imsak
  /// - fasting -> until iftar
  /// - afterIftar -> until the next Ramadan imsak
  final Duration timeRemaining;

  const RamadanDayState({
    required this.phase,
    this.targetNow,
    this.hijriDateString,
    this.imsakTime,
    this.iftarTime,
    this.tomorrowImsakTime,
    this.timeRemaining = Duration.zero,
  });

  const RamadanDayState.unavailable()
      : this(
          phase: RamadanDayPhase.unavailable,
        );

  const RamadanDayState.outsideRamadan({
    DateTime? targetNow,
    String? hijriDateString,
  }) : this(
          phase: RamadanDayPhase.outsideRamadan,
          targetNow: targetNow,
          hijriDateString: hijriDateString,
        );

  bool get isRamadan {
    return phase == RamadanDayPhase.beforeImsak ||
        phase == RamadanDayPhase.fasting ||
        phase == RamadanDayPhase.afterIftar;
  }

  @override
  List<Object?> get props => [
        phase,
        targetNow,
        hijriDateString,
        imsakTime,
        iftarTime,
        tomorrowImsakTime,
        timeRemaining,
      ];
}
