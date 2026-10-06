import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/guide_content_cards.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/section_header.dart';

class HajjGuideScreen extends StatelessWidget {
  const HajjGuideScreen({
    super.key,
  });

  static final Uri _officialSiteUri = Uri.parse(
    'https://hacumre.diyanet.gov.tr',
  );

  Future<void> _launchOfficialSite(
    BuildContext context,
  ) async {
    try {
      final launched = await launchUrl(
        _officialSiteUri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && context.mounted) {
        _showLaunchError(
          context,
        );
      }
    } catch (_) {
      if (context.mounted) {
        _showLaunchError(
          context,
        );
      }
    }
  }

  void _showLaunchError(
    BuildContext context,
  ) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        content: Text(
          context.l10n.hajjOfficialLinkError,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.hajjTitle,
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
                  icon: Icons.mosque_outlined,
                  description: l10n.hajjHubIntro,
                ),
                const SizedBox(
                  height: AppSpacing.xl,
                ),
                SectionHeader(
                  title: l10n.hajjLearnTitle,
                ),
                const SizedBox(
                  height: AppSpacing.sm,
                ),
                AppCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _GuideNavigationTile(
                        icon: Icons.auto_stories_outlined,
                        title: l10n.hajjFundamentalsTitle,
                        subtitle: l10n.hajjFundamentalsMenuDesc,
                        onTap: () => context.push(
                          AppRoutes.hajjFundamentals,
                        ),
                      ),
                      const Divider(
                        height: 1,
                      ),
                      _GuideNavigationTile(
                        icon: Icons.flag_outlined,
                        title: l10n.ihramRulesTitle,
                        subtitle: l10n.ihramRulesMenuDesc,
                        onTap: () => context.push(
                          AppRoutes.ihramRules,
                        ),
                      ),
                      const Divider(
                        height: 1,
                      ),
                      _GuideNavigationTile(
                        icon: Icons.compare_arrows_outlined,
                        title: l10n.hajjTypesTitle,
                        subtitle: l10n.hajjTypesMenuDesc,
                        onTap: () => context.push(
                          AppRoutes.hajjTypes,
                        ),
                      ),
                      const Divider(
                        height: 1,
                      ),
                      _GuideNavigationTile(
                        icon: Icons.calendar_month_outlined,
                        title: l10n.hajjDaysTitle,
                        subtitle: l10n.hajjDaysMenuDesc,
                        onTap: () => context.push(
                          AppRoutes.hajjDays,
                        ),
                      ),
                      const Divider(
                        height: 1,
                      ),
                      _GuideNavigationTile(
                        icon: Icons.directions_walk_outlined,
                        title: l10n.umrahGuideTitle,
                        subtitle: l10n.umrahGuideMenuDesc,
                        onTap: () => context.push(
                          AppRoutes.umrahGuide,
                        ),
                      ),
                      const Divider(
                        height: 1,
                      ),
                      _GuideNavigationTile(
                        icon: Icons.help_outline,
                        title: l10n.hajjSpecialCasesTitle,
                        subtitle: l10n.hajjSpecialCasesMenuDesc,
                        onTap: () => context.push(
                          AppRoutes.hajjSpecialCases,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: AppSpacing.xl,
                ),
                SectionHeader(
                  title: l10n.hajjOfficialInfoTitle,
                ),
                const SizedBox(
                  height: AppSpacing.sm,
                ),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.hajjDiyanetInfo,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(
                        height: AppSpacing.lg,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: PrimaryButton(
                          text: l10n.hajjOfficialLinkButton,
                          icon: Icons.open_in_browser,
                          onPressed: () => _launchOfficialSite(
                            context,
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

class _GuideNavigationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _GuideNavigationTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return ListTile(
      leading: ExcludeSemantics(
        child: Icon(
          icon,
          color: colorScheme.primary,
        ),
      ),
      title: Text(
        title,
      ),
      subtitle: Text(
        subtitle,
      ),
      trailing: Icon(
        Directionality.of(context) == TextDirection.rtl
            ? Icons.chevron_left
            : Icons.chevron_right,
      ),
      onTap: onTap,
    );
  }
}
