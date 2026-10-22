import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:islamfull/features/prayer/shared/presentation/utils/presentation_localizer.dart';
import 'package:islamfull/l10n/generated/app_localizations.dart';

void main() {
  testWidgets(
    'resolved district is displayed instead of fallback name',
    (tester) async {
      String? display;
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('tr'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Builder(
            builder: (context) {
              display = PresentationLocalizer.formatLocation(
                context: context,
                cityName: 'Malazgirt',
                countryName: 'Türkiye',
                lat: 39.15,
                lon: 42.54,
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(
        display,
        'Malazgirt, Türkiye',
      );
    },
  );

  testWidgets(
    'unresolved city shows truthful coordinates with country',
    (tester) async {
      String? display;
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('tr'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Builder(
            builder: (context) {
              display = PresentationLocalizer.formatLocation(
                context: context,
                cityName: 'Current Location',
                countryName: 'Türkiye',
                lat: 39.3292,
                lon: 42.289504,
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(
        display,
        'Türkiye (39.3292, 42.2895)',
      );
    },
  );
}
