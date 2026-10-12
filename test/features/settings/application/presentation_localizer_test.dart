// ignore_for_file: avoid_relative_lib_imports

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../lib/features/prayer/shared/presentation/utils/presentation_localizer.dart';
import '../../../../lib/l10n/generated/app_localizations.dart';

void main() {
  Widget buildTestContext(
    Locale locale,
    Widget Function(BuildContext) builder,
  ) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('tr'),
      ],
      home: Scaffold(
        body: Builder(
          builder: builder,
        ),
      ),
    );
  }

  testWidgets(
    'PresentationLocalizer maps English single-shadow Asr convention',
    (tester) async {
      late String localized;

      await tester.pumpWidget(
        buildTestContext(
          const Locale('en'),
          (context) {
            localized = PresentationLocalizer.localizeAsrConvention(
              context,
              'single_shadow',
            );

            return const SizedBox();
          },
        ),
      );

      await tester.pumpAndSettle();

      expect(
        localized,
        'One-shadow length',
      );
    },
  );

  testWidgets(
    'PresentationLocalizer maps Turkish double-shadow Asr convention',
    (tester) async {
      late String localized;

      await tester.pumpWidget(
        buildTestContext(
          const Locale('tr'),
          (context) {
            localized = PresentationLocalizer.localizeAsrConvention(
              context,
              'double_shadow',
            );

            return const SizedBox();
          },
        ),
      );

      await tester.pumpAndSettle();

      expect(
        localized,
        '2 Gölge Boyu',
      );
    },
  );

  testWidgets(
    'Location Identity de-duplicates effectively',
    (tester) async {
      late String location;

      await tester.pumpWidget(
        buildTestContext(
          const Locale('en'),
          (context) {
            location = PresentationLocalizer.formatLocation(
              context: context,
              cityName: 'Salihli',
              subAdminArea: 'Manisa',
              countryName: 'Türkiye',
            );

            return const SizedBox();
          },
        ),
      );

      expect(
        location,
        'Salihli, Manisa, Türkiye',
      );
    },
  );
}
