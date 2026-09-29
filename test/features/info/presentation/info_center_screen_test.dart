import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/features/info/presentation/info_center_screen.dart';
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
      home: InfoCenterScreen(),
    );
  }

  testWidgets(
    'Info Center shows one Ramadan guide and Hajj and Umrah guides',
    (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(),
      );

      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('Ramadan Guide'),
        250,
        scrollable: find.byType(Scrollable).first,
      );

      expect(
        find.text('Ramadan Guide'),
        findsOneWidget,
      );

      await tester.scrollUntilVisible(
        find.text('Hajj Fundamentals'),
        250,
        scrollable: find.byType(Scrollable).first,
      );

      expect(
        find.text('Hajj Fundamentals'),
        findsOneWidget,
      );

      await tester.scrollUntilVisible(
        find.text('Umrah Guide'),
        250,
        scrollable: find.byType(Scrollable).first,
      );

      expect(
        find.text('Umrah Guide'),
        findsOneWidget,
      );
    },
  );
}
