import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/features/settings/presentation/widgets/manual_location_sheet.dart';
import 'package:noor_life/l10n/generated/app_localizations.dart';

void main() {
  Widget buildTestableWidget({
    required Future<bool> Function(
      double,
      double,
    ) onSave,
  }) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
      ],
      locale: const Locale('en'),
      home: Scaffold(
        body: ManualLocationSheet(
          onSave: onSave,
        ),
      ),
    );
  }

  testWidgets(
    'manual location rejects latitude outside valid range',
    (tester) async {
      var called = false;

      await tester.pumpWidget(
        buildTestableWidget(
          onSave: (
            latitude,
            longitude,
          ) async {
            called = true;
            return true;
          },
        ),
      );

      await tester.enterText(
        find.byKey(
          const ValueKey(
            'manualLatitudeField',
          ),
        ),
        '95',
      );

      await tester.enterText(
        find.byKey(
          const ValueKey(
            'manualLongitudeField',
          ),
        ),
        '42',
      );

      await tester.tap(
        find.byKey(
          const ValueKey(
            'manualLocationSaveButton',
          ),
        ),
      );

      await tester.pump();

      expect(
        called,
        isFalse,
      );

      expect(
        find.text(
          'Latitude must be between -90 and 90.',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'manual location accepts comma decimal separator',
    (tester) async {
      double? receivedLatitude;
      double? receivedLongitude;

      await tester.pumpWidget(
        buildTestableWidget(
          onSave: (
            latitude,
            longitude,
          ) async {
            receivedLatitude = latitude;
            receivedLongitude = longitude;

            return true;
          },
        ),
      );

      await tester.enterText(
        find.byKey(
          const ValueKey(
            'manualLatitudeField',
          ),
        ),
        '39,3292',
      );

      await tester.enterText(
        find.byKey(
          const ValueKey(
            'manualLongitudeField',
          ),
        ),
        '42,289504',
      );

      await tester.tap(
        find.byKey(
          const ValueKey(
            'manualLocationSaveButton',
          ),
        ),
      );

      // Do not use pumpAndSettle here. The widget is mounted directly as the
      // test page rather than inside a real modal route, and it may retain
      // ongoing loading/cursor animations after a successful save.
      await tester.pump();
      await tester.pump(
        const Duration(
          milliseconds: 100,
        ),
      );

      expect(
        receivedLatitude,
        closeTo(
          39.3292,
          0.000001,
        ),
      );

      expect(
        receivedLongitude,
        closeTo(
          42.289504,
          0.000001,
        ),
      );
    },
  );
}
