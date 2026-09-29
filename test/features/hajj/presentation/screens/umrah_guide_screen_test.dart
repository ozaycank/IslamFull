import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/features/hajj/presentation/screens/umrah_guide_screen.dart';
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
      home: UmrahGuideScreen(),
    );
  }

  testWidgets(
    'Umrah guide presents the basic four-step sequence',
    (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Umrah Guide'),
        findsOneWidget,
      );

      expect(
        find.text('1. Enter Ihram'),
        findsOneWidget,
      );

      expect(
        find.text('2. Perform Tawaf'),
        findsOneWidget,
      );

      await tester.scrollUntilVisible(
        find.text('4. Cut the Hair and Leave Ihram'),
        250,
        scrollable: find.byType(Scrollable).first,
      );

      expect(
        find.text('3. Perform Sa\'y'),
        findsOneWidget,
      );

      expect(
        find.text('4. Cut the Hair and Leave Ihram'),
        findsOneWidget,
      );
    },
  );
}
