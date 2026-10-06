import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/features/guidance/presentation/widgets/guidance_step_card.dart';

void main() {
  testWidgets(
    'remains readable on narrow screen with large text',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MediaQuery(
              data: MediaQueryData(
                textScaler: TextScaler.linear(
                  2,
                ),
              ),
              child: SingleChildScrollView(
                child: SizedBox(
                  width: 320,
                  child: GuidanceStepCard(
                    icon: Icons.directions_walk_outlined,
                    title: 'Guidance step',
                    description:
                        'A sufficiently long instructional description that '
                        'must remain readable at a large accessibility text '
                        'size without horizontal overflow.',
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(
        find.text(
          'Guidance step',
        ),
        findsOneWidget,
      );

      expect(
        tester.takeException(),
        isNull,
      );
    },
  );

  testWidgets(
    'missing optional image does not hide textual guidance',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: GuidanceStepCard(
                icon: Icons.info_outline,
                title: 'Step title',
                description: 'Step description',
                imagePath: 'images/not-found/step.png',
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text(
          'Step title',
        ),
        findsOneWidget,
      );

      expect(
        find.text(
          'Step description',
        ),
        findsOneWidget,
      );

      expect(
        tester.takeException(),
        isNull,
      );
    },
  );
}
