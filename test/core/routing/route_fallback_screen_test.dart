import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/core/routing/route_fallback_screen.dart';
import 'package:noor_life/l10n/generated/app_localizations.dart';

void main() {
  testWidgets(
    'RouteFallbackScreen exposes safe home action',
    (tester) async {
      var returnedHome = false;

      await tester.pumpWidget(
        MaterialApp(
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
          home: RouteFallbackScreen(
            onReturnHome: () {
              returnedHome = true;
            },
          ),
        ),
      );

      final context = tester.element(
        find.byType(
          RouteFallbackScreen,
        ),
      );

      final l10n = AppLocalizations.of(
        context,
      )!;

      expect(
        find.text(
          l10n.errorStateDefaultTitle,
        ),
        findsOneWidget,
      );

      await tester.tap(
        find.text(
          l10n.navHome,
        ),
      );

      expect(
        returnedHome,
        isTrue,
      );
    },
  );

  testWidgets(
    'RouteFallbackScreen remains responsive with large text',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
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
          home: MediaQuery(
            data: MediaQueryData(
              textScaler: TextScaler.linear(
                2,
              ),
            ),
            child: RouteFallbackScreen(
              onReturnHome: _noop,
            ),
          ),
        ),
      );

      expect(
        tester.takeException(),
        isNull,
      );
    },
  );
}

void _noop() {}
