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
import 'package:noor_life/features/qurban/application/qurban_season_provider.dart';
import 'package:noor_life/features/qurban/domain/qurban_season_state.dart';

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
    int maghribHour = 18,
  }) {
    return PrayerDay(
      targetDate: DateTime.utc(
        2027,
        5,
        civilDay,
      ),
      hijriDateString: hijriDate,
      prayerTimes: [
        PrayerTime(
          name: PrayerName.maghrib,
          time: DateTime.utc(
            2027,
            5,
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

  group('Qurban season provider', () {
    test(
      'enters Dhul Hijjah after the final Dhul Qadah Maghrib',
      () {
        final schedule = PrayerSchedule(
          yesterday: day(
            civilDay: 5,
            hijriDate: '1448-11-28',
          ),
          today: day(
            civilDay: 6,
            hijriDate: '1448-11-29',
          ),
          tomorrow: day(
            civilDay: 7,
            hijriDate: '1448-12-1',
          ),
        );

        final container = createContainer(
          schedule: schedule,
          now: DateTime.utc(
            2027,
            5,
            6,
            20,
          ),
        );

        final state = container.read(
          qurbanSeasonProvider,
        );

        expect(
          state.phase,
          QurbanSeasonPhase.firstEightDays,
        );

        expect(
          state.dhulHijjahDay,
          1,
        );

        expect(
          state.hijriDateString,
          '1448-12-1',
        );

        expect(
          state.isSeasonContext,
          isTrue,
        );

        container.dispose();
      },
    );

    test(
      'identifies Arafah on 9 Dhul Hijjah',
      () {
        final schedule = PrayerSchedule(
          yesterday: day(
            civilDay: 14,
            hijriDate: '1448-12-8',
          ),
          today: day(
            civilDay: 15,
            hijriDate: '1448-12-9',
          ),
          tomorrow: day(
            civilDay: 16,
            hijriDate: '1448-12-10',
          ),
        );

        final container = createContainer(
          schedule: schedule,
          now: DateTime.utc(
            2027,
            5,
            15,
            12,
          ),
        );

        final state = container.read(
          qurbanSeasonProvider,
        );

        expect(
          state.phase,
          QurbanSeasonPhase.arafah,
        );

        expect(
          state.dhulHijjahDay,
          9,
        );

        container.dispose();
      },
    );

    test(
      'enters Eid day one after Arafah Maghrib',
      () {
        final schedule = PrayerSchedule(
          yesterday: day(
            civilDay: 14,
            hijriDate: '1448-12-8',
          ),
          today: day(
            civilDay: 15,
            hijriDate: '1448-12-9',
          ),
          tomorrow: day(
            civilDay: 16,
            hijriDate: '1448-12-10',
          ),
        );

        final container = createContainer(
          schedule: schedule,
          now: DateTime.utc(
            2027,
            5,
            15,
            20,
          ),
        );

        final state = container.read(
          qurbanSeasonProvider,
        );

        expect(
          state.phase,
          QurbanSeasonPhase.eid,
        );

        expect(
          state.dhulHijjahDay,
          10,
        );

        expect(
          state.eidDay,
          1,
        );

        expect(
          state.hijriDateString,
          '1448-12-10',
        );

        container.dispose();
      },
    );

    test(
      'leaves the Eid context after 13 Dhul Hijjah Maghrib',
      () {
        final schedule = PrayerSchedule(
          yesterday: day(
            civilDay: 18,
            hijriDate: '1448-12-12',
          ),
          today: day(
            civilDay: 19,
            hijriDate: '1448-12-13',
          ),
          tomorrow: day(
            civilDay: 20,
            hijriDate: '1448-12-14',
          ),
        );

        final container = createContainer(
          schedule: schedule,
          now: DateTime.utc(
            2027,
            5,
            19,
            20,
          ),
        );

        final state = container.read(
          qurbanSeasonProvider,
        );

        expect(
          state.phase,
          QurbanSeasonPhase.outsideSeason,
        );

        expect(
          state.isSeasonContext,
          isFalse,
        );

        expect(
          state.hijriDateString,
          '1448-12-14',
        );

        container.dispose();
      },
    );
  });
}
