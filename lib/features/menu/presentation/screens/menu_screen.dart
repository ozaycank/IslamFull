import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/section_header.dart';

/// Central hub for application settings, personalization, tools,
/// educational content, and seasonal worship resources.
class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.navMenu,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(
          AppSpacing.lg,
        ),
        children: [
          // Settings
          SectionHeader(
            title: l10n.menuSettingsGroup,
          ),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _MenuTile(
                  icon: Icons.language,
                  title: l10n.menuLanguage,
                  onTap: () => context.push(
                    AppRoutes.settings,
                  ),
                ),
                const Divider(height: 1),
                _MenuTile(
                  icon: Icons.notifications_none,
                  title: l10n.menuNotifications,
                  onTap: () => context.push(
                    AppRoutes.settings,
                  ),
                ),
                const Divider(height: 1),
                _MenuTile(
                  icon: Icons.access_time,
                  title: l10n.menuPrayerCalc,
                  onTap: () => context.push(
                    AppRoutes.settings,
                  ),
                ),
                const Divider(height: 1),
                _MenuTile(
                  icon: Icons.location_on_outlined,
                  title: l10n.menuLocation,
                  onTap: () => context.push(
                    AppRoutes.settings,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: AppSpacing.xxl,
          ),

          // Personalization and personal records
          SectionHeader(
            title: l10n.menuPersonalizationGroup,
          ),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _MenuTile(
                  icon: Icons.fact_check_outlined,
                  title: l10n.menuWorshipRecords,
                  onTap: () => context.go(
                    AppRoutes.activity,
                  ),
                ),
                const Divider(height: 1),
                _MenuTile(
                  icon: Icons.tune,
                  title: l10n.menuPreferences,
                  onTap: () => context.push(
                    AppRoutes.preferences,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: AppSpacing.xxl,
          ),

          // Tools and information
          SectionHeader(
            title: l10n.menuToolsGroup,
          ),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _MenuTile(
                  icon: Icons.calendar_month_outlined,
                  title: l10n.ramadanTitle,
                  onTap: () => context.push(
                    AppRoutes.ramadan,
                  ),
                ),
                const Divider(height: 1),
                _MenuTile(
                  icon: Icons.volunteer_activism_outlined,
                  title: l10n.qurbanTitle,
                  onTap: () => context.push(
                    AppRoutes.qurban,
                  ),
                ),
                const Divider(height: 1),
                _MenuTile(
                  icon: Icons.auto_awesome_mosaic_outlined,
                  title: l10n.menuIslamicTools,
                  onTap: () => context.push(
                    AppRoutes.tools,
                  ),
                ),
                const Divider(height: 1),
                _MenuTile(
                  icon: Icons.menu_book_outlined,
                  title: l10n.menuInfoCenter,
                  onTap: () => context.push(
                    AppRoutes.infoCenter,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: AppSpacing.xxl,
          ),

          // App information
          SectionHeader(
            title: l10n.menuAppGroup,
          ),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _MenuTile(
                  icon: Icons.info_outline,
                  title: l10n.menuAbout,
                  onTap: () => context.push(
                    AppRoutes.about,
                  ),
                ),
                const Divider(height: 1),
                _MenuTile(
                  icon: Icons.privacy_tip_outlined,
                  title: l10n.menuPrivacy,
                  onTap: () => context.push(
                    AppRoutes.privacy,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: AppSpacing.xxl,
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: context.colorScheme.primary,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        size: 20,
      ),
      onTap: onTap,
    );
  }
}
