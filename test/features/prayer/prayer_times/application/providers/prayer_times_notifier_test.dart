import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'package:noor_life/core/base/result.dart';
import 'package:noor_life/core/di/injection_container.dart';
import 'package:noor_life/core/logging/logger_service.dart';
import 'package:noor_life/features/prayer/location/application/providers/location_notifier.dart';
import 'package:noor_life/features/prayer/location/application/states/location_state.dart';
import 'package:noor_life/features/prayer/location/domain/entities/prayer_location.dart';
import 'package:noor_life/features/prayer/location/domain/interfaces/location_service.dart';
import 'package:noor_life/features/prayer/prayer_times/application/providers/prayer_times_notifier.dart';
import 'package:noor_life/features/prayer/prayer_times/application/services/prayer_orchestrator_service.dart';
import 'package:noor_life/features/prayer/prayer_times/domain/entities/prayer_day.dart';
import 'package:noor_life/features/prayer/prayer_times/domain/entities/prayer_schedule.dart';

class MockPrayerOrchestratorService extends Mock
    implements PrayerOrchestratorService {}

class MockLoggerService extends Mock implements LoggerService {}

class FakeLocationNotifier extends LocationNotifier {
  final LocationState initialState;

  FakeLocationNotifier(
    this.initialState,
  );

  @override
  LocationState build() => initialState;

  void emit(
    LocationState value,
  ) {
    state = value;
  }
}

void main() {
  const location = PrayerLocation(
    latitude: 39.3292,
    longitude: 42.289504,
    cityName: 'Aktuzla',
    countryName: 'Türkiye',
    timezoneIdentifier: 'Europe/Istanbul',
  );

  late MockPrayerOrchestratorService orchestrator;

  late MockLoggerService logger;

  setUpAll(() {
    tz.initializeTimeZones();

    registerFallbackValue(
      location,
    );

    registerFallbackValue(
      DateTime.utc(2026, 1, 1),
    );
  });

  setUp(() async {
    await getIt.reset();

    orchestrator = MockPrayerOrchestratorService();

    logger = MockLoggerService();

    getIt.registerSingleton<PrayerOrchestratorService>(
      orchestrator,
    );

    getIt.registerSingleton<LoggerService>(
      logger,
    );
  });

  tearDown(() async {
    await getIt.reset();
  });

  PrayerSchedule createSchedule() {
    return PrayerSchedule(
      yesterday: PrayerDay(
        targetDate: DateTime.utc(2026, 9, 30),
        prayerTimes: const [],
      ),
      today: PrayerDay(
        targetDate: DateTime.utc(2026, 10, 1),
        prayerTimes: const [],
      ),
      tomorrow: PrayerDay(
        targetDate: DateTime.utc(2026, 10, 2),
        prayerTimes: const [],
      ),
    );
  }

  test(
    'does not calculate prayer times when no valid location exists',
    () async {
      final fakeLocationNotifier = FakeLocationNotifier(
        const LocationState(
          status: LocationStatus.failure,
          failure: LocationFailure(
            'Accuracy too low',
            code: 'locationAccuracyInsufficient',
          ),
        ),
      );

      final container = ProviderContainer(
        overrides: [
          locationNotifierProvider.overrideWith(
            () => fakeLocationNotifier,
          ),
        ],
      );

      addTearDown(
        container.dispose,
      );

      container.read(
        prayerTimesNotifierProvider,
      );

      await pumpEventQueue(
        times: 5,
      );

      final state = container.read(
        prayerTimesNotifierProvider,
      );

      expect(
        state.schedule,
        isNull,
      );

      expect(
        state.location,
        isNull,
      );

      expect(
        state.failure?.code,
        'locationAccuracyInsufficient',
      );

      verifyNever(
        () => orchestrator.getSchedule(
          any(),
          any(),
        ),
      );
    },
  );

  test(
    'automatically loads prayer schedule when location becomes available',
    () async {
      final schedule = createSchedule();

      when(
        () => orchestrator.getSchedule(
          location,
          any(),
        ),
      ).thenAnswer(
        (_) async => Success(
          schedule,
        ),
      );

      final fakeLocationNotifier = FakeLocationNotifier(
        const LocationState(
          status: LocationStatus.requesting,
        ),
      );

      final container = ProviderContainer(
        overrides: [
          locationNotifierProvider.overrideWith(
            () => fakeLocationNotifier,
          ),
        ],
      );

      addTearDown(
        container.dispose,
      );

      container.read(
        prayerTimesNotifierProvider,
      );

      await pumpEventQueue();

      fakeLocationNotifier.emit(
        const LocationState(
          status: LocationStatus.success,
          location: location,
        ),
      );

      await pumpEventQueue(
        times: 10,
      );

      final state = container.read(
        prayerTimesNotifierProvider,
      );

      expect(
        state.location,
        location,
      );

      expect(
        state.schedule,
        schedule,
      );

      expect(
        state.failure,
        isNull,
      );

      verify(
        () => orchestrator.getSchedule(
          location,
          any(),
        ),
      ).called(1);
    },
  );
}
