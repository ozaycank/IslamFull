import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/shared/widgets/primary_button.dart';

void main() {
  testWidgets(
    'PrimaryButton invokes callback when enabled',
    (tester) async {
      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Continue',
              onPressed: () {
                pressed = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(
        find.text('Continue'),
      );

      expect(
        pressed,
        isTrue,
      );
    },
  );

  testWidgets(
    'PrimaryButton disables interaction while loading and preserves label',
    (tester) async {
      final semanticsHandle = tester.ensureSemantics();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Save changes',
              isLoading: true,
              onPressed: () {},
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );

      expect(
        button.onPressed,
        isNull,
      );

      expect(
        find.byType(
          CircularProgressIndicator,
        ),
        findsOneWidget,
      );

      expect(
        tester.getSemantics(
          find.byType(
            CircularProgressIndicator,
          ),
        ),
        isSemantics(
          label: 'Save changes',
        ),
      );

      semanticsHandle.dispose();
    },
  );

  testWidgets(
    'PrimaryButton with icon remains layout safe at large text scale',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: MediaQuery(
                data: const MediaQueryData(
                  textScaler: TextScaler.linear(2),
                ),
                child: SizedBox(
                  width: 180,
                  child: PrimaryButton(
                    text: 'Open official information',
                    icon: Icons.open_in_browser,
                    onPressed: () {},
                  ),
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
          'Open official information',
        ),
        findsOneWidget,
      );
    },
  );
}
