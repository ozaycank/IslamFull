import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../prayer/location/application/providers/location_notifier.dart';
import '../../../prayer/location/application/states/location_state.dart';
import '../../../prayer/prayer_times/application/providers/prayer_times_notifier.dart';
import '../../../prayer/prayer_times/domain/calculators/high_latitude_strategy.dart';
import '../../../prayer/shared/presentation/utils/presentation_localizer.dart';
import '../../application/providers/prayer_settings_notifier.dart';
import '../../application/providers/language_settings_notifier.dart';
import '../../application/providers/notification_settings_provider.dart';
import '../widgets/selection_bottom_sheet.dart';
import '../widgets/settings_selection_tile.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/theme/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: const [
            _NotificationSection(),
            SizedBox(height: AppSpacing.lg),
            _LocationSection(),
            SizedBox(height: AppSpacing.lg),
            _PrayerCalculationSection(),
            SizedBox(height: AppSpacing.lg),
            _ThemeSection(),
            SizedBox(height: AppSpacing.lg),
            _LanguageSection(),
          ],
        ),
      ),
    );
  }
}

// NEW: Notification Section
class _NotificationSection extends ConsumerWidget {
  const _NotificationSection();

  static const List<int> _reminderOptions = [
    5,
    10,
    15,
    30,
    45,
    60,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(notificationSettingsProvider);
    final notifier = ref.read(notificationSettingsProvider.notifier);

    if (!state.isLoaded) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: l10n.notificationsTitle,
        ),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              SwitchListTile(
                title: Text(l10n.notificationsEnabled),
                subtitle: !state.platformSupported
                    ? Text(l10n.notificationsUnsupportedPlatform)
                    : null,
                value: state.platformSupported && state.masterEnabled,
                activeThumbColor: context.colorScheme.primary,
                onChanged: !state.platformSupported
                    ? null
                    : (enabled) async {
                        final success = await notifier.toggleMaster(enabled);

                        if (!success && enabled && context.mounted) {
                          NotificationService.showError(
                            l10n.notificationPermissionDeniedMessage,
                          );
                        }
                      },
              ),
              if (state.masterEnabled && state.platformSupported) ...[
                const Divider(height: 1),
                SettingsSelectionTile(
                  title: l10n.prayerReminders,
                  value: l10n.notificationMinutesBefore(
                    state.prayerReminderMinutes,
                  ),
                  onTap: () {
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (sheetContext) => SelectionBottomSheet(
                        title: l10n.prayerReminders,
                        items: _reminderOptions
                            .map(
                              (minutes) => SelectionItem(
                                minutes.toString(),
                                l10n.notificationMinutesBefore(minutes),
                              ),
                            )
                            .toList(),
                        selectedId: state.prayerReminderMinutes.toString(),
                        onSelected: (id) {
                          notifier.setReminderMinutes(
                            int.parse(id),
                          );
                        },
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: Text(l10n.dailyVerseEnabled),
                  value: state.dailyVerseEnabled,
                  activeThumbColor: context.colorScheme.primary,
                  onChanged: (enabled) {
                    notifier.toggleDailyVerse(enabled);
                  },
                ),
                if (state.dailyVerseEnabled) ...[
                  const Divider(height: 1),
                  SettingsSelectionTile(
                    title: l10n.dailyVerseTime,
                    value: _parseTime(
                      state.dailyVerseTime,
                    ).format(context),
                    onTap: () async {
                      final selectedTime = await showTimePicker(
                        context: context,
                        initialTime: _parseTime(
                          state.dailyVerseTime,
                        ),
                      );

                      if (selectedTime == null) {
                        return;
                      }

                      await notifier.setDailyVerseTime(
                        _serializeTime(selectedTime),
                      );
                    },
                  ),
                ],
              ],
            ],
          ),
        ),
      ],
    );
  }

  TimeOfDay _parseTime(String value) {
    final parts = value.split(':');

    final hour = parts.isNotEmpty ? int.tryParse(parts.first) : null;

    final minute = parts.length > 1 ? int.tryParse(parts[1]) : null;

    return TimeOfDay(
      hour: hour != null && hour >= 0 && hour <= 23 ? hour : 20,
      minute: minute != null && minute >= 0 && minute <= 59 ? minute : 0,
    );
  }

  String _serializeTime(TimeOfDay value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }
}

class _LocationSection extends ConsumerWidget {
  const _LocationSection();

  Future<void> _refreshLocation(BuildContext context, WidgetRef ref) async {
    final success = await ref
        .read(locationNotifierProvider.notifier)
        .acquireDeviceLocation();

    if (success && context.mounted) {
      await ref.read(prayerTimesNotifierProvider.notifier).refreshTimes();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locState = ref.watch(locationNotifierProvider);
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    final location = locState.location;
    final isLoading = locState.status == LocationStatus.requesting;

    final locationDisplay = location != null
        ? PresentationLocalizer.formatLocation(
            context: context,
            cityName: location.cityName,
            subAdminArea: location.countryName,
            countryName: location.countryName,
          )
        : l10n.locationUnavailable;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: l10n.locationTitle),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      locationDisplay,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: AppSpacing.xl),
              _InfoRow(
                label: l10n.timezoneLabel,
                value: location?.timezoneIdentifier ?? '-',
              ),
              const SizedBox(height: AppSpacing.sm),
              _InfoRow(
                label: l10n.coordinatesLabel,
                value: location != null
                    ? '${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)}'
                    : '-',
              ),
              if (locState.failure != null) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  locState.failure!.message,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.error,
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: l10n.refreshLocation,
                  icon: Icons.my_location,
                  isLoading: isLoading,
                  onPressed: () => _refreshLocation(context, ref),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PrayerCalculationSection extends ConsumerWidget {
  const _PrayerCalculationSection();

  void _showSheet(
    BuildContext context,
    String title,
    List<SelectionItem> items,
    String? selectedId,
    ValueChanged<String> onSelected,
  ) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SelectionBottomSheet(
        title: title,
        items: items,
        selectedId: selectedId,
        onSelected: onSelected,
      ),
    );
  }

  String _getHighLatLabel(
    HighLatitudeStrategy? strategy,
    BuildContext context,
  ) {
    final l10n = context.l10n;
    switch (strategy) {
      case HighLatitudeStrategy.angleBased:
        return l10n.angleBasedLabel;
      case HighLatitudeStrategy.oneSeventh:
        return l10n.oneSeventhLabel;
      case HighLatitudeStrategy.nightMiddle:
        return l10n.nightMiddleLabel;
      case HighLatitudeStrategy.none:
        return l10n.noneLabel;
      case null:
        return '-';
    }
  }

  Future<void> _handleSettingChange(
    BuildContext context,
    WidgetRef ref,
    Future<bool> Function() saveOperation,
  ) async {
    final success = await saveOperation();
    if (success && context.mounted) {
      await ref.read(prayerTimesNotifierProvider.notifier).refreshTimes();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(prayerSettingsNotifierProvider);
    final notifier = ref.read(prayerSettingsNotifierProvider.notifier);
    final colorScheme = context.colorScheme;

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final rawMethodId = state.selectedMethodId;
    final selectedMethodName = rawMethodId != null
        ? PresentationLocalizer.localizeCalculationMethod(context, rawMethodId)
        : '-';

    final rawMadhabId = state.selectedMadhabId;
    final selectedMadhabName = rawMadhabId != null
        ? PresentationLocalizer.localizeMadhab(context, rawMadhabId)
        : '-';

    final highLatItems = HighLatitudeStrategy.values
        .map((s) => SelectionItem(s.name, _getHighLatLabel(s, context)))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: l10n.prayerCalculationTitle),
        if (state.failure != null)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Text(
              state.failure!.message,
              style: context.textTheme.bodySmall?.copyWith(
                color: colorScheme.error,
              ),
            ),
          ),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              SettingsSelectionTile(
                title: l10n.calculationMethodLabel,
                value: selectedMethodName,
                isLoading: state.isSaving,
                onTap: () => _showSheet(
                  context,
                  l10n.calculationMethodLabel,
                  state.availableMethods
                      .map(
                        (m) => SelectionItem(
                          m.id,
                          PresentationLocalizer.localizeCalculationMethod(
                            context,
                            m.id,
                          ),
                          m.description,
                        ),
                      )
                      .toList(),
                  state.selectedMethodId,
                  (id) => _handleSettingChange(
                    context,
                    ref,
                    () => notifier.updateMethod(id),
                  ),
                ),
              ),
              const Divider(height: 1),
              SettingsSelectionTile(
                title: l10n.madhabLabel,
                value: selectedMadhabName,
                isLoading: state.isSaving,
                onTap: () => _showSheet(
                  context,
                  l10n.madhabLabel,
                  state.availableMadhabs
                      .map(
                        (m) => SelectionItem(
                          m.id,
                          PresentationLocalizer.localizeMadhab(context, m.id),
                        ),
                      )
                      .toList(),
                  state.selectedMadhabId,
                  (id) => _handleSettingChange(
                    context,
                    ref,
                    () => notifier.updateMadhab(id),
                  ),
                ),
              ),
              const Divider(height: 1),
              SettingsSelectionTile(
                title: l10n.highLatitudeStrategyLabel,
                value: _getHighLatLabel(state.selectedHighLatStrategy, context),
                isLoading: state.isSaving,
                onTap: () => _showSheet(
                  context,
                  l10n.highLatitudeStrategyLabel,
                  highLatItems,
                  state.selectedHighLatStrategy?.name,
                  (id) {
                    final strategy = HighLatitudeStrategy.values.firstWhere(
                      (s) => s.name == id,
                    );
                    _handleSettingChange(
                      context,
                      ref,
                      () => notifier.updateHighLatitudeStrategy(strategy),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(
          width: AppSpacing.md,
        ),
        Flexible(
          child: Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _ThemeSection extends ConsumerWidget {
  const _ThemeSection();

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final l10n = context.l10n;

    final themeMode = ref.watch(
      themeModeProvider,
    );

    final notifier = ref.read(
      themeModeProvider.notifier,
    );

    String themeLabel(
      ThemeMode mode,
    ) {
      return switch (mode) {
        ThemeMode.system => l10n.themeSystem,
        ThemeMode.light => l10n.themeLight,
        ThemeMode.dark => l10n.themeDark,
      };
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: l10n.themeTitle,
        ),
        AppCard(
          padding: EdgeInsets.zero,
          child: SettingsSelectionTile(
            title: l10n.themeTitle,
            value: themeLabel(
              themeMode,
            ),
            onTap: () {
              showModalBottomSheet<void>(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                builder: (sheetContext) {
                  return SelectionBottomSheet(
                    title: l10n.themeTitle,
                    items: [
                      SelectionItem(
                        ThemeMode.system.name,
                        l10n.themeSystem,
                      ),
                      SelectionItem(
                        ThemeMode.light.name,
                        l10n.themeLight,
                      ),
                      SelectionItem(
                        ThemeMode.dark.name,
                        l10n.themeDark,
                      ),
                    ],
                    selectedId: themeMode.name,
                    onSelected: (id) async {
                      final selectedMode = switch (id) {
                        'light' => ThemeMode.light,
                        'dark' => ThemeMode.dark,
                        _ => ThemeMode.system,
                      };

                      try {
                        await notifier.setThemeMode(
                          selectedMode,
                        );
                      } catch (_) {
                        if (context.mounted) {
                          NotificationService.showError(
                            l10n.settingsSaveFailed,
                          );
                        }
                      }
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _LanguageSection extends ConsumerWidget {
  const _LanguageSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final localeState = ref.watch(languageSettingsNotifierProvider);
    final notifier = ref.read(languageSettingsNotifierProvider.notifier);

    final currentLanguageLabel = localeState.locale.languageCode == 'tr'
        ? l10n.languageTurkish
        : l10n.languageEnglish;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: l10n.languageLabel),
        AppCard(
          padding: EdgeInsets.zero,
          child: SettingsSelectionTile(
            title: l10n.languageLabel,
            value: currentLanguageLabel,
            onTap: () {
              showModalBottomSheet<void>(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (ctx) => SelectionBottomSheet(
                  title: l10n.languageLabel,
                  items: [
                    SelectionItem('en', l10n.languageEnglish),
                    SelectionItem('tr', l10n.languageTurkish),
                  ],
                  selectedId: localeState.locale.languageCode,
                  onSelected: (id) => notifier.setLocale(Locale(id)),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
