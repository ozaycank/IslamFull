import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/shared/widgets/guide_content_cards.dart';

void main() {
  testWidgets(
    'GuideInfoCard remains responsive on narrow layout with large text',
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
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: 320,
                    child: GuideInfoCard(
                      icon: Icons.info_outline,
                      title: 'Important information',
                      description:
                          'This is a longer informational description that '
                          'must remain readable at large accessibility text '
                          'sizes.',
                      source: 'Source note',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(
        tester.takeException(),
        isNull,
      );

      expect(
        find.text(
          'Important information',
        ),
        findsOneWidget,
      );

      expect(
        find.text(
          'Source note',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'GuideTopicCard expands and reveals description and source',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: GuideTopicCard(
                icon: Icons.menu_book_outlined,
                title: 'Topic',
                description: 'Topic description',
                source: 'Reference source',
              ),
            ),
          ),
        ),
      );

      expect(
        find.text(
          'Topic description',
        ),
        findsNothing,
      );

      await tester.tap(
        find.text(
          'Topic',
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text(
          'Topic description',
        ),
        findsOneWidget,
      );

      expect(
        find.text(
          'Reference source',
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
