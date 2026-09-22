import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';

class InfoCenterScreen extends StatelessWidget {
  const InfoCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.infoCenterTitle,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.menu_book_outlined,
                  color: colorScheme.primary,
                  size: 30,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.infoCenterWelcomeTitle,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  l10n.infoCenterWelcomeDesc,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            l10n.infoCenterLearningGuides,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.explore_outlined,
                    color: colorScheme.primary,
                  ),
                  title: Text(
                    l10n.newMuslimJourneyTitle,
                  ),
                  subtitle: Text(
                    l10n.newMuslimJourneyMenuDesc,
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                  ),
                  onTap: () => context.push(
                    AppRoutes.newMuslimJourney,
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    Icons.auto_stories_outlined,
                    color: colorScheme.primary,
                  ),
                  title: Text(
                    l10n.islamFoundationsTitle,
                  ),
                  subtitle: Text(
                    l10n.islamFoundationsMenuDesc,
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                  ),
                  onTap: () => context.push(
                    AppRoutes.islamFoundations,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            l10n.infoCenterWorshipGuides,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.mosque_outlined,
                    color: colorScheme.primary,
                  ),
                  title: Text(
                    l10n.prayerGuideTitle,
                  ),
                  subtitle: Text(
                    l10n.prayerGuideMenuDesc,
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                  ),
                  onTap: () => context.push(
                    AppRoutes.prayerGuide,
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    Icons.clean_hands_outlined,
                    color: colorScheme.primary,
                  ),
                  title: Text(
                    l10n.wuduGuideTitle,
                  ),
                  subtitle: Text(
                    l10n.wuduGuideMenuDesc,
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                  ),
                  onTap: () => context.push(
                    AppRoutes.wuduGuide,
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    Icons.shower_outlined,
                    color: colorScheme.primary,
                  ),
                  title: Text(
                    l10n.ghuslGuideTitle,
                  ),
                  subtitle: Text(
                    l10n.ghuslGuideMenuDesc,
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                  ),
                  onTap: () => context.push(
                    AppRoutes.ghuslGuide,
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    Icons.volunteer_activism_outlined,
                    color: colorScheme.primary,
                  ),
                  title: Text(
                    l10n.duasTitle,
                  ),
                  subtitle: Text(
                    l10n.duasMenuDesc,
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                  ),
                  onTap: () => context.push(
                    AppRoutes.duas,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
