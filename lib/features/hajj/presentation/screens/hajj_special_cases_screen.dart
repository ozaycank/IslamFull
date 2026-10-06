import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/guide_content_cards.dart';
import '../../../../shared/widgets/section_header.dart';

class HajjSpecialCasesScreen extends StatelessWidget {
  const HajjSpecialCasesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final topics = [
      (
        icon: Icons.location_on_outlined,
        title: l10n.hajjSpecialMiqatTitle,
        description: l10n.hajjSpecialMiqatDesc,
      ),
      (
        icon: Icons.health_and_safety_outlined,
        title: l10n.hajjSpecialMenstruationTitle,
        description: l10n.hajjSpecialMenstruationDesc,
      ),
      (
        icon: Icons.psychology_alt_outlined,
        title: l10n.hajjSpecialForgottenViolationTitle,
        description: l10n.hajjSpecialForgottenViolationDesc,
      ),
      (
        icon: Icons.medical_services_outlined,
        title: l10n.hajjSpecialMedicalNeedTitle,
        description: l10n.hajjSpecialMedicalNeedDesc,
      ),
      (
        icon: Icons.groups_outlined,
        title: l10n.hajjSpecialCrowdingTitle,
        description: l10n.hajjSpecialCrowdingDesc,
      ),
      (
        icon: Icons.content_cut,
        title: l10n.hajjSpecialEarlyHaircutTitle,
        description: l10n.hajjSpecialEarlyHaircutDesc,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.hajjSpecialCasesTitle,
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
                  icon: Icons.help_outline,
                  description: l10n.hajjSpecialCasesIntro,
                ),
                const SizedBox(
                  height: AppSpacing.xl,
                ),
                SectionHeader(
                  title: l10n.hajjSpecialCasesTopicsTitle,
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
                  description: l10n.hajjSpecialCasesNote,
                  source: l10n.hajjUmrahSourceNote,
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
