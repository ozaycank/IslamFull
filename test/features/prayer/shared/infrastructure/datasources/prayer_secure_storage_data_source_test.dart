import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:islamfull/core/storage/secure_storage_service.dart';
import 'package:islamfull/features/prayer/shared/infrastructure/datasources/prayer_secure_storage_data_source.dart';

class MockSecureStorageService extends Mock implements SecureStorageService {}

void main() {
  late MockSecureStorageService storage;
  late PrayerSecureStorageDataSource dataSource;

  setUp(
    () {
      storage = MockSecureStorageService();

      dataSource = PrayerSecureStorageDataSource(
        storage,
      );
    },
  );

  test(
    'stores double-shadow Asr convention directly',
    () async {
      when(
        () => storage.write(
          key: 'prayer_asr_shadow_rule_v1',
          value: 'double_shadow',
        ),
      ).thenAnswer(
        (_) async {},
      );

      when(
        () => storage.delete(
          key: 'prayer_madhab',
        ),
      ).thenAnswer(
        (_) async {},
      );

      await dataSource.saveSelectedAsrConvention(
        'double_shadow',
      );

      verify(
        () => storage.write(
          key: 'prayer_asr_shadow_rule_v1',
          value: 'double_shadow',
        ),
      ).called(
        1,
      );
    },
  );

  test(
    'stores single-shadow Asr convention directly',
    () async {
      when(
        () => storage.write(
          key: 'prayer_asr_shadow_rule_v1',
          value: 'single_shadow',
        ),
      ).thenAnswer(
        (_) async {},
      );

      when(
        () => storage.delete(
          key: 'prayer_madhab',
        ),
      ).thenAnswer(
        (_) async {},
      );

      await dataSource.saveSelectedAsrConvention(
        'single_shadow',
      );

      verify(
        () => storage.write(
          key: 'prayer_asr_shadow_rule_v1',
          value: 'single_shadow',
        ),
      ).called(
        1,
      );
    },
  );

  test(
    'rejects unsupported Asr convention identifier',
    () async {
      expect(
        () => dataSource.saveSelectedAsrConvention(
          'unsupported',
        ),
        throwsArgumentError,
      );

      verifyNever(
        () => storage.write(
          key: any(
            named: 'key',
          ),
          value: any(
            named: 'value',
          ),
        ),
      );
    },
  );

  test(
    'returns persisted double-shadow convention directly',
    () async {
      when(
        () => storage.read(
          key: 'prayer_asr_shadow_rule_v1',
        ),
      ).thenAnswer(
        (_) async => 'double_shadow',
      );

      final result = await dataSource.getSelectedAsrConventionId();

      expect(
        result,
        'double_shadow',
      );

      verifyNever(
        () => storage.read(
          key: 'prayer_madhab',
        ),
      );
    },
  );

  test(
    'migrates legacy Hanafi storage to double-shadow convention',
    () async {
      when(
        () => storage.read(
          key: 'prayer_asr_shadow_rule_v1',
        ),
      ).thenAnswer(
        (_) async => null,
      );

      when(
        () => storage.read(
          key: 'prayer_madhab',
        ),
      ).thenAnswer(
        (_) async => 'hanafi',
      );

      when(
        () => storage.write(
          key: 'prayer_asr_shadow_rule_v1',
          value: 'double_shadow',
        ),
      ).thenAnswer(
        (_) async {},
      );

      when(
        () => storage.delete(
          key: 'prayer_madhab',
        ),
      ).thenAnswer(
        (_) async {},
      );

      final result = await dataSource.getSelectedAsrConventionId();

      expect(
        result,
        'double_shadow',
      );

      verify(
        () => storage.write(
          key: 'prayer_asr_shadow_rule_v1',
          value: 'double_shadow',
        ),
      ).called(
        1,
      );

      verify(
        () => storage.delete(
          key: 'prayer_madhab',
        ),
      ).called(
        1,
      );
    },
  );

  test(
    'removes invalid convention when no legacy value exists',
    () async {
      when(
        () => storage.read(
          key: 'prayer_asr_shadow_rule_v1',
        ),
      ).thenAnswer(
        (_) async => 'invalid_rule',
      );

      when(
        () => storage.delete(
          key: 'prayer_asr_shadow_rule_v1',
        ),
      ).thenAnswer(
        (_) async {},
      );

      when(
        () => storage.read(
          key: 'prayer_madhab',
        ),
      ).thenAnswer(
        (_) async => null,
      );

      final result = await dataSource.getSelectedAsrConventionId();

      expect(
        result,
        isNull,
      );

      verify(
        () => storage.delete(
          key: 'prayer_asr_shadow_rule_v1',
        ),
      ).called(
        1,
      );
    },
  );
}
