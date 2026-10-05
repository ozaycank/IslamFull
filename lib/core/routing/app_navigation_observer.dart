import 'package:flutter/material.dart';

import '../logging/logger_service.dart';

class AppNavigationObserver extends NavigatorObserver {
  final LoggerService _logger;

  AppNavigationObserver(
    this._logger,
  );

  @override
  void didPush(
    Route<dynamic> route,
    Route<dynamic>? previousRoute,
  ) {
    super.didPush(
      route,
      previousRoute,
    );

    _logger.debug(
      '[NAVIGATION PUSH] '
      '${_describeRoute(previousRoute)} -> ${_describeRoute(route)}',
    );
  }

  @override
  void didPop(
    Route<dynamic> route,
    Route<dynamic>? previousRoute,
  ) {
    super.didPop(
      route,
      previousRoute,
    );

    _logger.debug(
      '[NAVIGATION POP] '
      '${_describeRoute(route)} -> ${_describeRoute(previousRoute)}',
    );
  }

  @override
  void didReplace({
    Route<dynamic>? newRoute,
    Route<dynamic>? oldRoute,
  }) {
    super.didReplace(
      newRoute: newRoute,
      oldRoute: oldRoute,
    );

    _logger.debug(
      '[NAVIGATION REPLACE] '
      '${_describeRoute(oldRoute)} -> ${_describeRoute(newRoute)}',
    );
  }

  @override
  void didRemove(
    Route<dynamic> route,
    Route<dynamic>? previousRoute,
  ) {
    super.didRemove(
      route,
      previousRoute,
    );

    _logger.debug(
      '[NAVIGATION REMOVE] '
      '${_describeRoute(route)} -> ${_describeRoute(previousRoute)}',
    );
  }

  String _describeRoute(
    Route<dynamic>? route,
  ) {
    if (route == null) {
      return 'none';
    }

    final routeName = route.settings.name?.trim();

    if (routeName != null && routeName.isNotEmpty) {
      return routeName;
    }

    // Never log route arguments. They may contain user/application data.
    //
    // Popup routes include dialogs and modal bottom sheets. Everything else
    // without a stable route name is deliberately represented generically
    // instead of logging Flutter's private implementation class names.
    if (route is PopupRoute<dynamic>) {
      return 'modal';
    }

    return 'unnamed';
  }
}
