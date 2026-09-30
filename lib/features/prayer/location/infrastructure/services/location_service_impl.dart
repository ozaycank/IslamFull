import 'package:injectable/injectable.dart';
import 'package:lat_lng_to_timezone/lat_lng_to_timezone.dart' as tzmap;
import 'package:geolocator/geolocator.dart' show Position;
import '../../../../../core/base/result.dart';
import '../../domain/entities/prayer_location.dart';
import '../../domain/interfaces/location_geocoding_service.dart';
import '../../domain/interfaces/location_permission_service.dart';
import '../../domain/interfaces/location_service.dart';
import '../datasources/geolocator_data_source.dart';

@LazySingleton(as: LocationService)
class LocationServiceImpl implements LocationService {
  /// Prayer calculations should not silently accept a city/region-level
  /// approximate location.
  ///
  /// This is an application data-quality threshold, not a religious rule.
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

      var permStatus = await _permissionService.checkPermission();

      if (permStatus == AppLocationPermission.denied) {
        permStatus = await _permissionService.requestPermission();
      }

      if (permStatus == AppLocationPermission.permanentlyDenied) {
        return const ResultFailure(
          LocationFailure(
            'Location permission permanently denied.',
            code: 'permissionDeniedForever',
          ),
        );
      }

      if (permStatus == AppLocationPermission.denied) {
        return const ResultFailure(
          LocationFailure(
            'Location permission denied.',
            code: 'permissionDenied',
          ),
        );
      }

      final position = await _geoDataSource.getCurrentPosition();

      if (!_coordinatesAreValid(position)) {
        return const ResultFailure(
          LocationFailure(
            'Received invalid coordinates from device.',
            code: 'invalidCoordinates',
          ),
        );
      }

      if (!_accuracyIsAcceptable(position.accuracy)) {
        return ResultFailure(
          LocationFailure(
            'Location accuracy is too low for reliable prayer times. '
            'Current accuracy is approximately '
            '${position.accuracy.round()} meters.',
            code: 'locationAccuracyInsufficient',
          ),
        );
      }

      final String timezoneId;

      try {
        timezoneId = tzmap.latLngToTimezoneString(
          position.latitude,
          position.longitude,
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

      final geoResult = await _geocodingService.reverseGeocode(
        position.latitude,
        position.longitude,
      );

      switch (geoResult) {
        case Success(value: final tuple):
          resolvedCity = tuple.$1;
          resolvedCountry = tuple.$2;

        case ResultFailure():
          // Coordinates and timezone are still usable when reverse
          // geocoding fails. Keep neutral fallback labels.
          break;
      }

      final location = PrayerLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        cityName: resolvedCity,
        countryName: resolvedCountry,
        timezoneIdentifier: timezoneId,
      );

      return Success(location);
    } catch (e) {
      return ResultFailure(
        LocationFailure(
          'Failed to acquire location: $e',
          code: 'coordinateAcquisitionFailed',
        ),
      );
    }
  }

  bool _coordinatesAreValid(
    Position position,
  ) {
    return position.latitude.isFinite &&
        position.longitude.isFinite &&
        position.latitude >= -90 &&
        position.latitude <= 90 &&
        position.longitude >= -180 &&
        position.longitude <= 180;
  }

  bool _accuracyIsAcceptable(
    double accuracyMeters,
  ) {
    return accuracyMeters.isFinite &&
        accuracyMeters > 0 &&
        accuracyMeters <= maxAcceptedAccuracyMeters;
  }
}
