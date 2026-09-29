import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../prayer/prayer_times/application/providers/prayer_times_notifier.dart';
import '../../prayer/prayer_times/domain/entities/prayer_day.dart';
import '../../prayer/prayer_times/domain/entities/prayer_time.dart';
import '../../prayer/prayer_times/domain/value_objects/prayer_name.dart';
import '../../prayer/prayer_times/presentation/providers/prayer_live_state_provider.dart';
import '../domain/qurban_season_state.dart';

final qurbanSeasonProvider = Provider<QurbanSeasonState>((ref) {
  final prayerState = ref.watch(
    prayerTimesNotifierProvider,
  );

  final targetNow = ref.watch(
    prayerTargetTimeProvider,
  );

  final schedule = prayerState.schedule;

  if (schedule == null || prayerState.location == null) {
    return const QurbanSeasonState.unavailable();
  }

  final todayHijri = _HijriDate.tryParse(
    schedule.today.hijriDateString,
  );

  final tomorrowHijri = _HijriDate.tryParse(
    schedule.tomorrow.hijriDateString,
  );

  if (todayHijri == null || tomorrowHijri == null) {
    return const QurbanSeasonState.unavailable();
  }

  final todayMaghrib = _findPrayer(
    schedule.today,
    PrayerName.maghrib,
  );

  if (todayMaghrib == null) {
    return const QurbanSeasonState.unavailable();
  }

  final afterMaghrib = !targetNow.isBefore(
    todayMaghrib.time,
  );

  // The Islamic day begins at sunset. After today's Maghrib the religious
  // date corresponds to the following civil day's Hijri date.
  final currentHijri = afterMaghrib ? tomorrowHijri : todayHijri;

  final currentHijriString = afterMaghrib
      ? schedule.tomorrow.hijriDateString
      : schedule.today.hijriDateString;

  if (!currentHijri.isDhulHijjah || currentHijri.day > 13) {
    return QurbanSeasonState.outsideSeason(
      targetNow: targetNow,
      hijriDateString: currentHijriString,
    );
  }

  if (currentHijri.day <= 8) {
    return QurbanSeasonState(
      phase: QurbanSeasonPhase.firstEightDays,
      targetNow: targetNow,
      hijriDateString: currentHijriString,
      dhulHijjahDay: currentHijri.day,
    );
  }

  if (currentHijri.day == 9) {
    return QurbanSeasonState(
      phase: QurbanSeasonPhase.arafah,
      targetNow: targetNow,
      hijriDateString: currentHijriString,
      dhulHijjahDay: currentHijri.day,
    );
  }

  return QurbanSeasonState(
    phase: QurbanSeasonPhase.eid,
    targetNow: targetNow,
    hijriDateString: currentHijriString,
    dhulHijjahDay: currentHijri.day,
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

class _HijriDate {
  final int year;
  final int month;
  final int day;

  const _HijriDate({
    required this.year,
    required this.month,
    required this.day,
  });

  bool get isDhulHijjah => month == 12;

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
