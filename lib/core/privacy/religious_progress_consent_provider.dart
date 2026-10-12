import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../di/injection_container.dart';
import '../storage/secure_storage_service.dart';

class ReligiousProgressConsentState {
  final bool isLoading;
  final bool isUpdating;
  final bool granted;
  final bool hasError;

  const ReligiousProgressConsentState({
    this.isLoading = false,
    this.isUpdating = false,
    this.granted = false,
    this.hasError = false,
  });
}

final religiousProgressConsentProvider = NotifierProvider<
    ReligiousProgressConsentNotifier, ReligiousProgressConsentState>(
  ReligiousProgressConsentNotifier.new,
);

class ReligiousProgressConsentNotifier
    extends Notifier<ReligiousProgressConsentState> {
  late final SecureStorageService _storage;

  @override
  ReligiousProgressConsentState build() {
    _storage = getIt<SecureStorageService>();

    Future.microtask(
      load,
    );

    return const ReligiousProgressConsentState(
      isLoading: true,
    );
  }

  Future<void> load() async {
    try {
      final granted = await _storage.getReligiousProgressConsent();

      state = ReligiousProgressConsentState(
        granted: granted,
      );
    } catch (_) {
      state = const ReligiousProgressConsentState(
        hasError: true,
      );
    }
  }

  Future<bool> grant() async {
    state = ReligiousProgressConsentState(
      isUpdating: true,
      granted: state.granted,
    );

    try {
      await _storage.setReligiousProgressConsent(
        true,
      );

      state = const ReligiousProgressConsentState(
        granted: true,
      );

      return true;
    } catch (_) {
      state = ReligiousProgressConsentState(
        granted: state.granted,
        hasError: true,
      );

      return false;
    }
  }

  Future<bool> withdrawAndDelete() async {
    state = ReligiousProgressConsentState(
      isUpdating: true,
      granted: state.granted,
    );

    try {
      // Stop future optional progress processing first.
      await _storage.setReligiousProgressConsent(
        false,
      );

      // Then remove the local progress covered by this preference.
      await _storage.clearReligiousProgressData();

      state = const ReligiousProgressConsentState(
        granted: false,
      );

      return true;
    } catch (_) {
      state = const ReligiousProgressConsentState(
        granted: false,
        hasError: true,
      );

      return false;
    }
  }
}
