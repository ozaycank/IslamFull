import '../../../../../core/base/result.dart';
import '../../../shared/domain/errors/prayer_failure.dart';
import '../entities/asr_convention.dart';
import '../entities/prayer_calculation_method.dart';

abstract class CalculationMethodRepository {
  Future<Result<List<PrayerCalculationMethod>, PrayerFailure>>
      getCalculationMethods();

  Future<Result<void, PrayerFailure>> updateCalculationMethod(
    String methodId,
  );

  Future<Result<List<AsrConvention>, PrayerFailure>> getAsrConventions();

  Future<Result<void, PrayerFailure>> updateAsrConvention(
    String conventionId,
  );
}
