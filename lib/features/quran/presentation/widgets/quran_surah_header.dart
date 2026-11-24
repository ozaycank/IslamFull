import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../domain/entities/revelation_type.dart';
import '../../domain/entities/surah.dart';

class QuranSurahHeader extends StatelessWidget {
  final Surah surah;

  const QuranSurahHeader({
    super.key,
    required this.surah,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    final languageCode = l10n.localeName.split('_').first;

    final displayName = switch (languageCode) {
      'ar' => '',
      'tr' => surah.nameTurkish,
      _ => surah.nameTransliteration,
    };

    final revelationStr = surah.revelationType == RevelationType.makkah
        ? l10n.quranMeccan
        : l10n.quranMedinan;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: AppCard(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.xl,
          horizontal: AppSpacing.lg,
        ),
        child: Column(
          children: [
            // Surah illustration: separate area, no text overlay.
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                width: 112,
                height: 112,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(
                    AppAssets.surahHeader,
                    fit: BoxFit.contain,
                    excludeFromSemantics: true,
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Arabic surah name is now displayed independently.
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    surah.nameArabic,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    style: textTheme.headlineSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            if (displayName.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                displayName,
                textAlign: TextAlign.center,
                style: textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSecondaryContainer,
                ),
              ),
            ],

            const SizedBox(height: AppSpacing.md),

            Divider(
              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),

            const SizedBox(height: AppSpacing.md),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  revelationStr.toUpperCase(),
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSecondaryContainer,
                    letterSpacing: 1.5,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: Text('•'),
                ),
                Text(
                  l10n.quranAyahCount(surah.ayahCount).toUpperCase(),
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSecondaryContainer,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
