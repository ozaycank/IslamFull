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
  Ayah? ayah,
}) {
  final testAyah = ayah ??
      const Ayah(
        number: 2,
        numberInSurah: 2,
        text: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
        page: 1,
        hizbQuarter: 1,
        juz: 1,
      );

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
          ayah: testAyah,
          isBookmarked: false,
          onBookmarkToggle: () {},
          translation: translation,
          translationIsLoading: translationIsLoading,
        ),
      ),
    ),
  );
}

Future<void> _expectBismillahRemoved(
  WidgetTester tester, {
  required Ayah ayah,
  required String remainingText,
}) async {
  await tester.pumpWidget(
    _buildTestApp(
      translationIsLoading: false,
      ayah: ayah,
    ),
  );

  await tester.pumpAndSettle();

  final arabicTextFinder = find.byWidgetPredicate(
    (widget) =>
        widget is RichText && widget.text.toPlainText().contains(remainingText),
  );

  expect(arabicTextFinder, findsOneWidget);

  final displayedText =
      tester.widget<RichText>(arabicTextFinder).text.toPlainText();

  expect(displayedText, contains(remainingText));
  expect(displayedText, isNot(contains('بِّسْمِ')));
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

  testWidgets(
    'removes the Bismillah variant with initial shadda in At-Tin',
    (tester) async {
      await _expectBismillahRemoved(
        tester,
        ayah: const Ayah(
          number: 1,
          numberInSurah: 1,
          text:
              'بِّسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ وَٱلتِّينِ وَٱلزَّيْتُونِ',
          page: 1,
          hizbQuarter: 1,
          juz: 1,
        ),
        remainingText: 'وَٱلتِّينِ',
      );
    },
  );

  testWidgets(
    'removes the Bismillah variant with initial shadda in Al-Qadr',
    (tester) async {
      await _expectBismillahRemoved(
        tester,
        ayah: const Ayah(
          number: 1,
          numberInSurah: 1,
          text:
              'بِّسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ إِنَّآ أَنزَلْنَٰهُ فِى لَيْلَةِ ٱلْقَدْرِ',
          page: 1,
          hizbQuarter: 1,
          juz: 1,
        ),
        remainingText: 'إِنَّآ',
      );
    },
  );
}
