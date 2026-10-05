import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/injection_container.dart';
import '../domain/circular_smoothing_filter.dart';
import '../domain/compass_alignment_rules.dart';
import '../domain/compass_models.dart';
import '../domain/interfaces/device_heading_service.dart';
import '../domain/relative_qibla_calculator.dart';
import 'qibla_provider.dart';

enum CompassStatus {
  initial,
  ready,
  sensorUnavailable,
  error,
  unsupportedPlatform,
  locationUnavailable,
}

class QiblaCompassState extends Equatable {
  final CompassStatus status;
  final double? qiblaBearing;
  final double? smoothedHeading;
  final double? relativeQiblaAngle;
  final QiblaAlignmentStatus? alignmentStatus;
  final CompassFailure? failure;

  const QiblaCompassState({
    this.status = CompassStatus.initial,
    this.qiblaBearing,
    this.smoothedHeading,
    this.relativeQiblaAngle,
    this.alignmentStatus,
    this.failure,
  });

  QiblaCompassState copyWith({
    CompassStatus? status,
    double? Function()? qiblaBearing,
    double? Function()? smoothedHeading,
    double? Function()? relativeQiblaAngle,
    QiblaAlignmentStatus? Function()? alignmentStatus,
    CompassFailure? Function()? failure,
  }) {
    return QiblaCompassState(
      status: status ?? this.status,
      qiblaBearing: qiblaBearing != null ? qiblaBearing() : this.qiblaBearing,
      smoothedHeading:
          smoothedHeading != null ? smoothedHeading() : this.smoothedHeading,
      relativeQiblaAngle: relativeQiblaAngle != null
          ? relativeQiblaAngle()
          : this.relativeQiblaAngle,
      alignmentStatus:
          alignmentStatus != null ? alignmentStatus() : this.alignmentStatus,
      failure: failure != null ? failure() : this.failure,
    );
  }

  @override
  List<Object?> get props => [
        status,
        qiblaBearing,
        smoothedHeading,
        relativeQiblaAngle,
        alignmentStatus,
        failure,
      ];
}

final qiblaCompassProvider =
    NotifierProvider.autoDispose<QiblaCompassNotifier, QiblaCompassState>(
  QiblaCompassNotifier.new,
);

class QiblaCompassNotifier extends AutoDisposeNotifier<QiblaCompassState> {
  StreamSubscription<Result<DeviceHeading?, CompassFailure>>? _subscription;

  late final DeviceHeadingService _headingService;

  late final CircularSmoothingFilter _smoothingFilter;

  @override
  QiblaCompassState build() {
    _headingService = getIt<DeviceHeadingService>();

    _smoothingFilter = CircularSmoothingFilter();

    ref.listen(
      qiblaProvider,
      (
        previous,
        next,
      ) {
        if (next.status == QiblaStatus.success && next.direction != null) {
          _updateQiblaBearing(
            next.direction!.bearingDegrees,
          );

          return;
        }

        state = state.copyWith(
          status: CompassStatus.locationUnavailable,
          qiblaBearing: () => null,
          relativeQiblaAngle: () => null,
          alignmentStatus: () => null,
          failure: () => null,
        );
      },
    );

    final initialQibla = ref.read(
      qiblaProvider,
    );

    final initialBearing = initialQibla.status == QiblaStatus.success &&
            initialQibla.direction != null
        ? initialQibla.direction!.bearingDegrees
        : null;

    ref.onDispose(
      () {
        _subscription?.cancel();
      },
    );

    _initStream();

    return QiblaCompassState(
      status: initialBearing != null
          ? CompassStatus.initial
          : CompassStatus.locationUnavailable,
      qiblaBearing: initialBearing,
    );
  }

  void retry() {
    _subscription?.cancel();
    _subscription = null;

    _smoothingFilter.reset();

    final qiblaState = ref.read(
      qiblaProvider,
    );

    final bearing =
        qiblaState.status == QiblaStatus.success && qiblaState.direction != null
            ? qiblaState.direction!.bearingDegrees
            : null;

    state = QiblaCompassState(
      status: bearing != null
          ? CompassStatus.initial
          : CompassStatus.locationUnavailable,
      qiblaBearing: bearing,
    );

    _initStream();
  }

  void _initStream() {
    _subscription = _headingService.headingStream.listen(
      _handleHeadingResult,
      onError: (
        Object error,
        StackTrace stackTrace,
      ) {
        _smoothingFilter.reset();

        state = state.copyWith(
          status: CompassStatus.error,
          smoothedHeading: () => null,
          relativeQiblaAngle: () => null,
          alignmentStatus: () => null,
          failure: () => const CompassFailure(
            'Compass stream failed.',
            code: 'compass_stream_error',
          ),
        );
      },
    );
  }

  void _handleHeadingResult(
    Result<DeviceHeading?, CompassFailure> result,
  ) {
    switch (result) {
      case Success(
          value: final heading,
        ):
        if (heading == null) {
          _smoothingFilter.reset();

          state = state.copyWith(
            status: CompassStatus.sensorUnavailable,
            smoothedHeading: () => null,
            relativeQiblaAngle: () => null,
            alignmentStatus: () => null,
            failure: () => const CompassFailure(
              'Sensor unavailable.',
              code: 'sensor_unavailable',
            ),
          );

          return;
        }

        final calculatedHeading = _smoothingFilter.smooth(
          heading.headingDegrees,
        );

        final bearing = state.qiblaBearing;

        if (bearing == null) {
          state = state.copyWith(
            status: CompassStatus.locationUnavailable,
            smoothedHeading: () => calculatedHeading,
            relativeQiblaAngle: () => null,
            alignmentStatus: () => null,
            failure: () => null,
          );

          return;
        }

        final relative = RelativeQiblaCalculator.calculate(
          bearing,
          calculatedHeading,
        );

        final alignment = CompassAlignmentRules.evaluate(
          relative,
        );

        state = state.copyWith(
          status: CompassStatus.ready,
          smoothedHeading: () => calculatedHeading,
          relativeQiblaAngle: () => relative,
          alignmentStatus: () => alignment,
          failure: () => null,
        );

      case ResultFailure(
          failure: final failure,
        ):
        _smoothingFilter.reset();

        final nextStatus = switch (failure.code) {
          'unsupported_platform' => CompassStatus.unsupportedPlatform,
          'sensor_unavailable' => CompassStatus.sensorUnavailable,
          _ => CompassStatus.error,
        };

        state = state.copyWith(
          status: nextStatus,
          smoothedHeading: () => null,
          relativeQiblaAngle: () => null,
          alignmentStatus: () => null,
          failure: () => failure,
        );
    }
  }

  void _updateQiblaBearing(
    double newBearing,
  ) {
    final smoothHeading = state.smoothedHeading;

    if (smoothHeading == null) {
      final recoveringFromLocation =
          state.status == CompassStatus.locationUnavailable ||
              state.status == CompassStatus.initial;

      state = state.copyWith(
        status: recoveringFromLocation ? CompassStatus.initial : state.status,
        qiblaBearing: () => newBearing,
        relativeQiblaAngle: () => null,
        alignmentStatus: () => null,
        failure: recoveringFromLocation ? () => null : null,
      );

      return;
    }

    final relative = RelativeQiblaCalculator.calculate(
      newBearing,
      smoothHeading,
    );

    final alignment = CompassAlignmentRules.evaluate(
      relative,
    );

    state = state.copyWith(
      status: CompassStatus.ready,
      qiblaBearing: () => newBearing,
      relativeQiblaAngle: () => relative,
      alignmentStatus: () => alignment,
      failure: () => null,
    );
  }
}
