import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/core/storage/secure_storage_service.dart';
import 'package:noor_life/features/quran/domain/entities/quran_bookmark.dart';
import 'package:noor_life/features/quran/domain/entities/quran_reading_progress.dart';
import 'package:noor_life/features/quran/infrastructure/datasources/quran_bookmark_local_data_source.dart';
import 'package:noor_life/features/quran/infrastructure/datasources/quran_progress_local_data_source.dart';

class _MemorySecureStorage extends SecureStorageService {
  final Map<String, String> data = {};
  Future<void> Function(String key)? afterRead;
  Future<void> Function(String key)? afterWrite;

  @override
  Future<String?> read({required String key}) async {
    final value = data[key];
    await afterRead?.call(key);
    return value;
  }

  @override
  Future<void> write({required String key, required String value}) async {
    data[key] = value;
    await afterWrite?.call(key);
  }

  @override
  Future<void> delete({required String key}) async {
    data.remove(key);
  }
}

void main() {
  late _MemorySecureStorage storage;
  late QuranProgressLocalDataSourceImpl progressSource;
  late QuranBookmarkLocalDataSourceImpl bookmarkSource;

  final progress = QuranReadingProgress(
    surahNumber: 2,
    ayahNumber: 10,
    updatedAt: DateTime.utc(2026, 10, 13),
  );
  final bookmark = QuranBookmark(
    surahNumber: 2,
    ayahNumber: 10,
    createdAt: DateTime.utc(2026, 10, 13),
  );

  setUp(() {
    storage = _MemorySecureStorage();
    progressSource = QuranProgressLocalDataSourceImpl(storage);
    bookmarkSource = QuranBookmarkLocalDataSourceImpl(storage);
  });

  test('without consent Quran reading and bookmarks are not persisted',
      () async {
    await progressSource.saveLastRead(progress);
    await bookmarkSource.saveBookmarks([bookmark]);

    expect(await progressSource.getLastRead(), isNull);
    expect(await bookmarkSource.getBookmarks(), isEmpty);
    expect(
      storage.data.containsKey(SecureStorageService.keyQuranLastRead),
      isFalse,
    );
    expect(
      storage.data.containsKey(SecureStorageService.keyQuranBookmarks),
      isFalse,
    );
  });

  test('consented Quran data uses legacy storage keys and round-trips',
      () async {
    await storage.setReligiousProgressConsent(true);
    await progressSource.saveLastRead(progress);
    await bookmarkSource.saveBookmarks([bookmark]);

    expect(
      storage.data.containsKey(SecureStorageService.keyQuranLastRead),
      isTrue,
    );
    expect(
      storage.data.containsKey(SecureStorageService.keyQuranBookmarks),
      isTrue,
    );
    expect(await progressSource.getLastRead(), progress);
    expect(await bookmarkSource.getBookmarks(), [bookmark]);
  });

  test('pre-consent records stay hidden and withdrawal deletes both keys',
      () async {
    await storage.setReligiousProgressConsent(true);
    await progressSource.saveLastRead(progress);
    await bookmarkSource.saveBookmarks([bookmark]);

    await storage.setReligiousProgressConsent(false);
    expect(await progressSource.getLastRead(), isNull);
    expect(await bookmarkSource.getBookmarks(), isEmpty);

    await storage.clearReligiousProgressData();
    expect(
      storage.data.containsKey(SecureStorageService.keyQuranLastRead),
      isFalse,
    );
    expect(
      storage.data.containsKey(SecureStorageService.keyQuranBookmarks),
      isFalse,
    );

    await storage.setReligiousProgressConsent(true);
    expect(await progressSource.getLastRead(), isNull);
    expect(await bookmarkSource.getBookmarks(), isEmpty);
  });

  test('a consent withdrawal while Quran data is being read hides it',
      () async {
    await storage.setReligiousProgressConsent(true);
    await progressSource.saveLastRead(progress);
    await bookmarkSource.saveBookmarks([bookmark]);

    storage.afterRead = (key) async {
      if (key == SecureStorageService.keyQuranLastRead ||
          key == SecureStorageService.keyQuranBookmarks) {
        storage.data[SecureStorageService.keyReligiousProgressConsent] =
            'false';
      }
    };

    expect(await progressSource.getLastRead(), isNull);
    await storage.setReligiousProgressConsent(true);
    expect(await bookmarkSource.getBookmarks(), isEmpty);
  });

  test('a Quran write finishing after withdrawal is erased', () async {
    await storage.setReligiousProgressConsent(true);
    storage.afterWrite = (key) async {
      if (key == SecureStorageService.keyQuranLastRead ||
          key == SecureStorageService.keyQuranBookmarks) {
        storage.data[SecureStorageService.keyReligiousProgressConsent] =
            'false';
      }
    };

    await progressSource.saveLastRead(progress);
    expect(
      storage.data.containsKey(SecureStorageService.keyQuranLastRead),
      isFalse,
    );

    await storage.setReligiousProgressConsent(true);
    await bookmarkSource.saveBookmarks([bookmark]);
    expect(
      storage.data.containsKey(SecureStorageService.keyQuranBookmarks),
      isFalse,
    );
  });

  test('pending Quran write is removed when consent changes mid-flight',
      () async {
    await storage.setReligiousProgressConsent(true);
    final pendingWrite = Completer<void>();
    storage.afterWrite = (key) async {
      if (key == SecureStorageService.keyQuranBookmarks) {
        await pendingWrite.future;
      }
    };

    final write = bookmarkSource.saveBookmarks([bookmark]);
    await pumpEventQueue();
    await storage.setReligiousProgressConsent(false);
    // Cleanup intentionally waits for the pending write. Start cleanup,
    // release the write, then await both rather than deadlocking the test.
    final cleanup = storage.clearReligiousProgressData();
    pendingWrite.complete();
    await Future.wait<void>([write, cleanup]);

    expect(
      storage.data.containsKey(SecureStorageService.keyQuranBookmarks),
      isFalse,
    );
  });
}
