import '../../domain/entities/quran_translation.dart';
import '../../domain/entities/surah.dart';
import '../../domain/repositories/quran_repository.dart';
import '../../domain/repositories/quran_translation_repository.dart';
import '../../domain/services/daily_verse_selector.dart';

class DailyVerseNotificationContent {
  final DateTime date;
  final int surahNumber;
  final int ayahNumber;
  final String surahName;
  final String arabicText;
  final String translation;

  const DailyVerseNotificationContent({
    required this.date,
    required this.surahNumber,
    required this.ayahNumber,
    required this.surahName,
    required this.arabicText,
    required this.translation,
  });

  String get reference => '$surahName $surahNumber:$ayahNumber';

  String get notificationBody => '$arabicText\n\n$translation\n$reference';

  /// Semantic payload intentionally remains independent from GoRouter.
  ///
  /// A later notification-interaction layer will parse this payload and decide
  /// how it maps to application navigation.
  String get payload => 'daily-verse:$surahNumber:$ayahNumber';
}

/// Builds the actual Quran content used by Daily Verse notifications.
///
/// Quran assets are static for the application lifetime, so repository results
/// are cached inside this service to avoid reading the same local asset files
/// repeatedly while creating a rolling notification window.
class DailyVerseNotificationContentService {
  final QuranRepository _quranRepository;
  final QuranTranslationRepository _translationRepository;
  final DailyVerseSelector _selector;

  Future<List<Surah>>? _surahCatalogFuture;

  final Map<int, Future<Surah>> _surahDetailCache = {};

  final Map<String, Future<Map<int, QuranTranslation>>> _translationCache = {};

  DailyVerseNotificationContentService({
    required QuranRepository quranRepository,
    required QuranTranslationRepository translationRepository,
    DailyVerseSelector selector = const DailyVerseSelector(),
  })  : _quranRepository = quranRepository,
        _translationRepository = translationRepository,
        _selector = selector;

  Future<DailyVerseNotificationContent?> buildForDate({
    required DateTime date,
    required String languageCode,
  }) async {
    final normalizedLanguageCode = _normalizeLanguageCode(
      languageCode,
    );

    final surahs = await _loadSurahCatalog();

    final selection = _selector.select(
      surahs: surahs,
      date: date,
    );

    if (selection == null) {
      return null;
    }

    final surahNumber = selection.surah.number;

    final surahDetail = await _loadSurahDetail(
      surahNumber,
    );

    final ayahs = surahDetail.ayahs;

    if (ayahs == null || ayahs.isEmpty) {
      return null;
    }

    final matchingAyahs = ayahs.where(
      (ayah) => ayah.numberInSurah == selection.ayahNumber,
    );

    if (matchingAyahs.isEmpty) {
      return null;
    }

    final selectedAyah = matchingAyahs.first;
    final arabicText = selectedAyah.text.trim();

    if (arabicText.isEmpty) {
      return null;
    }

    final translations = await _loadTranslationMap(
      surahNumber: surahNumber,
      languageCode: normalizedLanguageCode,
    );

    final translation = translations[selection.ayahNumber]?.text.trim();

    // A Daily Verse notification is expected to contain both the Quran text
    // and its translation. Do not silently send incomplete content.
    if (translation == null || translation.isEmpty) {
      return null;
    }

    final localizedSurahName = _localizedSurahName(
      selection.surah,
      normalizedLanguageCode,
    );

    return DailyVerseNotificationContent(
      date: DateTime(
        date.year,
        date.month,
        date.day,
      ),
      surahNumber: surahNumber,
      ayahNumber: selection.ayahNumber,
      surahName: localizedSurahName,
      arabicText: arabicText,
      translation: translation,
    );
  }

  Future<List<Surah>> _loadSurahCatalog() {
    return _surahCatalogFuture ??= _quranRepository.getSurahs();
  }

  Future<Surah> _loadSurahDetail(
    int surahNumber,
  ) {
    return _surahDetailCache.putIfAbsent(
      surahNumber,
      () => _quranRepository.getSurahDetail(
        surahNumber,
      ),
    );
  }

  Future<Map<int, QuranTranslation>> _loadTranslationMap({
    required int surahNumber,
    required String languageCode,
  }) {
    final cacheKey = '$languageCode:$surahNumber';

    return _translationCache.putIfAbsent(
      cacheKey,
      () async {
        final translations =
            await _translationRepository.getTranslationsForSurah(
          surahNumber,
          languageCode,
        );

        return {
          for (final translation in translations)
            if (translation.surahNumber == surahNumber)
              translation.ayahNumber: translation,
        };
      },
    );
  }

  String _normalizeLanguageCode(
    String languageCode,
  ) {
    final normalized = languageCode.trim().toLowerCase();

    if (normalized.contains('-')) {
      return normalized.split('-').first;
    }

    if (normalized.contains('_')) {
      return normalized.split('_').first;
    }

    return normalized;
  }

  String _localizedSurahName(
    Surah surah,
    String languageCode,
  ) {
    final localizedName =
        languageCode == 'tr' ? surah.nameTurkish : surah.nameEnglish;

    if (localizedName.trim().isNotEmpty) {
      return localizedName.trim();
    }

    return surah.nameTransliteration.trim();
  }
}
