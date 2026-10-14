# IslamFull

Flutter application for prayer times, Quran reading, and religious guidance.

## Local development

Use public build-time configuration. The app no longer bundles or loads
an `.env` asset, because assets are readable by end users, especially on web.

```powershell
flutter pub get
flutter run -d chrome --dart-define=APP_ENV=development
```

Optional public configuration variables: `APP_ENV` (development, staging,
production), `API_BASE_URL`, `CONNECT_TIMEOUT`, and `RECEIVE_TIMEOUT`.
The default mode is `production`. `APP_ENV=development` only enables diagnostic
network logging in debug builds, and request/response bodies are never logged.

**Never put passwords, API secrets, signing keys, or private tokens in
`--dart-define`.** Build-time defines are recoverable from released artifacts.
Use a controlled backend for genuinely secret credentials.

## Public legal documents

- English: `docs/privacy.html`
- Turkish: `docs/privacy-tr.html`
- Privacy contact: `islamfull.app@gmail.com`

## Store release gates

Android's sample package identifier and debug release signing are not
production-ready; configure a permanent application ID and release signing
before generating any Play Store bundle. Check the merged release manifest and
complete the Google Play Data safety declaration using real device/network
captures. For iOS, inspect Xcode's Privacy Report for third-party SDK manifests
and required-reason APIs, confirm the final bundle ID and signing, and finish
App Store Connect App Privacy answers after inspecting the release archive.
