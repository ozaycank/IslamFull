import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/features/hajj/presentation/screens/hajj_fundamentals_screen.dart';
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
      home: HajjFundamentalsScreen(),
    );
  }

  Future<void> revealAndTapTopic(
    WidgetTester tester,
    String title,
  ) async {
    final titleFinder = find.text(title);

    await tester.scrollUntilVisible(
      titleFinder,
      200,
      scrollable: find.byType(Scrollable).first,
    );

    await tester.pumpAndSettle();

    // scrollUntilVisible can stop when the widget is only partially inside
    // the scrollable. Ensure the title is fully inside the test viewport
    // before attempting a pointer interaction.
    await tester.ensureVisible(
      titleFinder,
    );

    await tester.pumpAndSettle();

    await tester.tap(
      titleFinder,
    );

    await tester.pumpAndSettle();
  }

  testWidgets(
    'Hajj fundamentals explains ihram and Arafat',
    (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Hajj Fundamentals'),
        findsOneWidget,
      );

      await revealAndTapTopic(
        tester,
        'Ihram and Miqat',
      );

      expect(
        find.textContaining(
          'miqat boundaries',
        ),
        findsOneWidget,
      );

      await revealAndTapTopic(
        tester,
        'Arafat',
      );

      expect(
        find.textContaining(
          'pillar of Hajj',
        ),
        findsOneWidget,
      );
    },
  );
}
