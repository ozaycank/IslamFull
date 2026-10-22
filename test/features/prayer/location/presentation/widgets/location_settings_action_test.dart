import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:islamfull/features/prayer/location/presentation/widgets/location_settings_action.dart';
import 'package:islamfull/l10n/generated/app_localizations.dart';

void main() {
  void testWidgetsOnAndroid(
    String description,
    Future<void> Function(WidgetTester tester) callback,
  ) {
    testWidgets(
      description,
      (tester) async {
        final previousPlatform = debugDefaultTargetPlatformOverride;
        debugDefaultTargetPlatformOverride = TargetPlatform.android;

        try {
          await callback(tester);
        } finally {
          // Flutter's test binding checks foundation debug variables before
          // the outer test tearDown callbacks run.
          debugDefaultTargetPlatformOverride = previousPlatform;
        }
      },
    );
  }

  Future<void> pumpAction(
    WidgetTester tester, {
    required String? code,
    Future<bool> Function()? openDevice,
    Future<bool> Function()? openApp,
  }) {
    return tester.pumpWidget(
      MaterialApp(
        locale: const Locale('tr'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(
          body: LocationSettingsAction(
            failureCode: code,
            openDeviceLocationSettings: openDevice,
            openApplicationSettings: openApp,
          ),
        ),
      ),
    );
  }

  testWidgetsOnAndroid(
    'GPS disabled offers device location settings',
    (tester) async {
      var opened = 0;

      await pumpAction(
        tester,
        code: 'locationServiceDisabled',
        openDevice: () async {
          opened++;
          return true;
        },
      );

      expect(
        find.byKey(const ValueKey('locationRecoverySettingsButton')),
        findsOneWidget,
      );
      expect(
        find.text('Konum ayarlarını aç'),
        findsOneWidget,
      );

      await tester.tap(
        find.byKey(const ValueKey('locationRecoverySettingsButton')),
      );
      await tester.pump();

      expect(opened, 1);
    },
  );

  testWidgetsOnAndroid(
    'blocked permission offers app settings',
    (tester) async {
      var opened = 0;

      await pumpAction(
        tester,
        code: 'permissionDeniedForever',
        openApp: () async {
          opened++;
          return true;
        },
      );

      expect(
        find.text('Uygulama ayarlarını aç'),
        findsOneWidget,
      );

      await tester.tap(
        find.byKey(const ValueKey('locationRecoverySettingsButton')),
      );
      await tester.pump();

      expect(opened, 1);
    },
  );

  testWidgetsOnAndroid(
    'ordinary denied permission has no settings action',
    (tester) async {
      await pumpAction(
        tester,
        code: 'permissionDenied',
      );

      expect(
        find.byKey(const ValueKey('locationRecoverySettingsButton')),
        findsNothing,
      );
    },
  );
}
