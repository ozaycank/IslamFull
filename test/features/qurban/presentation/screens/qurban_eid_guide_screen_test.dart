import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/features/qurban/presentation/screens/qurban_eid_guide_screen.dart';
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
      home: QurbanEidGuideScreen(),
    );
  }

  testWidgets(
    'shows Dhul Hijjah guidance and expands Eid prayer information',
    (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Dhul Hijjah & Eid al-Adha Guide'),
        findsOneWidget,
      );

      await tester.scrollUntilVisible(
        find.text('Eid Prayer'),
        250,
        scrollable: find.byType(Scrollable).first,
      );

      await tester.tap(
        find.text('Eid Prayer'),
      );

      await tester.pumpAndSettle();

      expect(
        find.textContaining(
          'two rakahs',
        ),
        findsOneWidget,
      );

      expect(
        find.textContaining(
          'Hanafi',
        ),
        findsOneWidget,
      );
    },
  );
}
