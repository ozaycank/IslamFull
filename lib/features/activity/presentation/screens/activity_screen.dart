import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // REQUIRED FOR HAPTIC FEEDBACK
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// Core & Shared
import '../../../../core/extensions/context_extensions.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/error_state_widget.dart';

// Domain & Application
import '../../domain/activity_prayer_type.dart';
import '../../domain/activity_models.dart';
import '../../application/activity_provider.dart';
import '../../utils/activity_date_utils.dart';

/// CORE ARCHITECTURE:
/// The ActivityScreen serves as the Presentation layer for the daily worship tracker.
/// It observes the [activityNotifierProvider] and renders a premium, gamified (but respectful) UI.
/// State mutations are strictly delegated to the [ActivityNotifier].
class ActivityScreen extends ConsumerStatefulWidget {
  const ActivityScreen({super.key});

  @override
  ConsumerState<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends ConsumerState<ActivityScreen> {
  // HELPER: Localizes the prayer enum into UI strings
  String _localizePrayerType(ActivityPrayerType type, AppLocalizations l10n) {
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

  // HELPER: Calculates the total progress percentage for the day (5 prayers + 1 Quran = 6 tasks)
  double _calculateDailyProgress(DailyActivity? activity) {
    if (activity == null) return 0.0;
    int completedCount =
        activity.completedPrayers.values.where((v) => v).length;
    if (activity.quranReadingOccurred) completedCount += 1;
    return completedCount / 6.0;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    final state = ref.watch(activityNotifierProvider);
    final notifier = ref.read(activityNotifierProvider.notifier);

    final todayStr = DateFormat.yMMMMd(l10n.localeName).format(DateTime.now());
    const trackablePrayers = ActivityPrayerType.values;
    final dailyProgress = _calculateDailyProgress(state.dailyActivity);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.activityTitle),
        elevation: 0,
      ),
      body: SafeArea(
        child: state.isLoading && state.dailyActivity == null
            ? const Center(child: CircularProgressIndicator())
            : state.failure != null && state.dailyActivity == null
                ? ErrorStateWidget(
                    title: l10n.errorStateDefaultTitle,
                    message: state.failure!.message,
                    retryText: l10n.retryButton,
                    onRetry: () => notifier.loadToday(),
                  )
                : RefreshIndicator(
                    onRefresh: () => notifier.loadToday(),
                    child: ListView(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        // 1. HEADER & MOTIVATION
                        Text(
                          todayStr,
                          style: textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          l10n.activityMotivation,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),

                        // 2. DAILY PROGRESS BAR
                        SectionHeader(title: l10n.activityTodayProgress),
                        AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    l10n.activityToday,
                                    style: textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${(dailyProgress * 100).toInt()}%',
                                    style: textTheme.titleMedium?.copyWith(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.md),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: dailyProgress,
                                  minHeight: 10,
                                  backgroundColor:
                                      colorScheme.surfaceContainerHighest,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),

                        // 3. WORSHIP TRACKING (PRAYERS)
                        SectionHeader(title: l10n.activityPrayers),
                        AppCard(
                          padding: EdgeInsets.zero,
                          child: Column(
                            children: trackablePrayers.map((prayer) {
                              final isCompleted = state.dailyActivity
                                      ?.completedPrayers[prayer] ??
                                  false;
                              final isLast = prayer == trackablePrayers.last;

                              return Column(
                                children: [
                                  _WorshipCard(
                                    title: _localizePrayerType(prayer, l10n),
                                    isCompleted: isCompleted,
                                    onTap: () {
                                      // UX ENHANCEMENT: Light haptic feedback on completion
                                      HapticFeedback.lightImpact();
                                      notifier.togglePrayer(prayer);
                                    },
                                    l10n: l10n,
                                  ),
                                  if (!isLast) const Divider(height: 1),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // 4. WORSHIP TRACKING (QURAN)
                        AppCard(
                          padding: EdgeInsets.zero,
                          child: _WorshipCard(
                            title: l10n.activityQuranReading,
                            icon: Icons.menu_book_rounded,
                            isCompleted:
                                state.dailyActivity?.quranReadingOccurred ??
                                    false,
                            onTap: () {
                              HapticFeedback.lightImpact();
                              notifier.markQuranRead();
                            },
                            l10n: l10n,
                            // UX ENHANCEMENT: Quran reading is currently a one-way toggle based on domain rules.
                            // We disable the tap if it's already completed to prevent confusion.
                            isDisabled:
                                state.dailyActivity?.quranReadingOccurred ??
                                    false,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxl),

                        // 5. STATISTICS SUMMARY
                        SectionHeader(title: l10n.activityStatistics),
                        Row(
                          children: [
                            _buildStatCard(
                              context,
                              l10n.statsStreak,
                              l10n.statsDays(
                                  state.statistics?.currentStreak ?? 0,),
                              Icons.local_fire_department,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            _buildStatCard(
                              context,
                              l10n.statsAvgCompletion,
                              '${((state.statistics?.last7DaysCompletion ?? 0) * 100).toInt()}%',
                              Icons.pie_chart,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            _buildStatCard(
                              context,
                              l10n.statsQuranDays,
                              l10n.statsDays(
                                  state.statistics?.last7DaysQuran ?? 0,),
                              Icons.auto_stories,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xxl),

                        // 6. HISTORY LIST
                        SectionHeader(title: l10n.activityHistory),
                        if (state.history
                            .where((r) => r.date != ActivityDateUtils.today())
                            .isEmpty)
                          _buildEmptyHistory(context, l10n)
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
                                    .where((r) =>
                                        r.date != ActivityDateUtils.today(),)
                                    .take(10) // Limit to 10 for performance
                                    .map((r) => _buildHistoryItem(context, r))
                                    .toList(),
                              ),
                            ),
                          ),

                        const SizedBox(height: AppSpacing.xxl),
                      ],
                    ),
                  ),
      ),
    );
  }

  // UI COMPONENT: History Item with Mini Progress Indicator
  Widget _buildHistoryItem(BuildContext context, DailyActivity activity) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;

    final parsedDate = DateTime.tryParse(activity.date) ?? DateTime.now();
    final displayDate = DateFormat.yMMMd(l10n.localeName).format(parsedDate);
    final completedCount =
        activity.completedPrayers.values.where((v) => v).length;
    final progress = _calculateDailyProgress(activity);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress,
            backgroundColor: colorScheme.surfaceContainerHighest,
            color:
                progress == 1.0 ? colorScheme.primary : colorScheme.secondary,
          ),
          Icon(
            progress == 1.0 ? Icons.star : Icons.calendar_today,
            size: 16,
            color: progress == 1.0
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
          ),
        ],
      ),
      title: Text(
        displayDate,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text('$completedCount/5 ${l10n.activityPrayers}'),
      trailing: activity.quranReadingOccurred
          ? Icon(Icons.menu_book, color: colorScheme.primary, size: 20)
          : const SizedBox.shrink(),
    );
  }

  // UI COMPONENT: Stat Card
  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Expanded(
      child: AppCard(
        child: Column(
          children: [
            Icon(icon, color: colorScheme.primary, size: 28),
            const SizedBox(height: AppSpacing.sm),
            Text(
              value,
              style:
                  textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.bodySmall
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  // UI COMPONENT: Motivating Empty State
  Widget _buildEmptyHistory(BuildContext context, AppLocalizations l10n) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Icon(
              Icons.auto_awesome_outlined,
              size: 48,
              color: colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.md),
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

/// UI COMPONENT: Premium Animated Worship Card
/// Replaces the boring SwitchListTile with a satisfying, gamified circular checkbox.
class _WorshipCard extends StatelessWidget {
  final String title;
  final IconData? icon;
  final bool isCompleted;
  final bool isDisabled;
  final VoidCallback onTap;
  final AppLocalizations l10n;

  const _WorshipCard({
    required this.title,
    this.icon,
    required this.isCompleted,
    required this.onTap,
    required this.l10n,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return InkWell(
      onTap: isDisabled ? null : onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: isCompleted
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
                size: 24,
              ),
              const SizedBox(width: AppSpacing.md),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isCompleted
                          ? colorScheme.onSurface
                          : colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isCompleted
                        ? l10n.activityCompleted
                        : l10n.activityTapToComplete,
                    style: textTheme.bodySmall?.copyWith(
                      color: isCompleted
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            // GAMIFICATION: Animated Circular Checkbox
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOutBack,
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted ? colorScheme.primary : Colors.transparent,
                border: Border.all(
                  color: isCompleted
                      ? colorScheme.primary
                      : colorScheme.outline.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: isCompleted
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
    );
  }
}
