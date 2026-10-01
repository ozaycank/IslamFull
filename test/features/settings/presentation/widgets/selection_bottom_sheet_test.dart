import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/features/settings/presentation/widgets/selection_bottom_sheet.dart';

void main() {
  Widget buildTestableWidget({
    required ValueChanged<String> onSelected,
    double textScale = 1,
  }) {
    return MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(
          textScaler: TextScaler.linear(
            textScale,
          ),
        ),
        child: Scaffold(
          body: Builder(
            builder: (context) {
              return Center(
                child: ElevatedButton(
                  key: const ValueKey(
                    'openSelectionSheet',
                  ),
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      useSafeArea: true,
                      isScrollControlled: true,
                      builder: (_) {
                        return SelectionBottomSheet(
                          title: 'Choose theme',
                          items: const [
                            SelectionItem(
                              'system',
                              'System',
                              'Follow device appearance.',
                            ),
                            SelectionItem(
                              'light',
                              'Light',
                            ),
                            SelectionItem(
                              'dark',
                              'Dark',
                            ),
                          ],
                          selectedId: 'system',
                          onSelected: onSelected,
                        );
                      },
                    );
                  },
                  child: const Text(
                    'Open',
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  testWidgets(
    'SelectionBottomSheet returns changed selection and closes',
    (tester) async {
      String? selected;

      await tester.pumpWidget(
        buildTestableWidget(
          onSelected: (id) {
            selected = id;
          },
        ),
      );

      await tester.tap(
        find.byKey(
          const ValueKey(
            'openSelectionSheet',
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.byIcon(
          Icons.check,
        ),
        findsOneWidget,
      );

      await tester.tap(
        find.text(
          'Dark',
        ),
      );

      await tester.pumpAndSettle();

      expect(
        selected,
        'dark',
      );

      expect(
        find.text(
          'Choose theme',
        ),
        findsNothing,
      );
    },
  );

  testWidgets(
    'SelectionBottomSheet remains usable with large text',
    (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          textScale: 2,
          onSelected: (_) {},
        ),
      );

      await tester.tap(
        find.byKey(
          const ValueKey(
            'openSelectionSheet',
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        tester.takeException(),
        isNull,
      );

      expect(
        find.text(
          'Follow device appearance.',
        ),
        findsOneWidget,
      );
    },
  );
}
