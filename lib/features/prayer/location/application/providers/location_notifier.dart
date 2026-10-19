import 'dart:async';

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

  Future<void> _saveTail = Future<void>.value();
  int _selectionGeneration = 0;
  bool _disposed = false;

  @override
  LocationState build() {
    _locationService = getIt<LocationService>();
    _localDataSource = getIt<PrayerLocalDataSource>();

    ref.onDispose(() {
      _disposed = true;
    });

    Future.microtask(
      _initLocation,
    );

    return const LocationState();
  }

  Future<void> _initLocation() async {
    final generation = _selectionGeneration;
    final PrayerLocation? saved;

    try {
      saved = await _localDataSource.getSelectedLocation();
    } catch (_) {
      // Corrupt or unavailable storage should not crash the prayer screen.
      if (!_disposed && generation == _selectionGeneration) {
        await acquireDeviceLocation();
      }
      return;
    }

    if (_disposed || generation != _selectionGeneration) {
      return;
    }

    if (saved == null) {
      await acquireDeviceLocation();
      return;
    }

    state = state.copyWith(
      status: LocationStatus.success,
      location: () => saved,
      failure: () => null,
    );

    if (_hasPlaceholderName(saved.cityName)) {
      // Cached coordinates work even with GPS disabled. Repair only the
      // old display label, without requesting native location access.
      unawaited(
        _refreshSavedName(saved, generation),
      );
    }
  }

  bool _hasPlaceholderName(String cityName) {
    final normalized = cityName.trim().toLowerCase();
    return normalized.isEmpty ||
        normalized == 'current location' ||
        normalized == 'mevcut konum' ||
        normalized == 'unknown';
  }

  Future<void> _refreshSavedName(
    PrayerLocation saved,
    int generation,
  ) async {
    try {
      final updated = await _locationService.refreshSavedLocationName(
        saved,
      );

      if (_disposed ||
          generation != _selectionGeneration ||
          state.location != saved ||
          updated == saved) {
        return;
      }

      await _saveSelectedLocation(updated);

      // A user can select a new location while the background save runs.
      if (_disposed ||
          generation != _selectionGeneration ||
          state.location != saved) {
        return;
      }

      state = state.copyWith(
        status: LocationStatus.success,
        location: () => updated,
        failure: () => null,
      );
    } catch (_) {
      // Optional geocoding must not invalidate a saved coordinate selection.
    }
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
    final generation = ++_selectionGeneration;

    state = state.copyWith(
      status: LocationStatus.requesting,
      failure: () => null,
    );

    late final Result<PrayerLocation, LocationFailure> result;

    try {
      result = await request();
    } catch (_) {
      if (!_disposed && generation == _selectionGeneration) {
        state = state.copyWith(
          status: LocationStatus.failure,
          failure: () => const LocationFailure(
            'Unable to retrieve location.',
            code: 'coordinateAcquisitionFailed',
          ),
        );
      }
      return false;
    }

    if (_disposed || generation != _selectionGeneration) {
      return false;
    }

    switch (result) {
      case Success(value: final location):
        try {
          await _saveSelectedLocation(location);
        } catch (_) {
          if (!_disposed && generation == _selectionGeneration) {
            state = state.copyWith(
              status: LocationStatus.failure,
              failure: () => const LocationFailure(
                'Location could not be saved.',
                code: 'locationPersistenceFailed',
              ),
            );
          }
          return false;
        }

        if (_disposed || generation != _selectionGeneration) {
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

  Future<void> _saveSelectedLocation(PrayerLocation location) {
    final operation = _saveTail.then<void>(
      (_) => _localDataSource.saveSelectedLocation(location),
    );

    // Keep the queue usable after a failed write while reporting the error
    // to the original caller.
    _saveTail = operation.then<void>(
      (_) {},
      onError: (Object _, StackTrace __) {},
    );

    return operation;
  }
}
