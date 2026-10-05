import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/core/logging/logger_service.dart';
import 'package:noor_life/core/routing/app_navigation_observer.dart';

class FakeLoggerService extends LoggerService {
  final List<String> messages = [];

  @override
  void debug(
    dynamic message,
  ) {
    messages.add(
      message.toString(),
    );
  }
}

void main() {
  test(
    'logs named route transitions clearly',
    () {
      final logger = FakeLoggerService();

      final observer = AppNavigationObserver(
        logger,
      );

      final route = MaterialPageRoute<void>(
        settings: const RouteSettings(
          name: '/settings',
        ),
        builder: (_) => const SizedBox.shrink(),
      );

      observer.didPush(
        route,
        null,
      );

      expect(
        logger.messages.single,
        '[NAVIGATION PUSH] none -> /settings',
      );
    },
  );

  test(
    'does not use route arguments as route identifier',
    () {
      final logger = FakeLoggerService();

      final observer = AppNavigationObserver(
        logger,
      );

      final route = MaterialPageRoute<void>(
        settings: const RouteSettings(
          arguments: {
            'token': 'secret-value',
          },
        ),
        builder: (_) => const SizedBox.shrink(),
      );

      observer.didPush(
        route,
        null,
      );

      expect(
        logger.messages.single,
        '[NAVIGATION PUSH] none -> unnamed',
      );

      expect(
        logger.messages.single,
        isNot(
          contains(
            'secret-value',
          ),
        ),
      );

      expect(
        logger.messages.single,
        isNot(
          contains(
            'MaterialPageRoute',
          ),
        ),
      );
    },
  );

  test(
    'pop log shows route being left and revealed route',
    () {
      final logger = FakeLoggerService();

      final observer = AppNavigationObserver(
        logger,
      );

      final previous = MaterialPageRoute<void>(
        settings: const RouteSettings(
          name: '/menu',
        ),
        builder: (_) => const SizedBox.shrink(),
      );

      final current = MaterialPageRoute<void>(
        settings: const RouteSettings(
          name: '/settings',
        ),
        builder: (_) => const SizedBox.shrink(),
      );

      observer.didPop(
        current,
        previous,
      );

      expect(
        logger.messages.single,
        '[NAVIGATION POP] /settings -> /menu',
      );
    },
  );

  test(
    'remove log records stable route identities',
    () {
      final logger = FakeLoggerService();

      final observer = AppNavigationObserver(
        logger,
      );

      final previous = MaterialPageRoute<void>(
        settings: const RouteSettings(
          name: '/home',
        ),
        builder: (_) => const SizedBox.shrink(),
      );

      final removed = MaterialPageRoute<void>(
        builder: (_) => const SizedBox.shrink(),
      );

      observer.didRemove(
        removed,
        previous,
      );

      expect(
        logger.messages.single,
        '[NAVIGATION REMOVE] unnamed -> /home',
      );
    },
  );
}
