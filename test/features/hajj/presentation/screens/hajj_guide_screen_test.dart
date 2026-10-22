import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:islamfull/features/hajj/presentation/screens/hajj_guide_screen.dart';
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
      home: HajjGuideScreen(),
    );
  }

  testWidgets(
    'Hajj and Umrah hub exposes all learning guides',
    (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Hajj Fundamentals'),
        findsOneWidget,
      );

      expect(
        find.text('Ihram Rules'),
        findsOneWidget,
      );

      expect(
        find.text('Types of Hajj'),
        findsOneWidget,
      );

      expect(
        find.text('Hajj Days'),
        findsOneWidget,
      );

      expect(
        find.text('Umrah Guide'),
        findsOneWidget,
      );

      expect(
        find.text('Common Hajj & Umrah Situations'),
        findsOneWidget,
      );

      await tester.scrollUntilVisible(
        find.text('Official Information'),
        250,
        scrollable: find.byType(Scrollable).first,
      );

      await tester.ensureVisible(
        find.text('Official Information'),
      );

      expect(
        find.text('Official Information'),
        findsOneWidget,
      );
    },
  );
}
