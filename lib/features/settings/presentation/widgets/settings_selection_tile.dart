import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';

class SettingsSelectionTile extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onTap;
  final bool isLoading;

  const SettingsSelectionTile({
    super.key,
    required this.title,
    required this.value,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    return Semantics(
      button: true,
      enabled: !isLoading,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: LayoutBuilder(
            builder: (
              context,
              constraints,
            ) {
              final baseFontSize = textTheme.bodyMedium?.fontSize ?? 14;

              final scaledFontSize = MediaQuery.textScalerOf(
                context,
              ).scale(
                baseFontSize,
              );

              final shouldStack =
                  constraints.maxWidth < 360 || scaledFontSize >= 20;

              final titleWidget = Text(
                title,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              );

              final valueWidget = isLoading
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        semanticsLabel: title,
                      ),
                    )
                  : Text(
                      value,
                      textAlign: TextAlign.end,
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    );

              final chevron = Icon(
                Icons.chevron_right,
                size: 18,
                color: colorScheme.onSurfaceVariant,
              );

              if (shouldStack) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleWidget,
                    const SizedBox(
                      height: AppSpacing.sm,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: valueWidget,
                          ),
                        ),
                        const SizedBox(
                          width: AppSpacing.sm,
                        ),
                        chevron,
                      ],
                    ),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: titleWidget,
                  ),
                  const SizedBox(
                    width: AppSpacing.md,
                  ),
                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: valueWidget,
                    ),
                  ),
                  const SizedBox(
                    width: AppSpacing.xs,
                  ),
                  chevron,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
