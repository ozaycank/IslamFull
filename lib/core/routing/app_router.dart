import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/activity/presentation/screens/activity_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/prayer/qibla/presentation/qibla_screen.dart';
import '../../features/prayer/shared/presentation/screens/prayer_home_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/quran/presentation/screens/quran_bookmarks_screen.dart';
import '../../features/quran/presentation/screens/quran_home_screen.dart';
import '../../features/quran/presentation/screens/surah_detail_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/shell/presentation/screens/app_shell_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../di/injection_container.dart';
import '../logging/logger_service.dart';
import 'app_navigation_observer.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static GoRouter createRouter(WidgetRef ref) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: AppRoutes.splash,
      observers: [
        AppNavigationObserver(getIt<LoggerService>()),
      ],
      routes: [
        GoRoute(
          path: AppRoutes.splash,
          builder: (context, state) => const SplashScreen(),
        ),
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
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return AppShellScreen(navigationShell: navigationShell);
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
                        final id = int.tryParse(idStr ?? '1') ?? 1;
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
                  path: AppRoutes.profile,
                  builder: (context, state) => const ProfileScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
