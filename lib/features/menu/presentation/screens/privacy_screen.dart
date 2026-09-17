import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.menuPrivacy),
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            // Gizlilik Güvencesi İkonu
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
              child: CircleAvatar(
                radius: 40,
                backgroundColor: colorScheme.primaryContainer,
                child: Icon(
                  Icons.shield_outlined,
                  size: 40,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ),

            // Başlık
            Text(
              l10n.menuPrivacy,
              textAlign: TextAlign.center,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // İçerik Kartı
            AppCard(
              child: Text(
                l10n.privacyPolicyContent,
                style: textTheme.bodyMedium?.copyWith(
                  height: 1.8,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}
