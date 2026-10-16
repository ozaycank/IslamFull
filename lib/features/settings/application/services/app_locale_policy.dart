import 'package:flutter/widgets.dart';

/// Resolves the initial device language and validates manual selections.
/// A saved supported language takes precedence in LanguageSettingsNotifier.
class AppLocalePolicy {
  AppLocalePolicy._();

  static const Locale english = Locale('en');
  static const Locale turkish = Locale('tr');
  static const Locale arabic = Locale('ar');

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

      case 'ar':
        return arabic;

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
