import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../menu/application/preferences_provider.dart';
import '../../../prayer/location/application/providers/location_notifier.dart';
import '../../../prayer/prayer_times/application/providers/prayer_times_notifier.dart';
import '../../../prayer/prayer_times/domain/entities/prayer_time.dart';
import '../../../prayer/prayer_times/domain/value_objects/prayer_name.dart';
import '../../../prayer/prayer_times/presentation/providers/prayer_live_state_provider.dart';
import '../../../prayer/shared/presentation/utils/presentation_localizer.dart';
import '../../../quran/application/providers/daily_verse_provider.dart';
import '../../../quran/application/providers/quran_bookmark_provider.dart';
import '../../../quran/application/providers/quran_progress_provider.dart';
import '../../../quran/application/providers/quran_provider.dart';
import '../../../ramadan/application/ramadan_day_provider.dart';
import '../../../ramadan/domain/ramadan_day_state.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.homeDailyOverview,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 800,
            ),
            child: ListView(
              padding: const EdgeInsets.all(
                AppSpacing.lg,
              ),
              children: const [
                _HomeHeader(),
                SizedBox(height: AppSpacing.xl),
                _NextPrayerHero(),
                SizedBox(height: AppSpacing.xl),
                _RamadanShortcut(),
                _PrayerSummary(),
                SizedBox(height: AppSpacing.xl),
                _QuranContinueReading(),
                SizedBox(height: AppSpacing.xl),
                _DailyVerseCard(),
                SizedBox(height: AppSpacing.xl),
                _ShahadaCard(),
                SizedBox(height: AppSpacing.md),
                _QuranBookmarkShortcut(),
                SizedBox(height: AppSpacing.xl),
                _QuickActions(),
                SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Location and calendar information for the selected prayer location.
class _HomeHeader extends ConsumerWidget {
  const _HomeHeader();

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    final locationState = ref.watch(
      locationNotifierProvider,
    );

    final prayerState = ref.watch(
      prayerTimesNotifierProvider,
    );

    // Use the selected prayer location's timezone rather than the device
    // timezone so the displayed civil date stays aligned with the schedule.
    final targetNow = ref.watch(
      prayerTargetTimeProvider,
    );

    final gregorianDate = DateFormat.yMMMMd(
      l10n.localeName,
    ).format(targetNow);

    final rawHijriDate = prayerState.schedule?.today.hijriDateString;

    final hijriDate = rawHijriDate != null
        ? PresentationLocalizer.formatSmartHijri(
            context,
            rawHijriDate,
          )
        : '...';

    String locationText = l10n.homeLocationUnavailable;

    if (locationState.location != null) {
      final location = locationState.location!;

      if (location.cityName.isNotEmpty && location.countryName.isNotEmpty) {
        locationText = '${location.cityName}, ${location.countryName}';
      } else if (location.cityName.isNotEmpty) {
        locationText = location.cityName;
      }
    }

    final isLoading = locationState.status.toString().contains(
          'requesting',
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.location_on,
              color: colorScheme.primary,
              size: 20,
            ),
            const SizedBox(
              width: AppSpacing.sm,
            ),
            Expanded(
              child: Text(
                isLoading ? '...' : locationText,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: AppSpacing.md,
        ),
        Text(
          gregorianDate,
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: AppSpacing.xs,
        ),
        Text(
          hijriDate,
          style: textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Primary next-prayer information.
class _NextPrayerHero extends ConsumerWidget {
  const _NextPrayerHero();

  String _formatDuration(
    Duration duration,
  ) {
    final hours = duration.inHours.toString().padLeft(2, '0');

    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');

    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

    if (duration.inHours > 0) {
      return '$hours:$minutes:$seconds';
    }

    return '$minutes:$seconds';
  }

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    final liveState = ref.watch(
      prayerLiveStateProvider,
    );

    if (liveState.nextPrayer == null) {
      return const SizedBox.shrink();
    }

    final nextPrayer = liveState.nextPrayer!;

    final remaining = liveState.timeRemaining;

    return Card(
      elevation: 0,
      color: colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(
          AppSpacing.xl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.homeNextPrayer,
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onPrimary.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(
              height: AppSpacing.sm,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    _getLocalizedPrayerName(
                      context,
                      nextPrayer.name,
                    ),
                    style: textTheme.displaySmall?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  width: AppSpacing.md,
                ),
                Text(
                  DateFormat.Hm().format(
                    nextPrayer.time,
                  ),
                  style: textTheme.headlineMedium?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: AppSpacing.lg,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: colorScheme.onPrimary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.timer_outlined,
                    color: colorScheme.onPrimary,
                    size: 18,
                  ),
                  const SizedBox(
                    width: AppSpacing.sm,
                  ),
                  Text(
                    '${_formatDuration(remaining)} ${l10n.homeRemaining}',
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Seasonal Ramadan entry.
///
/// It is intentionally hidden outside Ramadan so Home remains focused during
/// the rest of the year.
class _RamadanShortcut extends ConsumerWidget {
  const _RamadanShortcut();

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final state = ref.watch(
      ramadanDayProvider,
    );

    if (!state.isRamadan) {
      return const SizedBox.shrink();
    }

    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    final countdownLabel = switch (state.phase) {
      RamadanDayPhase.beforeImsak => l10n.ramadanUntilImsak,
      RamadanDayPhase.fasting => l10n.ramadanUntilIftar,
      RamadanDayPhase.afterIftar => l10n.ramadanUntilTomorrowImsak,
      _ => l10n.ramadanTitle,
    };

    return Column(
      children: [
        Card(
          elevation: 0,
          clipBehavior: Clip.antiAlias,
          color: colorScheme.secondaryContainer.withValues(alpha: 0.65),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: InkWell(
            onTap: () => context.push(
              AppRoutes.ramadan,
            ),
            child: Padding(
              padding: const EdgeInsets.all(
                AppSpacing.lg,
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colorScheme.onSecondaryContainer
                          .withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.nights_stay_outlined,
                      color: colorScheme.onSecondaryContainer,
                    ),
                  ),
                  const SizedBox(
                    width: AppSpacing.md,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.ramadanTitle,
                          style: textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSecondaryContainer,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          height: AppSpacing.xs,
                        ),
                        Text(
                          countdownLabel,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSecondaryContainer.withValues(
                              alpha: 0.8,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: AppSpacing.xs,
                        ),
                        Text(
                          _formatRamadanDuration(
                            state.timeRemaining,
                          ),
                          style: textTheme.titleLarge?.copyWith(
                            color: colorScheme.onSecondaryContainer,
                            fontWeight: FontWeight.w700,
                            fontFeatures: const [
                              FontFeature.tabularFigures(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: AppSpacing.sm,
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: colorScheme.onSecondaryContainer,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: AppSpacing.xl,
        ),
      ],
    );
  }

  String _formatRamadanDuration(
    Duration duration,
  ) {
    final safeDuration = duration.isNegative ? Duration.zero : duration;

    final hours = safeDuration.inHours.toString().padLeft(2, '0');

    final minutes = (safeDuration.inMinutes % 60).toString().padLeft(2, '0');

    final seconds = (safeDuration.inSeconds % 60).toString().padLeft(2, '0');

    return '$hours:$minutes:$seconds';
  }
}

/// Today's prayer schedule.
///
/// On wide layouts all times remain on one row. On narrower layouts the
/// schedule wraps into two or three columns instead of overflowing.
class _PrayerSummary extends ConsumerWidget {
  const _PrayerSummary();

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    final prayerState = ref.watch(
      prayerTimesNotifierProvider,
    );

    final liveState = ref.watch(
      prayerLiveStateProvider,
    );

    if (prayerState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final prayers = prayerState.schedule?.today.prayerTimes ?? [];

    if (prayers.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.homePrayerTimes,
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: AppSpacing.md,
        ),
        Card(
          elevation: 0,
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(
              AppSpacing.md,
            ),
            child: LayoutBuilder(
              builder: (
                context,
                constraints,
              ) {
                if (constraints.maxWidth >= 680) {
                  return Row(
                    children: prayers.map(
                      (prayer) {
                        final isNext =
                            liveState.nextPrayer?.name == prayer.name;

                        return Expanded(
                          child: _PrayerTimeItem(
                            prayer: prayer,
                            isNext: isNext,
                          ),
                        );
                      },
                    ).toList(),
                  );
                }

                final columns = constraints.maxWidth >= 420 ? 3 : 2;

                const spacing = AppSpacing.sm;

                final itemWidth =
                    (constraints.maxWidth - (spacing * (columns - 1))) /
                        columns;

                return Wrap(
                  spacing: spacing,
                  runSpacing: AppSpacing.md,
                  children: prayers.map(
                    (prayer) {
                      final isNext = liveState.nextPrayer?.name == prayer.name;

                      return SizedBox(
                        width: itemWidth,
                        child: _PrayerTimeItem(
                          prayer: prayer,
                          isNext: isNext,
                        ),
                      );
                    },
                  ).toList(),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _PrayerTimeItem extends StatelessWidget {
  final PrayerTime prayer;
  final bool isNext;

  const _PrayerTimeItem({
    required this.prayer,
    required this.isNext,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _getLocalizedPrayerName(
            context,
            prayer.name,
          ),
          textAlign: TextAlign.center,
          style: textTheme.labelMedium?.copyWith(
            color: isNext ? colorScheme.primary : colorScheme.onSurfaceVariant,
            fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        const SizedBox(
          height: AppSpacing.xs,
        ),
        Text(
          DateFormat.Hm().format(
            prayer.time,
          ),
          textAlign: TextAlign.center,
          style: textTheme.titleMedium?.copyWith(
            color: isNext ? colorScheme.primary : colorScheme.onSurface,
            fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

/// Quran reading position.
class _QuranContinueReading extends ConsumerWidget {
  const _QuranContinueReading();

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    final progressState = ref.watch(
      quranProgressNotifierProvider,
    );

    final quranState = ref.watch(
      quranNotifierProvider,
    );

    final lastRead = progressState.lastRead;

    if (lastRead == null || quranState.surahs.isEmpty) {
      return const SizedBox.shrink();
    }

    final surah = quranState.surahs.firstWhere(
      (surah) => surah.number == lastRead.surahNumber,
      orElse: () => quranState.surahs.first,
    );

    final surahName =
        l10n.localeName == 'tr' ? surah.nameTurkish : surah.nameTransliteration;

    double progressPercent = 0;

    if (surah.ayahCount > 0) {
      progressPercent = (lastRead.ayahNumber / surah.ayahCount).clamp(0.0, 1.0);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.homeContinueReading,
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: AppSpacing.md,
        ),
        InkWell(
          onTap: () {
            context.push(
              '/quran/surah/${lastRead.surahNumber}',
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            padding: const EdgeInsets.all(
              AppSpacing.lg,
            ),
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color:
                        colorScheme.onSecondaryContainer.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.menu_book_rounded,
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
                const SizedBox(
                  width: AppSpacing.md,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        surahName,
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: AppSpacing.xs,
                      ),
                      Text(
                        '${l10n.quranAyah} ${lastRead.ayahNumber} / ${surah.ayahCount}',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSecondaryContainer.withValues(
                            alpha: 0.8,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: AppSpacing.sm,
                      ),
                      LinearProgressIndicator(
                        value: progressPercent,
                        backgroundColor:
                            colorScheme.onSecondaryContainer.withValues(
                          alpha: 0.2,
                        ),
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(
                          4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: AppSpacing.md,
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: colorScheme.onSecondaryContainer,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Deterministic daily Quran verse.
class _DailyVerseCard extends ConsumerWidget {
  const _DailyVerseCard();

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final showDailyVerse = ref.watch(
      showDailyVerseSettingProvider,
    );

    if (!showDailyVerse) {
      return const SizedBox.shrink();
    }

    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    final dailyVerse = ref.watch(
      dailyVerseProvider,
    );

    if (dailyVerse == null) {
      return const SizedBox.shrink();
    }

    final surahName = l10n.localeName == 'tr'
        ? dailyVerse.surah.nameTurkish
        : dailyVerse.surah.nameTransliteration;

    final languageCode = l10n.localeName == 'tr' ? 'tr' : 'en';

    final contentAsync = ref.watch(
      dailyVerseContentProvider(
        languageCode,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.dailyVerseTitle,
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: AppSpacing.md,
        ),
        InkWell(
          onTap: () => context.push(
            '/quran/surah/${dailyVerse.surah.number}?ayah=${dailyVerse.ayahNumber}',
          ),
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            padding: const EdgeInsets.all(
              AppSpacing.lg,
            ),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                contentAsync.when(
                  data: (content) {
                    if (content == null) {
                      return const SizedBox.shrink();
                    }

                    return Column(
                      children: [
                        Text(
                          'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
                          style: textTheme.titleMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: AppSpacing.md,
                        ),
                        Text(
                          content.arabicText,
                          style: textTheme.headlineSmall?.copyWith(
                            color: colorScheme.onSurface,
                            height: 1.8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: AppSpacing.md,
                        ),
                        Text(
                          content.translation,
                          style: textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  },
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(
                        AppSpacing.md,
                      ),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (
                    error,
                    stackTrace,
                  ) =>
                      Text(
                    l10n.homeDailyVerseLoadFailed,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colorScheme.error,
                    ),
                  ),
                ),
                const SizedBox(
                  height: AppSpacing.md,
                ),
                const Divider(),
                const SizedBox(
                  height: AppSpacing.sm,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$surahName · ${dailyVerse.ayahNumber}',
                      style: textTheme.labelLarge?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: colorScheme.primary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Shahada reference card.
class _ShahadaCard extends ConsumerWidget {
  const _ShahadaCard();

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xl,
        horizontal: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.secondary.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          Text(
            l10n.homeShahadaArabic,
            style: textTheme.headlineSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: AppSpacing.md,
          ),
          Text(
            l10n.homeShahadaTransliteration,
            style: textTheme.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic,
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Shortcut to Quran bookmarks when bookmarks exist.
class _QuranBookmarkShortcut extends ConsumerWidget {
  const _QuranBookmarkShortcut();

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;

    final bookmarkState = ref.watch(
      quranBookmarkNotifierProvider,
    );

    final count = bookmarkState.bookmarks.length;

    if (count == 0) {
      return const SizedBox.shrink();
    }

    return ListTile(
      onTap: () => context.push('/quran/bookmarks'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      tileColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
      leading: Icon(
        Icons.bookmarks,
        color: colorScheme.primary,
      ),
      title: Text(
        l10n.homeBookmarks,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        l10n.homeSavedAyahs(count),
      ),
      trailing: const Icon(
        Icons.chevron_right,
      ),
    );
  }
}

/// Frequently used application shortcuts.
class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      children: [
        Expanded(
          child: _QuickActionCard(
            icon: Icons.explore,
            label: l10n.homeQibla,
            onTap: () => context.push(
              AppRoutes.qibla,
            ),
          ),
        ),
        const SizedBox(
          width: AppSpacing.md,
        ),
        Expanded(
          child: _QuickActionCard(
            icon: Icons.calculate_outlined,
            label: l10n.menuZakatCalc,
            onTap: () => context.push(
              AppRoutes.zakat,
            ),
          ),
        ),
        const SizedBox(
          width: AppSpacing.md,
        ),
        Expanded(
          child: _QuickActionCard(
            icon: Icons.settings,
            label: l10n.homeSettings,
            onTap: () => context.push(
              AppRoutes.settings,
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.lg,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 28,
              color: colorScheme.onSurface,
            ),
            const SizedBox(
              height: AppSpacing.sm,
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _getLocalizedPrayerName(
  BuildContext context,
  PrayerName name,
) {
  final l10n = context.l10n;

  switch (name) {
    case PrayerName.fajr:
      return l10n.homePrayerFajr;
    case PrayerName.sunrise:
      return l10n.homePrayerSunrise;
    case PrayerName.dhuhr:
      return l10n.homePrayerDhuhr;
    case PrayerName.asr:
      return l10n.homePrayerAsr;
    case PrayerName.maghrib:
      return l10n.homePrayerMaghrib;
    case PrayerName.isha:
      return l10n.homePrayerIsha;
  }
}
