import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/features/prayer/location/presentation/widgets/location_resume_recovery_listener.dart';

void main() {
  Future<void> pumpListener(
    WidgetTester tester, {
    required bool shouldRetry,
    required Future<void> Function() onRetry,
  }) {
    return tester.pumpWidget(
      MaterialApp(
        home: LocationResumeRecoveryListener(
          shouldRetry: () => shouldRetry,
          onRetry: onRetry,
          child: const Scaffold(
            body: Center(
              child: Text('Prayer location error'),
            ),
          ),
        ),
      ),
    );
  }

  void simulateBackgroundResume(
    WidgetTester tester,
  ) {
    tester.binding.handleAppLifecycleStateChanged(
      AppLifecycleState.inactive,
    );
    tester.binding.handleAppLifecycleStateChanged(
      AppLifecycleState.paused,
    );
    tester.binding.handleAppLifecycleStateChanged(
      AppLifecycleState.resumed,
    );
  }

  Future<void> runWithPlatform(
    TargetPlatform platform,
    Future<void> Function() callback,
  ) async {
    final previousPlatform = debugDefaultTargetPlatformOverride;
    debugDefaultTargetPlatformOverride = platform;

    try {
      await callback();
    } finally {
      // Restore this before Flutter's test binding checks debug variables.
      debugDefaultTargetPlatformOverride = previousPlatform;
    }
  }

  test(
    'only GPS-disabled and permanently-denied errors are recoverable',
    () {
      expect(
        isLocationSettingsRecoveryFailure('locationServiceDisabled'),
        isTrue,
      );

      expect(
        isLocationSettingsRecoveryFailure('permissionDeniedForever'),
        isTrue,
      );

      for (final code in <String?>[
        null,
        'permissionDenied',
        'locationTimeout',
        'coordinateAcquisitionFailed',
        'timezoneResolutionFailed',
      ]) {
        expect(
          isLocationSettingsRecoveryFailure(code),
          isFalse,
          reason: 'Unexpected recovery eligibility for $code',
        );
      }
    },
  );

  testWidgets(
    'retries location when returning to Android with a recoverable failure',
    (tester) async {
      await runWithPlatform(
        TargetPlatform.android,
        () async {
          var retryCount = 0;

          await pumpListener(
            tester,
            shouldRetry: true,
            onRetry: () async {
              retryCount++;
            },
          );

          simulateBackgroundResume(tester);

          await tester.pump();
          await tester.pump();

          expect(
            retryCount,
            1,
          );
        },
      );
    },
  );

  testWidgets(
    'does not retry when the current failure is no longer recoverable',
    (tester) async {
      await runWithPlatform(
        TargetPlatform.android,
        () async {
          var retryCount = 0;

          await pumpListener(
            tester,
            shouldRetry: false,
            onRetry: () async {
              retryCount++;
            },
          );

          simulateBackgroundResume(tester);

          await tester.pump();
          await tester.pump();

          expect(
            retryCount,
            0,
          );
        },
      );
    },
  );

  testWidgets(
    'does not run native location recovery on desktop',
    (tester) async {
      await runWithPlatform(
        TargetPlatform.linux,
        () async {
          var retryCount = 0;

          await pumpListener(
            tester,
            shouldRetry: true,
            onRetry: () async {
              retryCount++;
            },
          );

          simulateBackgroundResume(tester);

          await tester.pump();
          await tester.pump();

          expect(
            retryCount,
            0,
          );
        },
      );
    },
  );
}
