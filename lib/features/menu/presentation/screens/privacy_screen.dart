import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/legal_links.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/privacy/religious_progress_consent_provider.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../widgets/legal_section_card.dart';

class PrivacyScreen extends ConsumerWidget {
  const PrivacyScreen({
    super.key,
  });

  Future<void> _openUri(
    BuildContext context,
    Uri uri,
    String errorMessage,
  ) async {
    try {
      final launched = await launchUrl(
        uri,
      );

      if (launched) {
        return;
      }
    } catch (_) {
      // The user receives a localized message below.
    }

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          errorMessage,
        ),
      ),
    );
  }

  void _showConsentFailure(
    BuildContext context,
  ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            context.l10n.privacyReligiousProgressActionFailed,
          ),
        ),
      );
  }

  Future<void> _grantReligiousProgress(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final success = await ref
        .read(
          religiousProgressConsentProvider.notifier,
        )
        .grant();

    if (!success && context.mounted) {
      _showConsentFailure(
        context,
      );
    }
  }

  Future<void> _withdrawReligiousProgress(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final l10n = context.l10n;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (
        dialogContext,
      ) {
        return AlertDialog(
          title: Text(
            l10n.privacyReligiousProgressWithdrawConfirmTitle,
          ),
          content: Text(
            l10n.privacyReligiousProgressWithdrawConfirmDesc,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(
                dialogContext,
              ).pop(
                false,
              ),
              child: Text(
                MaterialLocalizations.of(
                  dialogContext,
                ).cancelButtonLabel,
              ),
            ),
            FilledButton(
              onPressed: () => Navigator.of(
                dialogContext,
              ).pop(
                true,
              ),
              child: Text(
                l10n.privacyReligiousProgressWithdraw,
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    final success = await ref
        .read(
          religiousProgressConsentProvider.notifier,
        )
        .withdrawAndDelete();

    if (!success && context.mounted) {
      _showConsentFailure(
        context,
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    final consentState = ref.watch(
      religiousProgressConsentProvider,
    );

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
                  icon: Icons.public_outlined,
                  title: l10n.privacyPublicPolicyTitle,
                  description: l10n.privacyPublicPolicyDesc(
                    LegalLinks.privacyContactEmail,
                  ),
                  footer: Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      FilledButton.icon(
                        onPressed: () => _openUri(
                          context,
                          LegalLinks.privacyPolicyUri,
                          l10n.privacyLinkOpenFailed,
                        ),
                        icon: const Icon(
                          Icons.open_in_new,
                        ),
                        label: Text(
                          l10n.privacyOpenPolicy,
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => _openUri(
                          context,
                          LegalLinks.privacyContactUri,
                          l10n.privacyLinkOpenFailed,
                        ),
                        icon: const Icon(
                          Icons.mail_outline,
                        ),
                        label: Text(
                          l10n.privacyEmailContact,
                        ),
                      ),
                    ],
                  ),
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
                  icon: Icons.fact_check_outlined,
                  title: l10n.privacyReligiousProgressTitle,
                  description: l10n.privacyReligiousProgressDesc,
                  footer: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (consentState.isLoading)
                        const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      else if (consentState.granted)
                        OutlinedButton.icon(
                          onPressed: consentState.isUpdating
                              ? null
                              : () => _withdrawReligiousProgress(
                                    context,
                                    ref,
                                  ),
                          icon: const Icon(
                            Icons.delete_outline,
                          ),
                          label: Text(
                            l10n.privacyReligiousProgressWithdraw,
                          ),
                        )
                      else
                        FilledButton.icon(
                          onPressed: consentState.isUpdating
                              ? null
                              : () => _grantReligiousProgress(
                                    context,
                                    ref,
                                  ),
                          icon: const Icon(
                            Icons.lock_outline,
                          ),
                          label: Text(
                            l10n.privacyReligiousProgressAllow,
                          ),
                        ),
                      if (consentState.hasError) ...[
                        const SizedBox(
                          height: AppSpacing.sm,
                        ),
                        Text(
                          l10n.privacyReligiousProgressActionFailed,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.error,
                          ),
                        ),
                      ],
                    ],
                  ),
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
