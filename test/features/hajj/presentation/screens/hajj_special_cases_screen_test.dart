import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/features/hajj/presentation/screens/hajj_special_cases_screen.dart';
import 'package:noor_life/l10n/generated/app_localizations.dart';

void main() {
  Widget buildTestableWidget() {
    return const MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'),
      ],
      locale: Locale('en'),
      home: HajjSpecialCasesScreen(),
    );
  }

  Future<void> revealAndTap(
    WidgetTester tester,
    String text,
  ) async {
    final finder = find.text(text);

    await tester.scrollUntilVisible(
      finder,
      200,
      scrollable: find.byType(Scrollable).first,
    );

    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();

    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  testWidgets(
    'Common situations guide directs complex cases to specific guidance',
    (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Common Hajj & Umrah Situations'),
        findsOneWidget,
      );

      await revealAndTap(
        tester,
        'Crossing the Miqat Without Ihram',
      );

      expect(
        find.textContaining(
          'Do not guess a penalty',
        ),
        findsOneWidget,
      );

      await revealAndTap(
        tester,
        'Menstruation or Postpartum Bleeding',
      );

      expect(
        find.textContaining(
          'does not prevent a woman from entering Ihram',
        ),
        findsOneWidget,
      );
    },
  );
}
