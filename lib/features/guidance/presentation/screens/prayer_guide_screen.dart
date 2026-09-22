import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../widgets/guidance_step_card.dart';

class PrayerGuideScreen extends StatelessWidget {
  const PrayerGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;

    final steps = [
      (
        icon: Icons.front_hand_outlined,
        title: l10n.prayerGuideStep1Title,
        description: l10n.prayerGuideStep1Desc,
        imagePath: 'assets/images/prayer/step1.png',
      ),
      (
        icon: Icons.person_outline,
        title: l10n.prayerGuideStep2Title,
        description: l10n.prayerGuideStep2Desc,
        imagePath: 'assets/images/prayer/step2.png',
      ),
      (
        icon: Icons.keyboard_double_arrow_down,
        title: l10n.prayerGuideStep3Title,
        description: l10n.prayerGuideStep3Desc,
        imagePath: 'assets/images/prayer/step3.png',
      ),
      (
        icon: Icons.accessibility_new_outlined,
        title: l10n.prayerGuideStep4Title,
        description: l10n.prayerGuideStep4Desc,
        imagePath: 'assets/images/prayer/step4.png',
      ),
      (
        icon: Icons.vertical_align_bottom,
        title: l10n.prayerGuideStep5Title,
        description: l10n.prayerGuideStep5Desc,
        imagePath: 'assets/images/prayer/step5.png',
      ),
      (
        icon: Icons.replay_outlined,
        title: l10n.prayerGuideStep6Title,
        description: l10n.prayerGuideStep6Desc,
        imagePath: 'assets/images/prayer/step6.png',
      ),
      (
        icon: Icons.event_seat_outlined,
        title: l10n.prayerGuideStep7Title,
        description: l10n.prayerGuideStep7Desc,
        imagePath: 'assets/images/prayer/step7.png',
      ),
      (
        icon: Icons.compare_arrows_outlined,
        title: l10n.prayerGuideStep8Title,
        description: l10n.prayerGuideStep8Desc,
        imagePath: 'assets/images/prayer/step8.png',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.prayerGuideTitle,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          AppCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.mosque_outlined,
                  color: colorScheme.primary,
                  size: 30,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    l10n.prayerGuideIntro,
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          SectionHeader(
            title: l10n.prayerGuidePreparationTitle,
          ),
          AppCard(
            child: Text(
              l10n.prayerGuidePreparationDesc,
              style: context.textTheme.bodyMedium?.copyWith(
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SectionHeader(
            title: l10n.prayerGuideFarzRakahsTitle,
          ),
          AppCard(
            child: Row(
              children: [
                Icon(
                  Icons.format_list_numbered,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    l10n.prayerGuideFarzRakahsDesc,
                    style: context.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          SectionHeader(
            title: l10n.prayerGuideTwoRakahTitle,
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
          const SizedBox(height: AppSpacing.xl),
          AppCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.prayerGuideSchoolNote,
                        style: context.textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        l10n.guidanceSourceNote,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
