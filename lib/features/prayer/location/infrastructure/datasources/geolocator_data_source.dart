import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GeolocatorDataSource {
  static const Duration _positionTimeout = Duration(
    seconds: 15,
  );

  Future<bool> isLocationServiceEnabled() =>
      Geolocator.isLocationServiceEnabled();

  Future<LocationPermission> checkPermission() => Geolocator.checkPermission();

  Future<LocationPermission> requestPermission() =>
      Geolocator.requestPermission();

  Future<Position> getCurrentPosition() {
    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
      timeLimit: _positionTimeout,
    );
  }
}
