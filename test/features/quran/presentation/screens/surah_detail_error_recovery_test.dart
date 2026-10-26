import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:islamfull/core/di/injection_container.dart';
import 'package:islamfull/features/quran/domain/entities/surah.dart';
import 'package:islamfull/features/quran/domain/repositories/quran_repository.dart';
import 'package:islamfull/features/quran/presentation/screens/surah_detail_screen.dart';
import 'package:islamfull/l10n/generated/app_localizations.dart';

class _FailingQuranRepository implements QuranRepository {
  int detailRequestCount = 0;

  @override
  Future<List<Surah>> getSurahs() async => <Surah>[];

  @override
  Future<Surah> getSurahDetail(
    int surahNumber,
  ) async {
    detailRequestCount++;
    throw StateError('INTERNAL_TEST_FAILURE_TOKEN');
  }
}

void main() {
  late _FailingQuranRepository repository;

  setUp(() async {
    await getIt.reset();

    repository = _FailingQuranRepository();

    getIt.registerSingleton<QuranRepository>(
      repository,
    );
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets(
    'hides technical error details and retries Quran loading',
    (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            locale:  Locale('en'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates:  [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home:  SurahDetailScreen(
              surahNumber: 1,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        repository.detailRequestCount,
        1,
      );

      expect(
        find.text('An unexpected error occurred. Please try again.'),
        findsOneWidget,
      );

      expect(
        find.text('Retry'),
        findsOneWidget,
      );

      expect(
        find.textContaining('INTERNAL_TEST_FAILURE_TOKEN'),
        findsNothing,
      );

      await tester.tap(
        find.text('Retry'),
      );

      await tester.pumpAndSettle();

      expect(
        repository.detailRequestCount,
        2,
      );

      expect(
        find.text('An unexpected error occurred. Please try again.'),
        findsOneWidget,
      );

      expect(
        find.textContaining('INTERNAL_TEST_FAILURE_TOKEN'),
        findsNothing,
      );

      expect(
        tester.takeException(),
        isNull,
      );
    },
  );
}
