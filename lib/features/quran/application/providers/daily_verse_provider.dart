import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection_container.dart';
import '../../domain/entities/surah.dart';
import '../../domain/repositories/quran_repository.dart';
import '../../domain/services/daily_verse_selector.dart';
import 'quran_provider.dart';
import 'quran_translation_provider.dart';

class DailyVerseData {
  final Surah surah;
  final int ayahNumber;

  const DailyVerseData(
    this.surah,
    this.ayahNumber,
  );
}

class DailyVerseContent {
  final String arabicText;
  final String translation;

  const DailyVerseContent({
    required this.arabicText,
    required this.translation,
  });
}

final dailyVerseProvider = Provider<DailyVerseData?>((ref) {
  final quranState = ref.watch(quranNotifierProvider);

  final selection = const DailyVerseSelector().select(
    surahs: quranState.surahs,
    date: DateTime.now(),
  );

  if (selection == null) {
    return null;
  }

  return DailyVerseData(
    selection.surah,
    selection.ayahNumber,
  );
});

final dailyVerseContentProvider =
    FutureProvider.family<DailyVerseContent?, String>(
  (ref, languageCode) async {
    final dailyVerse = ref.watch(dailyVerseProvider);

    if (dailyVerse == null) {
      return null;
    }

    final repository = getIt<QuranRepository>();

    final surahDetail = await repository.getSurahDetail(
      dailyVerse.surah.number,
    );

    final ayahs = surahDetail.ayahs;

    if (ayahs == null || ayahs.isEmpty) {
      return null;
    }

    final ayah = ayahs.firstWhere(
      (item) => item.numberInSurah == dailyVerse.ayahNumber,
      orElse: () => ayahs.first,
    );

    final translationMap = await ref.watch(
      quranTranslationProvider(
        (
          surahNumber: dailyVerse.surah.number,
          languageCode: languageCode,
        ),
      ).future,
    );

    return DailyVerseContent(
      arabicText: ayah.text,
      translation: translationMap[dailyVerse.ayahNumber]?.text ?? '',
    );
  },
);
