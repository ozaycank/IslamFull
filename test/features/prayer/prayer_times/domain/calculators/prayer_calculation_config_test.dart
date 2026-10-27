import 'package:flutter_test/flutter_test.dart';

import 'package:islamfull/features/prayer/calculation_methods/domain/entities/asr_convention.dart';
import 'package:islamfull/features/prayer/prayer_times/domain/calculators/calculation_method_profile.dart';
import 'package:islamfull/features/prayer/prayer_times/domain/calculators/prayer_calculation_config.dart';

void main() {
  group('PrayerCalculationConfig coordinate validation', () {
    test('rejects NaN latitude', () {
      expect(
        () => _createConfig(
          latitude: double.nan,
          longitude: 0.0,
        ),
        throwsArgumentError,
      );
    });

    test('rejects infinite latitude', () {
      expect(
        () => _createConfig(
          latitude: double.infinity,
          longitude: 0.0,
        ),
        throwsArgumentError,
      );
    });

    test('rejects negative infinite latitude', () {
      expect(
        () => _createConfig(
          latitude: double.negativeInfinity,
          longitude: 0.0,
        ),
        throwsArgumentError,
      );
    });

    test('rejects NaN longitude', () {
      expect(
        () => _createConfig(
          latitude: 0.0,
          longitude: double.nan,
        ),
        throwsArgumentError,
      );
    });

    test('rejects infinite longitude', () {
      expect(
        () => _createConfig(
          latitude: 0.0,
          longitude: double.infinity,
        ),
        throwsArgumentError,
      );
    });

    test('rejects negative infinite longitude', () {
      expect(
        () => _createConfig(
          latitude: 0.0,
          longitude: double.negativeInfinity,
        ),
        throwsArgumentError,
      );
    });

    test('accepts coordinates at the valid range boundaries', () {
      final southWest = _createConfig(
        latitude: -90.0,
        longitude: -180.0,
      );

      final northEast = _createConfig(
        latitude: 90.0,
        longitude: 180.0,
      );

      expect(southWest.latitude, -90.0);
      expect(southWest.longitude, -180.0);
      expect(northEast.latitude, 90.0);
      expect(northEast.longitude, 180.0);
    });
  });
}

PrayerCalculationConfig _createConfig({
  required double latitude,
  required double longitude,
}) {
  return PrayerCalculationConfig(
    latitude: latitude,
    longitude: longitude,
    dateUtc: DateTime.utc(2026, 6, 21),
    method: CalculationMethodProfile.mwl,
    asrConvention: AsrConvention.singleShadow,
  );
}
