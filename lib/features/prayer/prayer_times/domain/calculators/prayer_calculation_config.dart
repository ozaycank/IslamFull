import 'package:equatable/equatable.dart';

import '../../../calculation_methods/domain/entities/asr_convention.dart';
import 'calculation_method_profile.dart';
import 'high_latitude_strategy.dart';

class PrayerCalculationConfig extends Equatable {
  final double latitude;
  final double longitude;
  final DateTime dateUtc;
  final CalculationMethodProfile method;
  final AsrConvention asrConvention;
  final HighLatitudeStrategy highLatitudeStrategy;

  PrayerCalculationConfig({
    required this.latitude,
    required this.longitude,
    required this.dateUtc,
    required this.method,
    required this.asrConvention,
    this.highLatitudeStrategy = HighLatitudeStrategy.angleBased,
  }) {
    if (latitude < -90 || latitude > 90) {
      throw ArgumentError(
        'Latitude must be between -90 and 90',
      );
    }

    if (longitude < -180 || longitude > 180) {
      throw ArgumentError(
        'Longitude must be between -180 and 180',
      );
    }

    if (!dateUtc.isUtc) {
      throw ArgumentError(
        'Calculation date must be explicitly UTC',
      );
    }
  }

  @override
  List<Object?> get props => [
        latitude,
        longitude,
        dateUtc,
        method,
        asrConvention,
        highLatitudeStrategy,
      ];
}
