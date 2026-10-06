import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/guide_content_cards.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../prayer/shared/presentation/utils/presentation_localizer.dart';
import '../../application/qurban_season_provider.dart';
import '../../domain/qurban_season_state.dart';

class QurbanHubScreen extends ConsumerWidget {
  const QurbanHubScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;

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
        title: Text(
          l10n.qurbanTitle,
        ),
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
                GuideInfoCard(
                  icon: Icons.volunteer_activism_outlined,
                  description: l10n.qurbanIntro,
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
                  title: l10n.qurbanGuidesTitle,
                ),
                const SizedBox(
                  height: AppSpacing.sm,
                ),
                AppCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      ListTile(
                        leading: ExcludeSemantics(
                          child: Icon(
                            Icons.menu_book_outlined,
                            color: colorScheme.primary,
                          ),
                        ),
                        title: Text(
                          l10n.qurbanGuideTitle,
                        ),
                        subtitle: Text(
                          l10n.qurbanGuideMenuDesc,
                        ),
                        trailing: Icon(
                          Directionality.of(context) == TextDirection.rtl
                              ? Icons.chevron_left
                              : Icons.chevron_right,
                        ),
                        onTap: () => context.push(
                          AppRoutes.qurbanGuide,
                        ),
                      ),
                      const Divider(
                        height: 1,
                      ),
                      ListTile(
                        leading: ExcludeSemantics(
                          child: Icon(
                            Icons.celebration_outlined,
                            color: colorScheme.primary,
                          ),
                        ),
                        title: Text(
                          l10n.qurbanEidGuideTitle,
                        ),
                        subtitle: Text(
                          l10n.qurbanEidGuideMenuDesc,
                        ),
                        trailing: Icon(
                          Directionality.of(context) == TextDirection.rtl
                              ? Icons.chevron_left
                              : Icons.chevron_right,
                        ),
                        onTap: () => context.push(
                          AppRoutes.qurbanEidGuide,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: AppSpacing.xl,
                ),
                GuideInfoCard(
                  icon: Icons.info_outline,
                  description: l10n.qurbanScopeNote,
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
      child: LayoutBuilder(
        builder: (
          context,
          constraints,
        ) {
          final scaledTitle = MediaQuery.textScalerOf(
            context,
          ).scale(
            textTheme.titleMedium?.fontSize ?? 16,
          );

          final stack = constraints.maxWidth < 360 || scaledTitle >= 24;

          final iconWidget = ExcludeSemantics(
            child: Container(
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
          );

          final content = Column(
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
          );

          if (stack) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                iconWidget,
                const SizedBox(
                  height: AppSpacing.md,
                ),
                content,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              iconWidget,
              const SizedBox(
                width: AppSpacing.md,
              ),
              Expanded(
                child: content,
              ),
            ],
          );
        },
      ),
    );
  }
}
