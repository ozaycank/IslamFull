import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/features/menu/presentation/screens/menu_screen.dart';
import 'package:noor_life/l10n/generated/app_localizations.dart';

void main() {
  Widget buildTestableWidget({
    double textScale = 1,
  }) {
    return ProviderScope(
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
        ],
        locale: const Locale('en'),
        home: MediaQuery(
          data: MediaQueryData(
            textScaler: TextScaler.linear(
              textScale,
            ),
          ),
          child: const MenuScreen(),
        ),
      ),
    );
  }

  testWidgets(
    'Menu screen renders main groups safely',
    (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(),
      );

      await tester.pumpAndSettle();

      expect(
        find.text(
          'Menu',
        ),
        findsWidgets,
      );

      expect(
        find.text(
          'App Settings',
        ),
        findsOneWidget,
      );

      expect(
        find.text(
          'Tools & Information',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Menu screen remains responsive with large text',
    (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          textScale: 2,
        ),
      );

      await tester.pumpAndSettle();

      expect(
        tester.takeException(),
        isNull,
      );

      expect(
        find.text(
          'App Settings',
        ),
        findsOneWidget,
      );
    },
  );
}
