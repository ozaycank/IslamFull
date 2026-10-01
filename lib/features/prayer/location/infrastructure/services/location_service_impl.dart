import 'dart:async';

import 'package:geolocator/geolocator.dart' show Position;
import 'package:injectable/injectable.dart';
import 'package:lat_lng_to_timezone/lat_lng_to_timezone.dart' as tzmap;

import '../../../../../core/base/result.dart';
import '../../domain/entities/prayer_location.dart';
import '../../domain/interfaces/location_geocoding_service.dart';
import '../../domain/interfaces/location_permission_service.dart';
import '../../domain/interfaces/location_service.dart';
import '../datasources/geolocator_data_source.dart';

@LazySingleton(as: LocationService)
class LocationServiceImpl implements LocationService {
  static const double maxAcceptedAccuracyMeters = 25000;

  final LocationPermissionService _permissionService;
  final LocationGeocodingService _geocodingService;
  final GeolocatorDataSource _geoDataSource;

  LocationServiceImpl(
    this._permissionService,
    this._geocodingService,
    this._geoDataSource,
  );

  @override
  Future<Result<PrayerLocation, LocationFailure>> getCurrentLocation() async {
    try {
      final serviceEnabled = await _geoDataSource.isLocationServiceEnabled();

      if (!serviceEnabled) {
        return const ResultFailure(
          LocationFailure(
            'Location services are disabled.',
            code: 'locationServiceDisabled',
          ),
        );
      }

      var permission = await _permissionService.checkPermission();

      if (permission == AppLocationPermission.denied) {
        permission = await _permissionService.requestPermission();
      }

      if (permission == AppLocationPermission.permanentlyDenied) {
        return const ResultFailure(
          LocationFailure(
            'Location permission permanently denied.',
            code: 'permissionDeniedForever',
          ),
        );
      }

      if (permission == AppLocationPermission.denied) {
        return const ResultFailure(
          LocationFailure(
            'Location permission denied.',
            code: 'permissionDenied',
          ),
        );
      }

      final position = await _geoDataSource.getCurrentPosition();

      if (!_coordinatesAreValid(
        position.latitude,
        position.longitude,
      )) {
        return const ResultFailure(
          LocationFailure(
            'Received invalid coordinates from device.',
            code: 'invalidCoordinates',
          ),
        );
      }

      if (!_accuracyIsAcceptable(position)) {
        return ResultFailure(
          LocationFailure(
            'Location accuracy is too low for reliable prayer times. '
            'Current accuracy is approximately '
            '${position.accuracy.round()} meters.',
            code: 'locationAccuracyInsufficient',
          ),
        );
      }

      return _resolveCoordinates(
        position.latitude,
        position.longitude,
      );
    } on TimeoutException {
      return const ResultFailure(
        LocationFailure(
          'Location request timed out.',
          code: 'locationTimeout',
        ),
      );
    } catch (e) {
      return ResultFailure(
        LocationFailure(
          'Failed to acquire location: $e',
          code: 'coordinateAcquisitionFailed',
        ),
      );
    }
  }

  @override
  Future<Result<PrayerLocation, LocationFailure>> resolveManualLocation(
    double latitude,
    double longitude,
  ) async {
    if (!_coordinatesAreValid(
      latitude,
      longitude,
    )) {
      return const ResultFailure(
        LocationFailure(
          'The entered coordinates are invalid.',
          code: 'invalidCoordinates',
        ),
      );
    }

    return _resolveCoordinates(
      latitude,
      longitude,
    );
  }

  Future<Result<PrayerLocation, LocationFailure>> _resolveCoordinates(
    double latitude,
    double longitude,
  ) async {
    String timezoneId;

    try {
      timezoneId = tzmap.latLngToTimezoneString(
        latitude,
        longitude,
      );
    } catch (_) {
      return const ResultFailure(
        LocationFailure(
          'Failed to resolve timezone from coordinates.',
          code: 'timezoneResolutionFailed',
        ),
      );
    }

    var resolvedCity = 'Current Location';
    var resolvedCountry = 'Unknown';

    final geocodingResult = await _geocodingService.reverseGeocode(
      latitude,
      longitude,
    );

    switch (geocodingResult) {
      case Success(value: final result):
        final city = result.$1.trim();
        final country = result.$2.trim();

        if (city.isNotEmpty) {
          resolvedCity = city;
        }

        if (country.isNotEmpty) {
          resolvedCountry = country;
        }

      case ResultFailure():
        // Accurate coordinates and timezone remain valid even when
        // the optional human-readable place name cannot be resolved.
        break;
    }

    return Success(
      PrayerLocation(
        latitude: latitude,
        longitude: longitude,
        cityName: resolvedCity,
        countryName: resolvedCountry,
        timezoneIdentifier: timezoneId,
      ),
    );
  }

  bool _coordinatesAreValid(
    double latitude,
    double longitude,
  ) {
    return latitude.isFinite &&
        longitude.isFinite &&
        latitude >= -90 &&
        latitude <= 90 &&
        longitude >= -180 &&
        longitude <= 180;
  }

  bool _accuracyIsAcceptable(
    Position position,
  ) {
    return position.accuracy.isFinite &&
        position.accuracy > 0 &&
        position.accuracy <= maxAcceptedAccuracyMeters;
  }
}
