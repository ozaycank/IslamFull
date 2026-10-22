import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:islamfull/core/storage/secure_storage_service.dart';
import 'package:islamfull/features/activity/infrastructure/datasources/activity_local_data_source.dart';

class MockSecureStorageService extends Mock implements SecureStorageService {}

void main() {
  late MockSecureStorageService storage;
  late ActivityLocalDataSourceImpl dataSource;

  setUp(() {
    storage = MockSecureStorageService();

    dataSource = ActivityLocalDataSourceImpl(
      storage,
    );

    when(
      () => storage.getReligiousProgressConsent(),
    ).thenAnswer(
      (_) async => true,
    );

    when(
      () => storage.writeReligiousProgressData(
        key: SecureStorageService.keyActivityRecords,
        value: any(named: 'value'),
      ),
    ).thenAnswer((_) async {});
  });

  test(
    'returns empty map without reading activity data when consent is not granted',
    () async {
      when(
        () => storage.getReligiousProgressConsent(),
      ).thenAnswer(
        (_) async => false,
      );

      final result = await dataSource.loadAllRecords();

      expect(
        result,
        isEmpty,
      );

      verifyNever(
        () => storage.read(
          key: SecureStorageService.keyActivityRecords,
        ),
      );
    },
  );

  test(
    'returns empty map when no activity data is stored',
    () async {
      when(
        () => storage.read(
          key: SecureStorageService.keyActivityRecords,
        ),
      ).thenAnswer(
        (_) async => null,
      );

      final result = await dataSource.loadAllRecords();

      expect(
        result,
        isEmpty,
      );
    },
  );

  test(
    'decodes persisted activity records',
    () async {
      const encoded = '{"2026-10-09":{"quran":true}}';

      when(
        () => storage.read(
          key: SecureStorageService.keyActivityRecords,
        ),
      ).thenAnswer(
        (_) async => encoded,
      );

      final result = await dataSource.loadAllRecords();

      expect(
        result,
        {
          '2026-10-09': {
            'quran': true,
          },
        },
      );
    },
  );

  test(
    'rejects persisted activity payload that is not a map',
    () async {
      when(
        () => storage.read(
          key: SecureStorageService.keyActivityRecords,
        ),
      ).thenAnswer(
        (_) async => '[]',
      );

      expect(
        dataSource.loadAllRecords(),
        throwsA(
          isA<FormatException>(),
        ),
      );
    },
  );

  test(
    'routes activity writes through consent-guarded secure storage',
    () async {
      await dataSource.saveAllRecords(
        {
          '2026-10-09': {
            'quran': true,
          },
        },
      );

      verify(
        () => storage.writeReligiousProgressData(
          key: SecureStorageService.keyActivityRecords,
          value: any(named: 'value'),
        ),
      ).called(1);

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
    'encodes activity records through shared secure storage when consent is granted',
    () async {
      final records = <String, dynamic>{
        '2026-10-09': {
          'quran': true,
        },
      };

      await dataSource.saveAllRecords(
        records,
      );

      final verification = verify(
        () => storage.writeReligiousProgressData(
          key: SecureStorageService.keyActivityRecords,
          value: captureAny(
            named: 'value',
          ),
        ),
      );

      verification.called(
        1,
      );

      final encoded = verification.captured.single as String;

      expect(
        jsonDecode(
          encoded,
        ),
        records,
      );
    },
  );
}
