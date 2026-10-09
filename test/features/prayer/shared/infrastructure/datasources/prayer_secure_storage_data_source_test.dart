import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:noor_life/core/storage/secure_storage_service.dart';
import 'package:noor_life/features/prayer/shared/infrastructure/datasources/prayer_secure_storage_data_source.dart';

class MockSecureStorageService extends Mock implements SecureStorageService {}

void main() {
  late MockSecureStorageService storage;
  late PrayerSecureStorageDataSource dataSource;

  setUp(() {
    storage = MockSecureStorageService();

    dataSource = PrayerSecureStorageDataSource(
      storage,
    );
  });

  test(
    'stores Hanafi selection as a technical double-shadow rule',
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

      await dataSource.saveSelectedMadhab(
        'hanafi',
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
    'stores standard selection as a technical single-shadow rule',
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

      await dataSource.saveSelectedMadhab(
        'shafi_hanbali_maliki',
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
    'rejects unsupported madhab identifier',
    () async {
      expect(
        () => dataSource.saveSelectedMadhab(
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
    'maps persisted double-shadow rule back to Hanafi domain id',
    () async {
      when(
        () => storage.read(
          key: 'prayer_asr_shadow_rule_v1',
        ),
      ).thenAnswer(
        (_) async => 'double_shadow',
      );

      final result = await dataSource.getSelectedMadhabId();

      expect(
        result,
        'hanafi',
      );

      verifyNever(
        () => storage.read(
          key: 'prayer_madhab',
        ),
      );
    },
  );

  test(
    'migrates legacy madhab storage into technical Asr rule',
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

      final result = await dataSource.getSelectedMadhabId();

      expect(
        result,
        'hanafi',
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
    'removes an invalid technical rule when no legacy value exists',
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

      final result = await dataSource.getSelectedMadhabId();

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
