import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../prayer/prayer_times/application/providers/prayer_times_notifier.dart';
import '../../../prayer/shared/presentation/utils/presentation_localizer.dart';
import '../../application/ramadan_day_provider.dart';
import '../../domain/ramadan_day_state.dart';

class RamadanHubScreen extends ConsumerWidget {
  const RamadanHubScreen({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    final prayerState = ref.watch(
      prayerTimesNotifierProvider,
    );

    final ramadanState = ref.watch(
      ramadanDayProvider,
    );

    if (prayerState.isLoading && prayerState.schedule == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.ramadanTitle),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final location = prayerState.location;

    final locationText = location == null
        ? l10n.locationUnavailable
        : PresentationLocalizer.formatLocation(
            context: context,
            cityName: location.cityName,
            countryName: location.countryName,
            lat: location.latitude,
            lon: location.longitude,
          );

    final hijriDate = ramadanState.hijriDateString == null
        ? null
        : PresentationLocalizer.formatSmartHijri(
            context,
            ramadanState.hijriDateString,
          );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.ramadanTitle),
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
              children: [
                _RamadanHeader(
                  location: locationText,
                  hijriDate: hijriDate,
                ),
                const SizedBox(
                  height: AppSpacing.xl,
                ),
                if (ramadanState.phase == RamadanDayPhase.unavailable)
                  _UnavailableCard(
                    onRetry: () {
                      ref
                          .read(
                            prayerTimesNotifierProvider.notifier,
                          )
                          .refreshTimes();
                    },
                  )
                else if (ramadanState.phase == RamadanDayPhase.outsideRamadan)
                  const _OutsideRamadanCard()
                else ...[
                  _RamadanHero(
                    state: ramadanState,
                  ),
                  const SizedBox(
                    height: AppSpacing.xl,
                  ),
                  SectionHeader(
                    title: l10n.ramadanTodayTimes,
                  ),
                  const SizedBox(
                    height: AppSpacing.sm,
                  ),
                  _DailyTimesCard(
                    state: ramadanState,
                  ),
                ],
                const SizedBox(
                  height: AppSpacing.xl,
                ),
                AppCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(
                        width: AppSpacing.md,
                      ),
                      Expanded(
                        child: Text(
                          l10n.ramadanTimesNote,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            height: 1.45,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: AppSpacing.lg,
                ),
                OutlinedButton.icon(
                  onPressed: () => context.go(
                    AppRoutes.prayer,
                  ),
                  icon: const Icon(
                    Icons.schedule_outlined,
                  ),
                  label: Text(
                    l10n.ramadanViewPrayerTimes,
                  ),
                ),
                const SizedBox(
                  height: AppSpacing.xxl,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RamadanHeader extends StatelessWidget {
  final String location;
  final String? hijriDate;

  const _RamadanHeader({
    required this.location,
    required this.hijriDate,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              color: colorScheme.primary,
              size: 20,
            ),
            const SizedBox(
              width: AppSpacing.sm,
            ),
            Expanded(
              child: Text(
                location,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: AppSpacing.lg,
        ),
        Text(
          l10n.ramadanTitle,
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          height: AppSpacing.xs,
        ),
        Text(
          hijriDate ?? l10n.ramadanIntro,
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.4,
          ),
        ),
        if (hijriDate != null) ...[
          const SizedBox(
            height: AppSpacing.sm,
          ),
          Text(
            l10n.ramadanIntro,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ],
      ],
    );
  }
}

class _RamadanHero extends StatelessWidget {
  final RamadanDayState state;

  const _RamadanHero({
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    late final String title;

    switch (state.phase) {
      case RamadanDayPhase.beforeImsak:
        title = l10n.ramadanUntilImsak;

      case RamadanDayPhase.fasting:
        title = l10n.ramadanUntilIftar;

      case RamadanDayPhase.afterIftar:
        title = l10n.ramadanUntilTomorrowImsak;

      case RamadanDayPhase.unavailable:
      case RamadanDayPhase.outsideRamadan:
        return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(
        AppSpacing.xl,
      ),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (state.phase == RamadanDayPhase.afterIftar) ...[
            Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: colorScheme.onPrimaryContainer,
                  size: 20,
                ),
                const SizedBox(
                  width: AppSpacing.sm,
                ),
                Expanded(
                  child: Text(
                    l10n.ramadanIftarEntered,
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: AppSpacing.lg,
            ),
          ],
          Text(
            title,
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(
            height: AppSpacing.sm,
          ),
          Text(
            _formatDuration(
              state.timeRemaining,
            ),
            style: textTheme.displaySmall?.copyWith(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w700,
              fontFeatures: const [
                FontFeature.tabularFigures(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(
    Duration duration,
  ) {
    final safeDuration = duration.isNegative ? Duration.zero : duration;

    final hours = safeDuration.inHours.toString().padLeft(2, '0');

    final minutes = (safeDuration.inMinutes % 60).toString().padLeft(2, '0');

    final seconds = (safeDuration.inSeconds % 60).toString().padLeft(2, '0');

    return '$hours:$minutes:$seconds';
  }
}

class _DailyTimesCard extends StatelessWidget {
  final RamadanDayState state;

  const _DailyTimesCard({
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (state.phase == RamadanDayPhase.afterIftar) {
      return _ResponsiveTimeCards(
        first: _TimeItem(
          icon: Icons.nights_stay_outlined,
          label: l10n.ramadanTodayIftar,
          value: _formatTime(
            context,
            state.iftarTime,
          ),
        ),
        second: _TimeItem(
          icon: Icons.wb_twilight_outlined,
          label: l10n.ramadanTomorrowImsak,
          value: _formatTime(
            context,
            state.tomorrowImsakTime,
          ),
        ),
      );
    }

    return _ResponsiveTimeCards(
      first: _TimeItem(
        icon: Icons.wb_twilight_outlined,
        label: l10n.ramadanImsak,
        value: _formatTime(
          context,
          state.imsakTime,
        ),
      ),
      second: _TimeItem(
        icon: Icons.nights_stay_outlined,
        label: l10n.ramadanIftar,
        value: _formatTime(
          context,
          state.iftarTime,
        ),
      ),
    );
  }

  String _formatTime(
    BuildContext context,
    DateTime? value,
  ) {
    if (value == null) {
      return '—';
    }

    return DateFormat.Hm(
      context.l10n.localeName,
    ).format(value);
  }
}

class _ResponsiveTimeCards extends StatelessWidget {
  final Widget first;
  final Widget second;

  const _ResponsiveTimeCards({
    required this.first,
    required this.second,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (
        context,
        constraints,
      ) {
        if (constraints.maxWidth < 420) {
          return Column(
            children: [
              first,
              const SizedBox(
                height: AppSpacing.sm,
              ),
              second,
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: first,
            ),
            const SizedBox(
              width: AppSpacing.md,
            ),
            Expanded(
              child: second,
            ),
          ],
        );
      },
    );
  }
}

class _TimeItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _TimeItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return AppCard(
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: colorScheme.onPrimaryContainer,
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
                  label,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(
                  height: AppSpacing.xs,
                ),
                Text(
                  value,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OutsideRamadanCard extends StatelessWidget {
  const _OutsideRamadanCard();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.calendar_month_outlined,
            color: colorScheme.primary,
            size: 30,
          ),
          const SizedBox(
            height: AppSpacing.md,
          ),
          Text(
            l10n.ramadanOutsideTitle,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: AppSpacing.sm,
          ),
          Text(
            l10n.ramadanOutsideDesc,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _UnavailableCard extends StatelessWidget {
  final VoidCallback onRetry;

  const _UnavailableCard({
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.schedule_outlined,
            color: colorScheme.primary,
            size: 30,
          ),
          const SizedBox(
            height: AppSpacing.md,
          ),
          Text(
            l10n.ramadanUnavailableTitle,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: AppSpacing.sm,
          ),
          Text(
            l10n.ramadanUnavailableDesc,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.45,
            ),
          ),
          const SizedBox(
            height: AppSpacing.lg,
          ),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(
              Icons.refresh,
            ),
            label: Text(
              l10n.retryButton,
            ),
          ),
        ],
      ),
    );
  }
}
