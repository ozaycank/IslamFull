import 'package:injectable/injectable.dart';

import '../../../../../core/base/result.dart';
import '../../domain/interfaces/location_geocoding_service.dart';
import '../../domain/interfaces/location_service.dart';
import '../datasources/geocoding_data_source.dart';

@LazySingleton(as: LocationGeocodingService)
class LocationGeocodingServiceImpl implements LocationGeocodingService {
  final GeocodingDataSource _dataSource;

  LocationGeocodingServiceImpl(
    this._dataSource,
  );

  @override
  Future<Result<(String, String), LocationFailure>> reverseGeocode(
    double latitude,
    double longitude,
  ) async {
    try {
      final placemarks = await _dataSource.getPlacemarks(
        latitude,
        longitude,
      );

      if (placemarks.isEmpty) {
        return const ResultFailure(
          LocationFailure(
            'Platform geocoding returned no location information.',
            code: 'locationGeocodingFailed',
          ),
        );
      }

      final place = placemarks.first;

      final city = place.locality ??
          place.subAdministrativeArea ??
          place.administrativeArea ??
          '';

      final country = place.country ?? place.isoCountryCode ?? '';

      if (city.trim().isEmpty && country.trim().isEmpty) {
        return const ResultFailure(
          LocationFailure(
            'Platform geocoding returned no usable place name.',
            code: 'locationGeocodingFailed',
          ),
        );
      }

      return Success(
        (
          city.trim(),
          country.trim(),
        ),
      );
    } catch (_) {
      return const ResultFailure(
        LocationFailure(
          'Platform geocoding failed.',
          code: 'locationGeocodingFailed',
        ),
      );
    }
  }
}
