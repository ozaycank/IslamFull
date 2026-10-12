import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/injection_container.dart';
import '../../../prayer/calculation_methods/domain/entities/asr_convention.dart';
import '../../../prayer/calculation_methods/domain/repositories/calculation_method_repository.dart';
import '../../../prayer/prayer_times/domain/calculators/high_latitude_strategy.dart';
import '../../../prayer/shared/domain/errors/prayer_failure.dart';
import '../../../prayer/shared/infrastructure/datasources/prayer_local_data_source.dart';
import '../states/prayer_settings_state.dart';

final prayerSettingsNotifierProvider =
    NotifierProvider<PrayerSettingsNotifier, PrayerSettingsState>(
  PrayerSettingsNotifier.new,
);

class PrayerSettingsNotifier extends Notifier<PrayerSettingsState> {
  late final CalculationMethodRepository _repository;
  late final PrayerLocalDataSource _localDataSource;

  @override
  PrayerSettingsState build() {
    _repository = getIt<CalculationMethodRepository>();
    _localDataSource = getIt<PrayerLocalDataSource>();

    Future.microtask(
      () => loadSettings(),
    );

    return const PrayerSettingsState();
  }

  Future<void> loadSettings() async {
    state = state.copyWith(
      isLoading: true,
      failure: () => null,
    );

    final methodsResult = await _repository.getCalculationMethods();

    final asrConventionsResult = await _repository.getAsrConventions();

    final selectedMethodId =
        await _localDataSource.getSelectedCalculationMethodId() ?? 'diyar_turk';

    final selectedAsrConventionId =
        await _localDataSource.getSelectedAsrConventionId() ??
            AsrConvention.singleShadowId;

    final selectedHighLat =
        await _localDataSource.getSelectedHighLatitudeStrategy();

    if (methodsResult is Success && asrConventionsResult is Success) {
      state = state.copyWith(
        isLoading: false,
        availableMethods: (methodsResult as Success).value,
        availableAsrConventions: (asrConventionsResult as Success).value,
        selectedMethodId: selectedMethodId,
        selectedAsrConventionId: selectedAsrConventionId,
        selectedHighLatStrategy: selectedHighLat,
      );

      return;
    }

    state = state.copyWith(
      isLoading: false,
      failure: () => const PrayerCalculationFailure(
        'Failed to load settings',
      ),
    );
  }

  Future<bool> updateMethod(
    String id,
  ) async {
    state = state.copyWith(
      isSaving: true,
      failure: () => null,
    );

    final result = await _repository.updateCalculationMethod(
      id,
    );

    if (result is Success) {
      state = state.copyWith(
        isSaving: false,
        selectedMethodId: id,
      );

      return true;
    }

    state = state.copyWith(
      isSaving: false,
      failure: () => (result as ResultFailure).failure as PrayerFailure,
    );

    return false;
  }

  Future<bool> updateAsrConvention(
    String id,
  ) async {
    state = state.copyWith(
      isSaving: true,
      failure: () => null,
    );

    final result = await _repository.updateAsrConvention(
      id,
    );

    if (result is Success) {
      state = state.copyWith(
        isSaving: false,
        selectedAsrConventionId: id,
      );

      return true;
    }

    state = state.copyWith(
      isSaving: false,
      failure: () => (result as ResultFailure).failure as PrayerFailure,
    );

    return false;
  }

  Future<bool> updateHighLatitudeStrategy(
    HighLatitudeStrategy strategy,
  ) async {
    state = state.copyWith(
      isSaving: true,
      failure: () => null,
    );

    try {
      await _localDataSource.saveSelectedHighLatitudeStrategy(
        strategy,
      );

      state = state.copyWith(
        isSaving: false,
        selectedHighLatStrategy: strategy,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        failure: () => PrayerCalculationFailure(
          'Failed to save strategy: $e',
        ),
      );

      return false;
    }
  }
}
