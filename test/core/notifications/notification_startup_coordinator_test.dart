import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:noor_life/core/notifications/notification_startup_coordinator.dart';

void main() {
  group('NotificationStartupCoordinator', () {
    test('initializes only once and forwards launch payload afterwards',
        () async {
      final initializationGate = Completer<void>();
      final receivedPayloads = <String>[];

      var initializationCount = 0;
      var payloadReadCount = 0;

      final coordinator = NotificationStartupCoordinator(
        initialize: () async {
          initializationCount++;
          await initializationGate.future;
        },
        takeInitialPayload: () {
          payloadReadCount++;
          return 'prayer:isha';
        },
        handleInitialPayload: receivedPayloads.add,
      );

      final firstStart = coordinator.start();
      final secondStart = coordinator.start();

      expect(
        initializationCount,
        1,
      );

      expect(
        receivedPayloads,
        isEmpty,
      );

      initializationGate.complete();

      await Future.wait<void>([
        firstStart,
        secondStart,
      ]);

      expect(
        initializationCount,
        1,
      );

      expect(
        payloadReadCount,
        1,
      );

      expect(
        receivedPayloads,
        <String>['prayer:isha'],
      );
    });

    test('does not forward empty notification payloads', () async {
      final receivedPayloads = <String>[];

      final coordinator = NotificationStartupCoordinator(
        initialize: () async {},
        takeInitialPayload: () => '   ',
        handleInitialPayload: receivedPayloads.add,
      );

      await coordinator.start();

      expect(
        receivedPayloads,
        isEmpty,
      );
    });

    test('does not navigate after disposal', () async {
      final initializationGate = Completer<void>();
      final receivedPayloads = <String>[];

      var payloadReadCount = 0;

      final coordinator = NotificationStartupCoordinator(
        initialize: () => initializationGate.future,
        takeInitialPayload: () {
          payloadReadCount++;
          return 'daily-verse:112:3';
        },
        handleInitialPayload: receivedPayloads.add,
      );

      final startup = coordinator.start();

      coordinator.dispose();

      initializationGate.complete();

      await startup;

      expect(
        payloadReadCount,
        0,
      );

      expect(
        receivedPayloads,
        isEmpty,
      );
    });

    test('propagates initialization failures without using a payload',
        () async {
      var payloadReadCount = 0;

      final coordinator = NotificationStartupCoordinator(
        initialize: () async {
          throw StateError('Notification plugin unavailable');
        },
        takeInitialPayload: () {
          payloadReadCount++;
          return 'prayer:fajr';
        },
        handleInitialPayload: (_) {},
      );

      await expectLater(
        coordinator.start(),
        throwsA(
          isA<StateError>(),
        ),
      );

      expect(
        payloadReadCount,
        0,
      );
    });
  });
}
