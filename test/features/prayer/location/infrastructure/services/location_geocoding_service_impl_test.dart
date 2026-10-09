import 'package:flutter_test/flutter_test.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mocktail/mocktail.dart';

import 'package:noor_life/core/base/result.dart';
import 'package:noor_life/features/prayer/location/domain/interfaces/location_service.dart';
import 'package:noor_life/features/prayer/location/infrastructure/datasources/geocoding_data_source.dart';
import 'package:noor_life/features/prayer/location/infrastructure/services/location_geocoding_service_impl.dart';

class MockGeocodingDataSource extends Mock implements GeocodingDataSource {}

void main() {
  late MockGeocodingDataSource dataSource;
  late LocationGeocodingServiceImpl service;

  setUp(() {
    dataSource = MockGeocodingDataSource();

    service = LocationGeocodingServiceImpl(
      dataSource,
    );
  });

  test(
    'returns city and country from platform geocoding',
    () async {
      when(
        () => dataSource.getPlacemarks(
          41.0082,
          28.9784,
        ),
      ).thenAnswer(
        (_) async => [
          const Placemark(
            locality: 'Istanbul',
            country: 'Türkiye',
          ),
        ],
      );

      final result = await service.reverseGeocode(
        41.0082,
        28.9784,
      );

      expect(
        result,
        isA<Success<(String, String), LocationFailure>>(),
      );

      final value =
          (result as Success<(String, String), LocationFailure>).value;

      expect(
        value.$1,
        'Istanbul',
      );

      expect(
        value.$2,
        'Türkiye',
      );
    },
  );

  test(
    'returns failure when platform geocoding returns no placemarks',
    () async {
      when(
        () => dataSource.getPlacemarks(
          39.9334,
          32.8597,
        ),
      ).thenAnswer(
        (_) async => [],
      );

      final result = await service.reverseGeocode(
        39.9334,
        32.8597,
      );

      expect(
        result,
        isA<ResultFailure<(String, String), LocationFailure>>(),
      );

      final failure =
          (result as ResultFailure<(String, String), LocationFailure>).failure;

      expect(
        failure.code,
        'locationGeocodingFailed',
      );
    },
  );

  test(
    'returns failure when platform geocoding throws',
    () async {
      when(
        () => dataSource.getPlacemarks(
          51.5074,
          -0.1278,
        ),
      ).thenThrow(
        Exception(
          'Platform geocoder unavailable',
        ),
      );

      final result = await service.reverseGeocode(
        51.5074,
        -0.1278,
      );

      expect(
        result,
        isA<ResultFailure<(String, String), LocationFailure>>(),
      );

      final failure =
          (result as ResultFailure<(String, String), LocationFailure>).failure;

      expect(
        failure.code,
        'locationGeocodingFailed',
      );
    },
  );

  test(
    'returns failure when platform placemark contains no usable place name',
    () async {
      when(
        () => dataSource.getPlacemarks(
          0,
          0,
        ),
      ).thenAnswer(
        (_) async => [
          const Placemark(),
        ],
      );

      final result = await service.reverseGeocode(
        0,
        0,
      );

      expect(
        result,
        isA<ResultFailure<(String, String), LocationFailure>>(),
      );
    },
  );
}
