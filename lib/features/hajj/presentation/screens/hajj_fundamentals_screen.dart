import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/guide_content_cards.dart';
import '../../../../shared/widgets/section_header.dart';

class HajjFundamentalsScreen extends StatelessWidget {
  const HajjFundamentalsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final topics = [
      (
        icon: Icons.mosque_outlined,
        title: l10n.hajjFundamentalsMeaningTitle,
        description: l10n.hajjFundamentalsMeaningDesc,
        imagePath: null,
      ),
      (
        icon: Icons.flag_outlined,
        title: l10n.hajjFundamentalsIhramTitle,
        description: l10n.hajjFundamentalsIhramDesc,
        imagePath: 'images/hajj/ihram.png',
      ),
      (
        icon: Icons.autorenew,
        title: l10n.hajjFundamentalsTawafTitle,
        description: l10n.hajjFundamentalsTawafDesc,
        imagePath: 'images/hajj/tawaf.png',
      ),
      (
        icon: Icons.directions_walk_outlined,
        title: l10n.hajjFundamentalsSayTitle,
        description: l10n.hajjFundamentalsSayDesc,
        imagePath: 'images/hajj/say.png',
      ),
      (
        icon: Icons.landscape_outlined,
        title: l10n.hajjFundamentalsArafatTitle,
        description: l10n.hajjFundamentalsArafatDesc,
        imagePath: 'images/hajj/ritual_sites.png',
      ),
      (
        icon: Icons.nightlight_outlined,
        title: l10n.hajjFundamentalsMuzdalifahTitle,
        description: l10n.hajjFundamentalsMuzdalifahDesc,
        imagePath: null,
      ),
      (
        icon: Icons.place_outlined,
        title: l10n.hajjFundamentalsMinaTitle,
        description: l10n.hajjFundamentalsMinaDesc,
        imagePath: null,
      ),
      (
        icon: Icons.content_cut,
        title: l10n.hajjFundamentalsReleaseTitle,
        description: l10n.hajjFundamentalsReleaseDesc,
        imagePath: null,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.hajjFundamentalsTitle,
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
                  icon: Icons.auto_stories_outlined,
                  description: l10n.hajjFundamentalsIntro,
                ),
                const SizedBox(
                  height: AppSpacing.xl,
                ),
                SectionHeader(
                  title: l10n.hajjFundamentalsTopicsTitle,
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
                  description: l10n.hajjFundamentalsSchoolNote,
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
