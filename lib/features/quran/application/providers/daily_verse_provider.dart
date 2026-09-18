import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection_container.dart';
import '../../domain/entities/surah.dart';
import '../../domain/repositories/quran_repository.dart';
import 'quran_provider.dart';
import 'quran_translation_provider.dart';

class DailyVerseData {
  final Surah surah;
  final int ayahNumber;

  DailyVerseData(
    this.surah,
    this.ayahNumber,
  );
}

class DailyVerseContent {
  final String arabicText;
  final String translation;

  DailyVerseContent({
    required this.arabicText,
    required this.translation,
  });
}

final dailyVerseProvider = Provider<DailyVerseData?>((ref) {
  final quranState = ref.watch(quranNotifierProvider);

  if (quranState.surahs.isEmpty) {
    return null;
  }

  final now = DateTime.now();

  final seed = now.year * 10000 + now.month * 100 + now.day;

  final random = Random(seed);

  final validSurahs = quranState.surahs
      .where(
        (surah) => surah.ayahCount > 0 && surah.ayahCount < 150,
      )
      .toList();

  if (validSurahs.isEmpty) {
    return DailyVerseData(
      quranState.surahs.first,
      1,
    );
  }

  final selectedSurah = validSurahs[random.nextInt(validSurahs.length)];

  final selectedAyah = random.nextInt(selectedSurah.ayahCount) + 1;

  return DailyVerseData(
    selectedSurah,
    selectedAyah,
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
