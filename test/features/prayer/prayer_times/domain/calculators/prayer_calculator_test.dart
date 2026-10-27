import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'package:islamfull/core/base/result.dart';
import 'package:islamfull/features/prayer/calculation_methods/domain/entities/asr_convention.dart';
import 'package:islamfull/features/prayer/prayer_times/domain/calculators/astronomical_math.dart';
import 'package:islamfull/features/prayer/prayer_times/domain/calculators/calculation_method_profile.dart';
import 'package:islamfull/features/prayer/prayer_times/domain/calculators/high_latitude_strategy.dart';
import 'package:islamfull/features/prayer/prayer_times/domain/calculators/prayer_calculation_config.dart';
import 'package:islamfull/features/prayer/prayer_times/domain/calculators/prayer_calculator.dart';

void main() {
  setUpAll(() {
    tz.initializeTimeZones();
  });

  group('PrayerCalculator Math & Cross-Day Validation', () {
    test(
      'double-shadow Asr is chronologically later than single-shadow Asr',
      () {
        final singleShadowConfig = PrayerCalculationConfig(
          latitude: 41.0082,
          longitude: 28.9784,
          dateUtc: DateTime.utc(2026, 8, 9),
          method: CalculationMethodProfile.mwl,
          asrConvention: AsrConvention.singleShadow,
        );

        final doubleShadowConfig = PrayerCalculationConfig(
          latitude: 41.0082,
          longitude: 28.9784,
          dateUtc: DateTime.utc(2026, 8, 9),
          method: CalculationMethodProfile.mwl,
          asrConvention: AsrConvention.doubleShadow,
        );

        final singleShadowResult =
            PrayerCalculator(singleShadowConfig).calculate();

        final doubleShadowResult =
            PrayerCalculator(doubleShadowConfig).calculate();

        switch ((singleShadowResult, doubleShadowResult)) {
          case (
              Success(value: final singleShadowTimes),
              Success(value: final doubleShadowTimes),
            ):
            expect(
              doubleShadowTimes.asr.isAfter(singleShadowTimes.asr),
              isTrue,
            );

          default:
            fail('Expected both Asr calculations to succeed.');
        }
      },
    );

    test(
      'polar sunrise/sunset failure is explicit for every high-latitude strategy',
      () {
        for (final strategy in HighLatitudeStrategy.values) {
          final config = PrayerCalculationConfig(
            latitude: 80.0,
            longitude: 15.0,
            dateUtc: DateTime.utc(2026, 6, 21),
            method: CalculationMethodProfile.mwl,
            asrConvention: AsrConvention.singleShadow,
            highLatitudeStrategy: strategy,
          );

          final result = PrayerCalculator(config).calculate();

          switch (result) {
            case ResultFailure(failure: final failure):
              expect(
                failure.code,
                'polarSunriseSunsetUnavailable',
                reason: 'Strategy: $strategy',
              );

            case Success():
              fail(
                'Expected polar calculation to fail for strategy $strategy.',
              );
          }
        }
      },
    );

    test(
      'High Latitude None strategy explicitly fails when Fajr is unreachable',
      () {
        final config = PrayerCalculationConfig(
          latitude: 55.0,
          longitude: -0.1278,
          dateUtc: DateTime.utc(2026, 6, 21),
          method: CalculationMethodProfile.mwl,
          asrConvention: AsrConvention.singleShadow,
          highLatitudeStrategy: HighLatitudeStrategy.none,
        );

        final result = PrayerCalculator(config).calculate();

        switch (result) {
          case ResultFailure(failure: final failure):
            expect(failure.code, 'fajrAngleNotReached');
            expect(
              failure.message,
              contains('Fajr angle not reached'),
            );

          case Success():
            fail('Expected unreachable Fajr calculation to fail.');
        }
      },
    );

    test(
      'available high-latitude strategies calculate twilight when sunrise and sunset exist',
      () {
        for (final strategy in [
          HighLatitudeStrategy.angleBased,
          HighLatitudeStrategy.oneSeventh,
          HighLatitudeStrategy.nightMiddle,
        ]) {
          final config = PrayerCalculationConfig(
            latitude: 65.0,
            longitude: 24.94,
            dateUtc: DateTime.utc(2026, 6, 15),
            method: CalculationMethodProfile.mwl,
            asrConvention: AsrConvention.singleShadow,
            highLatitudeStrategy: strategy,
          );

          final result = PrayerCalculator(config).calculate();

          switch (result) {
            case Success(value: final times):
              expect(
                times.fajr.isBefore(times.sunrise),
                isTrue,
                reason: 'Fajr should precede sunrise for $strategy.',
              );
              expect(
                times.isha.isAfter(times.sunset),
                isTrue,
                reason: 'Isha should follow sunset for $strategy.',
              );

            case ResultFailure(failure: final failure):
              fail(
                'Expected strategy $strategy to succeed when sunrise and '
                'sunset exist. Failure: ${failure.message}',
              );
          }
        }
      },
    );

    test(
      'Fajr high-latitude adjustment uses the preceding night duration',
      () {
        final config = PrayerCalculationConfig(
          latitude: 65.0,
          longitude: 24.94,
          dateUtc: DateTime.utc(2026, 6, 15),
          method: CalculationMethodProfile.mwl,
          asrConvention: AsrConvention.singleShadow,
          highLatitudeStrategy: HighLatitudeStrategy.oneSeventh,
        );

        final currentJulianDay = AstronomicalMath.calculateJulianDay(
          config.dateUtc.year,
          config.dateUtc.month,
          config.dateUtc.day,
          12.0,
        );

        final currentSunPosition =
            AstronomicalMath.calculateSunPosition(currentJulianDay);

        final sunriseHourAngle = AstronomicalMath.calculateHourAngle(
          -0.833,
          currentSunPosition[0],
          config.latitude,
        );

        expect(sunriseHourAngle.isFinite, isTrue);

        final fajrHourAngle = AstronomicalMath.calculateHourAngle(
          -config.method.fajrAngle,
          currentSunPosition[0],
          config.latitude,
        );

        expect(fajrHourAngle.isNaN, isTrue);

        final noonUtc =
            12.0 - (config.longitude / 15.0) - currentSunPosition[1];

        final sunriseUtc = noonUtc - sunriseHourAngle;

        final previousJulianDay = AstronomicalMath.calculateJulianDay(
          config.dateUtc.year,
          config.dateUtc.month,
          config.dateUtc.day - 1,
          12.0,
        );

        final previousSunPosition =
            AstronomicalMath.calculateSunPosition(previousJulianDay);

        final previousNoonUtc =
            12.0 - (config.longitude / 15.0) - previousSunPosition[1];

        final previousSunsetHourAngle = AstronomicalMath.calculateHourAngle(
          -0.833,
          previousSunPosition[0],
          config.latitude,
        );

        expect(previousSunsetHourAngle.isFinite, isTrue);

        final previousSunsetUtc = previousNoonUtc + previousSunsetHourAngle;

        final previousNightDuration = 24.0 + sunriseUtc - previousSunsetUtc;

        expect(previousNightDuration, greaterThan(0));

        final expectedFajrUtcHour = sunriseUtc - (previousNightDuration / 7.0);

        final result = PrayerCalculator(config).calculate();

        switch (result) {
          case Success(value: final times):
            final actualFajrUtcHour =
                times.fajr.difference(config.dateUtc).inSeconds / 3600.0;

            expect(
              actualFajrUtcHour,
              closeTo(expectedFajrUtcHour, 2.0 / 3600.0),
            );

          case ResultFailure(failure: final failure):
            fail(
              'Expected the high-latitude Fajr calculation to succeed. '
              'Failure: ${failure.message}',
            );
        }
      },
    );
  });
}
