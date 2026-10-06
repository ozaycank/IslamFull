import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/guide_content_cards.dart';

class RamadanGuideScreen extends StatelessWidget {
  const RamadanGuideScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

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
        title: Text(
          l10n.ramadanGuideTitle,
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
                GuideInfoCard(
                  icon: Icons.menu_book_outlined,
                  description: l10n.ramadanGuideIntro,
                ),
                const SizedBox(
                  height: AppSpacing.xl,
                ),
                for (var index = 0; index < topics.length; index++) ...[
                  GuideTopicCard(
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
                GuideInfoCard(
                  icon: Icons.health_and_safety_outlined,
                  title: l10n.ramadanGuideImportantNoteTitle,
                  description: l10n.ramadanGuideImportantNote,
                ),
                const SizedBox(
                  height: AppSpacing.md,
                ),
                Text(
                  l10n.ramadanGuideSourceNote,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
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
