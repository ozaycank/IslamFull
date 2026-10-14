class LegalLinks {
  LegalLinks._();

  static const String privacyPolicyUrl =
      'https://ozaycank.github.io/IslamFull/privacy.html';

  static const String privacyPolicyUrlTr =
      'https://ozaycank.github.io/IslamFull/privacy-tr.html';

  static const String privacyContactEmail = 'islamfull.app@gmail.com';

  static Uri get privacyPolicyUri => Uri.parse(privacyPolicyUrl);

  static Uri privacyPolicyUriForLanguage(String languageCode) => Uri.parse(
        languageCode.toLowerCase().startsWith('tr')
            ? privacyPolicyUrlTr
            : privacyPolicyUrl,
      );

  static Uri get privacyContactUri => Uri(
        scheme: 'mailto',
        path: privacyContactEmail,
      );
}
