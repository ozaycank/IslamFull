import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/section_header.dart';

class HajjGuideScreen extends StatelessWidget {
  const HajjGuideScreen({super.key});

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
        _showLaunchError(context);
      }
    } catch (_) {
      if (context.mounted) {
        _showLaunchError(context);
      }
    }
  }

  void _showLaunchError(
    BuildContext context,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
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
                          Icons.mosque_outlined,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(
                        width: AppSpacing.md,
                      ),
                      Expanded(
                        child: Text(
                          l10n.hajjHubIntro,
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
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
                      ListTile(
                        leading: Icon(
                          Icons.auto_stories_outlined,
                          color: colorScheme.primary,
                        ),
                        title: Text(
                          l10n.hajjFundamentalsTitle,
                        ),
                        subtitle: Text(
                          l10n.hajjFundamentalsMenuDesc,
                        ),
                        trailing: const Icon(
                          Icons.chevron_right,
                        ),
                        onTap: () => context.push(
                          AppRoutes.hajjFundamentals,
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: Icon(
                          Icons.compare_arrows_outlined,
                          color: colorScheme.primary,
                        ),
                        title: Text(
                          l10n.hajjTypesTitle,
                        ),
                        subtitle: Text(
                          l10n.hajjTypesMenuDesc,
                        ),
                        trailing: const Icon(
                          Icons.chevron_right,
                        ),
                        onTap: () => context.push(
                          AppRoutes.hajjTypes,
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: Icon(
                          Icons.calendar_month_outlined,
                          color: colorScheme.primary,
                        ),
                        title: Text(
                          l10n.hajjDaysTitle,
                        ),
                        subtitle: Text(
                          l10n.hajjDaysMenuDesc,
                        ),
                        trailing: const Icon(
                          Icons.chevron_right,
                        ),
                        onTap: () => context.push(
                          AppRoutes.hajjDays,
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: Icon(
                          Icons.directions_walk_outlined,
                          color: colorScheme.primary,
                        ),
                        title: Text(
                          l10n.umrahGuideTitle,
                        ),
                        subtitle: Text(
                          l10n.umrahGuideMenuDesc,
                        ),
                        trailing: const Icon(
                          Icons.chevron_right,
                        ),
                        onTap: () => context.push(
                          AppRoutes.umrahGuide,
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
