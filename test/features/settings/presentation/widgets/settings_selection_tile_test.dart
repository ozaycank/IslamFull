import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/features/settings/presentation/widgets/settings_selection_tile.dart';

void main() {
  testWidgets(
    'SettingsSelectionTile remains readable with large text',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MediaQuery(
              data: const MediaQueryData(
                textScaler: TextScaler.linear(
                  2,
                ),
              ),
              child: SizedBox(
                width: 320,
                child: SettingsSelectionTile(
                  title: 'A very long settings option title',
                  value: 'A very long selected setting value',
                  onTap: () {},
                ),
              ),
            ),
          ),
        ),
      );

      expect(
        tester.takeException(),
        isNull,
      );

      expect(
        find.text(
          'A very long selected setting value',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'SettingsSelectionTile blocks interaction while loading',
    (tester) async {
      var taps = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SettingsSelectionTile(
              title: 'Theme',
              value: 'System',
              isLoading: true,
              onTap: () {
                taps++;
              },
            ),
          ),
        ),
      );

      await tester.tap(
        find.byType(
          SettingsSelectionTile,
        ),
      );

      expect(
        taps,
        0,
      );

      expect(
        find.byType(
          CircularProgressIndicator,
        ),
        findsOneWidget,
      );
    },
  );
}
