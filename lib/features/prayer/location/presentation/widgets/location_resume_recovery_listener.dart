import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

bool isLocationSettingsRecoveryFailure(String? code) {
  return code == 'locationServiceDisabled' || code == 'permissionDeniedForever';
}

/// Retries location acquisition when the app resumes from the background,
/// but only while a settings-recoverable location failure is still active.
class LocationResumeRecoveryListener extends StatefulWidget {
  final Widget child;
  final bool Function() shouldRetry;
  final Future<void> Function() onRetry;

  const LocationResumeRecoveryListener({
    super.key,
    required this.child,
    required this.shouldRetry,
    required this.onRetry,
  });

  @override
  State<LocationResumeRecoveryListener> createState() =>
      _LocationResumeRecoveryListenerState();
}

class _LocationResumeRecoveryListenerState
    extends State<LocationResumeRecoveryListener> with WidgetsBindingObserver {
  bool _wasBackgrounded = false;
  bool _retryInProgress = false;

  bool get _supportsNativeRecovery {
    return !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      _wasBackgrounded = true;
      return;
    }

    if (!_wasBackgrounded) {
      return;
    }

    _wasBackgrounded = false;

    if (!_supportsNativeRecovery || _retryInProgress) {
      return;
    }

    bool retryRequired;

    try {
      retryRequired = widget.shouldRetry();
    } catch (_) {
      return;
    }

    if (!retryRequired) {
      return;
    }

    unawaited(_retryLocation());
  }

  Future<void> _retryLocation() async {
    if (_retryInProgress) {
      return;
    }

    _retryInProgress = true;

    try {
      await widget.onRetry();
    } catch (_) {
      // The location notifier owns error state. The visible retry action
      // remains available if automatic recovery cannot complete.
    } finally {
      _retryInProgress = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
