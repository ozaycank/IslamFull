import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/features/hajj/presentation/screens/hajj_types_screen.dart';
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
      home: HajjTypesScreen(),
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
    'Hajj types distinguishes Ifrad Tamattu and Qiran',
    (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Types of Hajj'),
        findsOneWidget,
      );

      await revealAndTap(
        tester,
        'Ifrad',
      );

      expect(
        find.textContaining(
          'without performing Umrah',
        ),
        findsOneWidget,
      );

      await revealAndTap(
        tester,
        'Tamattu',
      );

      expect(
        find.textContaining(
          'leaves ihram',
        ),
        findsOneWidget,
      );

      await revealAndTap(
        tester,
        'Qiran',
      );

      expect(
        find.textContaining(
          'one continuous state of ihram',
        ),
        findsOneWidget,
      );
    },
  );
}
