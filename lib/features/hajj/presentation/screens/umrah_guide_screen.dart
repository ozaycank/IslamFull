import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/guide_content_cards.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../guidance/presentation/widgets/guidance_step_card.dart';

class UmrahGuideScreen extends StatelessWidget {
  const UmrahGuideScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.umrahGuideTitle,
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
                  icon: Icons.directions_walk_outlined,
                  description: l10n.umrahGuideIntro,
                ),
                const SizedBox(
                  height: AppSpacing.xl,
                ),
                SectionHeader(
                  title: l10n.umrahGuideStepsTitle,
                ),
                const SizedBox(
                  height: AppSpacing.sm,
                ),
                GuidanceStepCard(
                  icon: Icons.flag_outlined,
                  title: l10n.umrahGuideStep1Title,
                  description: l10n.umrahGuideStep1Desc,
                ),
                const SizedBox(
                  height: AppSpacing.md,
                ),
                GuidanceStepCard(
                  icon: Icons.autorenew,
                  title: l10n.umrahGuideStep2Title,
                  description: l10n.umrahGuideStep2Desc,
                ),
                const SizedBox(
                  height: AppSpacing.md,
                ),
                GuidanceStepCard(
                  icon: Icons.directions_walk_outlined,
                  title: l10n.umrahGuideStep3Title,
                  description: l10n.umrahGuideStep3Desc,
                ),
                const SizedBox(
                  height: AppSpacing.md,
                ),
                GuidanceStepCard(
                  icon: Icons.content_cut,
                  title: l10n.umrahGuideStep4Title,
                  description: l10n.umrahGuideStep4Desc,
                ),
                const SizedBox(
                  height: AppSpacing.xl,
                ),
                GuideInfoCard(
                  icon: Icons.info_outline,
                  description: l10n.umrahGuideSchoolNote,
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
