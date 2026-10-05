import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/base/result.dart';
import '../../location/application/providers/location_notifier.dart';
import '../../location/application/states/location_state.dart';
import '../../location/domain/entities/prayer_location.dart';
import '../domain/qibla_calculator.dart';
import '../domain/qibla_models.dart';

final currentPrayerLocationProvider = Provider<PrayerLocation?>(
  (ref) {
    return ref.watch(
      locationNotifierProvider.select(
        (state) => state.location,
      ),
    );
  },
);

final currentPrayerLocationStatusProvider = Provider<LocationStatus>(
  (ref) {
    return ref.watch(
      locationNotifierProvider.select(
        (state) => state.status,
      ),
    );
  },
);

enum QiblaStatus {
  initial,
  loading,
  success,
  failure,
}

class QiblaState extends Equatable {
  final QiblaStatus status;
  final QiblaDirection? direction;
  final QiblaFailure? failure;
  final String? locationName;

  const QiblaState({
    this.status = QiblaStatus.initial,
    this.direction,
    this.failure,
    this.locationName,
  });

  @override
  List<Object?> get props => [
        status,
        direction,
        failure,
        locationName,
      ];
}

final qiblaProvider = Provider<QiblaState>(
  (ref) {
    final location = ref.watch(
      currentPrayerLocationProvider,
    );

    // A previously selected valid location remains usable even if a
    // subsequent device refresh failed.
    if (location != null) {
      final result = QiblaCalculator.calculate(
        latitude: location.latitude,
        longitude: location.longitude,
      );

      switch (result) {
        case Success(value: final direction):
          return QiblaState(
            status: QiblaStatus.success,
            direction: direction,
            locationName: _buildLocationName(
              location,
            ),
          );

        case ResultFailure(
            failure: final failure,
          ):
          return QiblaState(
            status: QiblaStatus.failure,
            failure: failure,
          );
      }
    }

    final locationStatus = ref.watch(
      currentPrayerLocationStatusProvider,
    );

    if (locationStatus == LocationStatus.initial ||
        locationStatus == LocationStatus.requesting) {
      return const QiblaState(
        status: QiblaStatus.loading,
      );
    }

    return const QiblaState(
      status: QiblaStatus.failure,
      failure: QiblaFailure(
        'Location is unavailable.',
        code: 'no_location',
      ),
    );
  },
);

String? _buildLocationName(
  PrayerLocation location,
) {
  final city = location.cityName.trim();

  final country = location.countryName.trim();

  if (city.isEmpty && country.isEmpty) {
    return null;
  }

  if (city.isEmpty) {
    return country;
  }

  if (country.isEmpty) {
    return city;
  }

  return '$city, $country';
}
