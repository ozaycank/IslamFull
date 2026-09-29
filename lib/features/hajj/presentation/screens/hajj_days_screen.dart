import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../guidance/presentation/widgets/guidance_step_card.dart';

class HajjDaysScreen extends StatelessWidget {
  const HajjDaysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.hajjDaysTitle,
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
                    l10n.hajjDaysIntro,
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
                  title: l10n.hajjDaysFlowTitle,
                ),
                const SizedBox(
                  height: AppSpacing.sm,
                ),
                GuidanceStepCard(
                  icon: Icons.flag_outlined,
                  title: l10n.hajjDay8Title,
                  description: l10n.hajjDay8Desc,
                ),
                const SizedBox(
                  height: AppSpacing.md,
                ),
                GuidanceStepCard(
                  icon: Icons.landscape_outlined,
                  title: l10n.hajjDay9Title,
                  description: l10n.hajjDay9Desc,
                ),
                const SizedBox(
                  height: AppSpacing.md,
                ),
                GuidanceStepCard(
                  icon: Icons.mosque_outlined,
                  title: l10n.hajjDay10Title,
                  description: l10n.hajjDay10Desc,
                ),
                const SizedBox(
                  height: AppSpacing.md,
                ),
                GuidanceStepCard(
                  icon: Icons.place_outlined,
                  title: l10n.hajjDays11And12Title,
                  description: l10n.hajjDays11And12Desc,
                ),
                const SizedBox(
                  height: AppSpacing.md,
                ),
                GuidanceStepCard(
                  icon: Icons.event_available_outlined,
                  title: l10n.hajjDay13Title,
                  description: l10n.hajjDay13Desc,
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
                              l10n.hajjDaysNote,
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
