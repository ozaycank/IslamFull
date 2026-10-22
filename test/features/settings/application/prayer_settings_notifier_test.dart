import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:islamfull/core/base/result.dart';
import 'package:islamfull/core/di/injection_container.dart';
import 'package:islamfull/features/prayer/calculation_methods/domain/entities/asr_convention.dart';
import 'package:islamfull/features/prayer/calculation_methods/domain/entities/prayer_calculation_method.dart';
import 'package:islamfull/features/prayer/calculation_methods/domain/repositories/calculation_method_repository.dart';
import 'package:islamfull/features/prayer/prayer_times/domain/calculators/high_latitude_strategy.dart';
import 'package:islamfull/features/prayer/shared/domain/errors/prayer_failure.dart';
import 'package:islamfull/features/prayer/shared/infrastructure/datasources/prayer_local_data_source.dart';
import 'package:islamfull/features/settings/application/providers/prayer_settings_notifier.dart';

class MockCalculationMethodRepository extends Mock
    implements CalculationMethodRepository {}

class MockPrayerLocalDataSource extends Mock implements PrayerLocalDataSource {}

void main() {
  late MockCalculationMethodRepository mockRepository;
  late MockPrayerLocalDataSource mockLocalSource;

  setUp(() {
    mockRepository = MockCalculationMethodRepository();

    mockLocalSource = MockPrayerLocalDataSource();

    if (getIt.isRegistered<CalculationMethodRepository>()) {
      getIt.unregister<CalculationMethodRepository>();
    }

    getIt.registerSingleton<CalculationMethodRepository>(
      mockRepository,
    );

    if (getIt.isRegistered<PrayerLocalDataSource>()) {
      getIt.unregister<PrayerLocalDataSource>();
    }

    getIt.registerSingleton<PrayerLocalDataSource>(
      mockLocalSource,
    );

    when(
      () => mockRepository.getCalculationMethods(),
    ).thenAnswer(
      (_) async => const Success(
        [
          PrayerCalculationMethod(
            id: 'mwl',
            name: 'MWL',
            description: 'Desc',
          ),
        ],
      ),
    );

    when(
      () => mockRepository.getAsrConventions(),
    ).thenAnswer(
      (_) async => const Success(
        [
          AsrConvention.doubleShadow,
        ],
      ),
    );

    when(
      () => mockLocalSource.getSelectedCalculationMethodId(),
    ).thenAnswer(
      (_) async => 'mwl',
    );

    when(
      () => mockLocalSource.getSelectedAsrConventionId(),
    ).thenAnswer(
      (_) async => 'double_shadow',
    );

    when(
      () => mockLocalSource.getSelectedHighLatitudeStrategy(),
    ).thenAnswer(
      (_) async => HighLatitudeStrategy.oneSeventh,
    );
  });

  tearDown(() {
    getIt.reset();
  });

  group(
    'PrayerSettingsNotifier Logic',
    () {
      test(
        'loads persisted Asr convention and calculation settings',
        () async {
          final container = ProviderContainer();

          final notifier = container.read(
            prayerSettingsNotifierProvider.notifier,
          );

          await notifier.loadSettings();

          final state = container.read(
            prayerSettingsNotifierProvider,
          );

          expect(
            state.isLoading,
            isFalse,
          );

          expect(
            state.failure,
            isNull,
          );

          expect(
            state.selectedMethodId,
            'mwl',
          );

          expect(
            state.selectedAsrConventionId,
            'double_shadow',
          );

          expect(
            state.availableAsrConventions.single,
            AsrConvention.doubleShadow,
          );

          expect(
            state.selectedHighLatStrategy,
            HighLatitudeStrategy.oneSeventh,
          );
        },
      );

      test(
        'updateMethod returns true on success',
        () async {
          when(
            () => mockRepository.updateCalculationMethod(
              'isna',
            ),
          ).thenAnswer(
            (_) async => const Success(
              null,
            ),
          );

          final container = ProviderContainer();

          final notifier = container.read(
            prayerSettingsNotifierProvider.notifier,
          );

          await notifier.loadSettings();

          final result = await notifier.updateMethod(
            'isna',
          );

          final state = container.read(
            prayerSettingsNotifierProvider,
          );

          expect(
            state.isSaving,
            isFalse,
          );

          expect(
            state.selectedMethodId,
            'isna',
          );

          expect(
            result,
            isTrue,
          );
        },
      );

      test(
        'updateAsrConvention returns false on repository failure',
        () async {
          when(
            () => mockRepository.updateAsrConvention(
              'double_shadow',
            ),
          ).thenAnswer(
            (_) async => const ResultFailure(
              PrayerCalculationFailure(
                'Disk read failed',
              ),
            ),
          );

          final container = ProviderContainer();

          final notifier = container.read(
            prayerSettingsNotifierProvider.notifier,
          );

          await notifier.loadSettings();

          final result = await notifier.updateAsrConvention(
            'double_shadow',
          );

          final state = container.read(
            prayerSettingsNotifierProvider,
          );

          expect(
            state.isSaving,
            isFalse,
          );

          expect(
            state.failure,
            isNotNull,
          );

          expect(
            result,
            isFalse,
          );
        },
      );
    },
  );
}
