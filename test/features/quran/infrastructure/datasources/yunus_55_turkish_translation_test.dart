import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Turkish Yunus 10:55 translation includes both parts of the verse',
      () async {
    final decoded = jsonDecode(
      await rootBundle.loadString(
        'assets/data/quran/translations/tr/translation.json',
      ),
    );

    final Map<String, dynamic>? decodedMap =
        decoded is Map<String, dynamic> ? decoded : null;
    final dynamic rawRecords = decoded is List
        ? decoded
        : decodedMap?['quran'] ?? decodedMap?['data'] ?? decodedMap?['verses'];

    expect(rawRecords, isA<List<dynamic>>());
    final records = (rawRecords as List<dynamic>).where((item) {
      final record = item as Map<String, dynamic>;
      final rawSurah = record['chapter'] ?? record['surahNumber'];
      final rawAyah = record['verse'] ?? record['ayahNumber'];
      final surahNumber =
          rawSurah is num ? rawSurah.toInt() : int.tryParse('$rawSurah') ?? 0;
      final ayahNumber =
          rawAyah is num ? rawAyah.toInt() : int.tryParse('$rawAyah') ?? 0;
      return surahNumber == 10 && ayahNumber == 55;
    }).toList();

    expect(records, hasLength(1));
    final translation =
        (records.single as Map<String, dynamic>)['text'] as String;

    expect(
      translation,
      'İyi bilin ki, göklerde ve yerde ne varsa Allah\'ındır. '
      'İyi bilin ki, Allah\'ın verdiği söz gerçektir, ama çoğu bunu bilmez',
    );
  });
}
