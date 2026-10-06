import 'package:flutter/material.dart';

import '../design_system/tokens/app_spacing.dart';
import 'app_card.dart';
import 'guide_illustration.dart';

/// Shared informational card for educational/guidance screens.
///
/// The icon is decorative because its meaning is already represented by text.
/// An optional illustration may be supplied when it adds instructional value.
class GuideInfoCard extends StatelessWidget {
  final IconData icon;
  final String description;
  final String? title;
  final String? source;
  final String? imagePath;

  const GuideInfoCard({
    super.key,
    required this.icon,
    required this.description,
    this.title,
    this.source,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (
              context,
              constraints,
            ) {
              final scaledBodySize = MediaQuery.textScalerOf(
                context,
              ).scale(
                textTheme.bodyLarge?.fontSize ?? 16,
              );

              final shouldStack =
                  constraints.maxWidth < 360 || scaledBodySize >= 22;

              final iconWidget = ExcludeSemantics(
                child: Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    color: colorScheme.onPrimaryContainer,
                    size: 24,
                  ),
                ),
              );

              final contentWidget = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null) ...[
                    Text(
                      title!,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.sm,
                    ),
                  ],
                  Text(
                    description,
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                  if (source != null) ...[
                    const SizedBox(
                      height: AppSpacing.sm,
                    ),
                    Text(
                      source!,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.4,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              );

              if (shouldStack) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    iconWidget,
                    const SizedBox(
                      height: AppSpacing.md,
                    ),
                    contentWidget,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  iconWidget,
                  const SizedBox(
                    width: AppSpacing.md,
                  ),
                  Expanded(
                    child: contentWidget,
                  ),
                ],
              );
            },
          ),
          if (imagePath != null && imagePath!.trim().isNotEmpty) ...[
            const SizedBox(
              height: AppSpacing.lg,
            ),
            GuideIllustration(
              imagePath: imagePath!,
            ),
          ],
        ],
      ),
    );
  }
}

/// Shared expandable topic card used by informational guidance screens.
///
/// Illustrations are optional and are shown only after the user expands a
/// topic, avoiding unnecessary visual density on long guidance pages.
class GuideTopicCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? source;
  final String? imagePath;

  const GuideTopicCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.source,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final scaledTitleSize = MediaQuery.textScalerOf(
      context,
    ).scale(
      textTheme.titleMedium?.fontSize ?? 16,
    );

    final showLeadingIcon = scaledTitleSize < 25;

    return AppCard(
      padding: EdgeInsets.zero,
      child: ExpansionTile(
        maintainState: true,
        shape: const Border(),
        collapsedShape: const Border(),
        tilePadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xs,
        ),
        childrenPadding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        leading: showLeadingIcon
            ? ExcludeSemantics(
                child: Container(
                  width: 42,
                  height: 42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: colorScheme.onPrimaryContainer,
                    size: 22,
                  ),
                ),
              )
            : null,
        title: Text(
          title,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              description,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.55,
              ),
            ),
          ),
          if (imagePath != null && imagePath!.trim().isNotEmpty) ...[
            const SizedBox(
              height: AppSpacing.md,
            ),
            GuideIllustration(
              imagePath: imagePath!,
            ),
          ],
          if (source != null) ...[
            const SizedBox(
              height: AppSpacing.md,
            ),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                source!,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
