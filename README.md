# IslamFull

IslamFull is a Flutter application for prayer times, Quran reading, Qibla
direction, worship guidance, and everyday Islamic tools. The interface
supports Turkish, English, and Arabic, with Arabic Quran text and Turkish
and English translations in the Quran reader.

**Project status:** Pre-release development. Store publication requires the
release-readiness checks described below.

## Features

- Prayer-time calculations using the selected location.
- Device location with foreground permission, or manually entered coordinates.
- Qibla direction.
- Quran reading, with optional local reading progress and bookmarks.
- Prayer reminders and Daily Verse notifications scheduled locally on the device.
- Prayer and worship tools, including tasbih and zakat calculation.
- Learning and guidance content for prayer, wudu, ghusl, Hajj, Umrah, Ramadan,
  Qurban, duas, and related topics.
- Turkish, English, and Arabic interface localization.

Some personal religious-progress features are optional and require explicit
permission in the application. Review the privacy notices for details about
local storage, permissions, platform services, and data deletion.

## Technology

- Flutter and Dart
- Riverpod for application state
- GoRouter for navigation
- Local JSON assets for Quran content and translations
- Flutter localization resources in `lib/l10n/arb/`

## Repository structure

```text
assets/
  data/quran/                 Quran text, surah metadata, translations, sources
  branding/                   Application branding assets
  images/                     Application illustrations and guide images

docs/
  index.html                  Public project information
  privacy.html                English privacy policy
  privacy-tr.html             Turkish privacy policy

lib/
  core/                       Shared infrastructure, configuration, routing
  features/                   Application features
  l10n/arb/                   Turkish, English, and Arabic localization files
  shared/                     Shared widgets and design-system components

test/                         Unit, widget, and release-readiness tests

android/                      Android project and build configuration
ios/                          iOS project and privacy configuration
```

## Requirements

- Flutter stable and a compatible Dart SDK.
- Git.
- Chrome for local web development.
- Android Studio and the Android SDK for Android builds and device testing.
- macOS and Xcode for iOS builds and archive inspection.

Check the local toolchain before running a platform-specific build:

```powershell
flutter doctor -v
```

For Android, install the Android SDK and required platform/build tools, then
accept the Android SDK licenses. Android builds cannot run until Flutter can
locate a valid SDK installation.

## Local development

Fetch dependencies:

```powershell
flutter pub get
```

Run the web app in development mode:

```powershell
flutter run -d chrome --dart-define=APP_ENV=development
```

Run on an Android device after the Android toolchain has been configured:

```powershell
flutter run -d <device-id> --dart-define=APP_ENV=development
```

Replace `<device-id>` with a device ID listed by `flutter devices`.

## Configuration

The application supports these public build-time configuration values:

| Variable | Purpose |
| --- | --- |
| `APP_ENV` | Application environment: `development`, `staging`, or `production` |
| `API_BASE_URL` | Base URL for a configured application API |
| `CONNECT_TIMEOUT` | Network connection timeout configuration |
| `RECEIVE_TIMEOUT` | Network response timeout configuration |

The default `APP_ENV` is `production`. Development mode enables diagnostic
network logging in debug builds. Request and response bodies must not be
logged.

**Never place passwords, API secrets, private tokens, signing credentials,
or other confidential values in `--dart-define` or bundled assets.** Values
embedded in a web build or released application can be recovered from the
artifact. Keep genuine secrets on a controlled backend.

## Code quality and tests

Run the formatting tool, static analysis, and automated tests before considering
a change complete:

```powershell
dart format lib test
flutter analyze
flutter test --reporter compact
git diff --check
```

For release-related changes, run the relevant focused test first, followed by
the full test suite.

Automated tests do not replace manual device testing. In particular, verify
location permissions, prayer-time calculations, local notifications, navigation,
text direction, and the reader experience on supported physical devices before
publication.

## Quran content and attribution

Source metadata is maintained alongside the bundled data:

- Arabic Quran text: `assets/data/quran/SOURCE.md`
- Turkish translation: `assets/data/quran/translations/tr/SOURCE.md`
- English translation: `assets/data/quran/translations/en/SOURCE.md`

The Arabic text source record identifies the Tanzil Project. Preserve the
required source attribution, follow its text-usage conditions, and keep the
visible source and license links available in the application.

The Turkish translation source record identifies Erhan Aktaş and *Kerim Kur'an*,
obtained through AçıkKuran API. The API repository lists CC BY-NC-SA 4.0 for
the project. Before public distribution, verify that the applicable rights
cover the exact bundled translation data and the intended distribution method.

The English translation source record attributes the text to Marmaduke
Pickthall's *The Meaning of the Glorious Koran* (1930). Verify the provenance
and distribution status of the actual bundled dataset before publication.

Third-party content can have terms that differ from the application source
code's license. Do not infer the redistribution rights of a translation solely
from the license of the repository or API that supplied it.

## Public legal information

- English privacy policy: [`docs/privacy.html`](docs/privacy.html)
- Turkish privacy policy: [`docs/privacy-tr.html`](docs/privacy-tr.html)
- Public project page: [`docs/index.html`](docs/index.html)
- Privacy and support contact: `islamfull.app@gmail.com`

Before publication, verify that the published legal documents match the
behavior of the final release. Complete the required Terms of Use and Turkish
personal-data protection notice, and make sure the published URLs are publicly
accessible.

## Store release readiness

The application is not ready for store publication until every relevant item
below has been verified.

### Android

- The current Android namespace and application ID are `com.ozaycank.islamfull`.
  Confirm that this is the permanent identifier before the first store release.
- The release build configuration currently uses **debug signing**. Replace
  it with a dedicated production release-signing configuration before
  generating a store bundle.
- Keep signing keys and credentials outside version control. Never commit
  keystores, passwords, or signing-property files containing secrets.
- Configure the Android SDK and verify the merged release manifest.
- Verify the resolved target SDK and other store requirements at release time.
- Review all declared permissions and their actual use in the final artifact.
- Complete Google Play Data safety, ads, content-rating, target-audience, and
  other declarations using the actual app behavior and relevant device/network
  evidence.
- Build and test the release artifact on supported physical Android devices.

### iOS

- Confirm the final bundle identifier, signing team, certificates, and profiles.
- Inspect `ios/Runner/PrivacyInfo.xcprivacy` and the final Xcode Privacy Report.
- Review required-reason API declarations and third-party SDK privacy manifests.
- Inspect the final release archive and complete App Store Connect privacy
  declarations based on actual behavior.

### Content, legal, and listing

- Verify the provenance, attribution, and redistribution rights of all bundled
  Quran text and translation datasets.
- Confirm that the in-app source screen and source metadata accurately describe
  the bundled content.
- Finalize the privacy policy, Terms of Use, and any applicable personal-data
  protection notices.
- Prepare store screenshots, descriptions, support links, and other required
  listing assets.
- Run the full automated checks and complete manual device testing.
- Produce the final signed store artifact only after the release gates pass.

## Build artifacts

After installing and configuring the required toolchain and completing the
release-signing setup, the platform builds can be created with the relevant
Flutter commands.

Web:

```powershell
flutter build web --dart-define=APP_ENV=production
```

Android App Bundle:

```powershell
flutter build appbundle --release --dart-define=APP_ENV=production
```

iOS release/archive preparation requires macOS and Xcode. Do not publish
an artifact merely because a build succeeds; first complete the release gates
and verify the resulting artifact.

## Versioning

Update the application version in `pubspec.yaml` as part of a release.
Confirm that the resulting platform version names and build numbers are
appropriate before uploading an artifact to a store.