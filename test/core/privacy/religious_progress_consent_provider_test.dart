import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:islamfull/core/di/injection_container.dart';
import 'package:islamfull/core/privacy/religious_progress_consent_provider.dart';
import 'package:islamfull/core/storage/secure_storage_service.dart';

class _FakeSecureStorage extends SecureStorageService {
  bool consent = false;
  bool failClear = false;
  int clearCalls = 0;
  Completer<bool>? pendingConsentRead;

  @override
  Future<bool> getReligiousProgressConsent() async {
    final pending = pendingConsentRead;
    if (pending != null) {
      pendingConsentRead = null;
      return pending.future;
    }
    return consent;
  }

  @override
  Future<void> setReligiousProgressConsent(bool value) async {
    consent = value;
  }

  @override
  Future<void> clearReligiousProgressData() async {
    clearCalls++;
    if (failClear) {
      throw StateError('Test deletion failure');
    }
  }
}

void main() {
  late _FakeSecureStorage storage;
  late ProviderContainer container;

  setUp(() async {
    await getIt.reset();
    storage = _FakeSecureStorage();
    getIt.registerSingleton<SecureStorageService>(storage);
    container = ProviderContainer();
  });

  tearDown(() async {
    container.dispose();
    await getIt.reset();
  });

  test('fresh installation is denied and clears legacy records', () async {
    container.read(religiousProgressConsentProvider);
    await pumpEventQueue();

    final state = container.read(religiousProgressConsentProvider);
    expect(state.isLoading, isFalse);
    expect(state.granted, isFalse);
    expect(storage.clearCalls, 1);
  });

  test('failed withdrawal cannot re-enable undeleted progress', () async {
    container.read(religiousProgressConsentProvider);
    await pumpEventQueue();

    final notifier = container.read(
      religiousProgressConsentProvider.notifier,
    );
    expect(await notifier.grant(), isTrue);
    expect(storage.consent, isTrue);

    storage.failClear = true;
    expect(await notifier.withdrawAndDelete(), isFalse);
    expect(storage.consent, isFalse);
    expect(container.read(religiousProgressConsentProvider).granted, isFalse);

    expect(await notifier.grant(), isFalse);
    expect(storage.consent, isFalse);

    storage.failClear = false;
    expect(await notifier.grant(), isTrue);
    expect(storage.consent, isTrue);
  });

  test('late initial load cannot overwrite a newer grant', () async {
    final pendingLoad = Completer<bool>();
    storage.pendingConsentRead = pendingLoad;

    container.read(religiousProgressConsentProvider);
    await pumpEventQueue();

    final notifier = container.read(
      religiousProgressConsentProvider.notifier,
    );
    expect(await notifier.grant(), isTrue);

    pendingLoad.complete(false);
    await pumpEventQueue();

    expect(container.read(religiousProgressConsentProvider).granted, isTrue);
  });
}
