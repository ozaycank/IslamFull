import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';

import 'package:noor_life/core/base/result.dart';
import 'package:noor_life/features/prayer/location/domain/interfaces/location_geocoding_service.dart';
import 'package:noor_life/features/prayer/location/domain/interfaces/location_permission_service.dart';
import 'package:noor_life/features/prayer/location/domain/interfaces/location_service.dart';
import 'package:noor_life/features/prayer/location/infrastructure/datasources/geolocator_data_source.dart';
import 'package:noor_life/features/prayer/location/infrastructure/services/location_service_impl.dart';

class MockGeolocatorDataSource extends Mock
    implements GeolocatorDataSource {}

class MockLocationPermissionService extends Mock
    implements LocationPermissionService {}

class MockLocationGeocodingService extends Mock
    implements LocationGeocodingService {}

void main() {
  late MockGeolocatorDataSource mockGeoSource;
  late MockLocationPermissionService mockPermissionService;
  late MockLocationGeocodingService mockGeocodingService;
  late LocationServiceImpl locationService;

  Position position({
    required double latitude,
    required double longitude,
    double accuracy = 1,
  }) {
    return Position(
      latitude: latitude,
      longitude: longitude,
      timestamp: DateTime.now(),
      accuracy: accuracy,
      altitude: 1,
      heading: 1,
      speed: 1,
      speedAccuracy: 1,
      altitudeAccuracy: 1,
      headingAccuracy: 1,
      isMocked: false,
    );
  }

  setUp(() {
    mockGeoSource = MockGeolocatorDataSource();
    mockPermissionService =
        MockLocationPermissionService();
    mockGeocodingService =
        MockLocationGeocodingService();

    locationService = LocationServiceImpl(
      mockPermissionService,
      mockGeocodingService,
      mockGeoSource,
    );

    when(
      () => mockGeoSource.isLocationServiceEnabled(),
    ).thenAnswer(
      (_) async => true,
    );

    when(
      () => mockPermissionService.checkPermission(),
    ).thenAnswer(
      (_) async => AppLocationPermission.granted,
    );
  });

  test(
    'returns PrayerLocation with City and Country on successful geocoding',
    () async {
      final mockPosition = position(
        latitude: 41.0082,
        longitude: 28.9784,
        accuracy: 5,
      );

      when(
        () => mockGeoSource.getCurrentPosition(),
      ).thenAnswer(
        (_) async => mockPosition,
      );

      when(
        () => mockGeocodingService.reverseGeocode(
          41.0082,
          28.9784,
        ),
      ).thenAnswer(
        (_) async =>
            const Success(('Istanbul', 'Türkiye')),
      );

      final result =
          await locationService.getCurrentLocation();

      expect(
        result,
        isA<Success>(),
      );

      final location =
          (result as Success).value;

      expect(
        location.cityName,
        'Istanbul',
      );

      expect(
        location.countryName,
        'Türkiye',
      );

      expect(
        location.timezoneIdentifier,
        'Europe/Istanbul',
      );
    },
  );

  test(
    'gracefully falls back when geocoding fails without invalidating precise coordinates or timezone',
    () async {
      final mockPosition = position(
        latitude: 51.5074,
        longitude: -0.1278,
        accuracy: 10,
      );

      when(
        () => mockGeoSource.getCurrentPosition(),
      ).thenAnswer(
        (_) async => mockPosition,
      );

      when(
        () => mockGeocodingService.reverseGeocode(
          51.5074,
          -0.1278,
        ),
      ).thenAnswer(
        (_) async => const ResultFailure(
          LocationFailure(
            'Network error',
          ),
        ),
      );

      final result =
          await locationService.getCurrentLocation();

      expect(
        result,
        isA<Success>(),
      );

      final location =
          (result as Success).value;

      expect(
        location.cityName,
        'Current Location',
      );

      expect(
        location.countryName,
        'Unknown',
      );

      expect(
        location.timezoneIdentifier,
        'Europe/London',
      );
    },
  );

  test(
    'rejects a coarse location before geocoding or persistence can use it',
    () async {
      final mockPosition = position(
        latitude: 36.3036,
        longitude: 36.1576,
        accuracy: 100000,
      );

      when(
        () => mockGeoSource.getCurrentPosition(),
      ).thenAnswer(
        (_) async => mockPosition,
      );

      final result =
          await locationService.getCurrentLocation();

      expect(
        result,
        isA<ResultFailure>(),
      );

      final failure =
          (result as ResultFailure).failure;

      expect(
        failure,
        isA<LocationFailure>(),
      );

      expect(
        (failure as LocationFailure).code,
        'locationAccuracyInsufficient',
      );

      verifyNever(
        () => mockGeocodingService.reverseGeocode(
          any(),
          any(),
        ),
      );
    },
  );
}