import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/features/prayer/shared/presentation/widgets/prayer_empty_widget.dart';
import 'package:noor_life/l10n/generated/app_localizations.dart';

void main() {
  testWidgets(
    'PrayerEmptyWidget uses localized shared empty state',
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
          home: Scaffold(
            body: PrayerEmptyWidget(),
          ),
        ),
      );

      final context = tester.element(
        find.byType(
          PrayerEmptyWidget,
        ),
      );

      final l10n = AppLocalizations.of(
        context,
      )!;

      expect(
        find.text(
          l10n.emptyStateDefaultTitle,
        ),
        findsOneWidget,
      );

      expect(
        find.text(
          l10n.emptyStateDefaultDesc,
        ),
        findsOneWidget,
      );
    },
  );
}
