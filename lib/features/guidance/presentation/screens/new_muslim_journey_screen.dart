import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../application/journey_progress_provider.dart';
import '../../domain/journey_step_id.dart';

class NewMuslimJourneyScreen extends ConsumerWidget {
  const NewMuslimJourneyScreen({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    final progress = ref.watch(
      journeyProgressProvider,
    );

    final notifier = ref.read(
      journeyProgressProvider.notifier,
    );

    final steps = [
      _JourneyStepData(
        id: JourneyStepId.foundations,
        icon: Icons.menu_book_outlined,
        title: l10n.newMuslimJourneyFoundationsTitle,
        description: l10n.newMuslimJourneyFoundationsDesc,
        navigate: () => context.push(
          AppRoutes.islamFoundations,
        ),
      ),
      _JourneyStepData(
        id: JourneyStepId.wudu,
        icon: Icons.clean_hands_outlined,
        title: l10n.newMuslimJourneyWuduTitle,
        description: l10n.newMuslimJourneyWuduDesc,
        navigate: () => context.push(
          AppRoutes.wuduGuide,
        ),
      ),
      _JourneyStepData(
        id: JourneyStepId.prayer,
        icon: Icons.mosque_outlined,
        title: l10n.newMuslimJourneyPrayerTitle,
        description: l10n.newMuslimJourneyPrayerDesc,
        navigate: () => context.push(
          AppRoutes.prayerGuide,
        ),
      ),
      _JourneyStepData(
        id: JourneyStepId.quran,
        icon: Icons.auto_stories_outlined,
        title: l10n.newMuslimJourneyQuranTitle,
        description: l10n.newMuslimJourneyQuranDesc,
        navigate: () => context.go(
          AppRoutes.quran,
        ),
      ),
      _JourneyStepData(
        id: JourneyStepId.duas,
        icon: Icons.volunteer_activism_outlined,
        title: l10n.newMuslimJourneyDuasTitle,
        description: l10n.newMuslimJourneyDuasDesc,
        navigate: () => context.push(
          AppRoutes.duas,
        ),
      ),
    ];

    Future<void> openStep(
      _JourneyStepData step,
    ) async {
      try {
        await notifier.markVisited(
          step.id,
        );
      } catch (_) {
        // Learning should remain accessible even if
        // local progress persistence temporarily fails.
      }

      if (!context.mounted) {
        return;
      }

      step.navigate();
    }

    Future<void> toggleReviewed(
      _JourneyStepData step,
    ) async {
      final reviewed = progress.isReviewed(
        step.id,
      );

      try {
        await notifier.setReviewed(
          step.id,
          !reviewed,
        );
      } catch (_) {
        if (!context.mounted) {
          return;
        }

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                l10n.settingsSaveFailed,
              ),
            ),
          );
      }
    }

    final continueStep = steps.firstWhere(
      (step) => step.id == progress.continueStep,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.newMuslimJourneyTitle,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(
          AppSpacing.lg,
        ),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.explore_outlined,
                    color: colorScheme.onPrimaryContainer,
                    size: 28,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  l10n.newMuslimJourneyWelcomeTitle,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.newMuslimJourneySubtitle,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            l10n.journeyLearningPathTitle,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.journeyLearningPathDesc,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.45,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: progress.isLoading
                ? null
                : () => openStep(
                      continueStep,
                    ),
            icon: const Icon(
              Icons.arrow_forward_outlined,
            ),
            label: Text(
              l10n.journeyContinueButton,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            l10n.newMuslimJourneyStartHere,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ...steps.asMap().entries.expand(
            (entry) {
              final index = entry.key;
              final step = entry.value;

              return [
                _JourneyStepCard(
                  stepNumber: index + 1,
                  icon: step.icon,
                  title: step.title,
                  description: step.description,
                  reviewed: progress.isReviewed(
                    step.id,
                  ),
                  enabled: !progress.isLoading,
                  onTap: () => openStep(
                    step,
                  ),
                  onToggleReviewed: () => toggleReviewed(
                    step,
                  ),
                ),
                if (index != steps.length - 1)
                  const SizedBox(
                    height: AppSpacing.md,
                  ),
              ];
            },
          ),
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
                        l10n.newMuslimJourneyNoteTitle,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        l10n.newMuslimJourneyNoteBody,
                        style: textTheme.bodyMedium?.copyWith(
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
        ],
      ),
    );
  }
}

class _JourneyStepCard extends StatelessWidget {
  final int stepNumber;
  final IconData icon;
  final String title;
  final String description;
  final bool reviewed;
  final bool enabled;
  final VoidCallback onTap;
  final VoidCallback onToggleReviewed;

  const _JourneyStepCard({
    required this.stepNumber,
    required this.icon,
    required this.title,
    required this.description,
    required this.reviewed,
    required this.enabled,
    required this.onTap,
    required this.onToggleReviewed,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          InkWell(
            onTap: enabled ? onTap : null,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(
                AppSpacing.md,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      icon,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$stepNumber. $title',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          description,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            Icon(
                              reviewed
                                  ? Icons.check_circle_outline
                                  : Icons.circle_outlined,
                              size: 18,
                              color: reviewed
                                  ? colorScheme.primary
                                  : colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(
                              width: AppSpacing.xs,
                            ),
                            Text(
                              reviewed
                                  ? l10n.journeyReviewed
                                  : l10n.journeyNotReviewed,
                              style: textTheme.bodySmall?.copyWith(
                                color: reviewed
                                    ? colorScheme.primary
                                    : colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Icon(
                    Icons.chevron_right,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton.icon(
              onPressed: enabled ? onToggleReviewed : null,
              icon: Icon(
                reviewed
                    ? Icons.remove_circle_outline
                    : Icons.check_circle_outline,
                size: 18,
              ),
              label: Text(
                reviewed
                    ? l10n.journeyRemoveReviewed
                    : l10n.journeyMarkReviewed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _JourneyStepData {
  final JourneyStepId id;
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback navigate;

  const _JourneyStepData({
    required this.id,
    required this.icon,
    required this.title,
    required this.description,
    required this.navigate,
  });
}
