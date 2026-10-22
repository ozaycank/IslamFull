import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:islamfull/core/di/injection_container.dart';
import 'package:islamfull/core/privacy/religious_progress_consent_provider.dart';
import 'package:islamfull/core/routing/app_routes.dart';
import 'package:islamfull/features/quran/application/providers/quran_bookmark_provider.dart';
import 'package:islamfull/features/quran/application/providers/quran_progress_provider.dart';
import 'package:islamfull/features/quran/application/providers/quran_reader_settings_provider.dart';
import 'package:islamfull/features/quran/application/states/quran_bookmark_state.dart';
import 'package:islamfull/features/quran/application/states/quran_progress_state.dart';
import 'package:islamfull/features/quran/application/states/quran_reader_settings_state.dart';
import 'package:islamfull/features/quran/domain/entities/ayah.dart';
import 'package:islamfull/features/quran/domain/entities/revelation_type.dart';
import 'package:islamfull/features/quran/domain/entities/surah.dart';
import 'package:islamfull/features/quran/domain/repositories/quran_repository.dart';
import 'package:islamfull/features/quran/presentation/screens/surah_detail_screen.dart';
import 'package:islamfull/l10n/generated/app_localizations.dart';

class _FakeQuranRepository implements QuranRepository {
  @override
  Future<List<Surah>> getSurahs() async => [];

  @override
  Future<Surah> getSurahDetail(
    int surahNumber,
  ) async {
    return const Surah(
      number: 1,
      nameArabic: 'الفاتحة',
      nameTransliteration: 'Al-Fatihah',
      nameEnglish: 'The Opening',
      nameTurkish: 'Fâtiha',
      ayahCount: 1,
      revelationType: RevelationType.makkah,
      ayahs: [
        Ayah(
          number: 1,
          numberInSurah: 1,
          text: 'Test ayah',
          page: 1,
          hizbQuarter: 1,
          juz: 1,
        ),
      ],
    );
  }
}

class _NoConsentNotifier extends ReligiousProgressConsentNotifier {
  @override
  ReligiousProgressConsentState build() {
    return const ReligiousProgressConsentState(
      granted: false,
    );
  }
}

class _FakeBookmarkNotifier extends QuranBookmarkNotifier {
  @override
  QuranBookmarkState build() {
    return const QuranBookmarkState(
      isLoading: false,
    );
  }
}

class _FakeProgressNotifier extends QuranProgressNotifier {
  @override
  QuranProgressState build() {
    return const QuranProgressState(
      isLoading: false,
      lastRead: null,
    );
  }
}

class _FakeReaderSettingsNotifier extends QuranReaderSettingsNotifier {
  @override
  QuranReaderSettingsState build() {
    return QuranReaderSettingsState.initial().copyWith(
      isLoading: false,
    );
  }
}

void main() {
  setUp(() async {
    await getIt.reset();

    getIt.registerSingleton<QuranRepository>(
      _FakeQuranRepository(),
    );
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets(
    'consent SnackBar action navigates after reader disposal',
    (tester) async {
      final router = GoRouter(
        initialLocation: '/reader',
        routes: [
          GoRoute(
            path: '/reader',
            builder: (context, state) {
              return const SurahDetailScreen(
                surahNumber: 1,
              );
            },
          ),
          GoRoute(
            path: '/other',
            builder: (context, state) {
              return const Scaffold(
                body: Center(
                  child: Text('Other destination'),
                ),
              );
            },
          ),
          GoRoute(
            path: AppRoutes.privacy,
            builder: (context, state) {
              return const Scaffold(
                body: Center(
                  child: Text('Privacy destination'),
                ),
              );
            },
          ),
        ],
      );

      addTearDown(
        router.dispose,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            religiousProgressConsentProvider.overrideWith(
              _NoConsentNotifier.new,
            ),
            quranBookmarkNotifierProvider.overrideWith(
              _FakeBookmarkNotifier.new,
            ),
            quranProgressNotifierProvider.overrideWith(
              _FakeProgressNotifier.new,
            ),
            quranReaderSettingsNotifierProvider.overrideWith(
              _FakeReaderSettingsNotifier.new,
            ),
          ],
          child: MaterialApp.router(
            routerConfig: router,
            locale: const Locale('en'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.byType(SurahDetailScreen),
        findsOneWidget,
      );

      final bookmarkButton = find.byIcon(
        Icons.bookmark_border,
      );

      expect(
        bookmarkButton,
        findsOneWidget,
      );

      await tester.tap(
        bookmarkButton,
      );

      await tester.pumpAndSettle();

      final actionFinder = find.byType(
        SnackBarAction,
      );

      expect(
        actionFinder,
        findsOneWidget,
      );

      // Keep the action callback, as can happen when a SnackBar
      // remains active after its originating route is removed.
      final action = tester
          .widget<SnackBarAction>(
            actionFinder,
          )
          .onPressed;

      router.go(
        '/other',
      );

      await tester.pumpAndSettle();

      expect(
        find.byType(SurahDetailScreen),
        findsNothing,
      );

      expect(
        find.text('Other destination'),
        findsOneWidget,
      );

      // The callback must navigate through a captured router,
      // not through the disposed reader item's BuildContext.
      action();

      await tester.pumpAndSettle();

      expect(
        find.text('Privacy destination'),
        findsOneWidget,
      );

      expect(
        tester.takeException(),
        isNull,
      );
    },
  );
}
