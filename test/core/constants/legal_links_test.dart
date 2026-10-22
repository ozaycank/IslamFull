import 'package:flutter_test/flutter_test.dart';

import 'package:islamfull/core/constants/legal_links.dart';

void main() {
  test(
    'privacy policy URL uses the public IslamFull HTTPS endpoint',
    () {
      expect(
        LegalLinks.privacyPolicyUrl,
        'https://ozaycank.github.io/IslamFull/privacy.html',
      );

      expect(
        LegalLinks.privacyPolicyUri.scheme,
        'https',
      );

      expect(
        LegalLinks.privacyPolicyUri.host,
        'ozaycank.github.io',
      );
    },
  );

  test(
    'Turkish locale opens the published Turkish privacy notice',
    () {
      expect(
        LegalLinks.privacyPolicyUriForLanguage('tr').toString(),
        'https://ozaycank.github.io/IslamFull/privacy-tr.html',
      );
      expect(
        LegalLinks.privacyPolicyUriForLanguage('tr-TR').scheme,
        'https',
      );
      expect(
        LegalLinks.privacyPolicyUriForLanguage('en').toString(),
        LegalLinks.privacyPolicyUrl,
      );
    },
  );

  test(
    'privacy contact uses the dedicated IslamFull address',
    () {
      expect(
        LegalLinks.privacyContactEmail,
        'islamfull.app@gmail.com',
      );

      expect(
        LegalLinks.privacyContactUri.scheme,
        'mailto',
      );

      expect(
        LegalLinks.privacyContactUri.path,
        'islamfull.app@gmail.com',
      );
    },
  );
}
