import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:islamfull/features/prayer/location/application/providers/location_notifier.dart';
import 'package:islamfull/features/prayer/location/application/states/location_state.dart';
import 'package:islamfull/features/prayer/location/domain/entities/prayer_location.dart';
import 'package:islamfull/features/prayer/qibla/application/qibla_compass_provider.dart';
import 'package:islamfull/features/prayer/qibla/application/qibla_provider.dart';
import 'package:islamfull/features/prayer/qibla/domain/qibla_models.dart';
import 'package:islamfull/features/prayer/qibla/domain/compass_alignment_rules.dart';
import 'package:islamfull/features/prayer/qibla/presentation/qibla_screen.dart';
import 'package:islamfull/features/prayer/qibla/presentation/widgets/qibla_compass_dial.dart';
import 'package:islamfull/l10n/generated/app_localizations.dart';

class FakeQiblaLocationNotifier extends LocationNotifier {
  final LocationState initialState;

  int acquireCalls = 0;

  FakeQiblaLocationNotifier(
    this.initialState,
  );

  @override
  LocationState build() => initialState;

  @override
  Future<bool> acquireDeviceLocation() async {
    acquireCalls++;
    return false;
  }
}

class FakeCompassNotifier extends QiblaCompassNotifier {
  final QiblaCompassState initialState;

  int retryCalls = 0;

  FakeCompassNotifier(
    this.initialState,
  );

  @override
  QiblaCompassState build() => initialState;

  @override
  void retry() {
    retryCalls++;
  }
}

void main() {
  const location = PrayerLocation(
    latitude: 41.0082,
    longitude: 28.9784,
    cityName: 'Istanbul',
    countryName: 'Turkiye',
    timezoneIdentifier: 'Europe/Istanbul',
  );

  Widget buildTestableWidget({
    required QiblaState qiblaState,
    required LocationNotifier locationNotifier,
    QiblaCompassState compassState = const QiblaCompassState(
      status: CompassStatus.unsupportedPlatform,
    ),
    double textScale = 1,
  }) {
    return ProviderScope(
      overrides: [
        qiblaProvider.overrideWithValue(
          qiblaState,
        ),
        locationNotifierProvider.overrideWith(
          () => locationNotifier,
        ),
        qiblaCompassProvider.overrideWith(
          () => FakeCompassNotifier(
            compassState,
          ),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
        ],
        locale: const Locale('en'),
        home: MediaQuery(
          data: MediaQueryData(
            textScaler: TextScaler.linear(
              textScale,
            ),
          ),
          child: const QiblaScreen(),
        ),
      ),
    );
  }

  testWidgets(
    'missing location error exposes retry action',
    (tester) async {
      final locationNotifier = FakeQiblaLocationNotifier(
        const LocationState(
          status: LocationStatus.failure,
        ),
      );

      await tester.pumpWidget(
        buildTestableWidget(
          qiblaState: const QiblaState(
            status: QiblaStatus.failure,
            failure: QiblaFailure(
              'Location unavailable',
              code: 'no_location',
            ),
          ),
          locationNotifier: locationNotifier,
        ),
      );

      await tester.tap(
        find.text(
          'Retry',
        ),
      );

      await tester.pump();

      expect(
        locationNotifier.acquireCalls,
        1,
      );
    },
  );

  testWidgets(
    'Qibla screen remains responsive with large text',
    (tester) async {
      final locationNotifier = FakeQiblaLocationNotifier(
        const LocationState(
          status: LocationStatus.success,
          location: location,
        ),
      );

      await tester.pumpWidget(
        buildTestableWidget(
          textScale: 2,
          qiblaState: const QiblaState(
            status: QiblaStatus.success,
            direction: QiblaDirection(
              bearingDegrees: 151.5,
              compassDirection: CompassDirection.se,
            ),
            locationName: 'Istanbul, Turkiye',
          ),
          locationNotifier: locationNotifier,
        ),
      );

      await tester.pump();

      expect(
        tester.takeException(),
        isNull,
      );

      expect(
        find.textContaining(
          '151.5°',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'ready compass draws a direction dial without using the camera',
    (tester) async {
      final locationNotifier = FakeQiblaLocationNotifier(
        const LocationState(
          status: LocationStatus.success,
          location: location,
        ),
      );
      await tester.pumpWidget(
        buildTestableWidget(
          qiblaState: const QiblaState(
            status: QiblaStatus.success,
            direction: QiblaDirection(
              bearingDegrees: 151.5,
              compassDirection: CompassDirection.se,
            ),
          ),
          locationNotifier: locationNotifier,
          compassState: const QiblaCompassState(
            status: CompassStatus.ready,
            qiblaBearing: 151.5,
            smoothedHeading: 90,
            relativeQiblaAngle: 61.5,
            alignmentStatus: QiblaAlignmentStatus.turnRight,
          ),
        ),
      );
      await tester.scrollUntilVisible(
        find.byType(QiblaCompassDial),
        250,
      );
      final dial = tester.widget<QiblaCompassDial>(
        find.byType(QiblaCompassDial),
      );
      expect(dial.headingDegrees, 90);
      expect(dial.relativeQiblaAngle, 61.5);
      expect(dial.isAligned, isFalse);
      expect(tester.takeException(), isNull);
    },
  );
}
