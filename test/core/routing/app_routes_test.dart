import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/core/routing/app_routes.dart';

void main() {
  test(
    'static application route paths are unique',
    () {
      const routes = [
        AppRoutes.splash,
        AppRoutes.home,
        AppRoutes.prayer,
        AppRoutes.quran,
        AppRoutes.quranBookmarks,
        AppRoutes.activity,
        AppRoutes.menu,
        AppRoutes.settings,
        AppRoutes.qibla,
        AppRoutes.zakat,
        AppRoutes.hajj,
        AppRoutes.about,
        AppRoutes.privacy,
        AppRoutes.preferences,
        AppRoutes.tools,
        AppRoutes.tasbih,
        AppRoutes.infoCenter,
        AppRoutes.wuduGuide,
        AppRoutes.newMuslimJourney,
        AppRoutes.islamFoundations,
        AppRoutes.prayerGuide,
        AppRoutes.ghuslGuide,
        AppRoutes.duas,
        AppRoutes.ramadan,
        AppRoutes.ramadanGuide,
        AppRoutes.qurban,
        AppRoutes.qurbanGuide,
        AppRoutes.qurbanEidGuide,
        AppRoutes.hajjFundamentals,
        AppRoutes.ihramRules,
        AppRoutes.hajjTypes,
        AppRoutes.hajjDays,
        AppRoutes.umrahGuide,
        AppRoutes.hajjSpecialCases,
      ];

      expect(
        routes.toSet().length,
        routes.length,
      );
    },
  );
}
