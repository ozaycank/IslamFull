import 'package:flutter/material.dart';

import '../logging/logger_service.dart';

class AppNavigationObserver extends NavigatorObserver {
  final LoggerService _logger;

  AppNavigationObserver(this._logger);

  @override
  void didPush(
    Route<dynamic> route,
    Route<dynamic>? previousRoute,
  ) {
    super.didPush(route, previousRoute);

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
    super.didPop(route, previousRoute);

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

    // Route arguments may contain user or application data and should not be
    // treated as a route identifier or written to navigation logs.
    return route.runtimeType.toString();
  }
}
