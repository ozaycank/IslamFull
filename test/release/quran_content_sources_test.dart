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

  test('Turkish translation rights remain explicitly unverified', () {
    final metadata = File(
      'assets/data/quran/translations/tr/SOURCE.md',
    ).readAsStringSync();
    final sourceScreen = File(
      'lib/features/quran/presentation/screens/quran_sources_screen.dart',
    ).readAsStringSync();

    expect(metadata, contains('NOT VERIFIED'));
    expect(metadata, contains('BLOCKED'));
    expect(metadata, isNot(contains('**License:** CC BY-NC-SA 4.0')));
    expect(sourceScreen, contains('have not yet been verified'));
    expect(sourceScreen, contains('henüz doğrulanmamıştır'));
  });

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
