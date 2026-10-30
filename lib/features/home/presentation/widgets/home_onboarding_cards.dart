import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../prayer/location/application/providers/location_notifier.dart';
import '../../../prayer/location/application/states/location_state.dart';
import '../../../prayer/location/presentation/utils/location_failure_localizer.dart';
import '../../../prayer/location/presentation/widgets/location_settings_action.dart';
import '../../../prayer/prayer_times/application/providers/prayer_times_notifier.dart';
import '../../../settings/application/providers/notification_settings_provider.dart';
import '../../../settings/presentation/widgets/manual_location_sheet.dart';

/// First-run location setup card.
///
/// It is shown only when no saved location is available.
class HomeLocationSetupCard extends ConsumerWidget {
  const HomeLocationSetupCard({super.key});

  Future<void> _showManualLocation(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final currentLocation = ref
        .read(
          locationNotifierProvider,
        )
        .location;

    await showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        return ManualLocationSheet(
          initialLatitude: currentLocation?.latitude,
          initialLongitude: currentLocation?.longitude,
          onSave: (latitude, longitude) {
            return ref
                .read(locationNotifierProvider.notifier)
                .setManualCoordinates(
                  latitude,
                  longitude,
                );
          },
        );
      },
    );
  }

  Future<void> _useCurrentLocation(
    WidgetRef ref,
  ) async {
    await ref.read(locationNotifierProvider.notifier).acquireDeviceLocation();
  }

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final locationState = ref.watch(
      locationNotifierProvider,
    );

    // A saved location is enough to calculate prayer times.
    if (locationState.location != null) {
      return const SizedBox.shrink();
    }

    // Avoid displaying the setup card before local storage has been checked.
    if (locationState.status == LocationStatus.initial) {
      return const SizedBox.shrink();
    }

    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    final isLoading = locationState.status == LocationStatus.requesting;
    final failure = locationState.failure;

    final description = failure == null
        ? l10n.homeLocationSetupDescription
        : LocationFailureLocalizer.message(
            context,
            code: failure.code,
            fallback: l10n.homeLocationSetupDescription,
          );

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest.withValues(
        alpha: 0.55,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(
          AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: colorScheme.primary,
                  size: 26,
                ),
                const SizedBox(
                  width: AppSpacing.sm,
                ),
                Expanded(
                  child: Text(
                    l10n.homeLocationSetupTitle,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: AppSpacing.md,
            ),
            Text(
              description,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.45,
              ),
            ),
            const SizedBox(
              height: AppSpacing.lg,
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: isLoading ? null : () => _useCurrentLocation(ref),
                icon: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(
                        Icons.my_location,
                      ),
                label: Text(
                  l10n.homeUseCurrentLocation,
                ),
              ),
            ),
            if (failure != null) ...[
              const SizedBox(
                height: AppSpacing.sm,
              ),
              LocationSettingsAction(
                failureCode: failure.code,
              ),
            ],
            const SizedBox(
              height: AppSpacing.sm,
            ),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: isLoading
                    ? null
                    : () => _showManualLocation(
                          context,
                          ref,
                        ),
                icon: const Icon(
                  Icons.edit_location_alt_outlined,
                ),
                label: Text(
                  l10n.manualLocationButton,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Optional notification onboarding card.
///
/// It is displayed only after a valid prayer schedule has been calculated.
class HomeNotificationSetupCard extends ConsumerStatefulWidget {
  const HomeNotificationSetupCard({super.key});

  @override
  ConsumerState<HomeNotificationSetupCard> createState() =>
      _HomeNotificationSetupCardState();
}

class _HomeNotificationSetupCardState
    extends ConsumerState<HomeNotificationSetupCard> {
  bool _isEnabling = false;

  Future<void> _enableNotifications() async {
    if (_isEnabling) {
      return;
    }

    setState(() {
      _isEnabling = true;
    });

    try {
      final success = await ref
          .read(notificationSettingsProvider.notifier)
          .toggleMaster(true);

      if (!success && mounted) {
        NotificationService.showError(
          context.l10n.notificationPermissionDeniedMessage,
        );
      }
    } catch (_) {
      if (mounted) {
        NotificationService.showError(
          context.l10n.generalError,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isEnabling = false;
        });
      }
    }
  }

  Future<void> _dismiss() async {
    try {
      await ref
          .read(notificationSettingsProvider.notifier)
          .dismissNotificationPrompt();
    } catch (_) {
      if (mounted) {
        NotificationService.showError(
          context.l10n.generalError,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final prayerState = ref.watch(
      prayerTimesNotifierProvider,
    );

    // Do not ask about notifications until prayer times are ready.
    if (prayerState.isLoading ||
        prayerState.location == null ||
        prayerState.schedule == null) {
      return const SizedBox.shrink();
    }

    final notificationState = ref.watch(
      notificationSettingsProvider,
    );

    if (!notificationState.isLoaded ||
        !notificationState.platformSupported ||
        notificationState.masterEnabled ||
        notificationState.notificationPromptDismissed) {
      return const SizedBox.shrink();
    }

    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest.withValues(
        alpha: 0.55,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(
          AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.notifications_active_outlined,
                  color: colorScheme.primary,
                  size: 26,
                ),
                const SizedBox(
                  width: AppSpacing.sm,
                ),
                Expanded(
                  child: Text(
                    l10n.homeNotificationSetupTitle,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: AppSpacing.md,
            ),
            Text(
              l10n.homeNotificationSetupDescription,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.45,
              ),
            ),
            const SizedBox(
              height: AppSpacing.lg,
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isEnabling ? null : _enableNotifications,
                icon: _isEnabling
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(
                        Icons.notifications_active_outlined,
                      ),
                label: Text(
                  l10n.homeEnableNotifications,
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: _isEnabling ? null : _dismiss,
                child: Text(
                  l10n.homeNotificationLater,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
