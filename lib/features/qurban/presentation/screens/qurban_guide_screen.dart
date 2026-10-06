import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/guide_content_cards.dart';
import '../../../../shared/widgets/section_header.dart';

class QurbanGuideScreen extends StatelessWidget {
  const QurbanGuideScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

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
                GuideInfoCard(
                  icon: Icons.menu_book_outlined,
                  description: l10n.qurbanGuideIntro,
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
                  GuideTopicCard(
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
                GuideInfoCard(
                  icon: Icons.info_outline,
                  description: l10n.qurbanGuideSchoolNote,
                  source: l10n.qurbanGuideSourceNote,
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
