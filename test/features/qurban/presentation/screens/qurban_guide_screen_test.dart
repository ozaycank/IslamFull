import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/features/qurban/presentation/screens/qurban_guide_screen.dart';
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
      home: QurbanGuideScreen(),
    );
  }

  testWidgets(
    'Qurban guide displays and expands reference topics',
    (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Qurban Guide'),
        findsOneWidget,
      );

      expect(
        find.text('Who Is Responsible?'),
        findsOneWidget,
      );

      await tester.tap(
        find.text('Who Is Responsible?'),
      );

      await tester.pumpAndSettle();

      expect(
        find.textContaining(
          'Hanafi',
        ),
        findsOneWidget,
      );
    },
  );
}
