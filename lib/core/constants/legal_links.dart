class LegalLinks {
  LegalLinks._();

  static const String privacyPolicyUrl =
      'https://ozaycank.github.io/IslamFull/privacy.html';

  static const String privacyContactEmail = 'islamfull.app@gmail.com';

  static Uri get privacyPolicyUri => Uri.parse(
        privacyPolicyUrl,
      );

  static Uri get privacyContactUri => Uri(
        scheme: 'mailto',
        path: privacyContactEmail,
      );
}
