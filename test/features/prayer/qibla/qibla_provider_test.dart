import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/features/prayer/location/application/states/location_state.dart';
import 'package:noor_life/features/prayer/location/domain/entities/prayer_location.dart';
import 'package:noor_life/features/prayer/qibla/application/qibla_provider.dart';

void main() {
  group(
    'QiblaProvider',
    () {
      test(
        'returns loading while location is still being requested',
        () {
          final container = ProviderContainer(
            overrides: [
              currentPrayerLocationProvider.overrideWithValue(
                null,
              ),
              currentPrayerLocationStatusProvider.overrideWithValue(
                LocationStatus.requesting,
              ),
            ],
          );

          addTearDown(
            container.dispose,
          );

          final state = container.read(
            qiblaProvider,
          );

          expect(
            state.status,
            QiblaStatus.loading,
          );

          expect(
            state.failure,
            isNull,
          );
        },
      );

      test(
        'returns failure when no usable location exists',
        () {
          final container = ProviderContainer(
            overrides: [
              currentPrayerLocationProvider.overrideWithValue(
                null,
              ),
              currentPrayerLocationStatusProvider.overrideWithValue(
                LocationStatus.failure,
              ),
            ],
          );

          addTearDown(
            container.dispose,
          );

          final state = container.read(
            qiblaProvider,
          );

          expect(
            state.status,
            QiblaStatus.failure,
          );

          expect(
            state.failure?.code,
            'no_location',
          );
        },
      );

      test(
        'calculates qibla from valid selected location',
        () {
          const location = PrayerLocation(
            latitude: 41.0082,
            longitude: 28.9784,
            cityName: 'Istanbul',
            countryName: 'Turkiye',
            timezoneIdentifier: 'Europe/Istanbul',
          );

          final container = ProviderContainer(
            overrides: [
              currentPrayerLocationProvider.overrideWithValue(
                location,
              ),
              currentPrayerLocationStatusProvider.overrideWithValue(
                LocationStatus.success,
              ),
            ],
          );

          addTearDown(
            container.dispose,
          );

          final state = container.read(
            qiblaProvider,
          );

          expect(
            state.status,
            QiblaStatus.success,
          );

          expect(
            state.direction,
            isNotNull,
          );

          expect(
            state.locationName,
            'Istanbul, Turkiye',
          );
        },
      );
    },
  );
}
