import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'package:noor_life/features/prayer/location/domain/entities/prayer_location.dart';
import 'package:noor_life/features/prayer/prayer_times/application/providers/prayer_times_notifier.dart';
import 'package:noor_life/features/prayer/prayer_times/application/states/prayer_times_state.dart';
import 'package:noor_life/features/prayer/prayer_times/domain/entities/prayer_day.dart';
import 'package:noor_life/features/prayer/prayer_times/domain/entities/prayer_schedule.dart';
import 'package:noor_life/features/prayer/prayer_times/domain/entities/prayer_time.dart';
import 'package:noor_life/features/prayer/prayer_times/domain/value_objects/prayer_name.dart';
import 'package:noor_life/features/prayer/prayer_times/presentation/providers/prayer_live_state_provider.dart';
import 'package:noor_life/features/prayer/shared/domain/errors/prayer_failure.dart';

class FakePrayerTimesNotifier extends PrayerTimesNotifier {
  final PrayerTimesState fakeState;

  FakePrayerTimesNotifier(
    this.fakeState,
  );

  @override
  PrayerTimesState build() => fakeState;
}

void main() {
  setUpAll(() {
    tz.initializeTimeZones();
  });

  group('Prayer state hardening tests', () {
    test(
      'PrayerTimesState.copyWith nullable fields explicitly clear',
      () {
        const location = PrayerLocation(
          latitude: 0,
          longitude: 0,
          cityName: 'City',
          countryName: 'Country',
          timezoneIdentifier: 'UTC',
        );

        const failure = PrayerCalculationFailure(
          'test error',
        );

        const state = PrayerTimesState(
          isLoading: true,
          failure: failure,
          schedule: null,
          location: location,
        );

        final newState = state.copyWith(
          isLoading: false,
          failure: () => null,
          location: () => null,
        );

        expect(
          newState.isLoading,
          false,
        );

        expect(
          newState.failure,
          isNull,
        );

        expect(
          newState.location,
          isNull,
        );
      },
    );

    test(
      'Cross-day prayer ordering remains chronological',
      () async {
        final yesterday = PrayerDay(
          targetDate: DateTime.utc(2026, 8, 12),
          prayerTimes: [
            PrayerTime(
              name: PrayerName.fajr,
              time: DateTime.utc(
                2026,
                8,
                12,
                4,
              ),
            ),
            PrayerTime(
              name: PrayerName.isha,
              time: DateTime.utc(
                2026,
                8,
                12,
                20,
              ),
            ),
          ],
        );

        // Intentionally scrambled to verify native chronological sorting.
        final today = PrayerDay(
          targetDate: DateTime.utc(2026, 8, 13),
          prayerTimes: [
            PrayerTime(
              name: PrayerName.dhuhr,
              time: DateTime.utc(
                2026,
                8,
                13,
                12,
              ),
            ),
            PrayerTime(
              name: PrayerName.fajr,
              time: DateTime.utc(
                2026,
                8,
                13,
                4,
              ),
            ),
            PrayerTime(
              name: PrayerName.isha,
              time: DateTime.utc(
                2026,
                8,
                13,
                20,
              ),
            ),
          ],
        );

        final tomorrow = PrayerDay(
          targetDate: DateTime.utc(2026, 8, 14),
          prayerTimes: [
            PrayerTime(
              name: PrayerName.fajr,
              time: DateTime.utc(
                2026,
                8,
                14,
                4,
              ),
            ),
          ],
        );

        final schedule = PrayerSchedule(
          yesterday: yesterday,
          today: today,
          tomorrow: tomorrow,
        );

        const location = PrayerLocation(
          latitude: 0,
          longitude: 0,
          cityName: 'C',
          countryName: 'C',
          timezoneIdentifier: 'UTC',
        );

        final state = PrayerTimesState(
          schedule: schedule,
          location: location,
        );

        var container = ProviderContainer(
          overrides: [
            prayerTimesNotifierProvider.overrideWith(
              () => FakePrayerTimesNotifier(
                state,
              ),
            ),
            currentTimeProvider.overrideWith(
              (ref) => Stream.value(
                DateTime.utc(
                  2026,
                  8,
                  13,
                  2,
                ),
              ),
            ),
          ],
        );

        await container.read(
          currentTimeProvider.future,
        );

        var liveState = container.read(
          prayerLiveStateProvider,
        );

        expect(
          liveState.currentPrayer?.name,
          PrayerName.isha,
        );

        expect(
          liveState.currentPrayer?.time.day,
          12,
        );

        expect(
          liveState.nextPrayer?.name,
          PrayerName.fajr,
        );

        expect(
          liveState.nextPrayer?.time.day,
          13,
        );

        container.dispose();

        container = ProviderContainer(
          overrides: [
            prayerTimesNotifierProvider.overrideWith(
              () => FakePrayerTimesNotifier(
                state,
              ),
            ),
            currentTimeProvider.overrideWith(
              (ref) => Stream.value(
                DateTime.utc(
                  2026,
                  8,
                  13,
                  14,
                ),
              ),
            ),
          ],
        );

        await container.read(
          currentTimeProvider.future,
        );

        liveState = container.read(
          prayerLiveStateProvider,
        );

        expect(
          liveState.currentPrayer?.name,
          PrayerName.dhuhr,
        );

        expect(
          liveState.nextPrayer?.name,
          PrayerName.isha,
        );

        container.dispose();

        container = ProviderContainer(
          overrides: [
            prayerTimesNotifierProvider.overrideWith(
              () => FakePrayerTimesNotifier(
                state,
              ),
            ),
            currentTimeProvider.overrideWith(
              (ref) => Stream.value(
                DateTime.utc(
                  2026,
                  8,
                  13,
                  22,
                ),
              ),
            ),
          ],
        );

        await container.read(
          currentTimeProvider.future,
        );

        liveState = container.read(
          prayerLiveStateProvider,
        );

        expect(
          liveState.currentPrayer?.name,
          PrayerName.isha,
        );

        expect(
          liveState.nextPrayer?.name,
          PrayerName.fajr,
        );

        expect(
          liveState.nextPrayer?.time.day,
          14,
        );

        container.dispose();
      },
    );

    test(
      'Sunrise is never exposed as the next prayer',
      () async {
        final yesterday = PrayerDay(
          targetDate: DateTime.utc(2026, 8, 12),
          prayerTimes: [
            PrayerTime(
              name: PrayerName.isha,
              time: DateTime.utc(
                2026,
                8,
                12,
                20,
              ),
            ),
          ],
        );

        final today = PrayerDay(
          targetDate: DateTime.utc(2026, 8, 13),
          prayerTimes: [
            PrayerTime(
              name: PrayerName.fajr,
              time: DateTime.utc(
                2026,
                8,
                13,
                4,
              ),
            ),
            PrayerTime(
              name: PrayerName.sunrise,
              time: DateTime.utc(
                2026,
                8,
                13,
                6,
              ),
            ),
            PrayerTime(
              name: PrayerName.dhuhr,
              time: DateTime.utc(
                2026,
                8,
                13,
                12,
              ),
            ),
          ],
        );

        final tomorrow = PrayerDay(
          targetDate: DateTime.utc(2026, 8, 14),
          prayerTimes: const [],
        );

        final state = PrayerTimesState(
          schedule: PrayerSchedule(
            yesterday: yesterday,
            today: today,
            tomorrow: tomorrow,
          ),
          location: const PrayerLocation(
            latitude: 0,
            longitude: 0,
            cityName: 'C',
            countryName: 'C',
            timezoneIdentifier: 'UTC',
          ),
        );

        final container = ProviderContainer(
          overrides: [
            prayerTimesNotifierProvider.overrideWith(
              () => FakePrayerTimesNotifier(
                state,
              ),
            ),
            currentTimeProvider.overrideWith(
              (ref) => Stream.value(
                DateTime.utc(
                  2026,
                  8,
                  13,
                  5,
                ),
              ),
            ),
          ],
        );

        await container.read(
          currentTimeProvider.future,
        );

        final liveState = container.read(
          prayerLiveStateProvider,
        );

        expect(
          liveState.currentPrayer?.name,
          PrayerName.fajr,
        );

        expect(
          liveState.nextPrayer?.name,
          PrayerName.dhuhr,
        );

        container.dispose();
      },
    );

    test(
      'Target time follows the selected prayer location timezone',
      () async {
        const location = PrayerLocation(
          latitude: 35.6762,
          longitude: 139.6503,
          cityName: 'Tokyo',
          countryName: 'Japan',
          timezoneIdentifier: 'Asia/Tokyo',
        );

        const state = PrayerTimesState(
          location: location,
        );

        final container = ProviderContainer(
          overrides: [
            prayerTimesNotifierProvider.overrideWith(
              () => FakePrayerTimesNotifier(
                state,
              ),
            ),
            currentTimeProvider.overrideWith(
              (ref) => Stream.value(
                DateTime.utc(
                  2026,
                  8,
                  13,
                  18,
                  42,
                ),
              ),
            ),
          ],
        );

        await container.read(
          currentTimeProvider.future,
        );

        final targetNow = container.read(
          prayerTargetTimeProvider,
        );

        expect(
          targetNow.year,
          2026,
        );

        expect(
          targetNow.month,
          8,
        );

        expect(
          targetNow.day,
          14,
        );

        expect(
          targetNow.hour,
          3,
        );

        expect(
          targetNow.minute,
          42,
        );

        container.dispose();
      },
    );
  });
}
