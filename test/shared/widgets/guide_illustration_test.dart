import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/shared/widgets/guide_illustration.dart';

void main() {
  testWidgets(
    'missing optional illustration does not break the screen',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: GuideIllustration(
                imagePath: 'images/not-found/guide-image.png',
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        tester.takeException(),
        isNull,
      );
    },
  );

  testWidgets(
    'empty illustration path collapses safely',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GuideIllustration(
              imagePath: '',
            ),
          ),
        ),
      );

      expect(
        find.byType(Image),
        findsNothing,
      );

      expect(
        tester.takeException(),
        isNull,
      );
    },
  );
}
