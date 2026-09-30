import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/shared/widgets/section_header.dart';

void main() {
  testWidgets(
    'SectionHeader exposes heading semantics',
    (tester) async {
      final semanticsHandle = tester.ensureSemantics();

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SectionHeader(
              title: 'Prayer guidance',
            ),
          ),
        ),
      );

      expect(
        tester.getSemantics(
          find.text(
            'Prayer guidance',
          ),
        ),
        isSemantics(
          label: 'Prayer guidance',
          isHeader: true,
        ),
      );

      semanticsHandle.dispose();
    },
  );

  testWidgets(
    'SectionHeader action remains usable with large text',
    (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MediaQuery(
              data: const MediaQueryData(
                textScaler: TextScaler.linear(2),
              ),
              child: SizedBox(
                width: 320,
                child: SectionHeader(
                  title: 'A longer section heading',
                  actionText: 'View all',
                  onActionPressed: () {
                    tapped = true;
                  },
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

      await tester.tap(
        find.text(
          'View all',
        ),
      );

      expect(
        tapped,
        isTrue,
      );
    },
  );
}
