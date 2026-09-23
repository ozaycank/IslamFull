import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../prayer/prayer_times/application/providers/prayer_times_notifier.dart';
import '../../prayer/prayer_times/domain/entities/prayer_day.dart';
import '../../prayer/prayer_times/domain/entities/prayer_time.dart';
import '../../prayer/prayer_times/domain/value_objects/prayer_name.dart';
import '../../prayer/prayer_times/presentation/providers/prayer_live_state_provider.dart';
import '../domain/ramadan_day_state.dart';

final ramadanDayProvider = Provider<RamadanDayState>((ref) {
  final prayerState = ref.watch(
    prayerTimesNotifierProvider,
  );

  final targetNow = ref.watch(
    prayerTargetTimeProvider,
  );

  final schedule = prayerState.schedule;

  if (schedule == null || prayerState.location == null) {
    return const RamadanDayState.unavailable();
  }

  final todayHijri = _HijriDate.tryParse(
    schedule.today.hijriDateString,
  );

  final tomorrowHijri = _HijriDate.tryParse(
    schedule.tomorrow.hijriDateString,
  );

  if (todayHijri == null || tomorrowHijri == null) {
    return const RamadanDayState.unavailable();
  }

  final todayImsak = _findPrayer(
    schedule.today,
    PrayerName.fajr,
  );

  final todayIftar = _findPrayer(
    schedule.today,
    PrayerName.maghrib,
  );

  final tomorrowImsak = _findPrayer(
    schedule.tomorrow,
    PrayerName.fajr,
  );

  final tomorrowIftar = _findPrayer(
    schedule.tomorrow,
    PrayerName.maghrib,
  );

  if (todayIftar == null) {
    return const RamadanDayState.unavailable();
  }

  final afterTodayIftar = !targetNow.isBefore(
    todayIftar.time,
  );

  if (afterTodayIftar) {
    // The Islamic day changes at sunset.
    //
    // This handles both:
    // - the first Ramadan night after the final Sha'ban sunset;
    // - the end of Ramadan when Shawwal begins after the final iftar.
    if (!tomorrowHijri.isRamadan) {
      return RamadanDayState.outsideRamadan(
        targetNow: targetNow,
        hijriDateString: schedule.tomorrow.hijriDateString,
      );
    }

    if (tomorrowImsak == null || tomorrowIftar == null) {
      return const RamadanDayState.unavailable();
    }

    // First Ramadan night:
    // the civil date still belongs to Sha'ban, while the Islamic date has
    // already entered Ramadan after Maghrib.
    if (!todayHijri.isRamadan) {
      return RamadanDayState(
        phase: RamadanDayPhase.beforeImsak,
        targetNow: targetNow,
        hijriDateString: schedule.tomorrow.hijriDateString,
        imsakTime: tomorrowImsak.time,
        iftarTime: tomorrowIftar.time,
        tomorrowImsakTime: tomorrowImsak.time,
        timeRemaining: _safeDifference(
          tomorrowImsak.time,
          targetNow,
        ),
      );
    }

    return RamadanDayState(
      phase: RamadanDayPhase.afterIftar,
      targetNow: targetNow,
      hijriDateString: schedule.tomorrow.hijriDateString,
      imsakTime: todayImsak?.time,
      iftarTime: todayIftar.time,
      tomorrowImsakTime: tomorrowImsak.time,
      timeRemaining: _safeDifference(
        tomorrowImsak.time,
        targetNow,
      ),
    );
  }

  // Before today's Maghrib the current Islamic fasting day corresponds to
  // today's PrayerDay Hijri date.
  if (!todayHijri.isRamadan) {
    return RamadanDayState.outsideRamadan(
      targetNow: targetNow,
      hijriDateString: schedule.today.hijriDateString,
    );
  }

  if (todayImsak == null) {
    return const RamadanDayState.unavailable();
  }

  if (targetNow.isBefore(
    todayImsak.time,
  )) {
    return RamadanDayState(
      phase: RamadanDayPhase.beforeImsak,
      targetNow: targetNow,
      hijriDateString: schedule.today.hijriDateString,
      imsakTime: todayImsak.time,
      iftarTime: todayIftar.time,
      tomorrowImsakTime: tomorrowHijri.isRamadan ? tomorrowImsak?.time : null,
      timeRemaining: _safeDifference(
        todayImsak.time,
        targetNow,
      ),
    );
  }

  return RamadanDayState(
    phase: RamadanDayPhase.fasting,
    targetNow: targetNow,
    hijriDateString: schedule.today.hijriDateString,
    imsakTime: todayImsak.time,
    iftarTime: todayIftar.time,
    tomorrowImsakTime: tomorrowHijri.isRamadan ? tomorrowImsak?.time : null,
    timeRemaining: _safeDifference(
      todayIftar.time,
      targetNow,
    ),
  );
});

PrayerTime? _findPrayer(
  PrayerDay day,
  PrayerName name,
) {
  for (final prayer in day.prayerTimes) {
    if (prayer.name == name) {
      return prayer;
    }
  }

  return null;
}

Duration _safeDifference(
  DateTime target,
  DateTime now,
) {
  final difference = target.difference(now);

  if (difference.isNegative) {
    return Duration.zero;
  }

  return difference;
}

class _HijriDate {
  final int year;
  final int month;
  final int day;

  const _HijriDate({
    required this.year,
    required this.month,
    required this.day,
  });

  bool get isRamadan => month == 9;

  static _HijriDate? tryParse(
    String? raw,
  ) {
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }

    final parts = raw.split('-');

    if (parts.length != 3) {
      return null;
    }

    final year = int.tryParse(
      parts[0],
    );

    final month = int.tryParse(
      parts[1],
    );

    final day = int.tryParse(
      parts[2],
    );

    if (year == null ||
        month == null ||
        day == null ||
        month < 1 ||
        month > 12 ||
        day < 1 ||
        day > 30) {
      return null;
    }

    return _HijriDate(
      year: year,
      month: month,
      day: day,
    );
  }
}
