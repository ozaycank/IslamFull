import 'package:flutter_test/flutter_test.dart';
import 'package:islamfull/core/di/injection_container.dart';
import 'package:islamfull/features/prayer/location/infrastructure/datasources/geolocator_data_source.dart';
import 'package:islamfull/features/prayer/location/infrastructure/datasources/geocoding_data_source.dart';
import 'package:islamfull/features/prayer/location/domain/interfaces/location_permission_service.dart';
import 'package:islamfull/features/prayer/location/domain/interfaces/location_service.dart';
import 'package:islamfull/features/prayer/location/domain/interfaces/location_geocoding_service.dart';

void main() {
  setUpAll(() async {
    await configureDependencies();
  });

  tearDownAll(() {
    getIt.reset();
  });

  group('DI Runtime Resolution Tests', () {
    test('Should resolve GeolocatorDataSource', () {
      expect(() => getIt<GeolocatorDataSource>(), returnsNormally);
    });

    test('Should resolve GeocodingDataSource', () {
      expect(() => getIt<GeocodingDataSource>(), returnsNormally);
    });

    test('Should resolve LocationPermissionService', () {
      expect(() => getIt<LocationPermissionService>(), returnsNormally);
    });

    test('Should resolve LocationGeocodingService', () {
      expect(() => getIt<LocationGeocodingService>(), returnsNormally);
    });

    test('Should resolve LocationService', () {
      expect(() => getIt<LocationService>(), returnsNormally);
    });
  });
}
