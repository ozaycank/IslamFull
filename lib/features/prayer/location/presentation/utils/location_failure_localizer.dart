import 'package:flutter/widgets.dart';

import '../../../../../core/extensions/context_extensions.dart';

class LocationFailureLocalizer {
  LocationFailureLocalizer._();

  static String message(
    BuildContext context, {
    required String? code,
    required String fallback,
  }) {
    final l10n = context.l10n;

    return switch (code) {
      'locationAccuracyInsufficient' =>
        l10n.locationAccuracyInsufficientMessage,
      'locationServiceDisabled' => l10n.locationServiceDisabledMessage,
      'permissionDenied' => l10n.locationPermissionDeniedMessage,
      'permissionDeniedForever' => l10n.locationPermissionDeniedForeverMessage,
      'locationTimeout' => l10n.locationTimeoutMessage,
      'invalidCoordinates' => l10n.locationInvalidCoordinatesMessage,
      'timezoneResolutionFailed' => l10n.locationTimezoneErrorMessage,
      'locationPersistenceFailed' => l10n.locationSaveFailedMessage,
      'prayerLocationUnavailable' => l10n.prayerLocationUnavailableMessage,
      _ => fallback,
    };
  }
}
