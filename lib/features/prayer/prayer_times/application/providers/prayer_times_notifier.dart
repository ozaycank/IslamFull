import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../../../core/base/result.dart';
import '../../../../../core/di/injection_container.dart';
import '../../../../../core/logging/logger_extensions.dart';
import '../../../../../core/logging/logger_service.dart';
import '../../../location/application/providers/location_notifier.dart';
import '../../../location/application/states/location_state.dart';
import '../../../location/domain/entities/prayer_location.dart';
import '../../../shared/domain/errors/prayer_failure.dart';
import '../services/prayer_orchestrator_service.dart';
import '../states/prayer_times_state.dart';

final prayerTimesNotifierProvider =
    NotifierProvider<PrayerTimesNotifier, PrayerTimesState>(
  PrayerTimesNotifier.new,
);

class PrayerTimesNotifier extends Notifier<PrayerTimesState> {
  late final PrayerOrchestratorService _orchestrator;
  late final LoggerService _logger;

  int _loadGeneration = 0;

  @override
  PrayerTimesState build() {
    _orchestrator = getIt<PrayerOrchestratorService>();

    _logger = getIt<LoggerService>();

    ref.listen<LocationState>(
      locationNotifierProvider,
      (previous, next) {
        _handleLocationState(
          previous,
          next,
        );
      },
    );

    // LocationNotifier initializes asynchronously. Synchronize with its
    // current state once this notifier has completed its own build.
    Future.microtask(
      () => _handleLocationState(
        null,
        ref.read(locationNotifierProvider),
      ),
    );

    return const PrayerTimesState.initial();
  }

  void _handleLocationState(
    LocationState? previous,
    LocationState next,
  ) {
    if (next.status == LocationStatus.requesting) {
      if (state.schedule == null) {
        state = state.copyWith(
          isLoading: true,
          failure: () => null,
        );
      }

      return;
    }

    final location = next.location;

    if (next.status == LocationStatus.success && location != null) {
      final locationChanged =
          previous?.location != location || state.location != location;

      if (locationChanged || state.schedule == null) {
        unawaited(
          _loadTimesForLocation(
            location,
          ),
        );
      }

      return;
    }

    if (next.status == LocationStatus.failure && location == null) {
      _setLocationUnavailable(
        message: next.failure?.message,
        code: next.failure?.code,
      );
    }
  }

  Future<void> loadTimes() async {
    final locationState = ref.read(
      locationNotifierProvider,
    );

    final location = locationState.location;

    if (location == null) {
      _setLocationUnavailable(
        message: locationState.failure?.message,
        code: locationState.failure?.code,
      );

      return;
    }

    await _loadTimesForLocation(
      location,
    );
  }

  Future<void> _loadTimesForLocation(
    PrayerLocation location,
  ) async {
    final requestGeneration = ++_loadGeneration;

    final locationChanged = state.location != location;

    state = state.copyWith(
      isLoading: true,
      failure: () => null,
      schedule: locationChanged ? () => null : null,
      location: () => location,
    );

    final tz.Location targetTimezone;

    try {
      targetTimezone = tz.getLocation(
        location.timezoneIdentifier,
      );
    } catch (_) {
      if (requestGeneration != _loadGeneration) {
        return;
      }

      state = state.copyWith(
        isLoading: false,
        failure: () => const PrayerLocationFailure(
          'Selected location has an invalid timezone.',
          code: 'timezoneResolutionFailed',
        ),
        schedule: () => null,
      );

      return;
    }

    final targetNow = tz.TZDateTime.from(
      DateTime.now(),
      targetTimezone,
    );

    final targetCalendarDate = DateTime.utc(
      targetNow.year,
      targetNow.month,
      targetNow.day,
    );

    final result = await _orchestrator.getSchedule(
      location,
      targetCalendarDate,
    );

    // A newer location request superseded this result.
    if (requestGeneration != _loadGeneration) {
      return;
    }

    switch (result) {
      case Success(value: final schedule):
        _logger.logPrayer(
          'Prayer schedule loaded successfully.',
        );

        state = state.copyWith(
          isLoading: false,
          failure: () => null,
          schedule: () => schedule,
          location: () => location,
        );

      case ResultFailure(failure: final failure):
        _logger.logPrayer(
          'Failed to load prayer schedule: '
          '${failure.message}',
        );

        state = state.copyWith(
          isLoading: false,
          failure: () => failure,
        );
    }
  }

  void _setLocationUnavailable({
    String? message,
    String? code,
  }) {
    // Invalidate any schedule request still in flight.
    _loadGeneration++;

    state = state.copyWith(
      isLoading: false,
      failure: () => PrayerLocationFailure(
        message ?? 'A prayer location has not been selected.',
        code: code ?? 'prayerLocationUnavailable',
      ),
      schedule: () => null,
      location: () => null,
    );
  }

  Future<void> refreshTimes() async {
    await loadTimes();
  }
}
