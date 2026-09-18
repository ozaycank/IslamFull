import 'package:flutter_test/flutter_test.dart';
import 'package:noor_life/core/services/local_notification_service.dart';
import 'package:noor_life/features/quran/application/services/daily_verse_notification_content_service.dart';
import 'package:noor_life/features/quran/application/services/daily_verse_notification_scheduler.dart';
import 'package:noor_life/features/quran/domain/entities/ayah.dart';
import 'package:noor_life/features/quran/domain/entities/quran_translation.dart';
import 'package:noor_life/features/quran/domain/entities/revelation_type.dart';
import 'package:noor_life/features/quran/domain/entities/surah.dart';
import 'package:noor_life/features/quran/domain/repositories/quran_repository.dart';
import 'package:noor_life/features/quran/domain/repositories/quran_translation_repository.dart';
import 'package:timezone/data/latest_all.dart' as tz;

void main() {
  setUpAll(() {
    tz.initializeTimeZones();
  });

  group(
    'DailyVerseNotificationContentService',
    () {
      test(
        'builds Quran text, localized translation and semantic payload',
        () async {
          final quranRepository = _FakeQuranRepository();

          final translationRepository = _FakeQuranTranslationRepository();

          final service = DailyVerseNotificationContentService(
            quranRepository: quranRepository,
            translationRepository: translationRepository,
          );

          final content = await service.buildForDate(
            date: DateTime(
              2026,
              9,
              18,
            ),
            languageCode: 'tr',
          );

          expect(
            content,
            isNotNull,
          );

          expect(
            content!.surahNumber,
            1,
          );

          expect(
            content.surahName,
            'Fatiha',
          );

          expect(
            content.arabicText,
            'ARABIC ${content.ayahNumber}',
          );

          expect(
            content.translation,
            'TR ${content.ayahNumber}',
          );

          expect(
            content.payload,
            'daily-verse:1:${content.ayahNumber}',
          );

          expect(
            content.notificationBody,
            contains(
              'Fatiha 1:${content.ayahNumber}',
            ),
          );
        },
      );

      test(
        'returns null instead of creating incomplete content when translation is missing',
        () async {
          final service = DailyVerseNotificationContentService(
            quranRepository: _FakeQuranRepository(),
            translationRepository: _EmptyTranslationRepository(),
          );

          final content = await service.buildForDate(
            date: DateTime(
              2026,
              9,
              18,
            ),
            languageCode: 'en',
          );

          expect(
            content,
            isNull,
          );
        },
      );
    },
  );

  group(
    'DailyVerseNotificationScheduler',
    () {
      test(
        'rebuilds a seven-day rolling window and reuses cached Quran data',
        () async {
          final quranRepository = _FakeQuranRepository();

          final translationRepository = _FakeQuranTranslationRepository();

          final contentService = DailyVerseNotificationContentService(
            quranRepository: quranRepository,
            translationRepository: translationRepository,
          );

          final notificationService = _FakeLocalNotificationService();

          final scheduler = DailyVerseNotificationScheduler(
            contentService: contentService,
            notificationService: notificationService,
          );

          final scheduledCount = await scheduler.reschedule(
            notificationTime: '20:00',
            languageCode: 'en',
            timezoneId: 'Europe/Istanbul',
            title: 'Verse of the Day',
            referenceNow: DateTime.utc(
              2026,
              9,
              18,
              10,
            ),
          );

          expect(
            notificationService.legacyCancellationCount,
            1,
          );

          expect(
            notificationService.cancelledWindowStart,
            DateTime(
              2026,
              9,
              17,
            ),
          );

          expect(
            notificationService.cancelledWindowDays,
            DailyVerseNotificationScheduler.cleanupWindowDays,
          );

          expect(
            scheduledCount,
            DailyVerseNotificationScheduler.rollingWindowDays,
          );

          expect(
            notificationService.scheduledNotifications.length,
            DailyVerseNotificationScheduler.rollingWindowDays,
          );

          expect(
            notificationService.scheduledNotifications.first.date,
            DateTime(
              2026,
              9,
              18,
            ),
          );

          expect(
            notificationService.scheduledNotifications.last.date,
            DateTime(
              2026,
              9,
              24,
            ),
          );

          expect(
            notificationService.scheduledNotifications.every(
              (notification) =>
                  notification.title == 'Verse of the Day' &&
                  notification.payload.startsWith(
                    'daily-verse:1:',
                  ),
            ),
            isTrue,
          );

          // All seven dates use the same single-surah test catalog. Repository
          // caches should prevent seven repeated asset reads.
          expect(
            quranRepository.getSurahsCallCount,
            1,
          );

          expect(
            quranRepository.getSurahDetailCallCount,
            1,
          );

          expect(
            translationRepository.callCount,
            1,
          );
        },
      );
    },
  );
}

class _FakeQuranRepository implements QuranRepository {
  int getSurahsCallCount = 0;
  int getSurahDetailCallCount = 0;

  static const catalogSurah = Surah(
    number: 1,
    nameArabic: 'الفاتحة',
    nameTransliteration: 'Al-Fatihah',
    nameEnglish: 'The Opening',
    nameTurkish: 'Fatiha',
    ayahCount: 3,
    revelationType: RevelationType.makkah,
  );

  static const detailedSurah = Surah(
    number: 1,
    nameArabic: 'الفاتحة',
    nameTransliteration: 'Al-Fatihah',
    nameEnglish: 'The Opening',
    nameTurkish: 'Fatiha',
    ayahCount: 3,
    revelationType: RevelationType.makkah,
    ayahs: [
      Ayah(
        number: 1,
        numberInSurah: 1,
        text: 'ARABIC 1',
        page: 1,
        hizbQuarter: 1,
        juz: 1,
      ),
      Ayah(
        number: 2,
        numberInSurah: 2,
        text: 'ARABIC 2',
        page: 1,
        hizbQuarter: 1,
        juz: 1,
      ),
      Ayah(
        number: 3,
        numberInSurah: 3,
        text: 'ARABIC 3',
        page: 1,
        hizbQuarter: 1,
        juz: 1,
      ),
    ],
  );

  @override
  Future<List<Surah>> getSurahs() async {
    getSurahsCallCount++;

    return const [
      catalogSurah,
    ];
  }

  @override
  Future<Surah> getSurahDetail(
    int surahNumber,
  ) async {
    getSurahDetailCallCount++;

    expect(
      surahNumber,
      1,
    );

    return detailedSurah;
  }
}

class _FakeQuranTranslationRepository implements QuranTranslationRepository {
  int callCount = 0;

  @override
  Future<List<QuranTranslation>> getTranslationsForSurah(
    int surahNumber,
    String languageCode,
  ) async {
    callCount++;

    final prefix = languageCode == 'tr' ? 'TR' : 'EN';

    return [
      for (var ayah = 1; ayah <= 3; ayah++)
        QuranTranslation(
          surahNumber: surahNumber,
          ayahNumber: ayah,
          text: '$prefix $ayah',
          languageCode: languageCode,
        ),
    ];
  }
}

class _EmptyTranslationRepository implements QuranTranslationRepository {
  @override
  Future<List<QuranTranslation>> getTranslationsForSurah(
    int surahNumber,
    String languageCode,
  ) async {
    return const [];
  }
}

class _ScheduledDailyVerse {
  final DateTime date;
  final String timeString;
  final String title;
  final String body;
  final String timezoneId;
  final String payload;

  const _ScheduledDailyVerse({
    required this.date,
    required this.timeString,
    required this.title,
    required this.body,
    required this.timezoneId,
    required this.payload,
  });
}

class _FakeLocalNotificationService extends LocalNotificationService {
  int legacyCancellationCount = 0;

  DateTime? cancelledWindowStart;
  int? cancelledWindowDays;

  final List<_ScheduledDailyVerse> scheduledNotifications = [];

  @override
  bool get isSupportedPlatform => true;

  @override
  Future<void> cancelLegacyDailyVerseSchedules() async {
    legacyCancellationCount++;
  }

  @override
  Future<void> cancelDailyVerseWindow(
    DateTime startDate, {
    required int days,
  }) async {
    cancelledWindowStart = startDate;
    cancelledWindowDays = days;
  }

  @override
  Future<bool> scheduleDailyVerseForDate({
    required DateTime date,
    required String timeString,
    required String title,
    required String body,
    required String timezoneId,
    required String payload,
  }) async {
    scheduledNotifications.add(
      _ScheduledDailyVerse(
        date: date,
        timeString: timeString,
        title: title,
        body: body,
        timezoneId: timezoneId,
        payload: payload,
      ),
    );

    return true;
  }
}
