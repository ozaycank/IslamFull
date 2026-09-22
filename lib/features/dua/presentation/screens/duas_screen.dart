import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';

class DuasScreen extends StatelessWidget {
  const DuasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    final everydayDuas = [
      _DuaEntry(
        icon: Icons.wb_sunny_outlined,
        title: l10n.duaWakeTitle,
        when: l10n.duaWakeWhen,
        arabic: l10n.duaWakeArabic,
        transliteration: l10n.duaWakeTransliteration,
        meaning: l10n.duaWakeMeaning,
        source: l10n.duaWakeSource,
      ),
      _DuaEntry(
        icon: Icons.bedtime_outlined,
        title: l10n.duaSleepTitle,
        when: l10n.duaSleepWhen,
        arabic: l10n.duaSleepArabic,
        transliteration: l10n.duaSleepTransliteration,
        meaning: l10n.duaSleepMeaning,
        source: l10n.duaSleepSource,
      ),
      _DuaEntry(
        icon: Icons.door_front_door_outlined,
        title: l10n.duaLeavingHomeTitle,
        when: l10n.duaLeavingHomeWhen,
        arabic: l10n.duaLeavingHomeArabic,
        transliteration: l10n.duaLeavingHomeTransliteration,
        meaning: l10n.duaLeavingHomeMeaning,
        source: l10n.duaLeavingHomeSource,
      ),
      _DuaEntry(
        icon: Icons.wash_outlined,
        title: l10n.duaRestroomTitle,
        when: l10n.duaRestroomWhen,
        arabic: l10n.duaRestroomArabic,
        transliteration: l10n.duaRestroomTransliteration,
        meaning: l10n.duaRestroomMeaning,
        source: l10n.duaRestroomSource,
      ),
      _DuaEntry(
        icon: Icons.restaurant_outlined,
        title: l10n.duaAfterMealTitle,
        when: l10n.duaAfterMealWhen,
        arabic: l10n.duaAfterMealArabic,
        transliteration: l10n.duaAfterMealTransliteration,
        meaning: l10n.duaAfterMealMeaning,
        source: l10n.duaAfterMealSource,
      ),
      _DuaEntry(
        icon: Icons.travel_explore_outlined,
        title: l10n.duaTravelTitle,
        when: l10n.duaTravelWhen,
        arabic: l10n.duaTravelArabic,
        transliteration: l10n.duaTravelTransliteration,
        meaning: l10n.duaTravelMeaning,
        source: l10n.duaTravelSource,
      ),
    ];

    final afterPrayerDuas = [
      _DuaEntry(
        icon: Icons.mosque_outlined,
        title: l10n.duaAfterPrayerDhikrTitle,
        when: l10n.duaAfterPrayerDhikrWhen,
        arabic: l10n.duaAfterPrayerDhikrArabic,
        transliteration: l10n.duaAfterPrayerDhikrTransliteration,
        meaning: l10n.duaAfterPrayerDhikrMeaning,
        source: l10n.duaAfterPrayerDhikrSource,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.duasTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
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
                    Icons.menu_book_outlined,
                    color: colorScheme.onPrimaryContainer,
                    size: 28,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  l10n.duasTitle,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.duasIntro,
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
            l10n.duasEverydaySection,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ...everydayDuas.expand(
            (dua) => [
              _DuaCard(dua: dua),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.duasAfterPrayerSection,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ...afterPrayerDuas.expand(
            (dua) => [
              _DuaCard(dua: dua),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
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
                  child: Text(
                    l10n.duasRecommendationNote,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.library_books_outlined,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    l10n.guidanceSourceNote,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

class _DuaCard extends StatelessWidget {
  final _DuaEntry dua;

  const _DuaCard({
    required this.dua,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return AppCard(
      padding: EdgeInsets.zero,
      child: ExpansionTile(
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            dua.icon,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(
          dua.title,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(
            top: AppSpacing.xs,
          ),
          child: Text(
            dua.when,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.35,
            ),
          ),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        children: [
          const Divider(),
          const SizedBox(height: AppSpacing.sm),
          _DuaDetailSection(
            label: l10n.duaArabicLabel,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: SelectableText(
                dua.arabic,
                textAlign: TextAlign.right,
                style: textTheme.headlineSmall?.copyWith(
                  height: 1.8,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _DuaDetailSection(
            label: l10n.duaTransliterationLabel,
            child: SelectableText(
              dua.transliteration,
              style: textTheme.bodyLarge?.copyWith(
                height: 1.55,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _DuaDetailSection(
            label: l10n.duaMeaningLabel,
            child: SelectableText(
              dua.meaning,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.55,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _DuaDetailSection(
            label: l10n.duaSourceLabel,
            child: SelectableText(
              dua.source,
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

class _DuaDetailSection extends StatelessWidget {
  final String label;
  final Widget child;

  const _DuaDetailSection({
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: textTheme.labelLarge?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        child,
      ],
    );
  }
}

class _DuaEntry {
  final IconData icon;
  final String title;
  final String when;
  final String arabic;
  final String transliteration;
  final String meaning;
  final String source;

  const _DuaEntry({
    required this.icon,
    required this.title,
    required this.when,
    required this.arabic,
    required this.transliteration,
    required this.meaning,
    required this.source,
  });
}
