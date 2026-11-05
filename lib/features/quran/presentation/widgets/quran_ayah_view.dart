import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../application/providers/quran_reader_settings_provider.dart';
import '../../domain/entities/ayah.dart';
import '../../domain/entities/quran_translation.dart';
import '../constants/quran_reader_typography.dart';

class QuranAyahView extends ConsumerWidget {
  final Ayah ayah;
  final bool isBookmarked;
  final VoidCallback onBookmarkToggle;
  final QuranTranslation? translation;
  final bool translationIsLoading;

  const QuranAyahView({
    super.key,
    required this.ayah,
    required this.isBookmarked,
    required this.onBookmarkToggle,
    this.translation,
    this.translationIsLoading = false,
  });

  /// Cleans repetitive Bismillah text from the first Ayah
  /// for Surahs other than Al-Fatihah and At-Tawbah.
  String _getCleanedAyahText() {
    final text = ayah.text;

    if (ayah.numberInSurah != 1) {
      return text;
    }

    // The bundled Uthmani dataset contains two valid Bismillah
    // spellings at the beginning of surah 95 and surah 97.
    const bismillahPrefixes = <String>[
      'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
      'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
      'بِّسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
    ];

    for (final prefix in bismillahPrefixes) {
      if (text.startsWith(prefix) && text.length > prefix.length) {
        return text.substring(prefix.length).trim();
      }
    }

    return text;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    final settingsState = ref.watch(
      quranReaderSettingsNotifierProvider,
    );

    final currentFontSize = settingsState.settings.arabicFontSize;

    // Arabic readers already see the original Quran text.
    // An Arabic translation file does not exist.
    final showTranslation = settingsState.settings.showTranslation &&
        Localizations.localeOf(context).languageCode != 'ar';

    final cleanedText = _getCleanedAyahText();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            textDirection: TextDirection.rtl,
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: cleanedText,
                        style: textTheme.headlineSmall?.copyWith(
                          fontSize: currentFontSize,
                          height: QuranReaderTypography.arabicLineHeight,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const WidgetSpan(
                        child: SizedBox(width: AppSpacing.sm),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: _AyahNumberMarker(
                          number: ayah.numberInSurah,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.justify,
                  textDirection: TextDirection.rtl,
                ),
              ),
              IconButton(
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: isBookmarked
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
                onPressed: onBookmarkToggle,
                tooltip: isBookmarked
                    ? context.l10n.quranBookmarkRemove
                    : context.l10n.quranBookmarkAdd,
              ),
            ],
          ),

          // Do not display an unavailable-translation message
          // while the translation provider is still loading.
          if (showTranslation && !translationIsLoading) ...[
            const SizedBox(height: AppSpacing.lg),
            if (translation != null)
              Text(
                translation!.text,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
                textAlign: TextAlign.left,
                textDirection: TextDirection.ltr,
              )
            else
              Text(
                context.l10n.quranTranslationUnavailable,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.error,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.left,
                textDirection: TextDirection.ltr,
              ),
          ],

          const SizedBox(height: AppSpacing.lg),
          Divider(color: colorScheme.surfaceContainerHighest),
        ],
      ),
    );
  }
}

class _AyahNumberMarker extends StatelessWidget {
  final int number;

  const _AyahNumberMarker({
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.5),
          width: 2,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        number.toString(),
        style: textTheme.labelLarge?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
