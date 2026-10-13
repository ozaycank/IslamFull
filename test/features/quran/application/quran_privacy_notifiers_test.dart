import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/core/di/injection_container.dart';
import 'package:noor_life/core/privacy/religious_progress_consent_provider.dart';
import 'package:noor_life/features/quran/application/providers/quran_bookmark_provider.dart';
import 'package:noor_life/features/quran/application/providers/quran_progress_provider.dart';
import 'package:noor_life/features/quran/domain/entities/quran_bookmark.dart';
import 'package:noor_life/features/quran/domain/entities/quran_reading_progress.dart';
import 'package:noor_life/features/quran/domain/repositories/quran_bookmark_repository.dart';
import 'package:noor_life/features/quran/domain/repositories/quran_progress_repository.dart';

class _MutableConsentNotifier extends ReligiousProgressConsentNotifier {
  @override
  ReligiousProgressConsentState build() {
    return const ReligiousProgressConsentState();
  }

  void update(bool granted) {
    state = ReligiousProgressConsentState(granted: granted);
  }
}

class _ProgressRepository implements QuranProgressRepository {
  int readCalls = 0;
  int writeCalls = 0;
  QuranReadingProgress? stored;
  Completer<QuranReadingProgress?>? pendingRead;

  @override
  Future<QuranReadingProgress?> getLastRead() async {
    readCalls++;
    if (pendingRead != null) return pendingRead!.future;
    return stored;
  }

  @override
  Future<void> saveLastRead(QuranReadingProgress progress) async {
    writeCalls++;
    stored = progress;
  }

  @override
  Future<void> clearProgress() async {
    stored = null;
  }
}

class _BookmarkRepository implements QuranBookmarkRepository {
  int readCalls = 0;
  int writeCalls = 0;
  List<QuranBookmark> stored = [];
  Completer<List<QuranBookmark>>? pendingRead;

  @override
  Future<List<QuranBookmark>> getBookmarks() async {
    readCalls++;
    if (pendingRead != null) return pendingRead!.future;
    return List<QuranBookmark>.from(stored);
  }

  @override
  Future<void> saveBookmarks(List<QuranBookmark> bookmarks) async {
    writeCalls++;
    stored = List<QuranBookmark>.from(bookmarks);
  }
}

void main() {
  late ProviderContainer container;
  late _ProgressRepository progressRepository;
  late _BookmarkRepository bookmarkRepository;

  _MutableConsentNotifier consentNotifier() =>
      container.read(religiousProgressConsentProvider.notifier)
          as _MutableConsentNotifier;

  setUp(() async {
    await getIt.reset();
    progressRepository = _ProgressRepository();
    bookmarkRepository = _BookmarkRepository();
    getIt.registerSingleton<QuranProgressRepository>(progressRepository);
    getIt.registerSingleton<QuranBookmarkRepository>(bookmarkRepository);
    container = ProviderContainer(
      overrides: [
        religiousProgressConsentProvider.overrideWith(
          _MutableConsentNotifier.new,
        ),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await getIt.reset();
  });

  test('Quran progress never loads or saves without consent', () async {
    container.read(quranProgressNotifierProvider);
    await pumpEventQueue();
    expect(progressRepository.readCalls, 0);

    final progress = QuranReadingProgress(
      surahNumber: 2,
      ayahNumber: 5,
      updatedAt: DateTime.utc(2026, 10, 13),
    );
    await container
        .read(quranProgressNotifierProvider.notifier)
        .saveProgress(progress);
    expect(progressRepository.writeCalls, 0);

    consentNotifier().update(true);
    await pumpEventQueue();
    await container
        .read(quranProgressNotifierProvider.notifier)
        .saveProgress(progress);
    expect(progressRepository.writeCalls, 1);

    consentNotifier().update(false);
    expect(container.read(quranProgressNotifierProvider).lastRead, isNull);
  });

  test('Quran bookmarks never load or save without consent', () async {
    container.read(quranBookmarkNotifierProvider);
    await pumpEventQueue();
    expect(bookmarkRepository.readCalls, 0);

    await container.read(quranBookmarkNotifierProvider.notifier).toggleBookmark(
          surahNumber: 2,
          ayahNumber: 5,
        );
    expect(bookmarkRepository.writeCalls, 0);

    consentNotifier().update(true);
    // A watched notifier rebuilds lazily. Start its consented load first,
    // then wait for it to finish before attempting a bookmark edit.
    container.read(quranBookmarkNotifierProvider);
    await pumpEventQueue();
    expect(container.read(quranBookmarkNotifierProvider).isLoading, isFalse);
    await container.read(quranBookmarkNotifierProvider.notifier).toggleBookmark(
          surahNumber: 2,
          ayahNumber: 5,
        );
    expect(bookmarkRepository.writeCalls, 1);

    consentNotifier().update(false);
    expect(container.read(quranBookmarkNotifierProvider).bookmarks, isEmpty);
  });

  test('late Quran progress read cannot resurface after withdrawal', () async {
    final pending = Completer<QuranReadingProgress?>();
    progressRepository.pendingRead = pending;
    consentNotifier().update(true);
    container.read(quranProgressNotifierProvider);
    await pumpEventQueue();

    consentNotifier().update(false);
    pending.complete(
      QuranReadingProgress(
        surahNumber: 2,
        ayahNumber: 10,
        updatedAt: DateTime.utc(2026, 10, 13),
      ),
    );
    await pumpEventQueue();

    expect(container.read(quranProgressNotifierProvider).lastRead, isNull);
  });

  test('late Quran bookmark read cannot resurface after withdrawal', () async {
    final pending = Completer<List<QuranBookmark>>();
    bookmarkRepository.pendingRead = pending;
    consentNotifier().update(true);
    container.read(quranBookmarkNotifierProvider);
    await pumpEventQueue();

    consentNotifier().update(false);
    pending.complete([
      QuranBookmark(
        surahNumber: 2,
        ayahNumber: 10,
        createdAt: DateTime.utc(2026, 10, 13),
      ),
    ]);
    await pumpEventQueue();

    expect(container.read(quranBookmarkNotifierProvider).bookmarks, isEmpty);
  });
}
