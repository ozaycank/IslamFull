import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/features/menu/presentation/widgets/legal_section_card.dart';

void main() {
  testWidgets(
    'legal section card renders optional footer',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LegalSectionCard(
              icon: Icons.policy_outlined,
              title: 'Privacy',
              description: 'Privacy information',
              footer: Text(
                'Footer action',
              ),
            ),
          ),
        ),
      );

      expect(
        find.text(
          'Privacy',
        ),
        findsOneWidget,
      );

      expect(
        find.text(
          'Privacy information',
        ),
        findsOneWidget,
      );

      expect(
        find.text(
          'Footer action',
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
    'legal section card remains safe in narrow layout',
    (tester) async {
      await tester.binding.setSurfaceSize(
        const Size(
          320,
          700,
        ),
      );

      addTearDown(
        () => tester.binding.setSurfaceSize(
          null,
        ),
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: EdgeInsets.all(
                16,
              ),
              child: LegalSectionCard(
                icon: Icons.policy_outlined,
                title: 'Privacy information',
                description:
                    'A longer privacy description that must remain readable.',
                footer: Text(
                  'Footer action',
                ),
              ),
            ),
          ),
        ),
      );

      expect(
        find.text(
          'Privacy information',
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
