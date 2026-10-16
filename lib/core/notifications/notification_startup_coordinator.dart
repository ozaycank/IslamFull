class NotificationStartupCoordinator {
  final Future<void> Function() initialize;
  final String? Function() takeInitialPayload;
  final void Function(String) handleInitialPayload;

  Future<void>? _startupFuture;
  bool _disposed = false;

  NotificationStartupCoordinator({
    required this.initialize,
    required this.takeInitialPayload,
    required this.handleInitialPayload,
  });

  Future<void> start() {
    return _startupFuture ??= _start();
  }

  Future<void> _start() async {
    await initialize();

    if (_disposed) {
      return;
    }

    final payload = takeInitialPayload();

    if (_disposed || payload == null || payload.trim().isEmpty) {
      return;
    }

    handleInitialPayload(payload);
  }

  void dispose() {
    _disposed = true;
  }
}
