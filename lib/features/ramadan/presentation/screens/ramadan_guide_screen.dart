import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';

class RamadanGuideScreen extends StatelessWidget {
  const RamadanGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    final topics = [
      (
        icon: Icons.nights_stay_outlined,
        title: l10n.ramadanGuideFastingTitle,
        description: l10n.ramadanGuideFastingDesc,
        source: l10n.ramadanGuideFastingSource,
      ),
      (
        icon: Icons.restaurant_outlined,
        title: l10n.ramadanGuideSahurIftarTitle,
        description: l10n.ramadanGuideSahurIftarDesc,
        source: l10n.ramadanGuideSahurIftarSource,
      ),
      (
        icon: Icons.help_outline,
        title: l10n.ramadanGuideBreaksFastTitle,
        description: l10n.ramadanGuideBreaksFastDesc,
        source: l10n.ramadanGuideBreaksFastSource,
      ),
      (
        icon: Icons.mosque_outlined,
        title: l10n.ramadanGuideTarawihTitle,
        description: l10n.ramadanGuideTarawihDesc,
        source: l10n.ramadanGuideTarawihSource,
      ),
      (
        icon: Icons.volunteer_activism_outlined,
        title: l10n.ramadanGuideFitraFidyaTitle,
        description: l10n.ramadanGuideFitraFidyaDesc,
        source: l10n.ramadanGuideFitraFidyaSource,
      ),
      (
        icon: Icons.auto_awesome_outlined,
        title: l10n.ramadanGuideLaylatQadrTitle,
        description: l10n.ramadanGuideLaylatQadrDesc,
        source: l10n.ramadanGuideLaylatQadrSource,
      ),
      (
        icon: Icons.celebration_outlined,
        title: l10n.ramadanGuideEidTitle,
        description: l10n.ramadanGuideEidDesc,
        source: l10n.ramadanGuideEidSource,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.ramadanGuideTitle),
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
                          l10n.ramadanGuideIntro,
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
                for (var index = 0; index < topics.length; index++) ...[
                  _RamadanGuideTopicCard(
                    icon: topics[index].icon,
                    title: topics[index].title,
                    description: topics[index].description,
                    source: topics[index].source,
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
                        Icons.health_and_safety_outlined,
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
                              l10n.ramadanGuideImportantNoteTitle,
                              style: textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(
                              height: AppSpacing.xs,
                            ),
                            Text(
                              l10n.ramadanGuideImportantNote,
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: AppSpacing.md,
                ),
                Text(
                  l10n.ramadanGuideSourceNote,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
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

class _RamadanGuideTopicCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String source;

  const _RamadanGuideTopicCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.source,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return AppCard(
      padding: EdgeInsets.zero,
      child: ExpansionTile(
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
          const SizedBox(
            height: AppSpacing.md,
          ),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              source,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
