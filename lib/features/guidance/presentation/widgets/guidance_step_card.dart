import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/guide_illustration.dart';

class GuidanceStepCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? imagePath;

  const GuidanceStepCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (
              context,
              constraints,
            ) {
              final scaledTitleSize = MediaQuery.textScalerOf(
                context,
              ).scale(
                textTheme.titleMedium?.fontSize ?? 16,
              );

              final shouldStack =
                  constraints.maxWidth < 340 || scaledTitleSize >= 24;

              final iconWidget = ExcludeSemantics(
                child: Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              );

              final textWidget = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: AppSpacing.xs,
                  ),
                  Text(
                    description,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
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
                    textWidget,
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
                    child: textWidget,
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
