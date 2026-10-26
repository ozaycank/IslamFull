import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Tanzil attribution and license terms are visible in the app', () {
    final sourceScreen = File(
      'lib/features/quran/presentation/screens/quran_sources_screen.dart',
    ).readAsStringSync();
    final sourceMetadata = File(
      'assets/data/quran/SOURCE.md',
    ).readAsStringSync();

    expect(sourceScreen, contains('Tanzil Project'));
    expect(sourceScreen, contains('https://tanzil.net'));
    expect(
      sourceScreen,
      contains('https://tanzil.net/docs/Text_License'),
    );
    expect(sourceScreen, contains('CC BY 3.0'));
    expect(
      sourceMetadata,
      contains('https://tanzil.net/docs/Text_License'),
    );
  });

  test(
    'Turkish translation is attributed and redistribution rights remain a release check',
    () {
      final metadata = File(
        'assets/data/quran/translations/tr/SOURCE.md',
      ).readAsStringSync();
      final sourceScreen = File(
        'lib/features/quran/presentation/screens/quran_sources_screen.dart',
      ).readAsStringSync();

      expect(metadata, contains('Erhan Aktaş'));
      expect(metadata, contains('Kerim Kur'));
      expect(metadata, contains('CC BY-NC-SA 4.0'));
      expect(
        metadata,
        isNot(contains('[VERIFY FROM ACTUAL TRANSLATION DATA]')),
      );

      expect(sourceScreen, contains('Erhan Aktaş'));
      expect(
        sourceScreen,
        contains('must be verified'),
      );
      expect(
        sourceScreen,
        contains('yayın öncesinde doğrulanmalıdır'),
      );
    },
  );

  test('Quran sources screen is reachable from the Quran home screen', () {
    final routes = File(
      'lib/core/routing/app_routes.dart',
    ).readAsStringSync();
    final router = File(
      'lib/core/routing/app_router.dart',
    ).readAsStringSync();
    final home = File(
      'lib/features/quran/presentation/screens/quran_home_screen.dart',
    ).readAsStringSync();

    expect(routes, contains("quranSourcesSegment = 'sources'"));
    expect(router, contains('QuranSourcesScreen()'));
    expect(home, contains(r"'${AppRoutes.quran}/sources'"));
  });

  test('source screen includes Turkish, English and Arabic copy', () {
    final sourceScreen = File(
      'lib/features/quran/presentation/screens/quran_sources_screen.dart',
    ).readAsStringSync();

    expect(sourceScreen, contains('Kur’an kaynakları ve atıflar'));
    expect(sourceScreen, contains('Quran sources and attributions'));
    expect(sourceScreen, contains('مصادر القرآن والإسناد'));
  });
}
