import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/guide_content_cards.dart';
import '../../../../shared/widgets/section_header.dart';

class IhramRulesScreen extends StatelessWidget {
  const IhramRulesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final topics = [
      (
        icon: Icons.flag_outlined,
        title: l10n.ihramRulesMeaningTitle,
        description: l10n.ihramRulesMeaningDesc,
        imagePath: null,
      ),
      (
        icon: Icons.checkroom_outlined,
        title: l10n.ihramRulesClothingTitle,
        description: l10n.ihramRulesClothingDesc,
        imagePath: 'images/hajj/ihram.png',
      ),
      (
        icon: Icons.content_cut,
        title: l10n.ihramRulesHairNailsTitle,
        description: l10n.ihramRulesHairNailsDesc,
        imagePath: null,
      ),
      (
        icon: Icons.spa_outlined,
        title: l10n.ihramRulesFragranceTitle,
        description: l10n.ihramRulesFragranceDesc,
        imagePath: null,
      ),
      (
        icon: Icons.shower_outlined,
        title: l10n.ihramRulesCleanlinessTitle,
        description: l10n.ihramRulesCleanlinessDesc,
        imagePath: null,
      ),
      (
        icon: Icons.family_restroom_outlined,
        title: l10n.ihramRulesIntimacyTitle,
        description: l10n.ihramRulesIntimacyDesc,
        imagePath: null,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.ihramRulesTitle,
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
                  icon: Icons.flag_outlined,
                  description: l10n.ihramRulesIntro,
                ),
                const SizedBox(
                  height: AppSpacing.xl,
                ),
                SectionHeader(
                  title: l10n.ihramRulesTopicsTitle,
                ),
                const SizedBox(
                  height: AppSpacing.sm,
                ),
                for (var index = 0; index < topics.length; index++) ...[
                  GuideTopicCard(
                    icon: topics[index].icon,
                    title: topics[index].title,
                    description: topics[index].description,
                    imagePath: topics[index].imagePath,
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
                  description: l10n.ihramRulesPenaltyNote,
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
