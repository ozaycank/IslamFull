import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:noor_life/core/storage/secure_storage_service.dart';
import 'package:noor_life/features/activity/infrastructure/datasources/activity_local_data_source.dart';

class MockSecureStorageService extends Mock implements SecureStorageService {}

void main() {
  late MockSecureStorageService storage;
  late ActivityLocalDataSourceImpl dataSource;

  setUp(() {
    storage = MockSecureStorageService();

    dataSource = ActivityLocalDataSourceImpl(
      storage,
    );
  });

  test(
    'returns empty map when no activity data is stored',
    () async {
      when(
        () => storage.read(
          key: 'noorlife_activity_records_v2',
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
          key: 'noorlife_activity_records_v2',
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
          key: 'noorlife_activity_records_v2',
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
    'encodes activity records through shared secure storage',
    () async {
      final records = <String, dynamic>{
        '2026-10-09': {
          'quran': true,
        },
      };

      when(
        () => storage.write(
          key: 'noorlife_activity_records_v2',
          value: any(
            named: 'value',
          ),
        ),
      ).thenAnswer(
        (_) async {},
      );

      await dataSource.saveAllRecords(
        records,
      );

      final verification = verify(
        () => storage.write(
          key: 'noorlife_activity_records_v2',
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
