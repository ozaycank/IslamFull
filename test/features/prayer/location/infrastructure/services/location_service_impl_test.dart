import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';

import 'package:islamfull/core/base/result.dart';
import 'package:islamfull/features/prayer/location/domain/entities/prayer_location.dart';
import 'package:islamfull/features/prayer/location/domain/interfaces/location_geocoding_service.dart';
import 'package:islamfull/features/prayer/location/domain/interfaces/location_permission_service.dart';
import 'package:islamfull/features/prayer/location/domain/interfaces/location_service.dart';
import 'package:islamfull/features/prayer/location/infrastructure/datasources/geolocator_data_source.dart';
import 'package:islamfull/features/prayer/location/infrastructure/services/location_service_impl.dart';

class MockGeolocatorDataSource extends Mock implements GeolocatorDataSource {}

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
    mockPermissionService = MockLocationPermissionService();
    mockGeocodingService = MockLocationGeocodingService();

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
        (_) async => const Success(('Istanbul', 'Türkiye')),
      );

      final result = await locationService.getCurrentLocation();

      expect(
        result,
        isA<Success>(),
      );

      final location = (result as Success).value;

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

      final result = await locationService.getCurrentLocation();

      expect(
        result,
        isA<Success>(),
      );

      final location = (result as Success).value;

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

      final result = await locationService.getCurrentLocation();

      expect(
        result,
        isA<ResultFailure>(),
      );

      final failure = (result as ResultFailure).failure;

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
  test(
    'resolves valid manual coordinates without device accuracy requirement',
    () async {
      when(
        () => mockGeocodingService.reverseGeocode(
          39.3292,
          42.289504,
        ),
      ).thenAnswer(
        (_) async => const Success(
          ('Aktuzla', 'Türkiye'),
        ),
      );

      final result = await locationService.resolveManualLocation(
        39.3292,
        42.289504,
      );

      expect(
        result,
        isA<Success>(),
      );

      final location = (result as Success).value;

      expect(
        location.latitude,
        39.3292,
      );

      expect(
        location.longitude,
        42.289504,
      );

      expect(
        location.cityName,
        'Aktuzla',
      );

      expect(
        location.countryName,
        'Türkiye',
      );

      expect(
        location.timezoneIdentifier,
        'Europe/Istanbul',
      );

      verifyNever(
        () => mockGeoSource.getCurrentPosition(),
      );
    },
  );

  test(
    'rejects invalid manual coordinates before geocoding',
    () async {
      final result = await locationService.resolveManualLocation(
        95,
        42,
      );

      expect(
        result,
        isA<ResultFailure>(),
      );

      final failure = (result as ResultFailure).failure as LocationFailure;

      expect(
        failure.code,
        'invalidCoordinates',
      );

      verifyNever(
        () => mockGeocodingService.reverseGeocode(
          any(),
          any(),
        ),
      );
    },
  );
  test(
    'GPS disabled returns actionable failure without requesting permission',
    () async {
      when(() => mockGeoSource.isLocationServiceEnabled()).thenAnswer(
        (_) async => false,
      );

      final result = await locationService.getCurrentLocation();
      expect(result, isA<ResultFailure>());
      final failure = (result as ResultFailure).failure as LocationFailure;
      expect(failure.code, 'locationServiceDisabled');
      verifyNever(() => mockPermissionService.checkPermission());
      verifyNever(() => mockGeoSource.getCurrentPosition());
      verifyNever(() => mockGeocodingService.reverseGeocode(any(), any()));
    },
  );

  test(
    'permanently blocked permission never requests GPS fix',
    () async {
      when(() => mockPermissionService.checkPermission()).thenAnswer(
        (_) async => AppLocationPermission.permanentlyDenied,
      );

      final result = await locationService.getCurrentLocation();
      expect(result, isA<ResultFailure>());
      final failure = (result as ResultFailure).failure as LocationFailure;
      expect(failure.code, 'permissionDeniedForever');
      verifyNever(() => mockPermissionService.requestPermission());
      verifyNever(() => mockGeoSource.getCurrentPosition());
    },
  );

  test(
    'refreshes cached place name without GPS or permission',
    () async {
      const cached = PrayerLocation(
        latitude: 39.15,
        longitude: 42.54,
        cityName: 'Current Location',
        countryName: 'TÃ¼rkiye',
        timezoneIdentifier: 'Europe/Istanbul',
      );
      when(
        () => mockGeocodingService.reverseGeocode(
          39.15,
          42.54,
        ),
      ).thenAnswer(
        (_) async => const Success(
          ('Malazgirt', 'TÃ¼rkiye'),
        ),
      );

      final updated = await locationService.refreshSavedLocationName(
        cached,
      );
      expect(updated.cityName, 'Malazgirt');
      expect(updated.latitude, cached.latitude);
      expect(updated.longitude, cached.longitude);
      expect(updated.timezoneIdentifier, cached.timezoneIdentifier);
      verifyNever(() => mockGeoSource.isLocationServiceEnabled());
      verifyNever(() => mockGeoSource.getCurrentPosition());
      verifyNever(() => mockPermissionService.checkPermission());
    },
  );

  test(
    'keeps cached coordinates and label when geocoding fails',
    () async {
      const cached = PrayerLocation(
        latitude: 39.15,
        longitude: 42.54,
        cityName: 'Current Location',
        countryName: 'TÃ¼rkiye',
        timezoneIdentifier: 'Europe/Istanbul',
      );
      when(
        () => mockGeocodingService.reverseGeocode(
          39.15,
          42.54,
        ),
      ).thenAnswer(
        (_) async => const ResultFailure(
          LocationFailure(
            'Native geocoder unavailable',
          ),
        ),
      );

      final updated = await locationService.refreshSavedLocationName(
        cached,
      );
      expect(updated, cached);
    },
  );
}
