import 'package:flutter/material.dart';

import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';

class LegalSectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const LegalSectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      container: true,
      child: AppCard(
        child: LayoutBuilder(
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
                constraints.maxWidth < 360 || scaledTitleSize >= 23;

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
                Semantics(
                  header: true,
                  child: Text(
                    title,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(
                  height: AppSpacing.sm,
                ),
                Text(
                  description,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.55,
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
      ),
    );
  }
}
