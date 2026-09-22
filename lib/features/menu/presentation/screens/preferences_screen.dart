import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../application/preferences_provider.dart';

class PreferencesScreen extends ConsumerWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;

    final hapticEnabled = ref.watch(
      hapticFeedbackProvider,
    );

    final verseEnabled = ref.watch(
      showDailyVerseSettingProvider,
    );

    final notifier = ref.read(
      preferencesProvider.notifier,
    );

    Future<void> savePreference(
      Future<void> Function() action,
    ) async {
      try {
        await action();
      } catch (_) {
        if (!context.mounted) {
          return;
        }

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                l10n.settingsSaveFailed,
              ),
            ),
          );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.preferencesTitle,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(
          AppSpacing.lg,
        ),
        children: [
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                SwitchListTile(
                  title: Text(
                    l10n.prefHapticFeedback,
                  ),
                  subtitle: Text(
                    l10n.prefHapticDesc,
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  value: hapticEnabled,
                  activeThumbColor: colorScheme.primary,
                  onChanged: (value) {
                    savePreference(
                      () => notifier.setHapticFeedbackEnabled(
                        value,
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: Text(
                    l10n.prefDailyVerse,
                  ),
                  subtitle: Text(
                    l10n.prefDailyVerseDesc,
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  value: verseEnabled,
                  activeThumbColor: colorScheme.primary,
                  onChanged: (value) {
                    savePreference(
                      () => notifier.setShowDailyVerseOnHome(
                        value,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
