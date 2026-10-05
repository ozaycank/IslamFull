import 'app_routes.dart';

class RouteLocationPolicy {
  RouteLocationPolicy._();

  static const int minSurahNumber = 1;
  static const int maxSurahNumber = 114;

  static const int _maxExternalLocationLength = 2048;

  static final RegExp _surahDetailPattern = RegExp(
    r'^/quran/surah/([0-9]+)$',
  );

  static const Set<String> _allowedStaticNotificationLocations = {
    AppRoutes.home,
    AppRoutes.prayer,
    AppRoutes.quran,
    AppRoutes.quranBookmarks,
    AppRoutes.activity,
    AppRoutes.menu,
    AppRoutes.settings,
    AppRoutes.qibla,
    AppRoutes.zakat,
    AppRoutes.hajj,
    AppRoutes.about,
    AppRoutes.privacy,
    AppRoutes.preferences,
    AppRoutes.tools,
    AppRoutes.tasbih,
    AppRoutes.infoCenter,
    AppRoutes.wuduGuide,
    AppRoutes.newMuslimJourney,
    AppRoutes.islamFoundations,
    AppRoutes.prayerGuide,
    AppRoutes.ghuslGuide,
    AppRoutes.duas,
    AppRoutes.ramadan,
    AppRoutes.ramadanGuide,
    AppRoutes.qurban,
    AppRoutes.qurbanGuide,
    AppRoutes.qurbanEidGuide,
    AppRoutes.hajjFundamentals,
    AppRoutes.ihramRules,
    AppRoutes.hajjTypes,
    AppRoutes.hajjDays,
    AppRoutes.umrahGuide,
    AppRoutes.hajjSpecialCases,
  };

  /// Validates a route originating outside the normal in-app navigation
  /// flow, for example from a local-notification payload.
  ///
  /// Unknown paths, absolute URLs, fragments and malformed locations are
  /// rejected rather than forwarded directly to GoRouter.
  static String? sanitizeNotificationLocation(
    String? rawLocation,
  ) {
    if (rawLocation == null) {
      return null;
    }

    final location = rawLocation.trim();

    if (location.isEmpty ||
        location.length > _maxExternalLocationLength ||
        !location.startsWith('/')) {
      return null;
    }

    final Uri uri;

    try {
      uri = Uri.parse(
        location,
      );
    } on FormatException {
      return null;
    }

    if (uri.hasScheme || uri.hasAuthority || uri.fragment.isNotEmpty) {
      return null;
    }

    final path = uri.path;

    if (_allowedStaticNotificationLocations.contains(path)) {
      // Static application routes do not currently consume query
      // parameters. Drop unexpected parameters rather than propagating
      // arbitrary external data into navigation state.
      return path;
    }

    final match = _surahDetailPattern.firstMatch(
      path,
    );

    if (match == null) {
      return null;
    }

    final surahNumber = tryParseSurahNumber(
      match.group(1),
    );

    if (surahNumber == null) {
      return null;
    }

    final ayah = tryParseAyahNumber(
      uri.queryParameters['ayah'],
    );

    if (ayah == null) {
      return path;
    }

    return Uri(
      path: path,
      queryParameters: {
        'ayah': ayah.toString(),
      },
    ).toString();
  }

  static int? tryParseSurahNumber(
    String? rawValue,
  ) {
    final value = int.tryParse(
      rawValue ?? '',
    );

    if (value == null || value < minSurahNumber || value > maxSurahNumber) {
      return null;
    }

    return value;
  }

  static int? tryParseAyahNumber(
    String? rawValue,
  ) {
    final value = int.tryParse(
      rawValue ?? '',
    );

    if (value == null || value <= 0) {
      return null;
    }

    return value;
  }
}
