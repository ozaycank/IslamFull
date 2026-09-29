import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../guidance/presentation/widgets/guidance_step_card.dart';

class UmrahGuideScreen extends StatelessWidget {
  const UmrahGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

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
                AppCard(
                  child: Text(
                    l10n.umrahGuideIntro,
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
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
                AppCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(
                        width: AppSpacing.md,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.umrahGuideSchoolNote,
                              style: textTheme.bodyMedium?.copyWith(
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(
                              height: AppSpacing.sm,
                            ),
                            Text(
                              l10n.hajjUmrahSourceNote,
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
