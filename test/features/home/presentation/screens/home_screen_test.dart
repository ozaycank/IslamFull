// ignore_for_file: avoid_relative_lib_imports

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import 'package:noor_life/features/home/presentation/screens/home_screen.dart';
import 'package:noor_life/features/menu/application/preferences_provider.dart';
import 'package:noor_life/features/prayer/location/application/providers/location_notifier.dart';
import 'package:noor_life/features/prayer/location/application/states/location_state.dart';
import 'package:noor_life/features/prayer/location/domain/entities/prayer_location.dart';
import 'package:noor_life/features/prayer/prayer_times/application/providers/prayer_times_notifier.dart';
import 'package:noor_life/features/prayer/prayer_times/application/states/prayer_times_state.dart';
import 'package:noor_life/features/prayer/prayer_times/presentation/providers/prayer_live_state_provider.dart';
import 'package:noor_life/features/prayer/shared/domain/errors/prayer_failure.dart';
import 'package:noor_life/features/quran/application/providers/quran_progress_provider.dart';
import 'package:noor_life/features/quran/application/providers/quran_provider.dart';
import 'package:noor_life/features/quran/application/states/quran_progress_state.dart';
import 'package:noor_life/features/quran/application/states/quran_state.dart';
import 'package:noor_life/features/quran/domain/entities/surah.dart';
import 'package:noor_life/features/quran/domain/repositories/quran_bookmark_repository.dart';
import 'package:noor_life/features/quran/domain/repositories/quran_repository.dart';
import 'package:noor_life/features/ramadan/application/ramadan_day_provider.dart';
import 'package:noor_life/features/ramadan/domain/ramadan_day_state.dart';
import 'package:noor_life/l10n/generated/app_localizations.dart';

class FakeLocationNotifier extends LocationNotifier {
  @override
  LocationState build() => const LocationState(
        status: LocationStatus.success,
        location: PrayerLocation(
          latitude: 41.0,
          longitude: 28.0,
          cityName: 'Istanbul',
          countryName: 'Turkey',
          timezoneIdentifier: 'Europe/Istanbul',
        ),
      );
}

class FakePrayerTimesNotifier extends PrayerTimesNotifier {
  @override
  PrayerTimesState build() => const PrayerTimesState(
        isLoading: false,
        failure: PrayerCalculationFailure(
          'Network error',
        ),
        location: PrayerLocation(
          latitude: 41.0,
          longitude: 28.0,
          cityName: 'Istanbul',
          countryName: 'Turkey',
          timezoneIdentifier: 'Europe/Istanbul',
        ),
      );
}

class FakeQuranProgressNotifier extends QuranProgressNotifier {
  @override
  QuranProgressState build() => const QuranProgressState(
        isLoading: false,
        lastRead: null,
      );
}

class FakeQuranNotifier extends QuranNotifier {
  @override
  QuranState build() => const QuranState(
        isLoading: false,
        surahs: [],
        searchQuery: '',
      );
}

class FakeQuranRepository implements QuranRepository {
  @override
  Future<List<Surah>> getSurahs() async => [];

  @override
  Future<Surah> getSurahDetail(
    int surahNumber,
  ) async {
    throw UnimplementedError();
  }

  @override
  dynamic noSuchMethod(
    Invocation invocation,
  ) =>
      super.noSuchMethod(
        invocation,
      );
}

class FakeQuranBookmarkRepository implements QuranBookmarkRepository {
  @override
  dynamic noSuchMethod(
    Invocation invocation,
  ) {
    if (invocation.memberName.toString().contains('Stream') ||
        invocation.memberName.toString().contains('watch')) {
      return const Stream.empty();
    }

    return [];
  }
}

void main() {
  setUp(() async {
    final getIt = GetIt.instance;

    await getIt.reset();

    getIt.registerSingleton<QuranRepository>(
      FakeQuranRepository(),
    );

    getIt.registerSingleton<QuranBookmarkRepository>(
      FakeQuranBookmarkRepository(),
    );
  });

  Widget buildTestableWidget(
    Widget widget, {
    required List<Override> overrides,
  }) {
    return ProviderScope(
      overrides: overrides,
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
        home: widget,
      ),
    );
  }

  List<Override> baseOverrides({
    RamadanDayState ramadanState = const RamadanDayState.outsideRamadan(),
  }) {
    return [
      locationNotifierProvider.overrideWith(
        () => FakeLocationNotifier(),
      ),
      prayerTimesNotifierProvider.overrideWith(
        () => FakePrayerTimesNotifier(),
      ),
      quranProgressNotifierProvider.overrideWith(
        () => FakeQuranProgressNotifier(),
      ),
      quranNotifierProvider.overrideWith(
        () => FakeQuranNotifier(),
      ),
      prayerLiveStateProvider.overrideWith(
        (ref) => const PrayerLiveState(
          nextPrayer: null,
          timeRemaining: Duration.zero,
        ),
      ),
      prayerTargetTimeProvider.overrideWithValue(
        DateTime.utc(
          2026,
          9,
          24,
          10,
        ),
      ),
      ramadanDayProvider.overrideWithValue(
        ramadanState,
      ),

      // This test verifies Home rendering rather than persisted preferences.
      showDailyVerseSettingProvider.overrideWithValue(true),
    ];
  }

  testWidgets(
    'Home displays location and failsafe prayer states safely',
    (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
          buildTestableWidget(
            const HomeScreen(),
            overrides: baseOverrides(),
          ),
        );

        await tester.pumpAndSettle();

        expect(
          find.textContaining(
            'Istanbul',
          ),
          findsOneWidget,
        );

        expect(
          find.text('Ramadan'),
          findsNothing,
        );
      });
    },
  );

  testWidgets(
    'Home displays Ramadan shortcut only during Ramadan',
    (tester) async {
      final ramadanState = RamadanDayState(
        phase: RamadanDayPhase.fasting,
        targetNow: DateTime.utc(
          2026,
          2,
          19,
          12,
        ),
        hijriDateString: '1447-9-1',
        imsakTime: DateTime.utc(
          2026,
          2,
          19,
          5,
        ),
        iftarTime: DateTime.utc(
          2026,
          2,
          19,
          18,
        ),
        tomorrowImsakTime: DateTime.utc(
          2026,
          2,
          20,
          5,
        ),
        timeRemaining: const Duration(hours: 6),
      );

      await tester.runAsync(() async {
        await tester.pumpWidget(
          buildTestableWidget(
            const HomeScreen(),
            overrides: baseOverrides(
              ramadanState: ramadanState,
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(
          find.text('Ramadan'),
          findsOneWidget,
        );

        expect(
          find.text('Until Iftar'),
          findsOneWidget,
        );

        expect(
          find.text('06:00:00'),
          findsOneWidget,
        );
      });
    },
  );
}
