import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/features/prayer/shared/presentation/widgets/prayer_error_widget.dart';
import 'package:noor_life/l10n/generated/app_localizations.dart';

void main() {
  testWidgets(
    'PrayerErrorWidget uses localized shared error state and retries',
    (tester) async {
      var retried = false;

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
          home: Scaffold(
            body: PrayerErrorWidget(
              message: 'Prayer data unavailable.',
              onRetry: () {
                retried = true;
              },
            ),
          ),
        ),
      );

      final context = tester.element(
        find.byType(
          PrayerErrorWidget,
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

      expect(
        find.text(
          'Prayer data unavailable.',
        ),
        findsOneWidget,
      );

      await tester.tap(
        find.text(
          l10n.retryButton,
        ),
      );

      expect(
        retried,
        isTrue,
      );
    },
  );
}
