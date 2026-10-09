import 'dart:convert';

import 'package:injectable/injectable.dart';

import '../../../../core/storage/secure_storage_service.dart';

abstract class ActivityLocalDataSource {
  Future<Map<String, dynamic>> loadAllRecords();

  Future<void> saveAllRecords(
    Map<String, dynamic> records,
  );
}

@LazySingleton(
  as: ActivityLocalDataSource,
)
class ActivityLocalDataSourceImpl implements ActivityLocalDataSource {
  static const String _storageKey = 'noorlife_activity_records_v2';

  final SecureStorageService _storage;

  ActivityLocalDataSourceImpl(
    this._storage,
  );

  @override
  Future<Map<String, dynamic>> loadAllRecords() async {
    final data = await _storage.read(
      key: _storageKey,
    );

    if (data == null || data.isEmpty) {
      return {};
    }

    final decoded = json.decode(
      data,
    );

    if (decoded is! Map<String, dynamic>) {
      throw const FormatException(
        'Invalid activity storage format.',
      );
    }

    return Map<String, dynamic>.from(
      decoded,
    );
  }

  @override
  Future<void> saveAllRecords(
    Map<String, dynamic> records,
  ) async {
    final encoded = json.encode(
      records,
    );

    await _storage.write(
      key: _storageKey,
      value: encoded,
    );
  }
}
