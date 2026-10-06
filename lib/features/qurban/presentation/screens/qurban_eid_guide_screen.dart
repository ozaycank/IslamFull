import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/guide_content_cards.dart';
import '../../../../shared/widgets/section_header.dart';

class QurbanEidGuideScreen extends StatelessWidget {
  const QurbanEidGuideScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    final topics = [
      (
        icon: Icons.calendar_month_outlined,
        title: l10n.qurbanEidFirstDaysTitle,
        description: l10n.qurbanEidFirstDaysDesc,
      ),
      (
        icon: Icons.event_outlined,
        title: l10n.qurbanEidArafahTitle,
        description: l10n.qurbanEidArafahDesc,
      ),
      (
        icon: Icons.celebration_outlined,
        title: l10n.qurbanEidDaysTitle,
        description: l10n.qurbanEidDaysDesc,
      ),
      (
        icon: Icons.mosque_outlined,
        title: l10n.qurbanEidPrayerTitle,
        description: l10n.qurbanEidPrayerDesc,
      ),
      (
        icon: Icons.record_voice_over_outlined,
        title: l10n.qurbanEidTashriqTitle,
        description: l10n.qurbanEidTashriqDesc,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.qurbanEidGuideTitle,
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
                  description: l10n.qurbanEidGuideIntro,
                ),
                const SizedBox(
                  height: AppSpacing.xl,
                ),
                SectionHeader(
                  title: l10n.qurbanEidGuideTopicsTitle,
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
                AppCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ExcludeSemantics(
                        child: Icon(
                          Icons.format_quote_outlined,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(
                        width: AppSpacing.md,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.qurbanEidTashriqTextTitle,
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(
                              height: AppSpacing.sm,
                            ),
                            Text(
                              l10n.qurbanEidTashriqText,
                              style: textTheme.bodyLarge?.copyWith(
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: AppSpacing.xl,
                ),
                GuideInfoCard(
                  icon: Icons.info_outline,
                  description: l10n.qurbanEidSchoolNote,
                  source: l10n.qurbanGuideSourceNote,
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
