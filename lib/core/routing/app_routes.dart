class AppRoutes {
  AppRoutes._();

  static const String splash = '/';

  // Shell tabs.
  static const String home = '/home';
  static const String prayer = '/prayer';
  static const String quran = '/quran';
  static const String activity = '/activity';
  static const String menu = '/menu';

  // Quran child routes.
  static const String quranBookmarks = '/quran/bookmarks';
  static const String surahDetail = '/quran/surah/:id';

  static const String quranBookmarksSegment = 'bookmarks';
  static const String surahDetailSegment = 'surah/:id';

  // Standalone module pages.
  static const String settings = '/settings';
  static const String qibla = '/qibla';
  static const String zakat = '/zakat';
  static const String hajj = '/hajj';
  static const String about = '/about';
  static const String privacy = '/privacy';
  static const String preferences = '/preferences';
  static const String tools = '/tools';
  static const String tasbih = '/tasbih';
  static const String infoCenter = '/info-center';
  static const String wuduGuide = '/wudu-guide';

  // Guidance.
  static const String newMuslimJourney = '/new-muslim-journey';
  static const String islamFoundations = '/islam-foundations';
  static const String prayerGuide = '/prayer-guide';
  static const String ghuslGuide = '/ghusl-guide';
  static const String duas = '/duas';
  static const String ramadan = '/ramadan';
  static const String ramadanGuide = '/ramadan-guide';
  static const String qurban = '/qurban';
  static const String qurbanGuide = '/qurban-guide';
  static const String qurbanEidGuide = '/qurban-eid-guide';
  static const String hajjFundamentals = '/hajj-fundamentals';
  static const String ihramRules = '/ihram-rules';
  static const String hajjTypes = '/hajj-types';
  static const String hajjDays = '/hajj-days';
  static const String umrahGuide = '/umrah-guide';
  static const String hajjSpecialCases = '/hajj-special-cases';
}
