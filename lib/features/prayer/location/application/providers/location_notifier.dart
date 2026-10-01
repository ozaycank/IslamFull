import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/base/result.dart';
import '../../../../../core/di/injection_container.dart';
import '../../../shared/infrastructure/datasources/prayer_local_data_source.dart';
import '../../domain/entities/prayer_location.dart';
import '../../domain/interfaces/location_service.dart';
import '../states/location_state.dart';

final locationNotifierProvider =
    NotifierProvider<LocationNotifier, LocationState>(
  LocationNotifier.new,
);

class LocationNotifier extends Notifier<LocationState> {
  late final LocationService _locationService;
  late final PrayerLocalDataSource _localDataSource;

  @override
  LocationState build() {
    _locationService = getIt<LocationService>();
    _localDataSource = getIt<PrayerLocalDataSource>();

    Future.microtask(
      _initLocation,
    );

    return const LocationState();
  }

  Future<void> _initLocation() async {
    final saved = await _localDataSource.getSelectedLocation();

    if (saved == null) {
      await acquireDeviceLocation();
      return;
    }

    state = state.copyWith(
      status: LocationStatus.success,
      location: () => saved,
      failure: () => null,
    );
  }

  Future<bool> acquireDeviceLocation() {
    return _runLocationRequest(
      _locationService.getCurrentLocation,
    );
  }

  Future<bool> setManualCoordinates(
    double latitude,
    double longitude,
  ) {
    return _runLocationRequest(
      () => _locationService.resolveManualLocation(
        latitude,
        longitude,
      ),
    );
  }

  Future<bool> _runLocationRequest(
    Future<Result<PrayerLocation, LocationFailure>> Function() request,
  ) async {
    state = state.copyWith(
      status: LocationStatus.requesting,
      failure: () => null,
    );

    final result = await request();

    switch (result) {
      case Success(value: final location):
        try {
          await _localDataSource.saveSelectedLocation(
            location,
          );
        } catch (_) {
          state = state.copyWith(
            status: LocationStatus.failure,
            failure: () => const LocationFailure(
              'Location could not be saved.',
              code: 'locationPersistenceFailed',
            ),
          );

          return false;
        }

        state = state.copyWith(
          status: LocationStatus.success,
          location: () => location,
          failure: () => null,
        );

        return true;

      case ResultFailure(failure: final failure):
        state = state.copyWith(
          status: LocationStatus.failure,
          failure: () => failure,
        );

        return false;
    }
  }
}
