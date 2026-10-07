import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/features/menu/presentation/screens/about_screen.dart';
import 'package:noor_life/l10n/generated/app_localizations.dart';

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
        child: const AboutScreen(),
      ),
    );
  }

  testWidgets(
    'about screen renders product information',
    (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(),
      );

      await tester.pumpAndSettle();

      expect(
        find.text(
          'IslamFull',
        ),
        findsOneWidget,
      );

      expect(
        find.textContaining(
          'Version',
        ),
        findsOneWidget,
      );

      expect(
        find.textContaining(
          'Made with',
        ),
        findsNothing,
      );

      expect(
        tester.takeException(),
        isNull,
      );
    },
  );

  testWidgets(
    'about screen remains responsive with large text',
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
        find.text(
          'IslamFull',
        ),
        findsOneWidget,
      );

      expect(
        tester.takeException(),
        isNull,
      );
    },
  );
}
