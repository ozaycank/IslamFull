import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:islamfull/features/info/presentation/info_center_screen.dart';
import 'package:islamfull/l10n/generated/app_localizations.dart';

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
      home: InfoCenterScreen(),
    );
  }

  Future<void> reveal(
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
  }

  testWidgets(
    'Info Center exposes the worship guides without duplicate Ramadan entry',
    (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(),
      );

      await tester.pumpAndSettle();

      await reveal(
        tester,
        'Ramadan Guide',
      );

      expect(
        find.text('Ramadan Guide'),
        findsOneWidget,
      );

      await reveal(
        tester,
        'Hajj Fundamentals',
      );

      expect(
        find.text('Hajj Fundamentals'),
        findsOneWidget,
      );

      await reveal(
        tester,
        'Types of Hajj',
      );

      expect(
        find.text('Types of Hajj'),
        findsOneWidget,
      );

      await reveal(
        tester,
        'Hajj Days',
      );

      expect(
        find.text('Hajj Days'),
        findsOneWidget,
      );

      await reveal(
        tester,
        'Umrah Guide',
      );

      expect(
        find.text('Umrah Guide'),
        findsOneWidget,
      );

      await reveal(
        tester,
        'Ihram Rules',
      );

      expect(
        find.text('Ihram Rules'),
        findsOneWidget,
      );

      await reveal(
        tester,
        'Common Hajj & Umrah Situations',
      );

      expect(
        find.text('Common Hajj & Umrah Situations'),
        findsOneWidget,
      );
    },
  );
}
