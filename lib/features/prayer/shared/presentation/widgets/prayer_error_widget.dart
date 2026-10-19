import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../../shared/widgets/error_state_widget.dart';
import '../../../location/presentation/widgets/location_settings_action.dart';

class PrayerErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final String? failureCode;

  const PrayerErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
    this.failureCode,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      children: [
        Expanded(
          child: ErrorStateWidget(
            title: l10n.errorStateDefaultTitle,
            message: message,
            retryText: l10n.retryButton,
            onRetry: onRetry,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
          ),
          child: LocationSettingsAction(failureCode: failureCode),
        ),
      ],
    );
  }
}
