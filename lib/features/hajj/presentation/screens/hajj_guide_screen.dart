import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/primary_button.dart';

class HajjGuideScreen extends StatelessWidget {
  const HajjGuideScreen({super.key});

  Future<void> _launchOfficialSite() async {
    final Uri url = Uri.parse('https://hacumre.diyanet.gov.tr');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.hajjTitle),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            AppCard(
              child: Column(
                children: [
                  Icon(Icons.mosque_outlined,
                      size: 64, color: colorScheme.primary,),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    l10n.hajjDiyanetInfo,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyLarge?.copyWith(height: 1.6),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      text: l10n.hajjOfficialLinkButton,
                      icon: Icons.open_in_browser,
                      onPressed: _launchOfficialSite,
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
