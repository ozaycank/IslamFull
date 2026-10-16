import 'package:flutter/widgets.dart';

/// Defines how IslamFull resolves the initial application language.
///
/// A manually selected, supported language takes precedence over the
/// device's primary language. Unsupported languages fall back to English.
class AppLocalePolicy {
  AppLocalePolicy._();

  static const Locale english = Locale('en');
  static const Locale turkish = Locale('tr');

  static Locale fromDeviceLocale(
    Locale deviceLocale,
  ) {
    return fromSavedCode(
          deviceLocale.languageCode,
        ) ??
        english;
  }

  static Locale? fromSavedCode(
    String? code,
  ) {
    switch (code?.trim().toLowerCase()) {
      case 'en':
        return english;

      case 'tr':
        return turkish;

      default:
        return null;
    }
  }

  static Locale validateSelection(
    Locale selectedLocale,
  ) {
    final normalized = fromSavedCode(
      selectedLocale.languageCode,
    );

    if (normalized == null) {
      throw ArgumentError.value(
        selectedLocale.languageCode,
        'selectedLocale',
        'Unsupported application language.',
      );
    }

    return normalized;
  }
}
