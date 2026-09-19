import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';

class IslamFoundationsScreen extends StatelessWidget {
  const IslamFoundationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = context.colorScheme;

    final pillars = [
      (
        title: l10n.pillarShahadaTitle,
        description: l10n.pillarShahadaDesc,
        icon: Icons.favorite_outline,
      ),
      (
        title: l10n.pillarPrayerTitle,
        description: l10n.pillarPrayerDesc,
        icon: Icons.mosque_outlined,
      ),
      (
        title: l10n.pillarZakatTitle,
        description: l10n.pillarZakatDesc,
        icon: Icons.volunteer_activism_outlined,
      ),
      (
        title: l10n.pillarFastingTitle,
        description: l10n.pillarFastingDesc,
        icon: Icons.nightlight_outlined,
      ),
      (
        title: l10n.pillarHajjTitle,
        description: l10n.pillarHajjDesc,
        icon: Icons.public_outlined,
      ),
    ];

    final faithArticles = [
      (
        title: l10n.faithAllahTitle,
        description: l10n.faithAllahDesc,
      ),
      (
        title: l10n.faithAngelsTitle,
        description: l10n.faithAngelsDesc,
      ),
      (
        title: l10n.faithBooksTitle,
        description: l10n.faithBooksDesc,
      ),
      (
        title: l10n.faithMessengersTitle,
        description: l10n.faithMessengersDesc,
      ),
      (
        title: l10n.faithLastDayTitle,
        description: l10n.faithLastDayDesc,
      ),
      (
        title: l10n.faithDivineDecreeTitle,
        description: l10n.faithDivineDecreeDesc,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.islamFoundationsTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          AppCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.auto_stories_outlined,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    l10n.islamFoundationsIntro,
                    style: textTheme.bodyLarge?.copyWith(
                      height: 1.45,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            l10n.fivePillarsTitle,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.fivePillarsIntro,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          for (var index = 0; index < pillars.length; index++) ...[
            _FoundationCard(
              number: index + 1,
              icon: pillars[index].icon,
              title: pillars[index].title,
              description: pillars[index].description,
            ),
            if (index != pillars.length - 1)
              const SizedBox(height: AppSpacing.md),
          ],
          const SizedBox(height: AppSpacing.xl),
          Text(
            l10n.articlesOfFaithTitle,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.articlesOfFaithIntro,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          for (var index = 0; index < faithArticles.length; index++) ...[
            _FaithCard(
              number: index + 1,
              title: faithArticles[index].title,
              description: faithArticles[index].description,
            ),
            if (index != faithArticles.length - 1)
              const SizedBox(height: AppSpacing.md),
          ],
          const SizedBox(height: AppSpacing.xl),
          AppCard(
            child: Text(
              l10n.islamFoundationsDisclaimer,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FoundationCard extends StatelessWidget {
  final int number;
  final IconData icon;
  final String title;
  final String description;

  const _FoundationCard({
    required this.number,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
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
                  '$number. $title',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  description,
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
    );
  }
}

class _FaithCard extends StatelessWidget {
  final int number;
  final String title;
  final String description;

  const _FaithCard({
    required this.number,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 19,
            backgroundColor: colorScheme.secondaryContainer,
            foregroundColor: colorScheme.onSecondaryContainer,
            child: Text(
              '$number',
              style: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  description,
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
    );
  }
}
