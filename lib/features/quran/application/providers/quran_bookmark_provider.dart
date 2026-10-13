import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/privacy/religious_progress_consent_provider.dart';
import '../../domain/entities/quran_bookmark.dart';
import '../../domain/repositories/quran_bookmark_repository.dart';
import '../states/quran_bookmark_state.dart';

final quranBookmarkNotifierProvider =
    NotifierProvider<QuranBookmarkNotifier, QuranBookmarkState>(
  QuranBookmarkNotifier.new,
);

class QuranBookmarkNotifier extends Notifier<QuranBookmarkState> {
  QuranBookmarkRepository get _repository => getIt<QuranBookmarkRepository>();
  int _operationGeneration = 0;

  @override
  QuranBookmarkState build() {
    // Invalidate in-flight results synchronously on consent changes, even
    // before a watched provider is rebuilt by Riverpod.
    ref.listen(
      religiousProgressConsentProvider.select(
        (consent) => consent.granted,
      ),
      (previous, next) {
        ++_operationGeneration;
      },
    );

    final consentGranted = ref.watch(
      religiousProgressConsentProvider.select(
        (consent) => consent.granted,
      ),
    );

    final generation = ++_operationGeneration;
    Future.microtask(
      () => _loadBookmarks(consentGranted, generation),
    );

    return QuranBookmarkState(isLoading: consentGranted);
  }

  Future<void> loadBookmarks() {
    final consentGranted = ref.read(religiousProgressConsentProvider).granted;
    final generation = ++_operationGeneration;
    state = QuranBookmarkState(isLoading: consentGranted);
    return _loadBookmarks(consentGranted, generation);
  }

  Future<void> _loadBookmarks(bool consentGranted, int generation) async {
    if (generation != _operationGeneration) {
      return;
    }

    if (!consentGranted) {
      state = const QuranBookmarkState(isLoading: false);
      return;
    }

    try {
      final items = List<QuranBookmark>.from(
        await _repository.getBookmarks(),
      )..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      if (generation != _operationGeneration) {
        return;
      }

      state = QuranBookmarkState(isLoading: false, bookmarks: items);
    } catch (e) {
      if (generation != _operationGeneration) {
        return;
      }

      state = QuranBookmarkState(isLoading: false, failure: e.toString());
    }
  }

  Future<void> toggleBookmark({
    required int surahNumber,
    required int ayahNumber,
  }) async {
    final consent = ref.read(religiousProgressConsentProvider);
    if (!consent.granted || consent.isUpdating || state.isLoading) {
      return;
    }

    final generation = ++_operationGeneration;
    final previousBookmarks = List<QuranBookmark>.from(state.bookmarks);
    final updatedBookmarks = List<QuranBookmark>.from(previousBookmarks);

    final existingIndex = updatedBookmarks.indexWhere(
      (bookmark) =>
          bookmark.surahNumber == surahNumber &&
          bookmark.ayahNumber == ayahNumber,
    );

    if (existingIndex != -1) {
      updatedBookmarks.removeAt(existingIndex);
    } else {
      updatedBookmarks.insert(
        0,
        QuranBookmark(
          surahNumber: surahNumber,
          ayahNumber: ayahNumber,
          createdAt: DateTime.now(),
        ),
      );
    }

    state = QuranBookmarkState(
      isLoading: false,
      bookmarks: updatedBookmarks,
    );

    try {
      await _repository.saveBookmarks(updatedBookmarks);
    } catch (e) {
      if (generation != _operationGeneration) {
        return;
      }

      state = QuranBookmarkState(
        isLoading: false,
        bookmarks: previousBookmarks,
        failure: e.toString(),
      );
    }
  }
}
