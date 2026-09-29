import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../prayer/shared/presentation/utils/presentation_localizer.dart';
import '../../application/qurban_season_provider.dart';
import '../../domain/qurban_season_state.dart';

class QurbanHubScreen extends ConsumerWidget {
  const QurbanHubScreen({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    final seasonState = ref.watch(
      qurbanSeasonProvider,
    );

    final hijriDate = seasonState.hijriDateString == null
        ? null
        : PresentationLocalizer.formatSmartHijri(
            context,
            seasonState.hijriDateString,
          );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.qurbanTitle),
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
                AppCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.volunteer_activism_outlined,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(
                        width: AppSpacing.md,
                      ),
                      Expanded(
                        child: Text(
                          l10n.qurbanIntro,
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (seasonState.isSeasonContext) ...[
                  const SizedBox(
                    height: AppSpacing.xl,
                  ),
                  _QurbanSeasonCard(
                    state: seasonState,
                    hijriDate: hijriDate,
                  ),
                ],
                const SizedBox(
                  height: AppSpacing.xl,
                ),
                SectionHeader(
                  title: l10n.qurbanGuideTitle,
                ),
                const SizedBox(
                  height: AppSpacing.sm,
                ),
                AppCard(
                  padding: EdgeInsets.zero,
                  child: ListTile(
                    leading: Icon(
                      Icons.menu_book_outlined,
                      color: colorScheme.primary,
                    ),
                    title: Text(
                      l10n.qurbanGuideTitle,
                    ),
                    subtitle: Text(
                      l10n.qurbanGuideMenuDesc,
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                    ),
                    onTap: () => context.push(
                      AppRoutes.qurbanGuide,
                    ),
                  ),
                ),
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
                          l10n.qurbanScopeNote,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
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

class _QurbanSeasonCard extends StatelessWidget {
  final QurbanSeasonState state;
  final String? hijriDate;

  const _QurbanSeasonCard({
    required this.state,
    required this.hijriDate,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    late final String title;
    late final String description;
    late final IconData icon;

    switch (state.phase) {
      case QurbanSeasonPhase.firstEightDays:
        title = l10n.qurbanSeasonDhulHijjahDayTitle(
          state.dhulHijjahDay ?? 1,
        );
        description = l10n.qurbanSeasonDhulHijjahDesc;
        icon = Icons.calendar_month_outlined;

      case QurbanSeasonPhase.arafah:
        title = l10n.qurbanSeasonArafahTitle;
        description = l10n.qurbanSeasonArafahDesc;
        icon = Icons.event_outlined;

      case QurbanSeasonPhase.eid:
        title = l10n.qurbanSeasonEidDayTitle(
          state.eidDay ?? 1,
        );
        description = l10n.qurbanSeasonEidDesc;
        icon = Icons.mosque_outlined;

      case QurbanSeasonPhase.unavailable:
      case QurbanSeasonPhase.outsideSeason:
        return const SizedBox.shrink();
    }

    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (hijriDate != null) ...[
                  const SizedBox(
                    height: AppSpacing.xs,
                  ),
                  Text(
                    hijriDate!,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                const SizedBox(
                  height: AppSpacing.sm,
                ),
                Text(
                  description,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.45,
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
