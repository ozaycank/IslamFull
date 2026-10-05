import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/error_state_widget.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../menu/application/preferences_provider.dart';
import '../../application/activity_provider.dart';
import '../../domain/activity_models.dart';
import '../../domain/activity_prayer_type.dart';
import '../../utils/activity_date_utils.dart';

/// Displays factual daily worship records.
///
/// The screen intentionally avoids scores, rewards, achievements,
/// competition, streak pressure, and other gamification mechanics.
class ActivityScreen extends ConsumerStatefulWidget {
  const ActivityScreen({
    super.key,
  });

  @override
  ConsumerState<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends ConsumerState<ActivityScreen> {
  String _localizePrayerType(
    ActivityPrayerType type,
    AppLocalizations l10n,
  ) {
    switch (type) {
      case ActivityPrayerType.fajr:
        return l10n.prayerFajr;
      case ActivityPrayerType.dhuhr:
        return l10n.prayerDhuhr;
      case ActivityPrayerType.asr:
        return l10n.prayerAsr;
      case ActivityPrayerType.maghrib:
        return l10n.prayerMaghrib;
      case ActivityPrayerType.isha:
        return l10n.prayerIsha;
    }
  }

  void _performHapticIfEnabled() {
    final enabled = ref.read(
      hapticFeedbackProvider,
    );

    if (enabled) {
      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    final state = ref.watch(
      activityNotifierProvider,
    );

    final notifier = ref.read(
      activityNotifierProvider.notifier,
    );

    final todayStr = DateFormat.yMMMMd(
      l10n.localeName,
    ).format(
      DateTime.now(),
    );

    const trackablePrayers = ActivityPrayerType.values;

    final completedPrayerCount = state.dailyActivity?.completedPrayers.values
            .where(
              (value) => value,
            )
            .length ??
        0;

    final quranReadToday = state.dailyActivity?.quranReadingOccurred ?? false;

    final interactionDisabled = state.isLoading || state.isSaving;

    Widget body;

    if (state.isLoading && state.dailyActivity == null) {
      body = Center(
        child: CircularProgressIndicator(
          semanticsLabel: l10n.activityTitle,
        ),
      );
    } else if (state.failure != null && state.dailyActivity == null) {
      body = ErrorStateWidget(
        title: l10n.errorStateDefaultTitle,
        message: state.failure!.message,
        retryText: l10n.retryButton,
        onRetry: () {
          notifier.loadToday();
        },
      );
    } else {
      body = RefreshIndicator(
        onRefresh: notifier.loadToday,
        child: ListView(
          padding: const EdgeInsets.all(
            AppSpacing.lg,
          ),
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            if (state.isSaving) ...[
              LinearProgressIndicator(
                semanticsLabel: l10n.activityTitle,
              ),
              const SizedBox(
                height: AppSpacing.md,
              ),
            ],
            if (state.failure != null) ...[
              Semantics(
                liveRegion: true,
                child: AppCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: colorScheme.error,
                      ),
                      const SizedBox(
                        width: AppSpacing.md,
                      ),
                      Expanded(
                        child: Text(
                          state.failure!.message,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: AppSpacing.lg,
              ),
            ],
            Text(
              todayStr,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(
              height: AppSpacing.xs,
            ),
            Text(
              l10n.activityMotivation,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(
              height: AppSpacing.xl,
            ),
            SectionHeader(
              title: l10n.activityToday,
            ),
            AppCard(
              child: Column(
                children: [
                  _ActivitySummaryRow(
                    icon: Icons.mosque_outlined,
                    label: l10n.activityPrayers,
                    value: '$completedPrayerCount/'
                        '${trackablePrayers.length}',
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                    ),
                    child: Divider(height: 1),
                  ),
                  _ActivitySummaryRow(
                    icon: Icons.auto_stories_outlined,
                    label: l10n.activityQuranReading,
                    value: quranReadToday
                        ? l10n.activityReadToday
                        : l10n.activityNotRecorded,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: AppSpacing.xl,
            ),
            SectionHeader(
              title: l10n.activityPrayers,
            ),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: trackablePrayers.map(
                  (prayer) {
                    final isRecorded =
                        state.dailyActivity?.completedPrayers[prayer] ?? false;

                    final isLast = prayer == trackablePrayers.last;

                    return Column(
                      children: [
                        _WorshipCard(
                          title: _localizePrayerType(
                            prayer,
                            l10n,
                          ),
                          isRecorded: isRecorded,
                          isDisabled: interactionDisabled,
                          onTap: () {
                            _performHapticIfEnabled();

                            notifier.togglePrayer(
                              prayer,
                            );
                          },
                          l10n: l10n,
                        ),
                        if (!isLast)
                          const Divider(
                            height: 1,
                          ),
                      ],
                    );
                  },
                ).toList(),
              ),
            ),
            const SizedBox(
              height: AppSpacing.md,
            ),
            AppCard(
              padding: EdgeInsets.zero,
              child: _WorshipCard(
                title: l10n.activityQuranReading,
                icon: Icons.menu_book_rounded,
                isRecorded: quranReadToday,
                isDisabled: interactionDisabled || quranReadToday,
                onTap: () {
                  _performHapticIfEnabled();

                  notifier.markQuranRead();
                },
                l10n: l10n,
              ),
            ),
            const SizedBox(
              height: AppSpacing.xxl,
            ),
            SectionHeader(
              title: l10n.activityStatistics,
            ),
            _buildStatisticsSummary(
              context,
              state,
            ),
            const SizedBox(
              height: AppSpacing.xxl,
            ),
            SectionHeader(
              title: l10n.activityHistory,
            ),
            if (state.history
                .where(
                  (record) => record.date != ActivityDateUtils.today(),
                )
                .isEmpty)
              _buildEmptyHistory(
                context,
                l10n,
              )
            else
              AppCard(
                padding: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  child: Column(
                    children: state.history
                        .where(
                          (record) => record.date != ActivityDateUtils.today(),
                        )
                        .take(10)
                        .map(
                          (record) => _buildHistoryItem(
                            context,
                            record,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            const SizedBox(
              height: AppSpacing.xxl,
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.activityTitle,
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 800,
            ),
            child: body,
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsSummary(
    BuildContext context,
    ActivityState state,
  ) {
    final l10n = context.l10n;

    final averageCompletion =
        ((state.statistics?.last7DaysCompletion ?? 0) * 100).round();

    final quranDays = state.statistics?.last7DaysQuran ?? 0;

    return LayoutBuilder(
      builder: (
        context,
        constraints,
      ) {
        final averageCard = _buildStatCard(
          context,
          l10n.statsAvgCompletion,
          '$averageCompletion%',
          Icons.fact_check_outlined,
        );

        final quranCard = _buildStatCard(
          context,
          l10n.statsQuranDays,
          l10n.statsDays(
            quranDays,
          ),
          Icons.auto_stories_outlined,
        );

        if (constraints.maxWidth < 520) {
          return Column(
            children: [
              averageCard,
              const SizedBox(
                height: AppSpacing.sm,
              ),
              quranCard,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: averageCard,
            ),
            const SizedBox(
              width: AppSpacing.sm,
            ),
            Expanded(
              child: quranCard,
            ),
          ],
        );
      },
    );
  }

  Widget _buildHistoryItem(
    BuildContext context,
    DailyActivity activity,
  ) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;

    final parsedDate = DateTime.tryParse(
          activity.date,
        ) ??
        DateTime.now();

    final displayDate = DateFormat.yMMMd(
      l10n.localeName,
    ).format(
      parsedDate,
    );

    final completedCount = activity.completedPrayers.values
        .where(
          (value) => value,
        )
        .length;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        Icons.calendar_today_outlined,
        color: colorScheme.primary,
      ),
      title: Text(
        displayDate,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        '$completedCount/'
        '${ActivityPrayerType.values.length} '
        '${l10n.activityPrayers}',
      ),
      trailing: activity.quranReadingOccurred
          ? Icon(
              Icons.auto_stories_outlined,
              color: colorScheme.primary,
              size: 20,
            )
          : null,
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return AppCard(
      child: LayoutBuilder(
        builder: (
          context,
          constraints,
        ) {
          final scaledFontSize = MediaQuery.textScalerOf(
            context,
          ).scale(
            textTheme.bodyMedium?.fontSize ?? 14,
          );

          final shouldStack =
              constraints.maxWidth < 260 || scaledFontSize >= 20;

          final iconWidget = Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(
                12,
              ),
            ),
            child: Icon(
              icon,
              color: colorScheme.onPrimaryContainer,
              size: 22,
            ),
          );

          final titleWidget = Text(
            title,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          );

          final valueWidget = Text(
            value,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          );

          if (shouldStack) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                iconWidget,
                const SizedBox(
                  height: AppSpacing.md,
                ),
                titleWidget,
                const SizedBox(
                  height: AppSpacing.xs,
                ),
                valueWidget,
              ],
            );
          }

          return Row(
            children: [
              iconWidget,
              const SizedBox(
                width: AppSpacing.md,
              ),
              Expanded(
                child: titleWidget,
              ),
              const SizedBox(
                width: AppSpacing.sm,
              ),
              valueWidget,
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyHistory(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(
          AppSpacing.lg,
        ),
        child: Column(
          children: [
            ExcludeSemantics(
              child: Icon(
                Icons.history_outlined,
                size: 44,
                color: colorScheme.primary.withValues(
                  alpha: 0.6,
                ),
              ),
            ),
            const SizedBox(
              height: AppSpacing.md,
            ),
            Text(
              l10n.activityHistoryEmptyDesc,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivitySummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ActivitySummaryRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return LayoutBuilder(
      builder: (
        context,
        constraints,
      ) {
        final scaledFontSize = MediaQuery.textScalerOf(
          context,
        ).scale(
          textTheme.bodyLarge?.fontSize ?? 16,
        );

        final shouldStack = constraints.maxWidth < 320 || scaledFontSize >= 22;

        final iconWidget = Icon(
          icon,
          color: colorScheme.primary,
          size: 22,
        );

        final labelWidget = Text(
          label,
          style: textTheme.bodyLarge,
        );

        final valueWidget = Text(
          value,
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        );

        if (shouldStack) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              iconWidget,
              const SizedBox(
                width: AppSpacing.md,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    labelWidget,
                    const SizedBox(
                      height: AppSpacing.xs,
                    ),
                    valueWidget,
                  ],
                ),
              ),
            ],
          );
        }

        return Row(
          children: [
            iconWidget,
            const SizedBox(
              width: AppSpacing.md,
            ),
            Expanded(
              child: labelWidget,
            ),
            const SizedBox(
              width: AppSpacing.sm,
            ),
            valueWidget,
          ],
        );
      },
    );
  }
}

/// A factual record control.
///
/// The selected state means that the user has recorded the worship item.
/// It does not represent a reward, score, achievement, or competition state.
class _WorshipCard extends StatelessWidget {
  final String title;
  final IconData? icon;
  final bool isRecorded;
  final bool isDisabled;
  final VoidCallback onTap;
  final AppLocalizations l10n;

  const _WorshipCard({
    required this.title,
    this.icon,
    required this.isRecorded,
    required this.onTap,
    required this.l10n,
    this.isDisabled = false,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    final statusText =
        isRecorded ? l10n.activityCompleted : l10n.activityNotRecorded;

    return Semantics(
      container: true,
      button: true,
      enabled: !isDisabled,
      selected: isRecorded,
      label: title,
      value: statusText,
      excludeSemantics: true,
      child: InkWell(
        onTap: isDisabled ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.all(
            AppSpacing.lg,
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: isRecorded
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                  size: 24,
                ),
                const SizedBox(
                  width: AppSpacing.md,
                ),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      statusText,
                      style: textTheme.bodySmall?.copyWith(
                        color: isRecorded
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: AppSpacing.sm,
              ),
              AnimatedContainer(
                duration: const Duration(
                  milliseconds: 180,
                ),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isRecorded ? colorScheme.primary : Colors.transparent,
                  border: Border.all(
                    color: isRecorded
                        ? colorScheme.primary
                        : colorScheme.outline.withValues(
                            alpha: 0.5,
                          ),
                    width: 2,
                  ),
                ),
                child: isRecorded
                    ? Icon(
                        Icons.check,
                        size: 18,
                        color: colorScheme.onPrimary,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
