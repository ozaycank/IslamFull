import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/features/hajj/presentation/screens/ihram_rules_screen.dart';
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
      home: IhramRulesScreen(),
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
    'Ihram guide explains restrictions without calculating penalties',
    (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Ihram Rules'),
        findsOneWidget,
      );

      await revealAndTap(
        tester,
        'Hair and Nails',
      );

      expect(
        find.textContaining(
          'does not calculate a penalty automatically',
        ),
        findsOneWidget,
      );

      await revealAndTap(
        tester,
        'Bathing and Cleanliness',
      );

      expect(
        find.textContaining(
          'does not prevent bathing',
        ),
        findsOneWidget,
      );
    },
  );
}
