import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/error_state_widget.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../location/application/providers/location_notifier.dart';
import '../../shared/presentation/utils/presentation_localizer.dart';
import '../application/qibla_compass_provider.dart';
import '../application/qibla_provider.dart';
import '../domain/compass_alignment_rules.dart';
import '../domain/qibla_models.dart';

class QiblaScreen extends ConsumerWidget {
  const QiblaScreen({
    super.key,
  });

  String _getLocalizedDirection(
    CompassDirection direction,
    AppLocalizations l10n,
  ) {
    switch (direction) {
      case CompassDirection.n:
        return l10n.dirNorth;
      case CompassDirection.ne:
        return l10n.dirNorthEast;
      case CompassDirection.e:
        return l10n.dirEast;
      case CompassDirection.se:
        return l10n.dirSouthEast;
      case CompassDirection.s:
        return l10n.dirSouth;
      case CompassDirection.sw:
        return l10n.dirSouthWest;
      case CompassDirection.w:
        return l10n.dirWest;
      case CompassDirection.nw:
        return l10n.dirNorthWest;
    }
  }

  Widget _buildCompassMessage(
    BuildContext context, {
    required String message,
    VoidCallback? onRetry,
  }) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Semantics(
      liveRegion: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(
              height: AppSpacing.md,
            ),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(
                Icons.refresh,
              ),
              label: Text(
                l10n.retryButton,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCompassSection(
    BuildContext context,
    QiblaCompassState state, {
    required VoidCallback onRetry,
  }) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    switch (state.status) {
      case CompassStatus.locationUnavailable:
        return _buildCompassMessage(
          context,
          message: l10n.qiblaUnavailable,
        );

      case CompassStatus.unsupportedPlatform:
        return _buildCompassMessage(
          context,
          message: l10n.compassUnsupportedPlatform,
        );

      case CompassStatus.sensorUnavailable:
        return _buildCompassMessage(
          context,
          message: l10n.compassSensorUnavailable,
          onRetry: onRetry,
        );

      case CompassStatus.error:
        return _buildCompassMessage(
          context,
          message: l10n.compassError,
          onRetry: onRetry,
        );

      case CompassStatus.initial:
        return Center(
          child: CircularProgressIndicator(
            semanticsLabel: l10n.qiblaCompass,
          ),
        );

      case CompassStatus.ready:
        break;
    }

    if (state.smoothedHeading == null ||
        state.relativeQiblaAngle == null ||
        state.alignmentStatus == null) {
      return Center(
        child: CircularProgressIndicator(
          semanticsLabel: l10n.qiblaCompass,
        ),
      );
    }

    final relative = state.relativeQiblaAngle!;

    final alignment = state.alignmentStatus!;

    late final String directionText;

    late final Color indicatorColor;

    switch (alignment) {
      case QiblaAlignmentStatus.aligned:
        directionText = l10n.qiblaAligned;
        indicatorColor = colorScheme.primary;

      case QiblaAlignmentStatus.turnRight:
        directionText = l10n.turnRight(
          relative.abs().toStringAsFixed(1),
        );
        indicatorColor = colorScheme.secondary;

      case QiblaAlignmentStatus.turnLeft:
        directionText = l10n.turnLeft(
          relative.abs().toStringAsFixed(1),
        );
        indicatorColor = colorScheme.secondary;
    }

    return Column(
      children: [
        _InfoRow(
          label: l10n.qiblaHeading,
          value: '${state.smoothedHeading!.toStringAsFixed(1)}°',
        ),
        _InfoRow(
          label: l10n.qiblaRelativeAngle,
          value: '${relative > 0 ? '+' : ''}'
              '${relative.toStringAsFixed(1)}°',
        ),
        const SizedBox(
          height: AppSpacing.xxl,
        ),
        ExcludeSemantics(
          child: Transform.rotate(
            angle: relative * (math.pi / 180),
            child: Icon(
              Icons.navigation,
              color: indicatorColor,
              size: 100,
            ),
          ),
        ),
        const SizedBox(
          height: AppSpacing.xl,
        ),
        Semantics(
          liveRegion: true,
          label: directionText,
          child: ExcludeSemantics(
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              children: [
                if (alignment == QiblaAlignmentStatus.aligned)
                  Icon(
                    Icons.check_circle,
                    color: indicatorColor,
                    size: 28,
                  ),
                if (alignment == QiblaAlignmentStatus.turnRight)
                  Icon(
                    Icons.turn_right,
                    color: indicatorColor,
                    size: 28,
                  ),
                if (alignment == QiblaAlignmentStatus.turnLeft)
                  Icon(
                    Icons.turn_left,
                    color: indicatorColor,
                    size: 28,
                  ),
                Text(
                  directionText,
                  textAlign: TextAlign.center,
                  style: textTheme.titleLarge?.copyWith(
                    color: indicatorColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final l10n = context.l10n;

    final state = ref.watch(
      qiblaProvider,
    );

    final compassState = ref.watch(
      qiblaCompassProvider,
    );

    final locationState = ref.watch(
      locationNotifierProvider,
    );

    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    final location = locationState.location;

    final formattedLocation = location != null
        ? PresentationLocalizer.formatLocation(
            context: context,
            cityName: location.cityName,
            subAdminArea: null,
            countryName: location.countryName,
          )
        : l10n.locationUnavailable;

    Widget body;

    if (state.status == QiblaStatus.loading) {
      body = Center(
        child: CircularProgressIndicator(
          semanticsLabel: l10n.qiblaTitle,
        ),
      );
    } else if (state.status == QiblaStatus.failure || state.direction == null) {
      final isMissingLocation = state.failure?.code == 'no_location';

      body = ErrorStateWidget(
        title: l10n.qiblaUnavailable,
        message: state.failure?.code == 'qiblaUndefinedAtKaaba'
            ? l10n.qiblaUndefinedAtKaaba
            : isMissingLocation
                ? l10n.qiblaUnavailable
                : l10n.qiblaCalculationError,
        retryText: l10n.retryButton,
        onRetry: isMissingLocation
            ? () {
                ref
                    .read(
                      locationNotifierProvider.notifier,
                    )
                    .acquireDeviceLocation();
              }
            : null,
      );
    } else {
      body = ListView(
        padding: const EdgeInsets.all(
          AppSpacing.lg,
        ),
        children: [
          SectionHeader(
            title: l10n.qiblaLocation,
          ),
          AppCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on,
                  color: colorScheme.primary,
                ),
                const SizedBox(
                  width: AppSpacing.sm,
                ),
                Expanded(
                  child: Text(
                    formattedLocation,
                    style: textTheme.titleMedium,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: AppSpacing.xxl,
          ),
          SectionHeader(
            title: l10n.qiblaDirection,
          ),
          AppCard(
            child: Column(
              children: [
                const SizedBox(
                  height: AppSpacing.xl,
                ),
                ExcludeSemantics(
                  child: Container(
                    padding: const EdgeInsets.all(
                      AppSpacing.xl,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorScheme.primaryContainer.withValues(
                        alpha: 0.5,
                      ),
                    ),
                    child: Icon(
                      Icons.explore,
                      size: 64,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(
                  height: AppSpacing.lg,
                ),
                Text(
                  '${state.direction!.bearingDegrees.toStringAsFixed(1)}° '
                  '${_getLocalizedDirection(
                    state.direction!.compassDirection,
                    l10n,
                  )}',
                  textAlign: TextAlign.center,
                  style: textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(
                  height: AppSpacing.xl,
                ),
                Text(
                  l10n.qiblaDisclaimer,
                  textAlign: TextAlign.center,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: AppSpacing.xxl,
          ),
          SectionHeader(
            title: l10n.qiblaCompass,
          ),
          AppCard(
            child: _buildCompassSection(
              context,
              compassState,
              onRetry: () {
                ref
                    .read(
                      qiblaCompassProvider.notifier,
                    )
                    .retry();
              },
            ),
          ),
          const SizedBox(
            height: AppSpacing.xxl,
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.qiblaTitle),
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 800,
            ),
            child: body,
          ),
        ),
      ),
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
  Widget build(
    BuildContext context,
  ) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xs,
      ),
      child: LayoutBuilder(
        builder: (
          context,
          constraints,
        ) {
          final scaledFontSize = MediaQuery.textScalerOf(
            context,
          ).scale(
            textTheme.bodyMedium?.fontSize ?? 14,
          );

          final shouldStack =
              constraints.maxWidth < 320 || scaledFontSize >= 20;

          final labelWidget = Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          );

          final valueWidget = Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          );

          if (shouldStack) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                labelWidget,
                const SizedBox(
                  height: AppSpacing.xs,
                ),
                valueWidget,
              ],
            );
          }

          return Row(
            children: [
              Expanded(
                child: labelWidget,
              ),
              const SizedBox(
                width: AppSpacing.md,
              ),
              valueWidget,
            ],
          );
        },
      ),
    );
  }
}
