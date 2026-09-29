import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/features/hajj/presentation/screens/hajj_days_screen.dart';
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
      home: HajjDaysScreen(),
    );
  }

  testWidgets(
    'Hajj days presents the sequence from Tarwiyah through the final Tashriq day',
    (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('8 Dhul Hijjah · Tarwiyah'),
        findsOneWidget,
      );

      await tester.scrollUntilVisible(
        find.text('10 Dhul Hijjah · First Day of Eid'),
        250,
        scrollable: find.byType(Scrollable).first,
      );

      expect(
        find.text('10 Dhul Hijjah · First Day of Eid'),
        findsOneWidget,
      );

      await tester.scrollUntilVisible(
        find.text('13 Dhul Hijjah · Final Tashriq Day'),
        250,
        scrollable: find.byType(Scrollable).first,
      );

      await tester.ensureVisible(
        find.text('13 Dhul Hijjah · Final Tashriq Day'),
      );

      expect(
        find.text('11–12 Dhul Hijjah · Days of Tashriq'),
        findsOneWidget,
      );

      expect(
        find.text('13 Dhul Hijjah · Final Tashriq Day'),
        findsOneWidget,
      );
    },
  );
}
