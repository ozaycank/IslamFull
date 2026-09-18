import 'package:flutter_test/flutter_test.dart';
import 'package:noor_life/features/quran/domain/entities/revelation_type.dart';
import 'package:noor_life/features/quran/domain/entities/surah.dart';
import 'package:noor_life/features/quran/domain/services/daily_verse_selector.dart';

void main() {
  const selector = DailyVerseSelector();

  const alFatihah = Surah(
    number: 1,
    nameArabic: 'الفاتحة',
    nameTransliteration: 'Al-Fatihah',
    nameEnglish: 'The Opening',
    nameTurkish: 'Fatiha',
    ayahCount: 7,
    revelationType: RevelationType.makkah,
  );

  const alIkhlas = Surah(
    number: 112,
    nameArabic: 'الإخلاص',
    nameTransliteration: 'Al-Ikhlas',
    nameEnglish: 'The Sincerity',
    nameTurkish: 'İhlas',
    ayahCount: 4,
    revelationType: RevelationType.makkah,
  );

  const alMulk = Surah(
    number: 67,
    nameArabic: 'الملك',
    nameTransliteration: 'Al-Mulk',
    nameEnglish: 'The Sovereignty',
    nameTurkish: 'Mülk',
    ayahCount: 30,
    revelationType: RevelationType.makkah,
  );

  const alBaqarah = Surah(
    number: 2,
    nameArabic: 'البقرة',
    nameTransliteration: 'Al-Baqarah',
    nameEnglish: 'The Cow',
    nameTurkish: 'Bakara',
    ayahCount: 286,
    revelationType: RevelationType.madinah,
  );

  const invalidSurah = Surah(
    number: 99,
    nameArabic: 'اختبار',
    nameTransliteration: 'Invalid',
    nameEnglish: 'Invalid',
    nameTurkish: 'Geçersiz',
    ayahCount: 0,
    revelationType: RevelationType.makkah,
  );

  group('DailyVerseSelector', () {
    test(
      'returns the same selection for the same calendar date',
      () {
        final date = DateTime(2026, 9, 18);

        final first = selector.select(
          surahs: const [
            alFatihah,
            alIkhlas,
            alMulk,
          ],
          date: date,
        );

        final second = selector.select(
          surahs: const [
            alFatihah,
            alIkhlas,
            alMulk,
          ],
          date: date,
        );

        expect(first, isNotNull);
        expect(second, isNotNull);

        expect(
          first!.surah.number,
          second!.surah.number,
        );

        expect(
          first.ayahNumber,
          second.ayahNumber,
        );
      },
    );

    test(
      'ignores time-of-day when selecting the daily verse',
      () {
        final morning = selector.select(
          surahs: const [
            alFatihah,
            alIkhlas,
            alMulk,
          ],
          date: DateTime(
            2026,
            9,
            18,
            5,
            30,
          ),
        );

        final evening = selector.select(
          surahs: const [
            alFatihah,
            alIkhlas,
            alMulk,
          ],
          date: DateTime(
            2026,
            9,
            18,
            23,
            45,
          ),
        );

        expect(morning, isNotNull);
        expect(evening, isNotNull);

        expect(
          morning!.surah.number,
          evening!.surah.number,
        );

        expect(
          morning.ayahNumber,
          evening.ayahNumber,
        );
      },
    );

    test(
      'is independent from input surah ordering',
      () {
        final date = DateTime(2026, 9, 18);

        final normalOrder = selector.select(
          surahs: const [
            alFatihah,
            alMulk,
            alIkhlas,
          ],
          date: date,
        );

        final reversedOrder = selector.select(
          surahs: const [
            alIkhlas,
            alMulk,
            alFatihah,
          ],
          date: date,
        );

        expect(normalOrder, isNotNull);
        expect(reversedOrder, isNotNull);

        expect(
          normalOrder!.surah.number,
          reversedOrder!.surah.number,
        );

        expect(
          normalOrder.ayahNumber,
          reversedOrder.ayahNumber,
        );
      },
    );

    test(
      'prefers surahs with fewer than 150 ayahs',
      () {
        for (var day = 1; day <= 30; day++) {
          final selection = selector.select(
            surahs: const [
              alFatihah,
              alBaqarah,
            ],
            date: DateTime(2026, 9, day),
          );

          expect(selection, isNotNull);

          expect(
            selection!.surah.number,
            alFatihah.number,
          );
        }
      },
    );

    test(
      'falls back to a longer surah when no preferred surah exists',
      () {
        final selection = selector.select(
          surahs: const [
            alBaqarah,
          ],
          date: DateTime(2026, 9, 18),
        );

        expect(selection, isNotNull);

        expect(
          selection!.surah.number,
          alBaqarah.number,
        );

        expect(
          selection.ayahNumber,
          inInclusiveRange(
            1,
            alBaqarah.ayahCount,
          ),
        );
      },
    );

    test(
      'ignores surahs with non-positive ayah counts',
      () {
        final selection = selector.select(
          surahs: const [
            invalidSurah,
            alIkhlas,
          ],
          date: DateTime(2026, 9, 18),
        );

        expect(selection, isNotNull);
        expect(
          selection!.surah.number,
          alIkhlas.number,
        );
      },
    );

    test(
      'returns null when there are no usable surahs',
      () {
        final selection = selector.select(
          surahs: const [
            invalidSurah,
          ],
          date: DateTime(2026, 9, 18),
        );

        expect(selection, isNull);
      },
    );

    test(
      'always selects an ayah inside the selected surah bounds',
      () {
        for (var dayOffset = 0; dayOffset < 365; dayOffset++) {
          final date = DateTime(
            2026,
            1,
            1 + dayOffset,
          );

          final selection = selector.select(
            surahs: const [
              alFatihah,
              alIkhlas,
              alMulk,
            ],
            date: date,
          );

          expect(selection, isNotNull);

          expect(
            selection!.ayahNumber,
            inInclusiveRange(
              1,
              selection.surah.ayahCount,
            ),
          );
        }
      },
    );
  });
}
