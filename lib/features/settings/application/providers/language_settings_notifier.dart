import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../services/app_locale_policy.dart';

class LanguageState {
  final Locale locale;

  const LanguageState(
    this.locale,
  );
}

final languageSettingsNotifierProvider =
    NotifierProvider<LanguageSettingsNotifier, LanguageState>(
  LanguageSettingsNotifier.new,
);

class LanguageSettingsNotifier extends Notifier<LanguageState> {
  static const String _languageKey = 'app_language_preference';

  late final SecureStorageService _storage;

  // A saved preference must not overwrite a newer manual selection
  // if the secure-storage read finishes after the user changes language.
  bool _changedLocally = false;

  @override
  LanguageState build() {
    _storage = getIt<SecureStorageService>();

    final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;

    final initialLocale = AppLocalePolicy.fromDeviceLocale(
      deviceLocale,
    );

    unawaited(
      _loadLanguage(),
    );

    return LanguageState(
      initialLocale,
    );
  }

  Future<void> _loadLanguage() async {
    try {
      final savedCode = await _storage.read(
        key: _languageKey,
      );

      if (_changedLocally) {
        return;
      }

      final savedLocale = AppLocalePolicy.fromSavedCode(
        savedCode,
      );

      if (savedLocale != null) {
        state = LanguageState(
          savedLocale,
        );
      }
    } catch (_) {
      // Keep the device-based language when secure storage is
      // unavailable or no valid manual preference is stored.
    }
  }

  Future<void> setLocale(
    Locale newLocale,
  ) async {
    final selectedLocale = AppLocalePolicy.validateSelection(
      newLocale,
    );

    // Persist even if this equals the currently displayed language:
    // an explicit user choice must override future device defaults.
    _changedLocally = true;

    if (state.locale != selectedLocale) {
      state = LanguageState(
        selectedLocale,
      );
    }

    try {
      await _storage.write(
        key: _languageKey,
        value: selectedLocale.languageCode,
      );
    } catch (_) {
      // The selected language remains active for this session.
      // A subsequent launch will use the last persisted preference
      // or the device language if persistence was unsuccessful.
    }
  }
}
