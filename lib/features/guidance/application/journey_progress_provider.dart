import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection_container.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../domain/journey_step_id.dart';

class JourneyProgressState {
  final bool isLoading;
  final Set<JourneyStepId> reviewedSteps;
  final JourneyStepId? lastVisitedStep;

  const JourneyProgressState({
    this.isLoading = true,
    this.reviewedSteps = const {},
    this.lastVisitedStep,
  });

  bool isReviewed(
    JourneyStepId step,
  ) {
    return reviewedSteps.contains(step);
  }

  JourneyStepId get continueStep {
    final lastVisited = lastVisitedStep;

    if (lastVisited != null && !reviewedSteps.contains(lastVisited)) {
      return lastVisited;
    }

    for (final step in JourneyStepId.values) {
      if (!reviewedSteps.contains(step)) {
        return step;
      }
    }

    return lastVisited ?? JourneyStepId.foundations;
  }

  JourneyProgressState copyWith({
    bool? isLoading,
    Set<JourneyStepId>? reviewedSteps,
    JourneyStepId? lastVisitedStep,
    bool clearLastVisitedStep = false,
  }) {
    return JourneyProgressState(
      isLoading: isLoading ?? this.isLoading,
      reviewedSteps: reviewedSteps ?? this.reviewedSteps,
      lastVisitedStep:
          clearLastVisitedStep ? null : lastVisitedStep ?? this.lastVisitedStep,
    );
  }
}

final journeyProgressProvider =
    NotifierProvider<JourneyProgressNotifier, JourneyProgressState>(
  JourneyProgressNotifier.new,
);

class JourneyProgressNotifier extends Notifier<JourneyProgressState> {
  late final SecureStorageService _storage;

  @override
  JourneyProgressState build() {
    _storage = getIt<SecureStorageService>();

    Future.microtask(
      _loadProgress,
    );

    return const JourneyProgressState();
  }

  Future<void> markVisited(
    JourneyStepId step,
  ) async {
    if (state.lastVisitedStep == step) {
      return;
    }

    final previousStep = state.lastVisitedStep;

    state = state.copyWith(
      lastVisitedStep: step,
    );

    try {
      await _storage.setJourneyLastVisitedStep(
        step.name,
      );
    } catch (_) {
      state = state.copyWith(
        lastVisitedStep: previousStep,
        clearLastVisitedStep: previousStep == null,
      );
      rethrow;
    }
  }

  Future<void> setReviewed(
    JourneyStepId step,
    bool reviewed,
  ) async {
    final previousSteps = Set<JourneyStepId>.from(
      state.reviewedSteps,
    );

    final updatedSteps = Set<JourneyStepId>.from(
      previousSteps,
    );

    if (reviewed) {
      updatedSteps.add(step);
    } else {
      updatedSteps.remove(step);
    }

    if (updatedSteps.length == previousSteps.length) {
      final wasReviewed = previousSteps.contains(step);

      if (wasReviewed == reviewed) {
        return;
      }
    }

    state = state.copyWith(
      reviewedSteps: Set.unmodifiable(updatedSteps),
    );

    try {
      await _persistReviewedSteps(
        updatedSteps,
      );
    } catch (_) {
      state = state.copyWith(
        reviewedSteps: Set.unmodifiable(previousSteps),
      );
      rethrow;
    }
  }

  Future<void> _loadProgress() async {
    try {
      final reviewedRaw = await _storage.getJourneyReviewedSteps();

      final lastVisitedRaw = await _storage.getJourneyLastVisitedStep();

      final reviewedSteps = _decodeReviewedSteps(
        reviewedRaw,
      );

      final lastVisitedStep = _decodeStep(
        lastVisitedRaw,
      );

      state = JourneyProgressState(
        isLoading: false,
        reviewedSteps: Set.unmodifiable(reviewedSteps),
        lastVisitedStep: lastVisitedStep,
      );
    } catch (_) {
      state = const JourneyProgressState(
        isLoading: false,
      );
    }
  }

  Set<JourneyStepId> _decodeReviewedSteps(
    String? rawValue,
  ) {
    if (rawValue == null || rawValue.isEmpty) {
      return {};
    }

    final decoded = jsonDecode(rawValue);

    if (decoded is! List) {
      return {};
    }

    final result = <JourneyStepId>{};

    for (final value in decoded) {
      if (value is! String) {
        continue;
      }

      final step = _decodeStep(value);

      if (step != null) {
        result.add(step);
      }
    }

    return result;
  }

  JourneyStepId? _decodeStep(
    String? value,
  ) {
    if (value == null) {
      return null;
    }

    for (final step in JourneyStepId.values) {
      if (step.name == value) {
        return step;
      }
    }

    return null;
  }

  Future<void> _persistReviewedSteps(
    Set<JourneyStepId> steps,
  ) async {
    final stableOrder = JourneyStepId.values
        .where(steps.contains)
        .map((step) => step.name)
        .toList(growable: false);

    await _storage.setJourneyReviewedSteps(
      jsonEncode(stableOrder),
    );
  }
}
