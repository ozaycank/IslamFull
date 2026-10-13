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
  int _operationVersion = 0;

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
    final operationVersion = ++_operationVersion;

    try {
      final granted = await _storage.getReligiousProgressConsent();

      if (operationVersion != _operationVersion) {
        return;
      }

      if (!granted) {
        // Complete any interrupted withdrawal, and purge pre-consent
        // activity/journey records left by older application versions.
        await _storage.clearReligiousProgressData();
      }

      if (operationVersion != _operationVersion) {
        return;
      }

      state = ReligiousProgressConsentState(
        granted: granted,
      );
    } catch (_) {
      if (operationVersion != _operationVersion) {
        return;
      }

      state = const ReligiousProgressConsentState(
        hasError: true,
      );
    }
  }

  Future<bool> grant() async {
    if (state.isUpdating) {
      return false;
    }

    if (state.granted) {
      return true;
    }

    ++_operationVersion;

    state = const ReligiousProgressConsentState(
      isUpdating: true,
    );

    try {
      // Never revive records from an incomplete deletion or a legacy
      // installation when the user gives fresh consent.
      await _storage.clearReligiousProgressData();
      await _storage.setReligiousProgressConsent(true);

      state = const ReligiousProgressConsentState(
        granted: true,
      );

      return true;
    } catch (_) {
      state = const ReligiousProgressConsentState(
        hasError: true,
      );

      return false;
    }
  }

  Future<bool> withdrawAndDelete() async {
    if (state.isUpdating) {
      return false;
    }

    ++_operationVersion;

    // Disable UI-side processing before the asynchronous storage operation.
    state = const ReligiousProgressConsentState(
      isUpdating: true,
    );

    try {
      await _storage.setReligiousProgressConsent(false);
      await _storage.clearReligiousProgressData();

      state = const ReligiousProgressConsentState();
      return true;
    } catch (_) {
      // Fail closed: do not display or resume local religious progress.
      // A future load/grant retries cleanup before using these records.
      state = const ReligiousProgressConsentState(
        hasError: true,
      );

      return false;
    }
  }
}
