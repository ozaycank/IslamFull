import 'package:flutter/material.dart';

import '../../../../../shared/design_system/tokens/app_border_radius.dart';
import '../../../../../shared/design_system/tokens/app_spacing.dart';

class PrayerSkeleton extends StatelessWidget {
  const PrayerSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final baseColor = Theme.of(context).colorScheme.surfaceContainerHighest;

    return ListView(
      padding: const EdgeInsets.all(
        AppSpacing.lg,
      ),
      children: [
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: AppBorderRadius.large,
          ),
        ),
        const SizedBox(
          height: AppSpacing.lg,
        ),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Container(
            height: 24,
            width: 140,
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: AppBorderRadius.small,
            ),
          ),
        ),
        const SizedBox(
          height: AppSpacing.md,
        ),
        ...List.generate(
          6,
          (index) => Container(
            height: 56,
            margin: const EdgeInsets.symmetric(
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: AppBorderRadius.medium,
            ),
          ),
        ),
      ],
    );
  }
}
