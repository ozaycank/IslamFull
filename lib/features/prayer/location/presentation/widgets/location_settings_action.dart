import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../../core/extensions/context_extensions.dart';

/// Offers a device-settings recovery action only when it can help.
///
/// No settings screen opens automatically. Web users retain the manual
/// coordinate option because Geolocator's settings APIs are native-only.
class LocationSettingsAction extends StatelessWidget {
  final String? failureCode;
  final Future<bool> Function()? openDeviceLocationSettings;
  final Future<bool> Function()? openApplicationSettings;

  const LocationSettingsAction({
    super.key,
    required this.failureCode,
    this.openDeviceLocationSettings,
    this.openApplicationSettings,
  });

  @override
  Widget build(BuildContext context) {
    if (kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.android &&
            defaultTargetPlatform != TargetPlatform.iOS)) {
      return const SizedBox.shrink();
    }

    final isServiceDisabled = failureCode == 'locationServiceDisabled';
    final isPermissionBlocked = failureCode == 'permissionDeniedForever';

    if (!isServiceDisabled && !isPermissionBlocked) {
      return const SizedBox.shrink();
    }

    final l10n = context.l10n;

    return OutlinedButton.icon(
      key: const ValueKey('locationRecoverySettingsButton'),
      icon: const Icon(Icons.settings_outlined),
      label: Text(
        isServiceDisabled
            ? l10n.locationOpenDeviceSettings
            : l10n.locationOpenAppSettings,
      ),
      onPressed: () async {
        try {
          if (isServiceDisabled) {
            await (openDeviceLocationSettings ??
                Geolocator.openLocationSettings)();
          } else {
            await (openApplicationSettings ?? Geolocator.openAppSettings)();
          }
        } catch (_) {
          // Android/iOS can refuse the settings intent. The existing retry
          // and manual-coordinate actions remain available in the UI.
        }
      },
    );
  }
}
