import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/privacy/religious_progress_consent_provider.dart';
import '../../domain/entities/quran_reading_progress.dart';
import '../../domain/errors/quran_failure.dart';
import '../../domain/repositories/quran_progress_repository.dart';
import '../states/quran_progress_state.dart';

final quranProgressNotifierProvider =
    NotifierProvider<QuranProgressNotifier, QuranProgressState>(
  QuranProgressNotifier.new,
);

class QuranProgressNotifier extends Notifier<QuranProgressState> {
  QuranProgressRepository get _repository => getIt<QuranProgressRepository>();
  int _operationGeneration = 0;

  @override
  QuranProgressState build() {
    final consentGranted = ref.watch(
      religiousProgressConsentProvider.select(
        (consent) => consent.granted,
      ),
    );

    final generation = ++_operationGeneration;
    Future.microtask(
      () => _loadProgress(consentGranted, generation),
    );

    // Never expose progress loaded under a previous consent state.
    return QuranProgressState(isLoading: consentGranted);
  }

  Future<void> loadProgress() {
    final consentGranted = ref.read(religiousProgressConsentProvider).granted;
    final generation = ++_operationGeneration;
    state = QuranProgressState(isLoading: consentGranted);
    return _loadProgress(consentGranted, generation);
  }

  Future<void> _loadProgress(bool consentGranted, int generation) async {
    if (generation != _operationGeneration) {
      return;
    }

    if (!consentGranted) {
      state = const QuranProgressState(isLoading: false);
      return;
    }

    try {
      final progress = await _repository.getLastRead();
      if (generation != _operationGeneration ||
          !ref.read(religiousProgressConsentProvider).granted) {
        return;
      }

      state = QuranProgressState(isLoading: false, lastRead: progress);
    } catch (e) {
      if (generation != _operationGeneration ||
          !ref.read(religiousProgressConsentProvider).granted) {
        return;
      }

      state = QuranProgressState(
        isLoading: false,
        failure: QuranFailure(
          'Failed to load progress: $e',
          code: 'readFailed',
        ),
      );
    }
  }

  Future<void> saveProgress(QuranReadingProgress progress) async {
    final consent = ref.read(religiousProgressConsentProvider);
    if (!consent.granted || consent.isUpdating) {
      return;
    }

    final generation = ++_operationGeneration;
    final previousProgress = state.lastRead;
    state = QuranProgressState(isLoading: false, lastRead: progress);

    try {
      await _repository.saveLastRead(progress);
    } catch (e) {
      if (generation != _operationGeneration ||
          !ref.read(religiousProgressConsentProvider).granted) {
        return;
      }

      state = QuranProgressState(
        isLoading: false,
        lastRead: previousProgress,
        failure: QuranFailure(
          'Failed to save progress: $e',
          code: 'writeFailed',
        ),
      );
    }
  }

  Future<void> clearProgress() async {
    final generation = ++_operationGeneration;
    state = const QuranProgressState(isLoading: false);

    try {
      await _repository.clearProgress();
    } catch (e) {
      if (generation != _operationGeneration ||
          !ref.read(religiousProgressConsentProvider).granted) {
        return;
      }

      state = QuranProgressState(
        isLoading: false,
        failure: QuranFailure(
          'Failed to clear progress: $e',
          code: 'clearFailed',
        ),
      );
    }
  }
}
