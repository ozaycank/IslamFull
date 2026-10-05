import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/features/prayer/qibla/application/qibla_compass_provider.dart';

void main() {
  group(
    'QiblaCompassState',
    () {
      test(
        'copyWith can explicitly clear nullable compass values',
        () {
          const state = QiblaCompassState(
            status: CompassStatus.ready,
            qiblaBearing: 145,
            smoothedHeading: 90,
            relativeQiblaAngle: 55,
          );

          final cleared = state.copyWith(
            status: CompassStatus.locationUnavailable,
            qiblaBearing: () => null,
            smoothedHeading: () => null,
            relativeQiblaAngle: () => null,
            alignmentStatus: () => null,
            failure: () => null,
          );

          expect(
            cleared.status,
            CompassStatus.locationUnavailable,
          );

          expect(
            cleared.qiblaBearing,
            isNull,
          );

          expect(
            cleared.smoothedHeading,
            isNull,
          );

          expect(
            cleared.relativeQiblaAngle,
            isNull,
          );
        },
      );

      test(
        'copyWith preserves values when nullable callbacks are omitted',
        () {
          const state = QiblaCompassState(
            status: CompassStatus.ready,
            qiblaBearing: 145,
            smoothedHeading: 90,
            relativeQiblaAngle: 55,
          );

          final updated = state.copyWith(
            status: CompassStatus.error,
          );

          expect(
            updated.qiblaBearing,
            145,
          );

          expect(
            updated.smoothedHeading,
            90,
          );

          expect(
            updated.relativeQiblaAngle,
            55,
          );
        },
      );
    },
  );
}
