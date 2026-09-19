import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../di/injection_container.dart';
import '../storage/secure_storage_service.dart';

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  late final SecureStorageService _storage;

  @override
  ThemeMode build() {
    _storage = getIt<SecureStorageService>();

    Future.microtask(_loadThemeMode);

    return ThemeMode.system;
  }

  Future<void> setThemeMode(
    ThemeMode mode,
  ) async {
    if (state == mode) {
      return;
    }

    final previousMode = state;

    state = mode;

    try {
      await _storage.setThemeModePreference(
        mode.name,
      );
    } catch (_) {
      // Restore the previous value if persistence fails.
      state = previousMode;
      rethrow;
    }
  }

  Future<void> _loadThemeMode() async {
    try {
      final savedValue = await _storage.getThemeModePreference();

      state = _parseThemeMode(
        savedValue,
      );
    } catch (_) {
      state = ThemeMode.system;
    }
  }

  ThemeMode _parseThemeMode(
    String? value,
  ) {
    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }
}
