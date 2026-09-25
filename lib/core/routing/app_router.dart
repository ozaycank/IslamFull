import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/activity/presentation/screens/activity_screen.dart';
import '../../features/dua/presentation/screens/duas_screen.dart';
import '../../features/guidance/presentation/screens/ghusl_guide_screen.dart';
import '../../features/guidance/presentation/screens/islam_foundations_screen.dart';
import '../../features/guidance/presentation/screens/new_muslim_journey_screen.dart';
import '../../features/guidance/presentation/screens/prayer_guide_screen.dart';
import '../../features/hajj/presentation/screens/hajj_guide_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/info/presentation/info_center_screen.dart';
import '../../features/info/presentation/wudu_guide_screen.dart';
import '../../features/menu/presentation/screens/about_screen.dart';
import '../../features/menu/presentation/screens/menu_screen.dart';
import '../../features/menu/presentation/screens/preferences_screen.dart';
import '../../features/menu/presentation/screens/privacy_screen.dart';
import '../../features/prayer/qibla/presentation/qibla_screen.dart';
import '../../features/prayer/shared/presentation/screens/prayer_home_screen.dart';
import '../../features/quran/presentation/screens/quran_bookmarks_screen.dart';
import '../../features/quran/presentation/screens/quran_home_screen.dart';
import '../../features/quran/presentation/screens/surah_detail_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/shell/presentation/screens/app_shell_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/tools/presentation/islamic_tools_screen.dart';
import '../../features/tools/presentation/tasbih_screen.dart';
import '../../features/zakat/presentation/screens/zakat_calculator_screen.dart';
import '../../features/ramadan/presentation/screens/ramadan_hub_screen.dart';
import '../../features/ramadan/presentation/screens/ramadan_guide_screen.dart';
import '../../features/qurban/presentation/screens/qurban_guide_screen.dart';
import '../../features/qurban/presentation/screens/qurban_hub_screen.dart';
import '../di/injection_container.dart';
import '../logging/logger_service.dart';
import 'app_navigation_observer.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static GoRouter createRouter(
    WidgetRef ref, {
    String? initialLocation,
  }) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: initialLocation ?? AppRoutes.splash,
      observers: [
        AppNavigationObserver(
          getIt<LoggerService>(),
        ),
      ],
      routes: [
        GoRoute(
          path: AppRoutes.splash,
          builder: (context, state) => const SplashScreen(),
        ),

        // Full-screen routes
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: AppRoutes.settings,
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: AppRoutes.qibla,
          builder: (context, state) => const QiblaScreen(),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: AppRoutes.zakat,
          builder: (context, state) => const ZakatCalculatorScreen(),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: AppRoutes.hajj,
          builder: (context, state) => const HajjGuideScreen(),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: AppRoutes.about,
          builder: (context, state) => const AboutScreen(),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: AppRoutes.privacy,
          builder: (context, state) => const PrivacyScreen(),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: AppRoutes.preferences,
          builder: (context, state) => const PreferencesScreen(),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: AppRoutes.tools,
          builder: (context, state) => const IslamicToolsScreen(),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: AppRoutes.tasbih,
          builder: (context, state) => const TasbihScreen(),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: AppRoutes.infoCenter,
          builder: (context, state) => const InfoCenterScreen(),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: AppRoutes.newMuslimJourney,
          builder: (context, state) => const NewMuslimJourneyScreen(),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: AppRoutes.islamFoundations,
          builder: (context, state) => const IslamFoundationsScreen(),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: AppRoutes.wuduGuide,
          builder: (context, state) => const WuduGuideScreen(),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: AppRoutes.prayerGuide,
          builder: (context, state) => const PrayerGuideScreen(),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: AppRoutes.ghuslGuide,
          builder: (context, state) => const GhuslGuideScreen(),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: AppRoutes.duas,
          builder: (context, state) => const DuasScreen(),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: AppRoutes.ramadan,
          builder: (context, state) => const RamadanHubScreen(),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: AppRoutes.ramadanGuide,
          builder: (context, state) => const RamadanGuideScreen(),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: AppRoutes.qurban,
          builder: (context, state) => const QurbanHubScreen(),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: AppRoutes.qurbanGuide,
          builder: (context, state) => const QurbanGuideScreen(),
        ),

        StatefulShellRoute.indexedStack(
          builder: (
            context,
            state,
            navigationShell,
          ) {
            return AppShellScreen(
              navigationShell: navigationShell,
            );
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.home,
                  builder: (context, state) => const HomeScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.prayer,
                  builder: (context, state) => const PrayerHomeScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.quran,
                  builder: (context, state) => const QuranHomeScreen(),
                  routes: [
                    GoRoute(
                      path: 'bookmarks',
                      builder: (context, state) => const QuranBookmarksScreen(),
                    ),
                    GoRoute(
                      path: 'surah/:id',
                      builder: (context, state) {
                        final idStr = state.pathParameters['id'];

                        final id = int.tryParse(
                              idStr ?? '1',
                            ) ??
                            1;

                        final ayah = int.tryParse(
                          state.uri.queryParameters['ayah'] ?? '',
                        );

                        return SurahDetailScreen(
                          surahNumber: id,
                          jumpToAyah: ayah,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.activity,
                  builder: (context, state) => const ActivityScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.menu,
                  builder: (context, state) => const MenuScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
