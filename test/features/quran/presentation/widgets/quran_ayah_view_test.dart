import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:islamfull/features/quran/application/providers/quran_reader_settings_provider.dart';
import 'package:islamfull/features/quran/application/states/quran_reader_settings_state.dart';
import 'package:islamfull/features/quran/domain/entities/ayah.dart';
import 'package:islamfull/features/quran/domain/entities/quran_reader_settings.dart';
import 'package:islamfull/features/quran/domain/entities/quran_translation.dart';
import 'package:islamfull/features/quran/presentation/widgets/quran_ayah_view.dart';
import 'package:islamfull/l10n/generated/app_localizations.dart';

class _FakeQuranReaderSettingsNotifier extends QuranReaderSettingsNotifier {
  @override
  QuranReaderSettingsState build() {
    return const QuranReaderSettingsState(
      isLoading: false,
      settings: QuranReaderSettings(
        arabicFontSize: 26,
        showTranslation: true,
      ),
    );
  }
}

Widget _buildTestApp({
  required bool translationIsLoading,
  QuranTranslation? translation,
}) {
  return ProviderScope(
    overrides: [
      quranReaderSettingsNotifierProvider.overrideWith(
        _FakeQuranReaderSettingsNotifier.new,
      ),
    ],
    child: MaterialApp(
      locale: const Locale('en'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(
        body: QuranAyahView(
          ayah: const Ayah(
            number: 2,
            numberInSurah: 2,
            text: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
            page: 1,
            hizbQuarter: 1,
            juz: 1,
          ),
          isBookmarked: false,
          onBookmarkToggle: () {},
          translation: translation,
          translationIsLoading: translationIsLoading,
        ),
      ),
    ),
  );
}

void main() {
  testWidgets(
    'does not display unavailable message while translation is loading',
    (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          translationIsLoading: true,
        ),
      );

      await tester.pumpAndSettle();

      final l10n = AppLocalizations.of(
        tester.element(
          find.byType(QuranAyahView),
        ),
      )!;

      expect(
        find.text(l10n.quranTranslationUnavailable),
        findsNothing,
      );
    },
  );

  testWidgets(
    'displays unavailable message after loading when translation is missing',
    (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          translationIsLoading: false,
        ),
      );

      await tester.pumpAndSettle();

      final l10n = AppLocalizations.of(
        tester.element(
          find.byType(QuranAyahView),
        ),
      )!;

      expect(
        find.text(l10n.quranTranslationUnavailable),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'displays translation after it has loaded',
    (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          translationIsLoading: false,
          translation: const QuranTranslation(
            surahNumber: 1,
            ayahNumber: 2,
            text: 'Praise belongs to Allah, Lord of all worlds.',
            languageCode: 'en',
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text(
          'Praise belongs to Allah, Lord of all worlds.',
        ),
        findsOneWidget,
      );

      expect(
        find.text('Translation unavailable'),
        findsNothing,
      );
    },
  );
}
