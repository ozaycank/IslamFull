import 'package:equatable/equatable.dart';

import '../../../prayer/calculation_methods/domain/entities/asr_convention.dart';
import '../../../prayer/calculation_methods/domain/entities/prayer_calculation_method.dart';
import '../../../prayer/prayer_times/domain/calculators/high_latitude_strategy.dart';
import '../../../prayer/shared/domain/errors/prayer_failure.dart';

class PrayerSettingsState extends Equatable {
  final bool isLoading;
  final bool isSaving;
  final PrayerFailure? failure;
  final List<PrayerCalculationMethod> availableMethods;
  final List<AsrConvention> availableAsrConventions;
  final String? selectedMethodId;
  final String? selectedAsrConventionId;
  final HighLatitudeStrategy? selectedHighLatStrategy;

  const PrayerSettingsState({
    this.isLoading = false,
    this.isSaving = false,
    this.failure,
    this.availableMethods = const [],
    this.availableAsrConventions = const [],
    this.selectedMethodId,
    this.selectedAsrConventionId,
    this.selectedHighLatStrategy,
  });

  PrayerSettingsState copyWith({
    bool? isLoading,
    bool? isSaving,
    PrayerFailure? Function()? failure,
    List<PrayerCalculationMethod>? availableMethods,
    List<AsrConvention>? availableAsrConventions,
    String? selectedMethodId,
    String? selectedAsrConventionId,
    HighLatitudeStrategy? selectedHighLatStrategy,
  }) {
    return PrayerSettingsState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      failure: failure != null ? failure() : this.failure,
      availableMethods: availableMethods ?? this.availableMethods,
      availableAsrConventions:
          availableAsrConventions ?? this.availableAsrConventions,
      selectedMethodId: selectedMethodId ?? this.selectedMethodId,
      selectedAsrConventionId:
          selectedAsrConventionId ?? this.selectedAsrConventionId,
      selectedHighLatStrategy:
          selectedHighLatStrategy ?? this.selectedHighLatStrategy,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isSaving,
        failure,
        availableMethods,
        availableAsrConventions,
        selectedMethodId,
        selectedAsrConventionId,
        selectedHighLatStrategy,
      ];
}
