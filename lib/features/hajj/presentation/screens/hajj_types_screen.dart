import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/guide_content_cards.dart';
import '../../../../shared/widgets/section_header.dart';

class HajjTypesScreen extends StatelessWidget {
  const HajjTypesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final types = [
      (
        icon: Icons.looks_one_outlined,
        title: l10n.hajjTypeIfradTitle,
        description: l10n.hajjTypeIfradDesc,
      ),
      (
        icon: Icons.swap_horiz_outlined,
        title: l10n.hajjTypeTamattuTitle,
        description: l10n.hajjTypeTamattuDesc,
      ),
      (
        icon: Icons.link_outlined,
        title: l10n.hajjTypeQiranTitle,
        description: l10n.hajjTypeQiranDesc,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.hajjTypesTitle,
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
                  icon: Icons.compare_arrows_outlined,
                  description: l10n.hajjTypesIntro,
                ),
                const SizedBox(
                  height: AppSpacing.xl,
                ),
                SectionHeader(
                  title: l10n.hajjTypesThreeTitle,
                ),
                const SizedBox(
                  height: AppSpacing.sm,
                ),
                for (var index = 0; index < types.length; index++) ...[
                  GuideTopicCard(
                    icon: types[index].icon,
                    title: types[index].title,
                    description: types[index].description,
                  ),
                  if (index != types.length - 1)
                    const SizedBox(
                      height: AppSpacing.md,
                    ),
                ],
                const SizedBox(
                  height: AppSpacing.xl,
                ),
                GuideInfoCard(
                  icon: Icons.info_outline,
                  description: l10n.hajjTypesNote,
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
