import 'dart:async';

import 'package:geolocator/geolocator.dart'
    show LocationServiceDisabledException, Position;
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
      // Avoid requesting permission while the device-wide GPS switch is off.
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

      return await _resolveCoordinates(
        position.latitude,
        position.longitude,
      );
    } on LocationServiceDisabledException {
      // GPS can be turned off between the preflight check and the position fix.
      return const ResultFailure(
        LocationFailure(
          'Location services are disabled.',
          code: 'locationServiceDisabled',
        ),
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

    // Manual coordinates must remain available without GPS/permission.
    return _resolveCoordinates(
      latitude,
      longitude,
    );
  }

  @override
  Future<PrayerLocation> refreshSavedLocationName(
    PrayerLocation location,
  ) async {
    try {
      final result = await _geocodingService.reverseGeocode(
        location.latitude,
        location.longitude,
      );

      if (result case Success(value: final names)) {
        final city = names.$1.trim();
        final country = names.$2.trim();

        // Do not replace a cached name with another empty or generic label.
        if (city.isEmpty) {
          return location;
        }

        final updatedCountry =
            country.isNotEmpty ? country : location.countryName;

        if (city == location.cityName &&
            updatedCountry == location.countryName) {
          return location;
        }

        return PrayerLocation(
          latitude: location.latitude,
          longitude: location.longitude,
          cityName: city,
          countryName: updatedCountry,
          timezoneIdentifier: location.timezoneIdentifier,
        );
      }
    } catch (_) {
      // A human-readable label is optional. Never lose selected coordinates.
    }

    return location;
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

    // Geocoding is optional. It must not block valid prayer calculations.
    try {
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
          break;
      }
    } catch (_) {
      // A temporary native reverse-geocoding failure is not a GPS failure.
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
