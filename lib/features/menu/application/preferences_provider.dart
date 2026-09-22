import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection_container.dart';
import '../../../core/storage/secure_storage_service.dart';

class PreferencesState {
  final bool hapticFeedbackEnabled;
  final bool showDailyVerseOnHome;

  const PreferencesState({
    this.hapticFeedbackEnabled = true,
    this.showDailyVerseOnHome = true,
  });

  PreferencesState copyWith({
    bool? hapticFeedbackEnabled,
    bool? showDailyVerseOnHome,
  }) {
    return PreferencesState(
      hapticFeedbackEnabled:
          hapticFeedbackEnabled ?? this.hapticFeedbackEnabled,
      showDailyVerseOnHome: showDailyVerseOnHome ?? this.showDailyVerseOnHome,
    );
  }
}

final preferencesProvider =
    NotifierProvider<PreferencesNotifier, PreferencesState>(
  PreferencesNotifier.new,
);

final hapticFeedbackProvider = Provider<bool>((ref) {
  return ref.watch(
    preferencesProvider.select(
      (state) => state.hapticFeedbackEnabled,
    ),
  );
});

final showDailyVerseSettingProvider = Provider<bool>((ref) {
  return ref.watch(
    preferencesProvider.select(
      (state) => state.showDailyVerseOnHome,
    ),
  );
});

class PreferencesNotifier extends Notifier<PreferencesState> {
  late final SecureStorageService _storage;

  bool _hapticChangedLocally = false;
  bool _dailyVerseChangedLocally = false;

  @override
  PreferencesState build() {
    _storage = getIt<SecureStorageService>();

    Future.microtask(
      _loadPreferences,
    );

    return const PreferencesState();
  }

  Future<void> setHapticFeedbackEnabled(
    bool enabled,
  ) async {
    if (state.hapticFeedbackEnabled == enabled) {
      return;
    }

    final previousValue = state.hapticFeedbackEnabled;

    _hapticChangedLocally = true;

    state = state.copyWith(
      hapticFeedbackEnabled: enabled,
    );

    try {
      await _storage.setHapticFeedbackEnabled(
        enabled,
      );
    } catch (_) {
      state = state.copyWith(
        hapticFeedbackEnabled: previousValue,
      );
      rethrow;
    }
  }

  Future<void> setShowDailyVerseOnHome(
    bool enabled,
  ) async {
    if (state.showDailyVerseOnHome == enabled) {
      return;
    }

    final previousValue = state.showDailyVerseOnHome;

    _dailyVerseChangedLocally = true;

    state = state.copyWith(
      showDailyVerseOnHome: enabled,
    );

    try {
      await _storage.setShowDailyVerseOnHome(
        enabled,
      );
    } catch (_) {
      state = state.copyWith(
        showDailyVerseOnHome: previousValue,
      );
      rethrow;
    }
  }

  Future<void> _loadPreferences() async {
    try {
      final results = await Future.wait<bool>([
        _storage.getHapticFeedbackEnabled(),
        _storage.getShowDailyVerseOnHome(),
      ]);

      state = state.copyWith(
        hapticFeedbackEnabled:
            _hapticChangedLocally ? state.hapticFeedbackEnabled : results[0],
        showDailyVerseOnHome:
            _dailyVerseChangedLocally ? state.showDailyVerseOnHome : results[1],
      );
    } catch (_) {
      // Defaults remain available if preference persistence
      // cannot be read during application startup.
    }
  }
}
