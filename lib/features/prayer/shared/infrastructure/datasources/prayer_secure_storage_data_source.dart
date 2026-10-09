import 'dart:convert';

import 'package:injectable/injectable.dart';

import '../../../../../core/storage/secure_storage_service.dart';
import '../../../calculation_methods/domain/entities/madhab.dart';
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

  static const String _asrShadowRuleKey = 'prayer_asr_shadow_rule_v1';

  static const String _legacyMadhabKey = 'prayer_madhab';

  static const String _highLatitudeStrategyKey = 'high_lat_strategy';

  static const String _prayerLocationKey = 'prayer_location';

  static const String _standardMadhabId = 'shafi_hanbali_maliki';

  static const String _hanafiMadhabId = 'hanafi';

  static const String _singleShadowRule = 'single_shadow';

  static const String _doubleShadowRule = 'double_shadow';

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
  Future<List<Madhab>> getSupportedMadhabs() async {
    return const [
      Madhab(
        id: _standardMadhabId,
        name: _standardMadhabId,
      ),
      Madhab(
        id: _hanafiMadhabId,
        name: _hanafiMadhabId,
      ),
    ];
  }

  @override
  Future<void> saveSelectedMadhab(
    String madhabId,
  ) async {
    final asrRule = _asrRuleForMadhabId(
      madhabId,
    );

    if (asrRule == null) {
      throw ArgumentError.value(
        madhabId,
        'madhabId',
        'Unsupported Asr calculation convention.',
      );
    }

    await _storage.write(
      key: _asrShadowRuleKey,
      value: asrRule,
    );

    await _storage.delete(
      key: _legacyMadhabKey,
    );
  }

  @override
  Future<String?> getSelectedMadhabId() async {
    final persistedRule = await _storage.read(
      key: _asrShadowRuleKey,
    );

    final persistedMadhabId = _madhabIdForAsrRule(
      persistedRule,
    );

    if (persistedMadhabId != null) {
      return persistedMadhabId;
    }

    if (persistedRule != null) {
      await _storage.delete(
        key: _asrShadowRuleKey,
      );
    }

    final legacyMadhabId = await _storage.read(
      key: _legacyMadhabKey,
    );

    if (legacyMadhabId == null) {
      return null;
    }

    final migratedRule = _asrRuleForMadhabId(
      legacyMadhabId,
    );

    if (migratedRule == null) {
      await _storage.delete(
        key: _legacyMadhabKey,
      );

      return null;
    }

    await _storage.write(
      key: _asrShadowRuleKey,
      value: migratedRule,
    );

    await _storage.delete(
      key: _legacyMadhabKey,
    );

    return _madhabIdForAsrRule(
      migratedRule,
    );
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

  static String? _asrRuleForMadhabId(
    String madhabId,
  ) {
    switch (madhabId) {
      case _standardMadhabId:
        return _singleShadowRule;

      case _hanafiMadhabId:
        return _doubleShadowRule;

      default:
        return null;
    }
  }

  static String? _madhabIdForAsrRule(
    String? asrRule,
  ) {
    switch (asrRule) {
      case _singleShadowRule:
        return _standardMadhabId;

      case _doubleShadowRule:
        return _hanafiMadhabId;

      default:
        return null;
    }
  }
}
