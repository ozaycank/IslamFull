import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/shared/widgets/empty_state_widget.dart';

void main() {
  testWidgets(
    'EmptyStateWidget exposes heading semantics and action',
    (tester) async {
      var tapped = false;

      final semanticsHandle = tester.ensureSemantics();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              icon: Icons.inbox_outlined,
              title: 'Nothing here',
              description: 'There is currently no content.',
              actionText: 'Refresh',
              onActionPressed: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      expect(
        tester.getSemantics(
          find.text(
            'Nothing here',
          ),
        ),
        isSemantics(
          label: 'Nothing here',
          isHeader: true,
        ),
      );

      await tester.tap(
        find.text(
          'Refresh',
        ),
      );

      expect(
        tapped,
        isTrue,
      );

      semanticsHandle.dispose();
    },
  );

  testWidgets(
    'EmptyStateWidget remains responsive with large text',
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
              child: SizedBox(
                width: 320,
                child: EmptyStateWidget(
                  icon: Icons.inbox_outlined,
                  title: 'A longer empty state title',
                  description:
                      'A longer description that should remain readable on a narrow layout.',
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
    },
  );
}
