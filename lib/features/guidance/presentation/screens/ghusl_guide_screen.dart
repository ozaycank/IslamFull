import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../widgets/guidance_step_card.dart';

class GhuslGuideScreen extends StatelessWidget {
  const GhuslGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;

    final steps = [
      (
        icon: Icons.favorite_outline,
        title: l10n.ghuslStep1Title,
        description: l10n.ghuslStep1Desc,
        imagePath: 'images/ghusl/step1.png',
      ),
      (
        icon: Icons.cleaning_services_outlined,
        title: l10n.ghuslStep2Title,
        description: l10n.ghuslStep2Desc,
        imagePath: 'images/ghusl/step2.png',
      ),
      (
        icon: Icons.water_drop_outlined,
        title: l10n.ghuslStep3Title,
        description: l10n.ghuslStep3Desc,
        imagePath: 'images/ghusl/step3.png',
      ),
      (
        icon: Icons.wash_outlined,
        title: l10n.ghuslStep4Title,
        description: l10n.ghuslStep4Desc,
        imagePath: 'images/ghusl/step4.png',
      ),
      (
        icon: Icons.shower_outlined,
        title: l10n.ghuslStep5Title,
        description: l10n.ghuslStep5Desc,
        imagePath: 'images/ghusl/step5.png',
      ),
      (
        icon: Icons.accessibility_new_outlined,
        title: l10n.ghuslStep6Title,
        description: l10n.ghuslStep6Desc,
        imagePath: 'images/ghusl/step6.png',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.ghuslGuideTitle,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          AppCard(
            child: Text(
              l10n.ghuslGuideIntro,
              style: context.textTheme.bodyLarge?.copyWith(
                height: 1.5,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          SectionHeader(
            title: l10n.ghuslWhenRequiredTitle,
          ),
          AppCard(
            child: Text(
              l10n.ghuslWhenRequiredDesc,
              style: context.textTheme.bodyMedium?.copyWith(
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.ghuslSchoolNote,
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
    );
  }
}
