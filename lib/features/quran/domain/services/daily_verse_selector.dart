import '../entities/surah.dart';

/// Immutable result returned by [DailyVerseSelector].
class DailyVerseSelection {
  final Surah surah;
  final int ayahNumber;

  const DailyVerseSelection({
    required this.surah,
    required this.ayahNumber,
  });
}

/// Selects a deterministic Quran verse for a specific calendar date.
///
/// The selector is deliberately independent from Flutter, Riverpod, storage,
/// repositories, and platform APIs. This allows the same selection rule to be
/// reused by the UI and notification scheduling infrastructure.
///
/// Selection guarantees:
/// - The same calendar date produces the same result.
/// - Time-of-day does not affect the result.
/// - Repository list ordering does not affect the result.
/// - Surahs with invalid ayah counts are ignored.
/// - Surahs with 150 or more ayahs are avoided when shorter valid surahs exist.
class DailyVerseSelector {
  static const int _preferredMaximumAyahCount = 149;

  const DailyVerseSelector();

  DailyVerseSelection? select({
    required Iterable<Surah> surahs,
    required DateTime date,
  }) {
    final availableSurahs = surahs
        .where((surah) => surah.ayahCount > 0)
        .toList()
      ..sort((a, b) => a.number.compareTo(b.number));

    if (availableSurahs.isEmpty) {
      return null;
    }

    final preferredSurahs = availableSurahs
        .where(
          (surah) => surah.ayahCount <= _preferredMaximumAyahCount,
        )
        .toList();

    // Prefer shorter surahs, matching the existing application behaviour.
    // If the catalog ever contains only longer surahs, fall back gracefully
    // rather than returning an invalid verse.
    final selectionPool =
        preferredSurahs.isNotEmpty ? preferredSurahs : availableSurahs;

    final calendarSeed = _calendarSeed(date);
    final surahSeed = _mix32(calendarSeed);

    final selectedSurah = selectionPool[surahSeed % selectionPool.length];

    final ayahSeed = _mix32(
      surahSeed ^ (selectedSurah.number * 0x45D9F3B),
    );

    final selectedAyah = (ayahSeed % selectedSurah.ayahCount) + 1;

    return DailyVerseSelection(
      surah: selectedSurah,
      ayahNumber: selectedAyah,
    );
  }

  int _calendarSeed(DateTime date) {
    return (date.year * 10000) + (date.month * 100) + date.day;
  }

  /// Produces a deterministic 32-bit integer without depending on
  /// dart:math Random's internal implementation.
  int _mix32(int value) {
    var mixed = value & 0xFFFFFFFF;

    mixed ^= mixed >> 16;
    mixed = (mixed * 0x7FEB352D) & 0xFFFFFFFF;

    mixed ^= mixed >> 15;
    mixed = (mixed * 0x846CA68B) & 0xFFFFFFFF;

    mixed ^= mixed >> 16;

    return mixed & 0x7FFFFFFF;
  }
}
