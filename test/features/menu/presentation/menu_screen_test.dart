import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:islamfull/features/menu/presentation/screens/menu_screen.dart';
import 'package:islamfull/l10n/generated/app_localizations.dart';

void main() {
  Widget buildTestableWidget({
    double textScale = 1,
  }) {
    return MaterialApp(
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

      await tester.scrollUntilVisible(
        find.text(
          'Privacy & Legal',
        ),
        300,
      );

      expect(
        find.text(
          'Privacy & Legal',
        ),
        findsOneWidget,
      );

      expect(
        tester.takeException(),
        isNull,
      );
    },
  );

  testWidgets(
    'Menu screen remains responsive with large text',
    (tester) async {
      await tester.binding.setSurfaceSize(
        const Size(
          360,
          800,
        ),
      );

      addTearDown(
        () => tester.binding.setSurfaceSize(
          null,
        ),
      );

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
  testWidgets(
    'Menu exposes one honest Settings destination',
    (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(),
      );

      await tester.pumpAndSettle();

      expect(find.text('App Settings'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
      expect(find.byIcon(Icons.language), findsNothing);
      expect(find.byIcon(Icons.notifications_none), findsNothing);
      expect(find.byIcon(Icons.access_time), findsNothing);
      expect(find.byIcon(Icons.location_on_outlined), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}
