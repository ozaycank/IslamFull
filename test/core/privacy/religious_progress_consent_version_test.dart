import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/core/di/injection_container.dart';
import 'package:noor_life/core/privacy/religious_progress_consent_provider.dart';
import 'package:noor_life/core/storage/secure_storage_service.dart';

class _MemorySecureStorage extends SecureStorageService {
  final Map<String, String> values = <String, String>{};

  @override
  Future<String?> read({
    required String key,
  }) async =>
      values[key];

  @override
  Future<void> write({
    required String key,
    required String value,
  }) async {
    values[key] = value;
  }

  @override
  Future<void> delete({
    required String key,
  }) async {
    values.remove(key);
  }
}

void main() {
  late _MemorySecureStorage storage;

  setUp(
    () async {
      await getIt.reset();
      storage = _MemorySecureStorage();
      getIt.registerSingleton<SecureStorageService>(storage);
    },
  );

  tearDown(
    () async {
      await getIt.reset();
    },
  );

  test(
    'old unversioned true cannot grant the expanded consent scope',
    () async {
      storage.values[SecureStorageService.keyReligiousProgressConsent] = 'true';

      expect(
        await storage.getReligiousProgressConsent(),
        isFalse,
      );
    },
  );

  test(
    'unknown and incomplete consent values fail closed',
    () async {
      const key = SecureStorageService.keyReligiousProgressConsent;

      expect(await storage.getReligiousProgressConsent(), isFalse);

      storage.values[key] = 'granted:religious-progress-v1';
      expect(await storage.getReligiousProgressConsent(), isFalse);

      storage.values[key] = 'granted:religious-progress-v999';
      expect(await storage.getReligiousProgressConsent(), isFalse);

      storage.values[key] = 'false';
      expect(await storage.getReligiousProgressConsent(), isFalse);
    },
  );

  test(
    'grant persists the exact current version; withdrawal denies it',
    () async {
      const key = SecureStorageService.keyReligiousProgressConsent;

      await storage.setReligiousProgressConsent(true);

      expect(
        storage.values[key],
        'granted:${SecureStorageService.currentReligiousProgressConsentVersion}',
      );
      expect(await storage.getReligiousProgressConsent(), isTrue);

      await storage.setReligiousProgressConsent(false);

      expect(storage.values[key], 'false');
      expect(await storage.getReligiousProgressConsent(), isFalse);
    },
  );

  test(
    'legacy consent startup purges all scoped records but not settings',
    () async {
      storage.values.addAll({
        SecureStorageService.keyReligiousProgressConsent: 'true',
        SecureStorageService.keyActivityRecords: 'activity',
        SecureStorageService.keyJourneyReviewedSteps: 'reviewed',
        SecureStorageService.keyJourneyLastVisitedStep: 'visited',
        SecureStorageService.keyQuranLastRead: 'verse',
        SecureStorageService.keyQuranBookmarks: 'bookmarks',
        SecureStorageService.keyThemeMode: 'dark',
      });

      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(religiousProgressConsentProvider);
      await pumpEventQueue();

      final state = container.read(religiousProgressConsentProvider);
      expect(state.isLoading, isFalse);
      expect(state.granted, isFalse);
      expect(state.hasError, isFalse);

      for (final key in [
        SecureStorageService.keyActivityRecords,
        SecureStorageService.keyJourneyReviewedSteps,
        SecureStorageService.keyJourneyLastVisitedStep,
        SecureStorageService.keyQuranLastRead,
        SecureStorageService.keyQuranBookmarks,
      ]) {
        expect(storage.values.containsKey(key), isFalse);
      }

      expect(storage.values[SecureStorageService.keyThemeMode], 'dark');
    },
  );

  test(
    'new explicit consent after migration stores a versioned grant',
    () async {
      storage.values[SecureStorageService.keyReligiousProgressConsent] = 'true';

      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(religiousProgressConsentProvider);
      await pumpEventQueue();

      final notifier = container.read(
        religiousProgressConsentProvider.notifier,
      );

      expect(await notifier.grant(), isTrue);
      expect(container.read(religiousProgressConsentProvider).granted, isTrue);
      expect(await storage.getReligiousProgressConsent(), isTrue);
    },
  );

  test(
    'public policy documents the version and actual local scope',
    () {
      final policy = File('docs/privacy.html').readAsStringSync();

      expect(
        policy,
        contains(SecureStorageService.currentReligiousProgressConsentVersion),
      );
      expect(policy, contains('Quran bookmarks'));
      expect(policy, contains('New Muslim Journey'));
      expect(policy, contains('withdraw'));
      expect(policy, contains('October 13, 2026'));
      expect(
        policy,
        isNot(contains('Geocoding fallback powered by')),
      );
    },
  );
}
