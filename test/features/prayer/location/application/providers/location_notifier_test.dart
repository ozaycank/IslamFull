import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:noor_life/core/base/result.dart';
import 'package:noor_life/core/di/injection_container.dart';
import 'package:noor_life/features/prayer/location/application/providers/location_notifier.dart';
import 'package:noor_life/features/prayer/location/application/states/location_state.dart';
import 'package:noor_life/features/prayer/location/domain/entities/prayer_location.dart';
import 'package:noor_life/features/prayer/location/domain/interfaces/location_service.dart';
import 'package:noor_life/features/prayer/shared/infrastructure/datasources/prayer_local_data_source.dart';

class MockLocationService extends Mock implements LocationService {}

class MockPrayerLocalDataSource extends Mock implements PrayerLocalDataSource {}

void main() {
  const existingLocation = PrayerLocation(
    latitude: 41.0082,
    longitude: 28.9784,
    cityName: 'Istanbul',
    countryName: 'Türkiye',
    timezoneIdentifier: 'Europe/Istanbul',
  );

  const manualLocation = PrayerLocation(
    latitude: 39.3292,
    longitude: 42.289504,
    cityName: 'Aktuzla',
    countryName: 'Türkiye',
    timezoneIdentifier: 'Europe/Istanbul',
  );

  late MockLocationService locationService;

  late MockPrayerLocalDataSource localDataSource;

  setUp(() async {
    await getIt.reset();

    locationService = MockLocationService();

    localDataSource = MockPrayerLocalDataSource();

    getIt.registerSingleton<LocationService>(
      locationService,
    );

    getIt.registerSingleton<PrayerLocalDataSource>(
      localDataSource,
    );

    when(
      () => localDataSource.getSelectedLocation(),
    ).thenAnswer(
      (_) async => existingLocation,
    );
  });

  tearDown(() async {
    await getIt.reset();
  });

  test(
    'manual coordinates are resolved persisted and exposed as current location',
    () async {
      when(
        () => locationService.resolveManualLocation(
          39.3292,
          42.289504,
        ),
      ).thenAnswer(
        (_) async => const Success(
          manualLocation,
        ),
      );

      when(
        () => localDataSource.saveSelectedLocation(
          manualLocation,
        ),
      ).thenAnswer(
        (_) async {},
      );

      final container = ProviderContainer();

      addTearDown(
        container.dispose,
      );

      container.read(
        locationNotifierProvider,
      );

      await pumpEventQueue();

      final success = await container
          .read(
            locationNotifierProvider.notifier,
          )
          .setManualCoordinates(
            39.3292,
            42.289504,
          );

      expect(
        success,
        isTrue,
      );

      expect(
        container
            .read(
              locationNotifierProvider,
            )
            .location,
        manualLocation,
      );

      expect(
        container
            .read(
              locationNotifierProvider,
            )
            .status,
        LocationStatus.success,
      );

      verify(
        () => localDataSource.saveSelectedLocation(
          manualLocation,
        ),
      ).called(1);
    },
  );

  test(
    'failed device or manual request preserves previously selected location',
    () async {
      when(
        () => locationService.resolveManualLocation(
          39.3292,
          42.289504,
        ),
      ).thenAnswer(
        (_) async => const ResultFailure(
          LocationFailure(
            'Resolution failed',
            code: 'testFailure',
          ),
        ),
      );

      final container = ProviderContainer();

      addTearDown(
        container.dispose,
      );

      container.read(
        locationNotifierProvider,
      );

      await pumpEventQueue();

      final success = await container
          .read(
            locationNotifierProvider.notifier,
          )
          .setManualCoordinates(
            39.3292,
            42.289504,
          );

      expect(
        success,
        isFalse,
      );

      final state = container.read(
        locationNotifierProvider,
      );

      expect(
        state.location,
        existingLocation,
      );

      expect(
        state.status,
        LocationStatus.failure,
      );

      verifyNever(
        () => localDataSource.saveSelectedLocation(
          manualLocation,
        ),
      );
    },
  );
}
