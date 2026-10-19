import '../../../../../core/base/result.dart';
import '../../../../../core/errors/failure.dart';
import '../entities/prayer_location.dart';

class LocationFailure extends Failure {
  const LocationFailure(
    super.message, {
    super.code,
  });
}

abstract class LocationService {
  Future<Result<PrayerLocation, LocationFailure>> getCurrentLocation();

  Future<Result<PrayerLocation, LocationFailure>> resolveManualLocation(
    double latitude,
    double longitude,
  );

  /// Enriches a cached location's label using its existing coordinates.
  /// Never requests device GPS or additional location permission.
  /// Returns the original location if the platform geocoder is unavailable.
  Future<PrayerLocation> refreshSavedLocationName(PrayerLocation location);
}
