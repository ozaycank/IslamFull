import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'package:islamfull/core/base/result.dart';
import 'package:islamfull/core/di/injection_container.dart';
import 'package:islamfull/core/logging/logger_service.dart';
import 'package:islamfull/features/prayer/location/application/providers/location_notifier.dart';
import 'package:islamfull/features/prayer/location/application/states/location_state.dart';
import 'package:islamfull/features/prayer/location/domain/entities/prayer_location.dart';
import 'package:islamfull/features/prayer/location/domain/interfaces/location_service.dart';
import 'package:islamfull/features/prayer/prayer_times/application/providers/prayer_times_notifier.dart';
import 'package:islamfull/features/prayer/prayer_times/application/services/prayer_orchestrator_service.dart';
import 'package:islamfull/features/prayer/prayer_times/domain/entities/prayer_day.dart';
import 'package:islamfull/features/prayer/prayer_times/domain/entities/prayer_schedule.dart';
import 'package:islamfull/features/prayer/shared/domain/errors/prayer_failure.dart';

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
    tz_data.initializeTimeZones();

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

  test(
    'does not lose a day refresh requested while a schedule is loading',
    () async {
      final loadGate = Completer<Result<PrayerSchedule, PrayerFailure>>();
      final requestedDates = <DateTime>[];

      when(
        () => orchestrator.getSchedule(
          location,
          any(),
        ),
      ).thenAnswer((invocation) {
        requestedDates.add(invocation.positionalArguments[1] as DateTime);
        return loadGate.future;
      });

      final fakeLocationNotifier = FakeLocationNotifier(
        const LocationState(
          status: LocationStatus.success,
          location: location,
        ),
      );

      final container = ProviderContainer(
        overrides: [
          locationNotifierProvider.overrideWith(
            () => fakeLocationNotifier,
          ),
        ],
      );
      addTearDown(container.dispose);

      container.read(prayerTimesNotifierProvider);
      await pumpEventQueue(times: 5);

      expect(container.read(prayerTimesNotifierProvider).isLoading, isTrue);
      expect(requestedDates, hasLength(1));

      await container
          .read(prayerTimesNotifierProvider.notifier)
          .refreshIfCalendarDayChanged(
            referenceTime: DateTime.utc(2026, 10, 1, 21, 1),
          );

      loadGate.complete(
        Success<PrayerSchedule, PrayerFailure>(createSchedule()),
      );
      await pumpEventQueue(times: 10);

      final currentTargetTime = tz.TZDateTime.now(
        tz.getLocation(location.timezoneIdentifier),
      );
      final expectedDate = DateTime.utc(
        currentTargetTime.year,
        currentTargetTime.month,
        currentTargetTime.day,
      );

      expect(requestedDates, hasLength(2));
      expect(requestedDates.last, expectedDate);
    },
  );

  test(
    'refreshes the schedule when the selected location enters a new day',
    () async {
      final requestedDates = <DateTime>[];

      final nextDaySchedule = PrayerSchedule(
        yesterday: PrayerDay(
          targetDate: DateTime.utc(2026, 10, 1),
          prayerTimes: const [],
        ),
        today: PrayerDay(
          targetDate: DateTime.utc(2026, 10, 2),
          prayerTimes: const [],
        ),
        tomorrow: PrayerDay(
          targetDate: DateTime.utc(2026, 10, 3),
          prayerTimes: const [],
        ),
      );

      when(
        () => orchestrator.getSchedule(
          location,
          any(),
        ),
      ).thenAnswer((invocation) async {
        final targetDate = invocation.positionalArguments[1] as DateTime;
        requestedDates.add(targetDate);

        return Success(
          targetDate == DateTime.utc(2026, 10, 2)
              ? nextDaySchedule
              : createSchedule(),
        );
      });

      final fakeLocationNotifier = FakeLocationNotifier(
        const LocationState(
          status: LocationStatus.success,
          location: location,
        ),
      );

      final container = ProviderContainer(
        overrides: [
          locationNotifierProvider.overrideWith(
            () => fakeLocationNotifier,
          ),
        ],
      );

      addTearDown(container.dispose);

      container.read(prayerTimesNotifierProvider);
      await pumpEventQueue(times: 10);

      final initialRequestCount = requestedDates.length;

      // 20:59 UTC is 23:59 in the selected Europe/Istanbul timezone.
      await container
          .read(prayerTimesNotifierProvider.notifier)
          .refreshIfCalendarDayChanged(
            referenceTime: DateTime.utc(2026, 10, 1, 20, 59),
          );

      expect(requestedDates.length, initialRequestCount);

      // Two minutes later in that timezone, the schedule must move to Oct 2.
      await container
          .read(prayerTimesNotifierProvider.notifier)
          .refreshIfCalendarDayChanged(
            referenceTime: DateTime.utc(2026, 10, 1, 21, 1),
          );
      await pumpEventQueue(times: 10);

      expect(requestedDates.length, initialRequestCount + 1);
      expect(requestedDates.last, DateTime.utc(2026, 10, 2));
      expect(
        container.read(prayerTimesNotifierProvider).schedule?.today.targetDate,
        DateTime.utc(2026, 10, 2),
      );
    },
  );
}
