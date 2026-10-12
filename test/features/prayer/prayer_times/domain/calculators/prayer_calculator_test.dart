import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'package:noor_life/core/base/result.dart';
import 'package:noor_life/features/prayer/calculation_methods/domain/entities/asr_convention.dart';
import 'package:noor_life/features/prayer/prayer_times/domain/calculators/calculation_method_profile.dart';
import 'package:noor_life/features/prayer/prayer_times/domain/calculators/high_latitude_strategy.dart';
import 'package:noor_life/features/prayer/prayer_times/domain/calculators/prayer_calculation_config.dart';
import 'package:noor_life/features/prayer/prayer_times/domain/calculators/prayer_calculator.dart';

void main() {
  setUpAll(
    () {
      tz.initializeTimeZones();
    },
  );

  group(
    'PrayerCalculator Math & Cross-Day Validation',
    () {
      test(
        'double-shadow Asr is chronologically later than single-shadow Asr',
        () {
          final singleShadowConfig = PrayerCalculationConfig(
            latitude: 41.0082,
            longitude: 28.9784,
            dateUtc: DateTime.utc(
              2026,
              8,
              9,
            ),
            method: CalculationMethodProfile.mwl,
            asrConvention: AsrConvention.singleShadow,
          );

          final doubleShadowConfig = PrayerCalculationConfig(
            latitude: 41.0082,
            longitude: 28.9784,
            dateUtc: DateTime.utc(
              2026,
              8,
              9,
            ),
            method: CalculationMethodProfile.mwl,
            asrConvention: AsrConvention.doubleShadow,
          );

          final singleShadowResult = PrayerCalculator(
            singleShadowConfig,
          ).calculate();

          final doubleShadowResult = PrayerCalculator(
            doubleShadowConfig,
          ).calculate();

          switch ((
            singleShadowResult,
            doubleShadowResult,
          )) {
            case (
                Success(value: final singleShadowTimes),
                Success(value: final doubleShadowTimes),
              ):
              expect(
                doubleShadowTimes.asr.isAfter(
                  singleShadowTimes.asr,
                ),
                isTrue,
              );

            default:
              fail(
                'Expected both Asr calculations to succeed.',
              );
          }
        },
      );

      test(
        'Polar Latitude gracefully explicitly rejects without valid High Latitude Strategy',
        () {
          final config = PrayerCalculationConfig(
            latitude: 80.0,
            longitude: 15.0,
            dateUtc: DateTime.utc(
              2026,
              6,
              21,
            ),
            method: CalculationMethodProfile.mwl,
            asrConvention: AsrConvention.singleShadow,
            highLatitudeStrategy: HighLatitudeStrategy.none,
          );

          final result = PrayerCalculator(
            config,
          ).calculate();

          switch (result) {
            case ResultFailure(failure: final failure):
              expect(
                failure.message,
                contains(
                  'Astronomical failure',
                ),
              );

            case Success():
              fail(
                'Expected polar latitude calculation to fail.',
              );
          }
        },
      );

      test(
        'High Latitude None strategy explicitly fails when Fajr is unreachable',
        () {
          final config = PrayerCalculationConfig(
            latitude: 55.0,
            longitude: -0.1278,
            dateUtc: DateTime.utc(
              2026,
              6,
              21,
            ),
            method: CalculationMethodProfile.mwl,
            asrConvention: AsrConvention.singleShadow,
            highLatitudeStrategy: HighLatitudeStrategy.none,
          );

          final result = PrayerCalculator(
            config,
          ).calculate();

          switch (result) {
            case ResultFailure(failure: final failure):
              expect(
                failure.message,
                contains(
                  'Fajr angle not reached',
                ),
              );

            case Success():
              fail(
                'Expected unreachable Fajr calculation to fail.',
              );
          }
        },
      );
    },
  );
}
