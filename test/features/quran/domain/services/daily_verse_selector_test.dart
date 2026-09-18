import 'package:flutter_test/flutter_test.dart';
import 'package:noor_life/features/quran/domain/entities/revelation_type.dart';
import 'package:noor_life/features/quran/domain/entities/surah.dart';
import 'package:noor_life/features/quran/domain/services/daily_verse_selector.dart';

void main() {
  const selector = DailyVerseSelector();

  const shortSurah = Surah(
    number: 1,
    nameArabic: 'الفاتحة',
    nameTransliteration: 'Al-Fatihah',
    nameEnglish: 'The Opening',
    nameTurkish: 'Fatiha',
    ayahCount: 7,
    revelationType: RevelationType.makkah,
  );

  const anotherShortSurah = Surah(
    number: 112,
    nameArabic: 'الإخلاص',
    nameTransliteration: 'Al-Ikhlas',
    nameEnglish: 'The Sincerity',
    nameTurkish: 'İhlas',
    ayahCount: 4,
    revelationType: RevelationType.makkah,
  );

  const longSurah = Surah(
    number: 2,
    nameArabic: 'البقرة',
    nameTransliteration: 'Al-Baqarah',
    nameEnglish: 'The Cow',
    nameTurkish: 'Bakara',
    ayahCount: 286,
    revelationType: RevelationType.madinah,
  );

  group('DailyVerseSelector', () {
    test(
      'returns the same verse for the same date',
      () {
        final date = DateTime(2026, 9, 18);

        final first = selector.select(
          surahs: const [
            shortSurah,
            anotherShortSurah,
          ],
          date: date,
        );

        final second = selector.select(
          surahs: const [
            shortSurah,
            anotherShortSurah,
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
      'excludes very long surahs from daily verse selection',
      () {
        for (var day = 1; day <= 30; day++) {
          final selection = selector.select(
            surahs: const [
              shortSurah,
              longSurah,
            ],
            date: DateTime(2026, 9, day),
          );

          expect(selection, isNotNull);

          expect(
            selection!.surah.number,
            isNot(longSurah.number),
          );
        }
      },
    );

    test(
      'returns null when the catalog is empty',
      () {
        final result = selector.select(
          surahs: const [],
          date: DateTime(2026, 9, 18),
        );

        expect(result, isNull);
      },
    );

    test(
      'selected ayah is always inside the surah bounds',
      () {
        for (var day = 1; day <= 30; day++) {
          final selection = selector.select(
            surahs: const [
              shortSurah,
              anotherShortSurah,
            ],
            date: DateTime(2026, 9, day),
          );

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
