import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/features/prayer/location/domain/entities/prayer_location.dart';
import 'package:noor_life/features/prayer/prayer_times/application/providers/prayer_times_notifier.dart';
import 'package:noor_life/features/prayer/prayer_times/application/states/prayer_times_state.dart';
import 'package:noor_life/features/prayer/prayer_times/domain/entities/prayer_day.dart';
import 'package:noor_life/features/prayer/prayer_times/domain/entities/prayer_schedule.dart';
import 'package:noor_life/features/prayer/prayer_times/domain/entities/prayer_time.dart';
import 'package:noor_life/features/prayer/prayer_times/domain/value_objects/prayer_name.dart';
import 'package:noor_life/features/prayer/prayer_times/presentation/providers/prayer_live_state_provider.dart';
import 'package:noor_life/features/ramadan/application/ramadan_day_provider.dart';
import 'package:noor_life/features/ramadan/domain/ramadan_day_state.dart';

class FakePrayerTimesNotifier extends PrayerTimesNotifier {
  final PrayerTimesState fakeState;

  FakePrayerTimesNotifier(
    this.fakeState,
  );

  @override
  PrayerTimesState build() => fakeState;
}

void main() {
  const location = PrayerLocation(
    latitude: 41,
    longitude: 29,
    cityName: 'Istanbul',
    countryName: 'Türkiye',
    timezoneIdentifier: 'UTC',
  );

  PrayerDay day({
    required int civilDay,
    required String hijriDate,
    required int fajrHour,
    required int maghribHour,
  }) {
    return PrayerDay(
      targetDate: DateTime.utc(
        2026,
        2,
        civilDay,
      ),
      hijriDateString: hijriDate,
      prayerTimes: [
        PrayerTime(
          name: PrayerName.fajr,
          time: DateTime.utc(
            2026,
            2,
            civilDay,
            fajrHour,
          ),
        ),
        PrayerTime(
          name: PrayerName.maghrib,
          time: DateTime.utc(
            2026,
            2,
            civilDay,
            maghribHour,
          ),
        ),
      ],
    );
  }

  ProviderContainer createContainer({
    required PrayerSchedule schedule,
    required DateTime now,
  }) {
    final prayerState = PrayerTimesState(
      schedule: schedule,
      location: location,
    );

    return ProviderContainer(
      overrides: [
        prayerTimesNotifierProvider.overrideWith(
          () => FakePrayerTimesNotifier(
            prayerState,
          ),
        ),
        prayerTargetTimeProvider.overrideWithValue(
          now,
        ),
      ],
    );
  }

  group('Ramadan day provider', () {
    test(
      'enters Ramadan after the final Shaban Maghrib',
      () {
        final schedule = PrayerSchedule(
          yesterday: day(
            civilDay: 17,
            hijriDate: '1447-8-29',
            fajrHour: 5,
            maghribHour: 18,
          ),
          today: day(
            civilDay: 18,
            hijriDate: '1447-8-30',
            fajrHour: 5,
            maghribHour: 18,
          ),
          tomorrow: day(
            civilDay: 19,
            hijriDate: '1447-9-1',
            fajrHour: 5,
            maghribHour: 18,
          ),
        );

        final container = createContainer(
          schedule: schedule,
          now: DateTime.utc(
            2026,
            2,
            18,
            20,
          ),
        );

        final state = container.read(
          ramadanDayProvider,
        );

        expect(
          state.phase,
          RamadanDayPhase.beforeImsak,
        );

        expect(
          state.isRamadan,
          isTrue,
        );

        expect(
          state.hijriDateString,
          '1447-9-1',
        );

        expect(
          state.imsakTime,
          DateTime.utc(
            2026,
            2,
            19,
            5,
          ),
        );

        container.dispose();
      },
    );

    test(
      'counts down to iftar during a Ramadan fasting day',
      () {
        final schedule = PrayerSchedule(
          yesterday: day(
            civilDay: 18,
            hijriDate: '1447-8-30',
            fajrHour: 5,
            maghribHour: 18,
          ),
          today: day(
            civilDay: 19,
            hijriDate: '1447-9-1',
            fajrHour: 5,
            maghribHour: 18,
          ),
          tomorrow: day(
            civilDay: 20,
            hijriDate: '1447-9-2',
            fajrHour: 5,
            maghribHour: 18,
          ),
        );

        final container = createContainer(
          schedule: schedule,
          now: DateTime.utc(
            2026,
            2,
            19,
            12,
          ),
        );

        final state = container.read(
          ramadanDayProvider,
        );

        expect(
          state.phase,
          RamadanDayPhase.fasting,
        );

        expect(
          state.timeRemaining,
          const Duration(hours: 6),
        );

        expect(
          state.iftarTime,
          DateTime.utc(
            2026,
            2,
            19,
            18,
          ),
        );

        container.dispose();
      },
    );

    test(
      'leaves Ramadan after the final Ramadan Maghrib',
      () {
        final schedule = PrayerSchedule(
          yesterday: day(
            civilDay: 18,
            hijriDate: '1447-9-29',
            fajrHour: 5,
            maghribHour: 18,
          ),
          today: day(
            civilDay: 19,
            hijriDate: '1447-9-30',
            fajrHour: 5,
            maghribHour: 18,
          ),
          tomorrow: day(
            civilDay: 20,
            hijriDate: '1447-10-1',
            fajrHour: 5,
            maghribHour: 18,
          ),
        );

        final container = createContainer(
          schedule: schedule,
          now: DateTime.utc(
            2026,
            2,
            19,
            20,
          ),
        );

        final state = container.read(
          ramadanDayProvider,
        );

        expect(
          state.phase,
          RamadanDayPhase.outsideRamadan,
        );

        expect(
          state.isRamadan,
          isFalse,
        );

        container.dispose();
      },
    );
  });
}
