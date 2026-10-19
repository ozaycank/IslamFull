import 'package:geocoding/geocoding.dart' as geo;
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

      // Platform geocoders can return a country-only result first, followed
      // by a more useful district or locality in a later placemark. Search
      // every record before choosing the human-readable location name.
      final country = _firstUsable(
        placemarks,
        (place) => place.country ?? place.isoCountryCode,
      );

      // Turkish districts usually arrive in subAdministrativeArea. Prefer
      // the district to a neighborhood or a broad provincial label.
      final city = _firstUsable(
            placemarks,
            (place) => place.subAdministrativeArea,
            country: country,
          ) ??
          _firstUsable(
            placemarks,
            (place) => place.locality,
            country: country,
          ) ??
          _firstUsable(
            placemarks,
            (place) => place.administrativeArea,
            country: country,
          ) ??
          _firstUsable(
            placemarks,
            (place) => place.subLocality,
            country: country,
          ) ??
          _firstUsable(
            placemarks,
            (place) =>
                place.thoroughfare == null || place.thoroughfare!.trim().isEmpty
                    ? place.name
                    : null,
            country: country,
          ) ??
          '';

      if (city.isEmpty && (country == null || country.isEmpty)) {
        return const ResultFailure(
          LocationFailure(
            'Platform geocoding returned no usable place name.',
            code: 'locationGeocodingFailed',
          ),
        );
      }

      return Success(
        (
          city,
          country ?? '',
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

  String? _firstUsable(
    List<geo.Placemark> placemarks,
    String? Function(geo.Placemark) candidate, {
    String? country,
  }) {
    for (final place in placemarks) {
      final name = candidate(place)?.trim() ?? '';
      final normalized = name.toLowerCase();

      if (name.isEmpty ||
          normalized == country?.trim().toLowerCase() ||
          normalized == 'current location' ||
          normalized == 'mevcut konum' ||
          normalized == 'unknown' ||
          normalized == 'merkez' ||
          normalized == 'central' ||
          RegExp(r'^\d+$').hasMatch(normalized)) {
        continue;
      }

      return name;
    }

    return null;
  }
}
