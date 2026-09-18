import 'dart:math';

import '../entities/surah.dart';

class DailyVerseSelection {
  final Surah surah;
  final int ayahNumber;

  const DailyVerseSelection({
    required this.surah,
    required this.ayahNumber,
  });
}

/// Selects the same verse for the same calendar date.
///
/// This service is intentionally independent from Riverpod and UI state so it
/// can be reused by the home screen, notification scheduler, and tests.
class DailyVerseSelector {
  const DailyVerseSelector();

  DailyVerseSelection? select({
    required List<Surah> surahs,
    required DateTime date,
  }) {
    if (surahs.isEmpty) {
      return null;
    }

    final eligibleSurahs = surahs
        .where(
          (surah) => surah.ayahCount > 0 && surah.ayahCount < 150,
        )
        .toList(growable: false);

    // Preserve the previous application's fallback behaviour.
    if (eligibleSurahs.isEmpty) {
      return DailyVerseSelection(
        surah: surahs.first,
        ayahNumber: 1,
      );
    }

    final seed = (date.year * 10000) + (date.month * 100) + date.day;

    final random = Random(seed);

    final selectedSurah = eligibleSurahs[random.nextInt(eligibleSurahs.length)];

    final selectedAyah = random.nextInt(selectedSurah.ayahCount) + 1;

    return DailyVerseSelection(
      surah: selectedSurah,
      ayahNumber: selectedAyah,
    );
  }
}
