import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../widgets/legal_section_card.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.menuPrivacy,
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
                LegalSectionCard(
                  icon: Icons.shield_outlined,
                  title: l10n.privacyIntroTitle,
                  description: l10n.privacyIntroDesc,
                ),
                const SizedBox(
                  height: AppSpacing.md,
                ),
                LegalSectionCard(
                  icon: Icons.storage_outlined,
                  title: l10n.privacyDataTitle,
                  description: l10n.privacyDataDesc,
                ),
                const SizedBox(
                  height: AppSpacing.md,
                ),
                LegalSectionCard(
                  icon: Icons.location_on_outlined,
                  title: l10n.privacyLocationTitle,
                  description: l10n.privacyLocationDesc,
                ),
                const SizedBox(
                  height: AppSpacing.md,
                ),
                LegalSectionCard(
                  icon: Icons.notifications_none_outlined,
                  title: l10n.privacyNotificationsTitle,
                  description: l10n.privacyNotificationsDesc,
                ),
                const SizedBox(
                  height: AppSpacing.md,
                ),
                LegalSectionCard(
                  icon: Icons.security_outlined,
                  title: l10n.privacyStorageTitle,
                  description: l10n.privacyStorageDesc,
                ),
                const SizedBox(
                  height: AppSpacing.md,
                ),
                LegalSectionCard(
                  icon: Icons.open_in_new_outlined,
                  title: l10n.privacyExternalTitle,
                  description: l10n.privacyExternalDesc,
                ),
                const SizedBox(
                  height: AppSpacing.md,
                ),
                LegalSectionCard(
                  icon: Icons.delete_outline,
                  title: l10n.privacyRetentionTitle,
                  description: l10n.privacyRetentionDesc,
                ),
                const SizedBox(
                  height: AppSpacing.md,
                ),
                LegalSectionCard(
                  icon: Icons.contact_support_outlined,
                  title: l10n.privacyRightsTitle,
                  description: l10n.privacyRightsDesc,
                ),
                const SizedBox(
                  height: AppSpacing.md,
                ),
                LegalSectionCard(
                  icon: Icons.menu_book_outlined,
                  title: l10n.privacyReligiousInfoTitle,
                  description: l10n.privacyReligiousInfoDesc,
                ),
                const SizedBox(
                  height: AppSpacing.md,
                ),
                LegalSectionCard(
                  icon: Icons.policy_outlined,
                  title: l10n.privacyTermsTitle,
                  description: l10n.privacyTermsDesc,
                ),
                const SizedBox(
                  height: AppSpacing.xl,
                ),
                Center(
                  child: Text(
                    l10n.privacyUpdated,
                    textAlign: TextAlign.center,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
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
