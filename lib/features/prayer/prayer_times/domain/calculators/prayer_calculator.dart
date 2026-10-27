import 'dart:math' as math;

import '../../../../../core/base/result.dart';
import '../../../shared/domain/errors/prayer_failure.dart';
import 'astronomical_math.dart';
import 'calculated_prayer_times.dart';
import 'high_latitude_strategy.dart';
import 'prayer_calculation_config.dart';

class PrayerCalculator {
  final PrayerCalculationConfig config;

  const PrayerCalculator(this.config);

  Result<CalculatedPrayerTimes, PrayerCalculationFailure> calculate() {
    try {
      final jdNoonUtc = AstronomicalMath.calculateJulianDay(
        config.dateUtc.year,
        config.dateUtc.month,
        config.dateUtc.day,
        12.0,
      );

      final sunPos = AstronomicalMath.calculateSunPosition(jdNoonUtc);
      final decl = sunPos[0];
      final eqt = sunPos[1];
      final noonUTC = 12.0 - (config.longitude / 15.0) - eqt;

      const angleSunriseSunset = -0.833;

      final hourAngleSunrise = AstronomicalMath.calculateHourAngle(
        angleSunriseSunset,
        decl,
        config.latitude,
      );

      if (!hourAngleSunrise.isFinite) {
        return const ResultFailure(
          PrayerCalculationFailure(
            'Astronomical failure: Sun does not rise/set at this latitude '
            'on this date. Polar calculation requires specialized fatwa '
            'rules not covered by standard high-latitude strategies.',
            code: 'polarSunriseSunsetUnavailable',
          ),
        );
      }

      final sunriseUTC = noonUTC - hourAngleSunrise;
      final sunsetUTC = noonUTC + hourAngleSunrise;

      final fajrAngle = -config.method.fajrAngle;
      double fajrUTC = noonUTC -
          AstronomicalMath.calculateHourAngle(
            fajrAngle,
            decl,
            config.latitude,
          );

      double ishaUTC = double.nan;

      if (config.method.ishaIntervalMinutes != null) {
        ishaUTC = sunsetUTC + (config.method.ishaIntervalMinutes! / 60.0);
      } else if (config.method.ishaAngle != null) {
        final ishaAngle = -config.method.ishaAngle!;

        ishaUTC = noonUTC +
            AstronomicalMath.calculateHourAngle(
              ishaAngle,
              decl,
              config.latitude,
            );
      }

      final asrShadowFactor = config.asrConvention.shadowFactor;
      final latDeclDiff = (config.latitude - decl).abs();

      final asrAngle = AstronomicalMath.rad2deg(
        math.atan(
          1.0 /
              (asrShadowFactor +
                  math.tan(AstronomicalMath.deg2rad(latDeclDiff))),
        ),
      );

      final asrUTC = noonUTC +
          AstronomicalMath.calculateHourAngle(
            asrAngle,
            decl,
            config.latitude,
          );

      // Fajr fallback must use the night ending at today's sunrise:
      // yesterday's sunset through today's sunrise.
      if (!fajrUTC.isFinite) {
        if (config.highLatitudeStrategy == HighLatitudeStrategy.none) {
          return const ResultFailure(
            PrayerCalculationFailure(
              'Fajr angle not reached and no high latitude strategy selected.',
              code: 'fajrAngleNotReached',
            ),
          );
        }

        final jdYesterdayNoon = AstronomicalMath.calculateJulianDay(
          config.dateUtc.year,
          config.dateUtc.month,
          config.dateUtc.day - 1,
          12.0,
        );

        final sunPosYesterday =
            AstronomicalMath.calculateSunPosition(jdYesterdayNoon);

        final noonYesterdayUTC =
            12.0 - (config.longitude / 15.0) - sunPosYesterday[1];

        final hourAngleYesterday = AstronomicalMath.calculateHourAngle(
          angleSunriseSunset,
          sunPosYesterday[0],
          config.latitude,
        );

        if (!hourAngleYesterday.isFinite) {
          return const ResultFailure(
            PrayerCalculationFailure(
              'The previous sunset cannot be calculated reliably for '
              'the selected date and latitude.',
              code: 'polarPreviousSunsetUnavailable',
            ),
          );
        }

        final previousSunsetUTC = noonYesterdayUTC + hourAngleYesterday;

        // Both events are expressed relative to their respective UTC date.
        final nightDurationBeforeSunrise =
            24.0 + sunriseUTC - previousSunsetUTC;

        if (!nightDurationBeforeSunrise.isFinite ||
            nightDurationBeforeSunrise <= 0) {
          return const ResultFailure(
            PrayerCalculationFailure(
              'The night duration before sunrise could not be calculated.',
              code: 'invalidPreviousNightDuration',
            ),
          );
        }

        if (config.highLatitudeStrategy == HighLatitudeStrategy.angleBased) {
          fajrUTC = sunriseUTC -
              (nightDurationBeforeSunrise * (config.method.fajrAngle / 60.0));
        } else if (config.highLatitudeStrategy ==
            HighLatitudeStrategy.oneSeventh) {
          fajrUTC = sunriseUTC - (nightDurationBeforeSunrise / 7.0);
        } else if (config.highLatitudeStrategy ==
            HighLatitudeStrategy.nightMiddle) {
          fajrUTC = sunriseUTC - (nightDurationBeforeSunrise / 2.0);
        }
      }

      // Isha fallback uses the night after today's sunset:
      // today's sunset through tomorrow's sunrise.
      if (!ishaUTC.isFinite) {
        if (config.highLatitudeStrategy == HighLatitudeStrategy.none) {
          return const ResultFailure(
            PrayerCalculationFailure(
              'Isha angle not reached and no high latitude strategy selected.',
              code: 'ishaAngleNotReached',
            ),
          );
        }

        if (config.highLatitudeStrategy == HighLatitudeStrategy.angleBased &&
            config.method.ishaAngle == null) {
          return const ResultFailure(
            PrayerCalculationFailure(
              'Isha cannot use the angle-based strategy because the '
              'selected calculation method has no Isha angle.',
              code: 'ishaAngleNotConfigured',
            ),
          );
        }

        final jdTomorrowNoon = AstronomicalMath.calculateJulianDay(
          config.dateUtc.year,
          config.dateUtc.month,
          config.dateUtc.day + 1,
          12.0,
        );

        final sunPosTomorrow =
            AstronomicalMath.calculateSunPosition(jdTomorrowNoon);

        final noonTomorrowUTC =
            12.0 - (config.longitude / 15.0) - sunPosTomorrow[1];

        final hourAngleTomorrow = AstronomicalMath.calculateHourAngle(
          angleSunriseSunset,
          sunPosTomorrow[0],
          config.latitude,
        );

        if (!hourAngleTomorrow.isFinite) {
          return const ResultFailure(
            PrayerCalculationFailure(
              'Astronomical failure for tomorrow’s sunrise. '
              'The next sunrise cannot be calculated reliably.',
              code: 'polarNextSunriseUnavailable',
            ),
          );
        }

        final tomorrowSunriseUTC = noonTomorrowUTC - hourAngleTomorrow + 24.0;

        final nightDurationAfterSunset = tomorrowSunriseUTC - sunsetUTC;

        if (!nightDurationAfterSunset.isFinite ||
            nightDurationAfterSunset <= 0) {
          return const ResultFailure(
            PrayerCalculationFailure(
              'The night duration after sunset could not be calculated.',
              code: 'invalidNextNightDuration',
            ),
          );
        }

        if (config.highLatitudeStrategy == HighLatitudeStrategy.angleBased &&
            config.method.ishaAngle != null) {
          ishaUTC = sunsetUTC +
              (nightDurationAfterSunset * (config.method.ishaAngle! / 60.0));
        } else if (config.highLatitudeStrategy ==
            HighLatitudeStrategy.oneSeventh) {
          ishaUTC = sunsetUTC + (nightDurationAfterSunset / 7.0);
        } else if (config.highLatitudeStrategy ==
            HighLatitudeStrategy.nightMiddle) {
          ishaUTC = sunsetUTC + (nightDurationAfterSunset / 2.0);
        }
      }

      if (!fajrUTC.isFinite || !ishaUTC.isFinite || !asrUTC.isFinite) {
        return const ResultFailure(
          PrayerCalculationFailure(
            'One or more prayer times could not be resolved under the '
            'selected calculation method and high-latitude strategy.',
            code: 'prayerTimeUnavailable',
          ),
        );
      }

      return Success(
        CalculatedPrayerTimes(
          fajr: _decimalToUtcTime(config.dateUtc, fajrUTC),
          sunrise: _decimalToUtcTime(config.dateUtc, sunriseUTC),
          dhuhr: _decimalToUtcTime(config.dateUtc, noonUTC),
          asr: _decimalToUtcTime(config.dateUtc, asrUTC),
          sunset: _decimalToUtcTime(config.dateUtc, sunsetUTC),
          maghrib: _decimalToUtcTime(config.dateUtc, sunsetUTC),
          isha: _decimalToUtcTime(config.dateUtc, ishaUTC),
        ),
      );
    } catch (e) {
      return ResultFailure(
        PrayerCalculationFailure(
          'Critical engine failure: $e',
          code: 'calculationEngineFailure',
        ),
      );
    }
  }

  DateTime _decimalToUtcTime(DateTime baseDateUtc, double decimalHours) {
    final fixedHours = AstronomicalMath.fixHour(decimalHours);
    final dayOffset = decimalHours < 0 ? -1 : (decimalHours >= 24 ? 1 : 0);

    final hours = fixedHours.floor();
    final minutes = ((fixedHours - hours) * 60).floor();
    final seconds = ((((fixedHours - hours) * 60) - minutes) * 60).floor();

    return DateTime.utc(
      baseDateUtc.year,
      baseDateUtc.month,
      baseDateUtc.day + dayOffset,
      hours,
      minutes,
      seconds,
    );
  }
}
