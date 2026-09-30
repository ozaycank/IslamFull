import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../activity/application/activity_provider.dart';

class AppShellScreen extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const AppShellScreen({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    // Keeps Quran reading progress and Activity records synchronized while
    // the application shell is alive.
    ref.watch(quranActivityBridgeProvider);

    final l10n = context.l10n;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(
              Icons.home_outlined,
            ),
            selectedIcon: const Icon(
              Icons.home,
            ),
            label: l10n.navHome,
          ),
          NavigationDestination(
            icon: const Icon(
              Icons.access_time,
            ),
            selectedIcon: const Icon(
              Icons.access_time_filled,
            ),
            label: l10n.navPrayer,
          ),
          NavigationDestination(
            icon: const Icon(
              Icons.menu_book_outlined,
            ),
            selectedIcon: const Icon(
              Icons.menu_book,
            ),
            label: l10n.navQuran,
          ),
          NavigationDestination(
            icon: const Icon(
              Icons.fact_check_outlined,
            ),
            selectedIcon: const Icon(
              Icons.fact_check,
            ),
            label: l10n.navActivity,
          ),
          NavigationDestination(
            icon: const Icon(
              Icons.menu_open_outlined,
            ),
            selectedIcon: const Icon(
              Icons.menu,
            ),
            label: l10n.navMenu,
          ),
        ],
      ),
    );
  }
}
