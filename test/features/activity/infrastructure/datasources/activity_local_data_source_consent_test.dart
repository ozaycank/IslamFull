import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/core/storage/secure_storage_service.dart';
import 'package:noor_life/features/activity/infrastructure/datasources/activity_local_data_source.dart';

class _MemorySecureStorage extends SecureStorageService {
  final Map<String, String> data = {};
  Future<void> Function(String key)? afterWrite;
  Future<void> Function(String key)? afterRead;

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
  late ActivityLocalDataSourceImpl source;

  setUp(() {
    storage = _MemorySecureStorage();
    source = ActivityLocalDataSourceImpl(storage);
  });

  test('without consent, activity records cannot be loaded or saved', () async {
    storage.data[SecureStorageService.keyActivityRecords] =
        jsonEncode({'legacy': true});

    expect(await source.loadAllRecords(), isEmpty);
    await source.saveAllRecords({'today': true});
    expect(
      storage.data[SecureStorageService.keyActivityRecords],
      jsonEncode({'legacy': true}),
    );
  });

  test('a read that finishes after withdrawal is ignored', () async {
    await storage.setReligiousProgressConsent(true);
    storage.data[SecureStorageService.keyActivityRecords] =
        jsonEncode({'previous': true});
    storage.afterRead = (key) async {
      if (key == SecureStorageService.keyActivityRecords) {
        storage.data[SecureStorageService.keyReligiousProgressConsent] =
            'false';
      }
    };

    expect(await source.loadAllRecords(), isEmpty);
  });

  test('a write that completes after withdrawal is removed', () async {
    await storage.setReligiousProgressConsent(true);
    storage.afterWrite = (key) async {
      if (key == SecureStorageService.keyActivityRecords) {
        storage.data[SecureStorageService.keyReligiousProgressConsent] =
            'false';
      }
    };

    await source.saveAllRecords({'today': true});
    expect(
      storage.data.containsKey(SecureStorageService.keyActivityRecords),
      isFalse,
    );
  });

  test('journey progress writes are also guarded by consent', () async {
    await storage.setJourneyReviewedSteps('["foundations"]');
    expect(
        storage.data.containsKey(SecureStorageService.keyJourneyReviewedSteps),
        isFalse,);

    await storage.setReligiousProgressConsent(true);
    await storage.setJourneyReviewedSteps('["foundations"]');
    expect(storage.data[SecureStorageService.keyJourneyReviewedSteps],
        '["foundations"]',);

    storage.afterWrite = (key) async {
      if (key == SecureStorageService.keyJourneyLastVisitedStep) {
        storage.data[SecureStorageService.keyReligiousProgressConsent] =
            'false';
      }
    };
    await storage.setJourneyLastVisitedStep('wudu');
    expect(
        storage.data
            .containsKey(SecureStorageService.keyJourneyLastVisitedStep),
        isFalse,);
  });
}
