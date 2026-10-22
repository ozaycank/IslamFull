import 'package:flutter_test/flutter_test.dart';

import 'package:islamfull/features/quran/application/services/daily_verse_notification_content_service.dart';
import 'package:islamfull/features/quran/domain/entities/ayah.dart';
import 'package:islamfull/features/quran/domain/entities/quran_translation.dart';
import 'package:islamfull/features/quran/domain/entities/revelation_type.dart';
import 'package:islamfull/features/quran/domain/entities/surah.dart';
import 'package:islamfull/features/quran/domain/repositories/quran_repository.dart';
import 'package:islamfull/features/quran/domain/repositories/quran_translation_repository.dart';

void main() {
  test(
    'Arabic daily verse uses original Arabic without requesting a translation',
    () async {
      final translations = _TrackingTranslations();
      final service = DailyVerseNotificationContentService(
        quranRepository: _TestQuran(),
        translationRepository: translations,
      );

      final result = await service.buildForDate(
        date: DateTime(2026, 10, 16),
        languageCode: 'ar',
      );

      expect(result, isNotNull);
      expect(result!.surahName, 'الفاتحة');
      expect(result.translation, isEmpty);
      expect(result.notificationBody, contains('آية اختبارية'));
      expect(result.notificationBody, contains('الفاتحة'));
      expect(result.notificationBody, isNot(contains('\n\n')));
      expect(translations.called, isFalse);
    },
  );
}

class _TestQuran implements QuranRepository {
  static const _catalog = Surah(
    number: 1,
    nameArabic: 'الفاتحة',
    nameTurkish: 'Fatiha',
    nameEnglish: 'The Opening',
    nameTransliteration: 'Al-Fatihah',
    ayahCount: 3,
    revelationType: RevelationType.makkah,
  );

  @override
  Future<List<Surah>> getSurahs() async => const [_catalog];

  @override
  Future<Surah> getSurahDetail(int surahNumber) async => const Surah(
        number: 1,
        nameArabic: 'الفاتحة',
        nameTurkish: 'Fatiha',
        nameEnglish: 'The Opening',
        nameTransliteration: 'Al-Fatihah',
        ayahCount: 3,
        revelationType: RevelationType.makkah,
        ayahs: [
          Ayah(
            number: 1,
            numberInSurah: 1,
            text: 'آية اختبارية',
            page: 1,
            hizbQuarter: 1,
            juz: 1,
          ),
          Ayah(
            number: 2,
            numberInSurah: 2,
            text: 'آية اختبارية',
            page: 1,
            hizbQuarter: 1,
            juz: 1,
          ),
          Ayah(
            number: 3,
            numberInSurah: 3,
            text: 'آية اختبارية',
            page: 1,
            hizbQuarter: 1,
            juz: 1,
          ),
        ],
      );
}

class _TrackingTranslations implements QuranTranslationRepository {
  bool called = false;

  @override
  Future<List<QuranTranslation>> getTranslationsForSurah(
    int surahNumber,
    String languageCode,
  ) async {
    called = true;
    return const [];
  }
}
