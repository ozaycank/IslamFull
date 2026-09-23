import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../application/providers/prayer_times_notifier.dart';
import '../../domain/entities/prayer_time.dart';
import '../../domain/value_objects/prayer_name.dart';

final currentTimeProvider = StreamProvider<DateTime>((ref) {
  return Stream.periodic(
    const Duration(seconds: 1),
    (_) => DateTime.now(),
  );
});

/// Resolves the current time in the timezone of the selected prayer location.
///
/// This keeps prayer, Home, and Ramadan features aligned when the selected
/// location uses a different timezone from the device.
final prayerTargetTimeProvider = Provider<DateTime>((ref) {
  final state = ref.watch(prayerTimesNotifierProvider);

  final deviceNow = ref.watch(currentTimeProvider).value ?? DateTime.now();

  final timezoneIdentifier = state.location?.timezoneIdentifier;

  if (timezoneIdentifier == null || timezoneIdentifier.isEmpty) {
    return deviceNow;
  }

  try {
    final targetLocation = tz.getLocation(
      timezoneIdentifier,
    );

    return tz.TZDateTime.from(
      deviceNow,
      targetLocation,
    );
  } catch (_) {
    return tz.TZDateTime.from(
      deviceNow,
      tz.UTC,
    );
  }
});

class PrayerLiveState {
  final PrayerTime? currentPrayer;
  final PrayerTime? nextPrayer;
  final Duration timeRemaining;

  const PrayerLiveState({
    this.currentPrayer,
    this.nextPrayer,
    this.timeRemaining = Duration.zero,
  });
}

final prayerLiveStateProvider = Provider<PrayerLiveState>((ref) {
  final state = ref.watch(
    prayerTimesNotifierProvider,
  );

  final targetNow = ref.watch(
    prayerTargetTimeProvider,
  );

  if (state.schedule == null || state.location == null) {
    return const PrayerLiveState();
  }

  final allTimes = [
    ...state.schedule!.yesterday.prayerTimes,
    ...state.schedule!.today.prayerTimes,
    ...state.schedule!.tomorrow.prayerTimes,
  ]
      .where(
        // Sunrise remains visible in the daily schedule, but it is not a prayer
        // and therefore must not be presented as the "next prayer".
        (prayer) => prayer.name != PrayerName.sunrise,
      )
      .toList();

  allTimes.sort(
    (first, second) => first.time.compareTo(
      second.time,
    ),
  );

  PrayerTime? current;
  PrayerTime? next;

  for (var index = 0; index < allTimes.length; index++) {
    if (allTimes[index].time.isAfter(targetNow)) {
      next = allTimes[index];

      if (index > 0) {
        current = allTimes[index - 1];
      }

      break;
    }
  }

  if (next == null && allTimes.isNotEmpty) {
    current = allTimes.last;
  }

  final remaining = next?.time.difference(targetNow) ?? Duration.zero;

  return PrayerLiveState(
    currentPrayer: current,
    nextPrayer: next,
    timeRemaining: remaining,
  );
});
