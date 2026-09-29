import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/features/hajj/presentation/screens/hajj_guide_screen.dart';
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
      home: HajjGuideScreen(),
    );
  }

  testWidgets(
    'Hajj and Umrah hub exposes both learning guides',
    (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Hajj & Umrah'),
        findsOneWidget,
      );

      expect(
        find.text('Hajj Fundamentals'),
        findsOneWidget,
      );

      expect(
        find.text('Umrah Guide'),
        findsOneWidget,
      );

      await tester.scrollUntilVisible(
        find.text('Official Information'),
        250,
        scrollable: find.byType(Scrollable).first,
      );

      expect(
        find.text('Official Information'),
        findsOneWidget,
      );

      expect(
        find.text('Open Official Diyanet Hajj & Umrah'),
        findsOneWidget,
      );
    },
  );
}
