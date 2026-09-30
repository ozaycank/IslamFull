import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/features/quran/application/providers/quran_progress_provider.dart';
import 'package:noor_life/features/quran/application/providers/quran_provider.dart';
import 'package:noor_life/features/quran/application/states/quran_progress_state.dart';
import 'package:noor_life/features/quran/application/states/quran_state.dart';
import 'package:noor_life/features/quran/domain/errors/quran_failure.dart';
import 'package:noor_life/features/quran/presentation/screens/quran_home_screen.dart';
import 'package:noor_life/l10n/generated/app_localizations.dart';

class FakeQuranNotifier extends QuranNotifier {
  final QuranState fakeState;
  final VoidCallback? onBuild;

  FakeQuranNotifier({
    required this.fakeState,
    this.onBuild,
  });

  @override
  QuranState build() {
    onBuild?.call();
    return fakeState;
  }
}

class FakeQuranProgressNotifier extends QuranProgressNotifier {
  @override
  QuranProgressState build() {
    return const QuranProgressState(
      isLoading: false,
      lastRead: null,
    );
  }
}

void main() {
  Widget buildTestableWidget({
    required QuranState state,
    VoidCallback? onQuranBuild,
  }) {
    return ProviderScope(
      overrides: [
        quranNotifierProvider.overrideWith(
          () => FakeQuranNotifier(
            fakeState: state,
            onBuild: onQuranBuild,
          ),
        ),
        quranProgressNotifierProvider.overrideWith(
          () => FakeQuranProgressNotifier(),
        ),
      ],
      child: const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en'),
        ],
        locale: Locale('en'),
        home: QuranHomeScreen(),
      ),
    );
  }

  testWidgets(
    'Quran Home displays safe empty state',
    (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          state: const QuranState(
            isLoading: false,
            surahs: [],
            searchQuery: '',
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.byType(TextField),
        findsOneWidget,
      );

      expect(
        find.text(
          'No surah found',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Quran error state exposes a working retry action',
    (tester) async {
      var buildCount = 0;

      await tester.pumpWidget(
        buildTestableWidget(
          state: const QuranState(
            isLoading: false,
            surahs: [],
            searchQuery: '',
            failure: QuranFailure(
              'Network error',
            ),
          ),
          onQuranBuild: () {
            buildCount++;
          },
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text(
          'Network error',
        ),
        findsOneWidget,
      );

      expect(
        find.text(
          'Retry',
        ),
        findsOneWidget,
      );

      expect(
        buildCount,
        1,
      );

      await tester.tap(
        find.text(
          'Retry',
        ),
      );

      await tester.pumpAndSettle();

      expect(
        buildCount,
        greaterThanOrEqualTo(2),
      );
    },
  );
}
