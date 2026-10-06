import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/guide_content_cards.dart';
import '../../guidance/presentation/widgets/guidance_step_card.dart';

class WuduGuideScreen extends StatelessWidget {
  const WuduGuideScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final steps = [
      (
        icon: Icons.favorite_outline,
        title: l10n.wuduStep1Title,
        description: l10n.wuduStep1Desc,
        imagePath: 'images/wudu/step1.png',
      ),
      (
        icon: Icons.wash_outlined,
        title: l10n.wuduStep2Title,
        description: l10n.wuduStep2Desc,
        imagePath: 'images/wudu/step2.png',
      ),
      (
        icon: Icons.water_drop_outlined,
        title: l10n.wuduStep3Title,
        description: l10n.wuduStep3Desc,
        imagePath: 'images/wudu/step3.png',
      ),
      (
        icon: Icons.air_outlined,
        title: l10n.wuduStep4Title,
        description: l10n.wuduStep4Desc,
        imagePath: 'images/wudu/step4.png',
      ),
      (
        icon: Icons.face_outlined,
        title: l10n.wuduStep5Title,
        description: l10n.wuduStep5Desc,
        imagePath: 'images/wudu/step5.png',
      ),
      (
        icon: Icons.back_hand_outlined,
        title: l10n.wuduStep6Title,
        description: l10n.wuduStep6Desc,
        imagePath: 'images/wudu/step6.png',
      ),
      (
        icon: Icons.accessibility_new_outlined,
        title: l10n.wuduStep7Title,
        description: l10n.wuduStep7Desc,
        imagePath: 'images/wudu/step7.png',
      ),
      (
        icon: Icons.hearing_outlined,
        title: l10n.wuduStep8Title,
        description: l10n.wuduStep8Desc,
        imagePath: 'images/wudu/step8.png',
      ),
      (
        icon: Icons.directions_walk_outlined,
        title: l10n.wuduStep9Title,
        description: l10n.wuduStep9Desc,
        imagePath: 'images/wudu/step9.png',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.wuduGuideTitle,
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
                  icon: Icons.water_drop_outlined,
                  description: l10n.wuduGuideIntro,
                ),
                const SizedBox(
                  height: AppSpacing.lg,
                ),
                for (var index = 0; index < steps.length; index++) ...[
                  GuidanceStepCard(
                    icon: steps[index].icon,
                    title: steps[index].title,
                    description: steps[index].description,
                    imagePath: steps[index].imagePath,
                  ),
                  if (index != steps.length - 1)
                    const SizedBox(
                      height: AppSpacing.md,
                    ),
                ],
                const SizedBox(
                  height: AppSpacing.xl,
                ),
                GuideInfoCard(
                  icon: Icons.info_outline,
                  description: l10n.wuduGuideSchoolNote,
                  source: l10n.guidanceSourceNote,
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
