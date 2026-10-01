import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/shared/widgets/error_state_widget.dart';

void main() {
  testWidgets(
    'ErrorStateWidget exposes heading semantics and retry action',
    (tester) async {
      var retried = false;
      final semanticsHandle = tester.ensureSemantics();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorStateWidget(
              title: 'Unable to load',
              message: 'Something went wrong.',
              retryText: 'Retry',
              onRetry: () {
                retried = true;
              },
            ),
          ),
        ),
      );

      expect(
        tester.getSemantics(
          find.text(
            'Unable to load',
          ),
        ),
        isSemantics(
          label: 'Unable to load',
          isHeader: true,
        ),
      );

      await tester.tap(
        find.text(
          'Retry',
        ),
      );

      expect(
        retried,
        isTrue,
      );

      semanticsHandle.dispose();
    },
  );

  testWidgets(
    'ErrorStateWidget remains usable with large text and no retry',
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
                child: ErrorStateWidget(
                  title: 'A longer error title',
                  message:
                      'A longer explanatory error message that should remain readable.',
                  retryText: 'Retry',
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
          'Retry',
        ),
        findsNothing,
      );
    },
  );
}
