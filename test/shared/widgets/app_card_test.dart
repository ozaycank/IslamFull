import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/shared/widgets/app_card.dart';

void main() {
  testWidgets(
    'non interactive AppCard does not create an InkWell',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppCard(
              child: Text(
                'Information',
              ),
            ),
          ),
        ),
      );

      expect(
        find.byType(InkWell),
        findsNothing,
      );
    },
  );

  testWidgets(
    'interactive AppCard exposes button semantics and handles tap',
    (tester) async {
      var tapped = false;

      final semanticsHandle = tester.ensureSemantics();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppCard(
              onTap: () {
                tapped = true;
              },
              child: const Text(
                'Open details',
              ),
            ),
          ),
        ),
      );

      expect(
        tester.getSemantics(
          find.text('Open details'),
        ),
        isSemantics(
          label: 'Open details',
          isButton: true,
          hasTapAction: true,
        ),
      );

      await tester.tap(
        find.text('Open details'),
      );

      expect(
        tapped,
        isTrue,
      );

      semanticsHandle.dispose();
    },
  );
}
