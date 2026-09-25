import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/features/zakat/presentation/screens/zakat_calculator_screen.dart';
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
      home: ZakatCalculatorScreen(),
    );
  }

  Finder scrollableFinder() {
    return find.byType(Scrollable).first;
  }

  Future<void> scrollToText(
    WidgetTester tester,
    String text,
  ) async {
    await tester.scrollUntilVisible(
      find.text(text),
      300,
      scrollable: scrollableFinder(),
    );

    await tester.pumpAndSettle();
  }

  Future<void> enterFieldByLabel(
    WidgetTester tester, {
    required String label,
    required String value,
  }) async {
    await scrollToText(
      tester,
      label,
    );

    final labelFinder = find.text(label);

    final fieldFinder = find.ancestor(
      of: labelFinder,
      matching: find.byType(TextFormField),
    );

    expect(
      fieldFinder,
      findsOneWidget,
    );

    await tester.enterText(
      fieldFinder,
      value,
    );

    await tester.pump();
  }

  Future<void> tapCalculate(
    WidgetTester tester,
  ) async {
    await scrollToText(
      tester,
      'Calculate Zakat',
    );

    await tester.tap(
      find.text('Calculate Zakat'),
    );

    await tester.pumpAndSettle();
  }

  testWidgets(
    'does not show payable zakat when lunar-year condition is unconfirmed',
    (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(),
      );

      await tester.pumpAndSettle();

      await enterFieldByLabel(
        tester,
        label: 'Current Gold Price per Gram *',
        value: '1000',
      );

      await enterFieldByLabel(
        tester,
        label: 'Cash & Bank Accounts',
        value: '100000',
      );

      await tapCalculate(
        tester,
      );

      expect(
        find.textContaining(
          'lunar-year condition has not been confirmed',
        ),
        findsOneWidget,
      );

      expect(
        find.text('Estimated Zakat Amount:'),
        findsNothing,
      );
    },
  );

  testWidgets(
    'shows estimated zakat after nisab and lunar-year conditions are confirmed',
    (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(),
      );

      await tester.pumpAndSettle();

      await scrollToText(
        tester,
        'A lunar zakat year has been completed',
      );

      await tester.tap(
        find.text(
          'A lunar zakat year has been completed',
        ),
      );

      await tester.pumpAndSettle();

      await enterFieldByLabel(
        tester,
        label: 'Current Gold Price per Gram *',
        value: '1000',
      );

      await enterFieldByLabel(
        tester,
        label: 'Cash & Bank Accounts',
        value: '100000',
      );

      await tapCalculate(
        tester,
      );

      expect(
        find.text('Estimated Zakat Amount:'),
        findsOneWidget,
      );

      expect(
        find.text('₺2500.00'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'rejects a zero gold price',
    (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(),
      );

      await tester.pumpAndSettle();

      await enterFieldByLabel(
        tester,
        label: 'Current Gold Price per Gram *',
        value: '0',
      );

      await tapCalculate(
        tester,
      );

      expect(
        find.text(
          'Enter a gold price greater than zero.',
        ),
        findsOneWidget,
      );

      expect(
        find.text('Calculation Result'),
        findsNothing,
      );
    },
  );
}
