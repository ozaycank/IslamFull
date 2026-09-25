import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/section_header.dart';

class QurbanGuideScreen extends StatelessWidget {
  const QurbanGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    final topics = [
      (
        icon: Icons.favorite_outline,
        title: l10n.qurbanGuideMeaningTitle,
        description: l10n.qurbanGuideMeaningDesc,
      ),
      (
        icon: Icons.person_outline,
        title: l10n.qurbanGuideResponsibilityTitle,
        description: l10n.qurbanGuideResponsibilityDesc,
      ),
      (
        icon: Icons.pets_outlined,
        title: l10n.qurbanGuideAnimalsTitle,
        description: l10n.qurbanGuideAnimalsDesc,
      ),
      (
        icon: Icons.groups_outlined,
        title: l10n.qurbanGuideSharesTitle,
        description: l10n.qurbanGuideSharesDesc,
      ),
      (
        icon: Icons.schedule_outlined,
        title: l10n.qurbanGuideTimeTitle,
        description: l10n.qurbanGuideTimeDesc,
      ),
      (
        icon: Icons.handshake_outlined,
        title: l10n.qurbanGuideProxyTitle,
        description: l10n.qurbanGuideProxyDesc,
      ),
      (
        icon: Icons.volunteer_activism_outlined,
        title: l10n.qurbanGuideMeatTitle,
        description: l10n.qurbanGuideMeatDesc,
      ),
      (
        icon: Icons.fact_check_outlined,
        title: l10n.qurbanGuideMisconceptionsTitle,
        description: l10n.qurbanGuideMisconceptionsDesc,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.qurbanGuideTitle,
        ),
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 800,
            ),
            child: ListView(
              padding: const EdgeInsets.all(
                AppSpacing.lg,
              ),
              children: [
                AppCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.menu_book_outlined,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(
                        width: AppSpacing.md,
                      ),
                      Expanded(
                        child: Text(
                          l10n.qurbanGuideIntro,
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: AppSpacing.xl,
                ),
                SectionHeader(
                  title: l10n.qurbanGuideTopicsTitle,
                ),
                const SizedBox(
                  height: AppSpacing.sm,
                ),
                for (var index = 0; index < topics.length; index++) ...[
                  _QurbanGuideTopicCard(
                    icon: topics[index].icon,
                    title: topics[index].title,
                    description: topics[index].description,
                  ),
                  if (index != topics.length - 1)
                    const SizedBox(
                      height: AppSpacing.md,
                    ),
                ],
                const SizedBox(
                  height: AppSpacing.xl,
                ),
                AppCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(
                        width: AppSpacing.md,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.qurbanGuideSchoolNote,
                              style: textTheme.bodyMedium?.copyWith(
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(
                              height: AppSpacing.sm,
                            ),
                            Text(
                              l10n.qurbanGuideSourceNote,
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                height: 1.4,
                              ),
                            ),
                          ],
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
          ),
        ),
      ),
    );
  }
}

class _QurbanGuideTopicCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _QurbanGuideTopicCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return AppCard(
      padding: EdgeInsets.zero,
      child: ExpansionTile(
        shape: const Border(),
        collapsedShape: const Border(),
        tilePadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xs,
        ),
        childrenPadding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        leading: Container(
          width: 42,
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: colorScheme.onPrimaryContainer,
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              description,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
