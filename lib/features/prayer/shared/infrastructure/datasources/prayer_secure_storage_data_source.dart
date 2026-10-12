import 'dart:convert';

import 'package:injectable/injectable.dart';

import '../../../../../core/storage/secure_storage_service.dart';
import '../../../calculation_methods/domain/entities/asr_convention.dart';
import '../../../calculation_methods/domain/entities/prayer_calculation_method.dart';
import '../../../location/domain/entities/prayer_location.dart';
import '../../../location/infrastructure/models/prayer_location_model.dart';
import '../../../prayer_times/domain/calculators/high_latitude_strategy.dart';
import 'prayer_local_data_source.dart';

@LazySingleton(
  as: PrayerLocalDataSource,
)
class PrayerSecureStorageDataSource implements PrayerLocalDataSource {
  static const String _calculationMethodKey = 'prayer_calc_method';

  static const String _asrConventionKey = 'prayer_asr_shadow_rule_v1';

  static const String _legacyMadhabKey = 'prayer_madhab';

  static const String _highLatitudeStrategyKey = 'high_lat_strategy';

  static const String _prayerLocationKey = 'prayer_location';

  final SecureStorageService _storage;

  PrayerSecureStorageDataSource(
    this._storage,
  );

  @override
  Future<List<PrayerCalculationMethod>> getSupportedMethods() async {
    return const [
      PrayerCalculationMethod(
        id: 'diyar_turk',
        name: 'diyar_turk',
        description: 'desc_diyar_turk',
      ),
      PrayerCalculationMethod(
        id: 'mwl',
        name: 'mwl',
        description: 'desc_mwl',
      ),
      PrayerCalculationMethod(
        id: 'isna',
        name: 'isna',
        description: 'desc_isna',
      ),
      PrayerCalculationMethod(
        id: 'egypt',
        name: 'egypt',
        description: 'desc_egypt',
      ),
      PrayerCalculationMethod(
        id: 'makkah',
        name: 'makkah',
        description: 'desc_makkah',
      ),
    ];
  }

  @override
  Future<void> saveSelectedCalculationMethod(
    String methodId,
  ) async {
    await _storage.write(
      key: _calculationMethodKey,
      value: methodId,
    );
  }

  @override
  Future<String?> getSelectedCalculationMethodId() {
    return _storage.read(
      key: _calculationMethodKey,
    );
  }

  @override
  Future<List<AsrConvention>> getSupportedAsrConventions() async {
    return AsrConvention.values;
  }

  @override
  Future<void> saveSelectedAsrConvention(
    String conventionId,
  ) async {
    if (AsrConvention.fromId(
          conventionId,
        ) ==
        null) {
      throw ArgumentError.value(
        conventionId,
        'conventionId',
        'Unsupported Asr calculation convention.',
      );
    }

    await _storage.write(
      key: _asrConventionKey,
      value: conventionId,
    );

    await _storage.delete(
      key: _legacyMadhabKey,
    );
  }

  @override
  Future<String?> getSelectedAsrConventionId() async {
    final persistedConventionId = await _storage.read(
      key: _asrConventionKey,
    );

    if (AsrConvention.fromId(
          persistedConventionId,
        ) !=
        null) {
      return persistedConventionId;
    }

    if (persistedConventionId != null) {
      await _storage.delete(
        key: _asrConventionKey,
      );
    }

    final legacyMadhabId = await _storage.read(
      key: _legacyMadhabKey,
    );

    if (legacyMadhabId == null) {
      return null;
    }

    final migratedConventionId = _legacyMadhabToConventionId(
      legacyMadhabId,
    );

    if (migratedConventionId == null) {
      await _storage.delete(
        key: _legacyMadhabKey,
      );

      return null;
    }

    await _storage.write(
      key: _asrConventionKey,
      value: migratedConventionId,
    );

    await _storage.delete(
      key: _legacyMadhabKey,
    );

    return migratedConventionId;
  }

  @override
  Future<void> saveSelectedHighLatitudeStrategy(
    HighLatitudeStrategy strategy,
  ) async {
    await _storage.write(
      key: _highLatitudeStrategyKey,
      value: strategy.name,
    );
  }

  @override
  Future<HighLatitudeStrategy> getSelectedHighLatitudeStrategy() async {
    final value = await _storage.read(
      key: _highLatitudeStrategyKey,
    );

    switch (value) {
      case 'oneSeventh':
        return HighLatitudeStrategy.oneSeventh;

      case 'nightMiddle':
        return HighLatitudeStrategy.nightMiddle;

      case 'none':
        return HighLatitudeStrategy.none;

      default:
        return HighLatitudeStrategy.angleBased;
    }
  }

  @override
  Future<void> saveSelectedLocation(
    PrayerLocation location,
  ) async {
    final model = PrayerLocationModel(
      latitude: location.latitude,
      longitude: location.longitude,
      cityName: location.cityName,
      countryName: location.countryName,
      timezoneIdentifier: location.timezoneIdentifier,
    );

    await _storage.write(
      key: _prayerLocationKey,
      value: jsonEncode(
        model.toJson(),
      ),
    );
  }

  @override
  Future<PrayerLocation?> getSelectedLocation() async {
    final value = await _storage.read(
      key: _prayerLocationKey,
    );

    if (value == null) {
      return null;
    }

    try {
      final json = jsonDecode(
        value,
      ) as Map<String, dynamic>;

      return PrayerLocationModel.fromJson(
        json,
      );
    } catch (_) {
      return null;
    }
  }

  static String? _legacyMadhabToConventionId(
    String legacyMadhabId,
  ) {
    switch (legacyMadhabId) {
      case 'shafi_hanbali_maliki':
        return AsrConvention.singleShadowId;

      case 'hanafi':
        return AsrConvention.doubleShadowId;

      default:
        return null;
    }
  }
}
