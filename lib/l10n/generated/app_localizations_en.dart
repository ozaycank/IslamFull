// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'IslamFull';

  @override
  String get splashLoading => 'Loading application...';

  @override
  String get generalError => 'An unexpected error occurred. Please try again.';

  @override
  String get navHome => 'Home';

  @override
  String get navPrayer => 'Prayer';

  @override
  String get navQuran => 'Quran';

  @override
  String get navActivity => 'Activity';

  @override
  String get navProfile => 'Profile';

  @override
  String get homeTitle => 'Home';

  @override
  String get homeDesc =>
      'Welcome to IslamFull. Your daily spiritual overview will appear here.';

  @override
  String get prayerTitle => 'Prayer Times';

  @override
  String get prayerDesc =>
      'Accurate prayer times and qibla direction will be displayed here.';

  @override
  String get quranTitle => 'Al-Quran';

  @override
  String get quranDesc =>
      'Holy Quran reading, audio recitations, and bookmarks will be available here.';

  @override
  String get activityDesc =>
      'Track your daily prayers, dhikr, and fasting progress here.';

  @override
  String get profileTitle => 'User Profile';

  @override
  String get profileDesc =>
      'Manage your Islamic lifestyle, preferences, and personal statistics all in one place.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsDesc =>
      'Configure notifications, calculation methods, and app themes.';

  @override
  String get openSettingsButton => 'Open Settings';

  @override
  String get emptyStateDefaultTitle => 'No Content Available';

  @override
  String get emptyStateDefaultDesc =>
      'This module is currently under development for a future phase.';

  @override
  String get errorStateDefaultTitle => 'Something Went Wrong';

  @override
  String get retryButton => 'Retry';

  @override
  String get prayerFajr => 'Fajr';

  @override
  String get prayerSunrise => 'Sunrise';

  @override
  String get prayerDhuhr => 'Dhuhr';

  @override
  String get prayerAsr => 'Asr';

  @override
  String get prayerMaghrib => 'Maghrib';

  @override
  String get prayerIsha => 'Isha';

  @override
  String get prayerNextPrayer => 'Next Prayer';

  @override
  String get prayerRemainingTime => 'Remaining Time';

  @override
  String get prayerCalculationMethod => 'Calculation Method';

  @override
  String get prayerMadhab => 'Madhab / Juristic Method';

  @override
  String get prayerLocationHeader => 'Prayer Location';

  @override
  String get prayerRefreshButton => 'Refresh Times';

  @override
  String get prayerSettingsTitle => 'Prayer Settings';

  @override
  String get prayerSettingsDesc =>
      'Adjust your calculation methods and juristic preferences.';

  @override
  String get locationTitle => 'Location Settings';

  @override
  String get currentLocation => 'Current Location';

  @override
  String get refreshLocation => 'Refresh Location';

  @override
  String get locationUnavailable => 'Location Unavailable';

  @override
  String get locationPermissionDenied => 'Location permission is required.';

  @override
  String get locationServiceDisabled => 'Location services are disabled.';

  @override
  String get locationGeocodingFailed => 'Failed to resolve address.';

  @override
  String get timezoneLabel => 'Timezone';

  @override
  String get coordinatesLabel => 'Coordinates';

  @override
  String get unknownCountry => 'Unknown';

  @override
  String get prayerCalculationTitle => 'Prayer Calculation';

  @override
  String get calculationMethodLabel => 'Calculation Method';

  @override
  String get madhabLabel => 'Madhab / Juristic Method';

  @override
  String get highLatitudeStrategyLabel => 'High Latitude Strategy';

  @override
  String get calculationMethodSaved => 'Settings saved successfully.';

  @override
  String get settingsSaveFailed => 'Failed to save settings.';

  @override
  String get angleBasedLabel => 'Angle Based';

  @override
  String get oneSeventhLabel => 'One Seventh';

  @override
  String get nightMiddleLabel => 'Middle of the Night';

  @override
  String get noneLabel => 'None';

  @override
  String get qiblaTitle => 'Qibla Direction';

  @override
  String get qiblaDirection => 'Direction';

  @override
  String get qiblaBearing => 'Bearing';

  @override
  String get qiblaLocation => 'Location';

  @override
  String get qiblaUnavailable =>
      'Qibla calculation unavailable. Please ensure your location is set.';

  @override
  String get qiblaCalculationError => 'Failed to calculate Qibla direction.';

  @override
  String get dirNorth => 'N';

  @override
  String get dirNorthEast => 'NE';

  @override
  String get dirEast => 'E';

  @override
  String get dirSouthEast => 'SE';

  @override
  String get dirSouth => 'S';

  @override
  String get dirSouthWest => 'SW';

  @override
  String get dirWest => 'W';

  @override
  String get dirNorthWest => 'NW';

  @override
  String get qiblaDisclaimer =>
      'Calculated from your current location. Turn-by-turn compass guidance is not enabled yet.';

  @override
  String get qiblaUndefinedAtKaaba =>
      'You are at the Kaaba. Qibla direction is undefined.';

  @override
  String get qiblaCompass => 'Qibla Compass';

  @override
  String get qiblaHeading => 'Device Heading';

  @override
  String get qiblaRelativeAngle => 'Relative Angle';

  @override
  String turnLeft(String degrees) {
    return 'Turn left $degrees°';
  }

  @override
  String turnRight(String degrees) {
    return 'Turn right $degrees°';
  }

  @override
  String get qiblaAligned => 'Aligned with Qibla';

  @override
  String get compassUnavailable => 'Compass Unavailable';

  @override
  String get compassSensorUnavailable =>
      'Your device does not have a compass sensor.';

  @override
  String get compassUnsupportedPlatform =>
      'Compass is not supported on this platform.';

  @override
  String get compassError => 'Failed to read compass sensor.';

  @override
  String get languageLabel => 'App Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageTurkish => 'Türkçe';

  @override
  String get themeTitle => 'Theme';

  @override
  String get themeSystem => 'System Default';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get methodMWL => 'Muslim World League';

  @override
  String get methodISNA => 'Islamic Society of North America';

  @override
  String get methodEgypt => 'Egyptian General Authority';

  @override
  String get methodMakkah => 'Umm Al-Qura';

  @override
  String get methodKarachi => 'University of Islamic Sciences, Karachi';

  @override
  String get methodTehran => 'Institute of Geophysics, University of Tehran';

  @override
  String get methodShia => 'Shia Ithna-Ashari';

  @override
  String get methodGulf => 'Gulf Region';

  @override
  String get methodKuwait => 'Kuwait';

  @override
  String get methodQatar => 'Qatar';

  @override
  String get methodSingapore => 'Majlis Ugama Islam Singapura';

  @override
  String get methodFrance => 'Union des Organisations Islamiques de France';

  @override
  String get methodTurkey => 'Diyanet Approximation Profile';

  @override
  String get methodRussia => 'Spiritual Administration of Muslims of Russia';

  @override
  String get methodMoonsighting => 'Moonsighting Committee Worldwide';

  @override
  String get methodDubai => 'Dubai';

  @override
  String get methodJakim => 'Jabatan Kemajuan Islam Malaysia';

  @override
  String get methodTunisia => 'Tunisian Ministry of Religious Affairs';

  @override
  String get methodAlgeria => 'Algerian Ministry of Religious Affairs';

  @override
  String get methodKemenag => 'Indonesian Ministry of Religious Affairs';

  @override
  String get methodMorocco => 'Moroccan Ministry of Habous and Islamic Affairs';

  @override
  String get methodPortugal => 'Great Mosque of Paris';

  @override
  String get methodJafari => 'Shia Ithna-Ashari';

  @override
  String get madhabStandard => 'Standard (Shafi / Maliki / Hanbali)';

  @override
  String get madhabHanafi => 'Hanafi';

  @override
  String get hijriMuharram => 'Muharram';

  @override
  String get hijriSafar => 'Safar';

  @override
  String get hijriRabiAlAwwal => 'Rabi\' al-Awwal';

  @override
  String get hijriRabiAlThani => 'Rabi\' al-Thani';

  @override
  String get hijriJumadaAlAwwal => 'Jumada al-Awwal';

  @override
  String get hijriJumadaAlThani => 'Jumada al-Thani';

  @override
  String get hijriRajab => 'Rajab';

  @override
  String get hijriShaaban => 'Sha\'ban';

  @override
  String get hijriRamadan => 'Ramadan';

  @override
  String get hijriShawwal => 'Shawwal';

  @override
  String get hijriDhuAlQiDah => 'Dhu al-Qi\'dah';

  @override
  String get hijriDhuAlHijjah => 'Dhu al-Hijjah';

  @override
  String get asrConventionDesc => 'Asr calculation convention';

  @override
  String get homeGreeting => 'Assalamu Alaikum';

  @override
  String get homeToday => 'Today\'s Schedule';

  @override
  String get nextPrayerHeader => 'Next Prayer';

  @override
  String get viewQibla => 'Qibla Direction';

  @override
  String get openSettings => 'App Settings';

  @override
  String get homePrayerError => 'Prayer times unavailable.';

  @override
  String get homePrayerRetry => 'Retry Location';

  @override
  String get homeComingSoon => 'Coming Soon';

  @override
  String get quranSearchHint => 'Search Surah';

  @override
  String get quranNoSurahFound => 'No Surah found.';

  @override
  String get quranMeccan => 'Meccan';

  @override
  String get quranMedinan => 'Medinan';

  @override
  String quranAyahCount(int count) {
    return '$count Ayahs';
  }

  @override
  String get quranDetailPlaceholderText =>
      'Quran text reader will be implemented in a later phase.';

  @override
  String get quranContinueReading => 'Continue Reading';

  @override
  String get quranLastRead => 'Last Read';

  @override
  String get quranAyah => 'Ayah';

  @override
  String get quranContinue => 'Continue';

  @override
  String get quranNoHistory => 'No reading history yet.';

  @override
  String get quranBookmarks => 'Bookmarks';

  @override
  String get quranBookmarkAdd => 'Add Bookmark';

  @override
  String get quranBookmarkRemove => 'Remove Bookmark';

  @override
  String get quranNoBookmarksYet => 'No bookmarks yet.';

  @override
  String get quranReaderSettings => 'Reader Settings';

  @override
  String get quranTextSize => 'Text Size';

  @override
  String get quranResetDefault => 'Reset to Default';

  @override
  String get quranShowTranslation => 'Show Translation';

  @override
  String get quranTranslationUnavailable => 'Translation unavailable.';

  @override
  String get homeDailyOverview => 'Daily Overview';

  @override
  String get homeNextPrayer => 'Next Prayer';

  @override
  String get homeRemaining => 'remaining';

  @override
  String get homePrayerTimes => 'Prayer Times';

  @override
  String get homeContinueReading => 'Continue Reading';

  @override
  String get homeBookmarks => 'Bookmarks';

  @override
  String homeSavedAyahs(int count) {
    return '$count saved ayahs';
  }

  @override
  String get homeQibla => 'Qibla';

  @override
  String get homeSettings => 'Settings';

  @override
  String get homeLocationUnavailable => 'Location unavailable';

  @override
  String get homePrayerFajr => 'Fajr';

  @override
  String get homePrayerSunrise => 'Sunrise';

  @override
  String get homePrayerDhuhr => 'Dhuhr';

  @override
  String get homePrayerAsr => 'Asr';

  @override
  String get homePrayerMaghrib => 'Maghrib';

  @override
  String get homePrayerIsha => 'Isha';

  @override
  String get descDiyarTurk => 'Diyanet Approximation using 18°/17° angles.';

  @override
  String get descMwl => 'Standard method widely used across Europe and Asia.';

  @override
  String get descIsna => 'Standard method for North America.';

  @override
  String get descEgypt => 'Standard method in Africa and Middle East.';

  @override
  String get descMakkah => 'Standard method in Arabian Peninsula.';

  @override
  String get activityTitle => 'Activity';

  @override
  String get activityToday => 'Today\'s Activity';

  @override
  String get activityPrayers => 'Prayers';

  @override
  String get activityCompleted => 'Completed';

  @override
  String get activityNotCompleted => 'Not Completed';

  @override
  String get activityQuranReading => 'Quran Reading';

  @override
  String get activityReadToday => 'Read Today';

  @override
  String get activityNotRecorded => 'Not Recorded';

  @override
  String get activityMarkAsRead => 'Mark as Read';

  @override
  String get activityHistory => 'History';

  @override
  String get activityStatistics => 'Statistics';

  @override
  String get activityEmptyHistory => 'No past records found.';

  @override
  String get statsStreak => 'Current Streak';

  @override
  String statsDays(int count) {
    return '$count Days';
  }

  @override
  String get statsAvgCompletion => '7-Day Avg';

  @override
  String get statsQuranDays => 'Quran (7d)';

  @override
  String get profileGuest => 'Guest User';

  @override
  String get profileGuestDesc => 'Sign in to backup your data.';

  @override
  String get profileStatsSummary => 'Your Progress';

  @override
  String get dailyVerseTitle => 'Verse of the Day';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsEnabled => 'Enable Notifications';

  @override
  String get prayerReminders => 'Prayer Reminders';

  @override
  String get dailyVerseEnabled => 'Daily Quran Verse';

  @override
  String get notificationPermissionDeniedMessage =>
      'Notification permission denied. Please enable it in your device settings.';

  @override
  String get activityMotivation => 'Today is a great day to purify your heart.';

  @override
  String get activityTodayProgress => 'Daily Progress';

  @override
  String get activityTapToComplete => 'Tap to complete';

  @override
  String get activityHistoryEmptyDesc =>
      'As you record your worship, this space will become the map of your spiritual journey.';

  @override
  String get homeShahadaArabic =>
      'أَشْهَدُ أَنْ لَا إِلَٰهَ إِلَّا ٱللَّٰهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا رَسُولُ ٱللَّٰهِ';

  @override
  String get homeShahadaTransliteration =>
      'Ash-hadu an la ilaha illallah, wa ash-hadu anna Muhammadan rasulullah.';

  @override
  String get navMenu => 'Menu';

  @override
  String get menuSettingsGroup => 'App Settings';

  @override
  String get menuLanguage => 'Language';

  @override
  String get menuTheme => 'Theme';

  @override
  String get menuNotifications => 'Notifications';

  @override
  String get menuPrayerCalc => 'Prayer Calculation';

  @override
  String get menuLocation => 'Location';

  @override
  String get menuSounds => 'Notification Sounds';

  @override
  String get menuPersonalizationGroup => 'Personalization';

  @override
  String get menuDailyGoals => 'Daily Goals';

  @override
  String get menuPreferences => 'Preferences';

  @override
  String get menuToolsGroup => 'Tools & Information';

  @override
  String get menuIslamicTools => 'Islamic Tools';

  @override
  String get menuInfoCenter => 'Information Center';

  @override
  String get menuHajjGuide => 'Hajj & Umrah';

  @override
  String get menuZakatCalc => 'Zakat Calculator';

  @override
  String get menuAppGroup => 'Application';

  @override
  String get menuAbout => 'About';

  @override
  String get menuPrivacy => 'Privacy & Legal';

  @override
  String get menuSources => 'Sources';

  @override
  String get zakatTitle => 'Zakat Calculator';

  @override
  String get zakatGoldPriceLabel => 'Current Gold Price per Gram';

  @override
  String get zakatAssetsGroup => 'Your Assets (Subject to Zakat)';

  @override
  String get zakatCashLabel => 'Cash & Bank Accounts';

  @override
  String get zakatGoldGramsLabel => 'Owned Gold (Grams)';

  @override
  String get zakatTradeGoodsLabel => 'Trade Goods Value';

  @override
  String get zakatReceivablesLabel => 'Eligible Receivables';

  @override
  String get zakatDebtsGroup => 'Deductions';

  @override
  String get zakatDebtsLabel => 'Current-Year Debts & Essential Needs';

  @override
  String get zakatCalculateButton => 'Calculate Zakat';

  @override
  String get zakatResultTitle => 'Calculation Result';

  @override
  String get zakatTotalWealth => 'Total Net Wealth:';

  @override
  String get zakatNisabAmount => 'Nisab Threshold (80.18 gr):';

  @override
  String get zakatRequiredAmount => 'Estimated Zakat Amount:';

  @override
  String get zakatNotRequired =>
      'Based on the values entered, your current net zakatable wealth is below the nisab threshold.';

  @override
  String get zakatDiyanetNote =>
      'This calculator uses the 80.18 grams of gold nisab reference and general guidance published by the Presidency of Religious Affairs. Basic-use assets such as your primary residence and personal-use vehicle are not entered as zakatable assets. Individual rulings can vary by circumstances and school of law.';

  @override
  String get zakatLunarYearTitle => 'Lunar-Year Condition';

  @override
  String get zakatLunarYearConfirmed => 'A lunar zakat year has been completed';

  @override
  String get zakatLunarYearDesc =>
      'Confirm this only if one lunar year has passed since your zakatable wealth reached nisab and it is still at or above nisab now. Income acquired during that zakat year may be included with the existing zakatable wealth under current Presidency of Religious Affairs guidance.';

  @override
  String get zakatLunarYearNotConfirmed =>
      'Your current net zakatable wealth reaches the nisab estimate, but the lunar-year condition has not been confirmed. This calculator therefore cannot determine an estimated payable zakat amount.';

  @override
  String get zakatReceivablesHelp =>
      'Include receivables that are acknowledged by the debtor or supported by clear evidence and are relevant to your zakat calculation. Doubtful or unrecoverable receivables are treated differently.';

  @override
  String get zakatDebtsHelp =>
      'Enter genuine essential needs and debts that are due within the current zakat year. Do not deduct the entire balance of long-term debts solely because they exist.';

  @override
  String get zakatEstimateNote =>
      'This result is a calculation aid, not an individual fatwa. Receivables, debts, newly acquired wealth and other personal circumstances can require a more detailed assessment.';

  @override
  String get zakatGoldPriceRequired => 'Enter the current gold price per gram.';

  @override
  String get zakatGoldPricePositive => 'Enter a gold price greater than zero.';

  @override
  String get hajjTitle => 'Hajj & Umrah';

  @override
  String get hajjDiyanetInfo =>
      'For official Hajj and Umrah registration, organisation announcements and current administrative information in Türkiye, use the Presidency of Religious Affairs Hajj and Umrah website.';

  @override
  String get hajjOfficialLinkButton => 'Open Official Diyanet Hajj & Umrah';

  @override
  String get comingSoonAlert => 'This feature will be added in the next phase.';

  @override
  String get aboutAppDescription =>
      'IslamFull is a local, privacy-focused Islamic lifestyle assistant designed to help you track daily prayers, read the Quran, and reach your spiritual goals.';

  @override
  String get aboutVersion => 'Version 1.0.0';

  @override
  String get aboutCopyright => '© 2026 IslamFull. All rights reserved.';

  @override
  String get privacyPolicyContent =>
      'IslamFull works without requiring a user account. Feature settings and personal-use records may be stored locally on your device. Device location is accessed when requested for prayer times, Qibla and timezone calculations. A readable place name may be obtained through platform geocoding and, if that does not return usable information, the current app may transmit the selected latitude and longitude over HTTPS to the public OpenStreetMap Foundation Nominatim service. Local notification permissions are used only if you enable reminders. Some preferences and records are stored using platform-protected secure storage. IslamFull does not sell personal data. External services and websites are subject to their own privacy practices.';

  @override
  String get privacyIntroTitle => 'Privacy at a glance';

  @override
  String get privacyIntroDesc =>
      'IslamFull is designed to work without requiring a user account. This page explains what the current app build accesses, what can remain on your device, and which operating-system or external services may be involved.';

  @override
  String get privacyPublicPolicyTitle => 'Public privacy policy';

  @override
  String privacyPublicPolicyDesc(String email) {
    return 'The detailed IslamFull Privacy Policy is published publicly on the IslamFull website. Privacy contact: $email';
  }

  @override
  String get privacyOpenPolicy => 'Open Privacy Policy';

  @override
  String get privacyEmailContact => 'Email privacy contact';

  @override
  String get privacyLinkOpenFailed => 'The link could not be opened.';

  @override
  String get privacyDataTitle => 'App data';

  @override
  String get privacyDataDesc =>
      'Feature settings and personal-use records may be stored locally on your device. This can include prayer settings and selected location, notification and appearance preferences, New Muslim Journey progress, Quran reading progress and bookmarks, reader settings and worship activity records. IslamFull does not sell personal data, and the current app does not require an IslamFull account.';

  @override
  String get privacyLocationTitle => 'Location';

  @override
  String get privacyLocationDesc =>
      'When you request device location, IslamFull uses foreground location for prayer-time calculation, Qibla direction and timezone selection. Your selected latitude, longitude, city, country and timezone may be stored locally so the app can remember the selected prayer location. You can use manual coordinates instead. IslamFull does not request continuous background location.';

  @override
  String get privacyNotificationsTitle => 'Notifications';

  @override
  String get privacyNotificationsDesc =>
      'If you enable reminders, IslamFull schedules prayer and Daily Verse notifications locally on your device. Notification permission is controlled by the operating system. On supported Android versions, precise scheduling may also depend on the system\'s exact-alarm access.';

  @override
  String get privacyStorageTitle => 'Local storage and security';

  @override
  String get privacyStorageDesc =>
      'Some preferences and records are stored using platform-protected secure storage. Other feature state may also remain in local application storage. Device security and operating-system backup or restore behavior can affect locally stored information.';

  @override
  String get privacyExternalTitle => 'External services and links';

  @override
  String get privacyExternalDesc =>
      'IslamFull may use operating-system geocoding to obtain a readable place name. If that does not return usable information, the current app may send the selected latitude and longitude over HTTPS to the public Nominatim service operated by the OpenStreetMap Foundation for reverse geocoding. External links you choose to open, including official Diyanet pages, are governed by the destination service\'s own terms and privacy practices.';

  @override
  String get privacyRetentionTitle => 'Retention and deletion';

  @override
  String get privacyRetentionDesc =>
      'Locally stored app data may remain until the relevant feature is reset, application storage is cleared where supported, or the application is removed. Operating-system backup, restore, secure-storage or keychain behavior may cause some information to persist or be restored. IslamFull currently does not maintain an IslamFull user account database.';

  @override
  String get privacyRightsTitle => 'Privacy requests';

  @override
  String get privacyRightsDesc =>
      'Privacy and personal-data questions concerning IslamFull can be sent to islamfull.app@gmail.com. The detailed public Privacy Policy is also available from this screen.';

  @override
  String get privacyReligiousInfoTitle =>
      'Religious and calculation information';

  @override
  String get privacyReligiousInfoDesc =>
      'IslamFull provides educational religious content and calculation aids. Prayer times, Qibla, Hijri dates, zakat estimates and guidance can vary according to calculation method, location, device data and jurisprudential context. For matters requiring an individual ruling or official procedure, verify the information with Diyanet or another qualified authority.';

  @override
  String get privacyTermsTitle => 'Use of the application';

  @override
  String get privacyTermsDesc =>
      'IslamFull is an informational and personal-use assistant. Calculations and guidance should not be treated as a guarantee, an individual fatwa, medical advice, financial advice or an official administrative decision. You remain responsible for decisions made using the application.';

  @override
  String get privacyUpdated => 'Last updated: October 9, 2026';

  @override
  String get preferencesTitle => 'Preferences';

  @override
  String get prefHapticFeedback => 'Haptic Feedback';

  @override
  String get prefHapticDesc => 'Vibration on Tasbih and buttons';

  @override
  String get prefDailyVerse => 'Daily Verse';

  @override
  String get prefDailyVerseDesc => 'Show daily verse on home screen';

  @override
  String get toolsTitle => 'Islamic Tools';

  @override
  String get tasbihTitle => 'Tasbih (Dhikr)';

  @override
  String get tasbihReset => 'Reset';

  @override
  String get tasbihCount => 'Dhikr Count';

  @override
  String tasbihGoal(int goal) {
    return 'Goal: $goal';
  }

  @override
  String get infoCenterTitle => 'Information Center';

  @override
  String get wuduGuideTitle => 'How to perform Wudu?';

  @override
  String get wuduStep1Title => '1. Intention and Bismillah';

  @override
  String get wuduStep1Desc => 'Make intention for Wudu and say Bismillah.';

  @override
  String get wuduStep2Title => '2. Wash Hands';

  @override
  String get wuduStep2Desc =>
      'Wash hands up to the wrists three times, ensuring water reaches between fingers.';

  @override
  String get wuduStep3Title => '3. Rinse Mouth';

  @override
  String get wuduStep3Desc =>
      'Take water into the mouth with the right hand and rinse it three times.';

  @override
  String get wuduStep4Title => '4. Sniff Water into Nose';

  @override
  String get wuduStep4Desc =>
      'Inhale water into the nose with the right hand and blow it out using the left hand, three times.';

  @override
  String get wuduStep5Title => '5. Wash Face';

  @override
  String get wuduStep5Desc =>
      'Wash the whole face (from hairline to chin) three times.';

  @override
  String get wuduStep6Title => '6. Wash Arms';

  @override
  String get wuduStep6Desc =>
      'Wash the right arm up to the elbow three times, then do the same for the left arm.';

  @override
  String get wuduStep7Title => '7. Wipe Head (Masah)';

  @override
  String get wuduStep7Desc =>
      'Wipe the head once with wet hands. In Diyanet\'s Hanafi guidance, wiping at least one quarter of the head fulfills this requirement; details differ between schools of Islamic law.';

  @override
  String get wuduStep8Title => '8. Wipe Ears and Neck';

  @override
  String get wuduStep8Desc =>
      'Wipe the ears. Diyanet\'s commonly taught sequence also includes wiping the neck with the backs of the hands. Some details of this step vary between schools of Islamic law.';

  @override
  String get wuduStep9Title => '9. Wash Feet';

  @override
  String get wuduStep9Desc =>
      'Wash the right foot up to the ankles three times, starting from the toes. Repeat for the left foot.';

  @override
  String notificationMinutesBefore(int minutes) {
    return '$minutes minutes before';
  }

  @override
  String get dailyVerseTime => 'Daily verse time';

  @override
  String get notificationsUnsupportedPlatform =>
      'Local notifications are not supported on this platform yet.';

  @override
  String get infoCenterWelcomeTitle => 'Learn at Your Own Pace';

  @override
  String get infoCenterWelcomeDesc =>
      'Explore clear, practical guides about the foundations of Islam and everyday worship.';

  @override
  String get infoCenterLearningGuides => 'Learning Guides';

  @override
  String get infoCenterWorshipGuides => 'Worship Guides';

  @override
  String get newMuslimJourneyTitle => 'New Muslim Journey';

  @override
  String get newMuslimJourneyMenuDesc =>
      'A simple starting path for learning the essentials of Islam.';

  @override
  String get newMuslimJourneyWelcomeTitle => 'Welcome to Your Journey';

  @override
  String get newMuslimJourneySubtitle =>
      'You do not need to learn everything at once. Begin with the foundations, then build your knowledge and worship step by step.';

  @override
  String get newMuslimJourneyStartHere => 'Start Here';

  @override
  String get newMuslimJourneyFoundationsTitle => 'Learn the Foundations';

  @override
  String get newMuslimJourneyFoundationsDesc =>
      'Understand the five pillars of Islam and the six articles of faith.';

  @override
  String get newMuslimJourneyWuduTitle => 'Learn Wudu';

  @override
  String get newMuslimJourneyWuduDesc =>
      'Learn the basic steps of purification before prayer.';

  @override
  String get newMuslimJourneyPrayerTitle => 'Become Familiar with Prayer';

  @override
  String get newMuslimJourneyPrayerDesc =>
      'Explore daily prayer times and begin becoming familiar with the rhythm of the five prayers.';

  @override
  String get newMuslimJourneyQuranTitle => 'Read the Quran';

  @override
  String get newMuslimJourneyQuranDesc =>
      'Read the Quran together with a translation in the language you understand best.';

  @override
  String get newMuslimJourneyNoteTitle => 'Learn Gradually';

  @override
  String get newMuslimJourneyNoteBody =>
      'IslamFull provides introductory guidance. For personal religious rulings or circumstances that require detailed guidance, consult a qualified and trusted scholar.';

  @override
  String get islamFoundationsTitle => 'Foundations of Islam';

  @override
  String get islamFoundationsMenuDesc =>
      'Learn the five pillars of Islam and the core articles of faith.';

  @override
  String get islamFoundationsIntro =>
      'The pillars of Islam describe core acts of worship, while the articles of faith summarize fundamental beliefs. This guide offers a concise introduction.';

  @override
  String get fivePillarsTitle => 'The Five Pillars of Islam';

  @override
  String get fivePillarsIntro =>
      'The five pillars form the central framework of Muslim worship and practice.';

  @override
  String get pillarShahadaTitle => 'Shahada';

  @override
  String get pillarShahadaDesc =>
      'Bearing witness that there is no deity worthy of worship except Allah and that Muhammad is His Messenger.';

  @override
  String get pillarPrayerTitle => 'Salah';

  @override
  String get pillarPrayerDesc =>
      'Performing the five daily prayers at their prescribed times.';

  @override
  String get pillarZakatTitle => 'Zakat';

  @override
  String get pillarZakatDesc =>
      'Giving obligatory charity when its religious conditions are met.';

  @override
  String get pillarFastingTitle => 'Fasting in Ramadan';

  @override
  String get pillarFastingDesc =>
      'Fasting during the month of Ramadan from dawn until sunset for those required and able to fast.';

  @override
  String get pillarHajjTitle => 'Hajj';

  @override
  String get pillarHajjDesc =>
      'Making the pilgrimage to Makkah once in a lifetime for Muslims who are able to undertake it.';

  @override
  String get articlesOfFaithTitle => 'The Six Articles of Faith';

  @override
  String get articlesOfFaithIntro =>
      'These six principles summarize the foundational beliefs traditionally taught in Islamic creed.';

  @override
  String get faithAllahTitle => 'Belief in Allah';

  @override
  String get faithAllahDesc =>
      'Believing in Allah, His oneness, and that He alone is worthy of worship.';

  @override
  String get faithAngelsTitle => 'Belief in the Angels';

  @override
  String get faithAngelsDesc =>
      'Believing in the angels created by Allah and in the duties assigned to them.';

  @override
  String get faithBooksTitle => 'Belief in the Revealed Books';

  @override
  String get faithBooksDesc =>
      'Believing in the scriptures revealed by Allah to His messengers.';

  @override
  String get faithMessengersTitle => 'Belief in the Messengers';

  @override
  String get faithMessengersDesc =>
      'Believing in the prophets and messengers sent by Allah to guide humanity.';

  @override
  String get faithLastDayTitle => 'Belief in the Last Day';

  @override
  String get faithLastDayDesc =>
      'Believing in resurrection, judgment, and the life of the Hereafter.';

  @override
  String get faithDivineDecreeTitle => 'Belief in Divine Decree';

  @override
  String get faithDivineDecreeDesc =>
      'Believing in Allah\'s complete knowledge and decree while recognizing human responsibility for choices.';

  @override
  String get islamFoundationsDisclaimer =>
      'This section provides a concise educational overview and is not intended to replace detailed religious instruction.';

  @override
  String get wuduGuideMenuDesc =>
      'Follow the basic steps of ablution before prayer.';

  @override
  String get guidanceSourceNote =>
      'Content basis: Presidency of Religious Affairs (Diyanet), with differences between Islamic legal schools noted where relevant.';

  @override
  String get wuduGuideIntro =>
      'Wudu is the ritual purification performed before prayer and certain other acts of worship. The steps below follow the commonly taught Diyanet sequence.';

  @override
  String get wuduGuideSchoolNote =>
      'Some details of wudu, including how much of the head is wiped and certain recommended actions, differ between schools of Islamic law.';

  @override
  String get prayerGuideTitle => 'How to Perform Prayer';

  @override
  String get prayerGuideMenuDesc =>
      'Learn the preparation and basic sequence of Salah step by step.';

  @override
  String get prayerGuideShortcutDesc =>
      'Learn the basic movements and sequence of prayer.';

  @override
  String get prayerGuideIntro =>
      'This guide introduces the essential structure of Salah using a two-rak\'ah prayer as the learning model.';

  @override
  String get prayerGuidePreparationTitle => 'Before Prayer';

  @override
  String get prayerGuidePreparationDesc =>
      'Before prayer, ensure ritual purity, cleanliness of the body, clothing and place, appropriate covering, the correct prayer time, facing the Qiblah, and intention for the prayer.';

  @override
  String get prayerGuideFarzRakahsTitle => 'Obligatory Rak\'ahs';

  @override
  String get prayerGuideFarzRakahsDesc =>
      'Fajr: 2 • Dhuhr: 4 • Asr: 4 • Maghrib: 3 • Isha: 4';

  @override
  String get prayerGuideTwoRakahTitle => 'Basic Two-Rak\'ah Sequence';

  @override
  String get prayerGuideStep1Title => '1. Intention and Opening Takbir';

  @override
  String get prayerGuideStep1Desc =>
      'Make the intention in your heart for the prayer you are about to perform. Begin the prayer by saying \'Allahu Akbar\'.';

  @override
  String get prayerGuideStep2Title => '2. Standing and Recitation';

  @override
  String get prayerGuideStep2Desc =>
      'Remain standing for the recitation. In Diyanet\'s common two-rak\'ah example, the opening supplication is followed by seeking refuge, Bismillah, Al-Fatihah and a passage from the Quran.';

  @override
  String get prayerGuideStep3Title => '3. Bowing (Ruku)';

  @override
  String get prayerGuideStep3Desc =>
      'Say \'Allahu Akbar\' and bow. In the commonly taught Diyanet practice, \'Subhana Rabbiyal Azim\' is recited three times.';

  @override
  String get prayerGuideStep4Title => '4. Rise from Ruku';

  @override
  String get prayerGuideStep4Desc =>
      'Rise from bowing while saying \'Sami\'Allahu liman hamidah\'. Once fully upright, say \'Rabbana laka\'l-hamd\'. Remain briefly in the upright position before proceeding to prostration.';

  @override
  String get prayerGuideStep5Title => '5. Two Prostrations';

  @override
  String get prayerGuideStep5Desc =>
      'Say \'Allahu Akbar\' to enter prostration, rise briefly to a sitting position, and then perform the second prostration. In the commonly taught practice, \'Subhana Rabbiyal A\'la\' is recited three times in each prostration.';

  @override
  String get prayerGuideStep6Title => '6. Second Rak\'ah';

  @override
  String get prayerGuideStep6Desc =>
      'Stand for the second rak\'ah. Recite Al-Fatihah and a passage from the Quran, then repeat the bowing and two prostrations.';

  @override
  String get prayerGuideStep7Title => '7. Final Sitting';

  @override
  String get prayerGuideStep7Desc =>
      'After the second rak\'ah, remain seated for the final sitting. In Diyanet\'s common teaching, the Tashahhud and the Salawat prayers are recited here.';

  @override
  String get prayerGuideStep8Title => '8. Complete with Salam';

  @override
  String get prayerGuideStep8Desc =>
      'Complete the prayer by turning first to the right and then to the left, saying \'Assalamu alaykum wa rahmatullah\'.';

  @override
  String get prayerGuideSchoolNote =>
      'The essential pillars of prayer are shared, while details such as hand placement, some recitations and sitting positions may differ between schools of Islamic law. This guide follows the commonly taught Diyanet sequence without presenting school-specific details as universal.';

  @override
  String get ghuslGuideTitle => 'How to Perform Ghusl';

  @override
  String get ghuslGuideMenuDesc =>
      'Learn when full ritual purification is required and how it is performed.';

  @override
  String get ghuslGuideIntro =>
      'Ghusl is full ritual purification in which the body is washed thoroughly so that water reaches every required area.';

  @override
  String get ghuslWhenRequiredTitle => 'When is Ghusl Required?';

  @override
  String get ghuslWhenRequiredDesc =>
      'Ghusl is required after major ritual impurity such as janabah, and after menstruation or postnatal bleeding has ended.';

  @override
  String get ghuslStep1Title => '1. Intention and Bismillah';

  @override
  String get ghuslStep1Desc =>
      'Form the intention for purification and begin with Bismillah.';

  @override
  String get ghuslStep2Title => '2. Wash the Hands and Remove Impurity';

  @override
  String get ghuslStep2Desc =>
      'Wash the hands and clean any physical impurity from the body and private area.';

  @override
  String get ghuslStep3Title => '3. Rinse the Mouth and Nose';

  @override
  String get ghuslStep3Desc =>
      'Rinse the mouth thoroughly and clean the nose with water. Diyanet identifies these, together with washing the whole body, as obligatory elements of ghusl in the Hanafi school.';

  @override
  String get ghuslStep4Title => '4. Perform Wudu';

  @override
  String get ghuslStep4Desc =>
      'Perform wudu as you would for prayer. If water is collecting around the feet, they may be washed at the end.';

  @override
  String get ghuslStep5Title => '5. Wash the Head and Hair';

  @override
  String get ghuslStep5Desc =>
      'Pour water over the head and make sure it reaches the scalp and roots of the hair.';

  @override
  String get ghuslStep6Title => '6. Wash the Entire Body';

  @override
  String get ghuslStep6Desc =>
      'Wash the entire body thoroughly, leaving no dry area. Pay attention to places that water may not easily reach.';

  @override
  String get ghuslSchoolNote =>
      'Details concerning the obligatory elements of ghusl differ between Islamic legal schools. The sequence above follows Diyanet\'s commonly taught Hanafi-oriented explanation while identifying the shared goal of complete ritual purification.';

  @override
  String get journeyLearningPathTitle => 'Your Learning Path';

  @override
  String get journeyLearningPathDesc =>
      'Use these simple markers only to remember what you have reviewed and where you would like to continue. They are not scores, rewards, or achievements.';

  @override
  String get journeyReviewed => 'Reviewed';

  @override
  String get journeyNotReviewed => 'Not marked';

  @override
  String get journeyMarkReviewed => 'Mark as reviewed';

  @override
  String get journeyRemoveReviewed => 'Remove review mark';

  @override
  String get journeyContinueButton => 'Continue Learning';

  @override
  String get newMuslimJourneyDuasTitle => 'Learn Daily Duas';

  @override
  String get newMuslimJourneyDuasDesc =>
      'Read a small collection of sourced supplications for common moments in daily life.';

  @override
  String get duasTitle => 'Daily Duas';

  @override
  String get duasMenuDesc =>
      'Read short, sourced supplications for everyday moments.';

  @override
  String get duasIntro =>
      'A calm reference for learning supplications and remembrance from the Islamic tradition. Read them at your own pace and return whenever you need them.';

  @override
  String get duasEverydaySection => 'Everyday Duas';

  @override
  String get duasAfterPrayerSection => 'After Prayer';

  @override
  String get duasRecommendationNote =>
      'These supplications and remembrances are presented for learning and voluntary practice. They are not a score, reward, or achievement system.';

  @override
  String get duaWhenLabel => 'When';

  @override
  String get duaArabicLabel => 'Arabic';

  @override
  String get duaTransliterationLabel => 'Transliteration';

  @override
  String get duaMeaningLabel => 'Meaning';

  @override
  String get duaSourceLabel => 'Source';

  @override
  String get duaWakeTitle => 'Upon Waking';

  @override
  String get duaWakeWhen => 'After waking from sleep.';

  @override
  String get duaWakeArabic =>
      'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ';

  @override
  String get duaWakeTransliteration =>
      'Al-hamdu lillahil-ladhi ahyana ba\'da ma amatana wa ilayhin-nushur.';

  @override
  String get duaWakeMeaning =>
      'All praise is for Allah who gave us life after causing us to die, and to Him is the resurrection.';

  @override
  String get duaWakeSource => 'Bukhari, Da\'awat, 7';

  @override
  String get duaSleepTitle => 'Before Sleep';

  @override
  String get duaSleepWhen => 'When going to bed.';

  @override
  String get duaSleepArabic => 'بِاسْمِكَ أَمُوتُ وَأَحْيَا';

  @override
  String get duaSleepTransliteration => 'Bismika amutu wa ahya.';

  @override
  String get duaSleepMeaning => 'In Your name I die and I live.';

  @override
  String get duaSleepSource => 'Bukhari, Da\'awat, 7';

  @override
  String get duaLeavingHomeTitle => 'Leaving Home';

  @override
  String get duaLeavingHomeWhen => 'When leaving your home.';

  @override
  String get duaLeavingHomeArabic =>
      'بِسْمِ اللَّهِ، تَوَكَّلْتُ عَلَى اللَّهِ، لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ';

  @override
  String get duaLeavingHomeTransliteration =>
      'Bismillah, tawakkaltu \'alallah, la hawla wa la quwwata illa billah.';

  @override
  String get duaLeavingHomeMeaning =>
      'In the name of Allah; I place my trust in Allah. There is no power and no strength except through Allah.';

  @override
  String get duaLeavingHomeSource => 'Abu Dawud, Adab, 102-103';

  @override
  String get duaRestroomTitle => 'Before Entering the Restroom';

  @override
  String get duaRestroomWhen => 'Before entering the restroom.';

  @override
  String get duaRestroomArabic =>
      'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْخُبُثِ وَالْخَبَائِثِ';

  @override
  String get duaRestroomTransliteration =>
      'Allahumma inni a\'udhu bika minal-khubthi wal-khaba\'ith.';

  @override
  String get duaRestroomMeaning =>
      'O Allah, I seek refuge in You from evil and impure things.';

  @override
  String get duaRestroomSource => 'Bukhari, Wudu, 9';

  @override
  String get duaAfterMealTitle => 'After Eating';

  @override
  String get duaAfterMealWhen => 'After eating or drinking.';

  @override
  String get duaAfterMealArabic =>
      'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنَا وَسَقَانَا وَجَعَلَنَا مِنَ الْمُسْلِمِينَ';

  @override
  String get duaAfterMealTransliteration =>
      'Al-hamdu lillahil-ladhi at\'amana wa saqana wa ja\'alana minal-muslimin.';

  @override
  String get duaAfterMealMeaning =>
      'All praise is for Allah who fed us, gave us drink, and made us among the Muslims.';

  @override
  String get duaAfterMealSource => 'Tirmidhi, Da\'awat, 56';

  @override
  String get duaTravelTitle => 'Travel';

  @override
  String get duaTravelWhen => 'When setting out on a journey.';

  @override
  String get duaTravelArabic =>
      'سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ وَإِنَّا إِلَى رَبِّنَا لَمُنْقَلِبُونَ اللَّهُمَّ إِنَّا نَسْأَلُكَ فِي سَفَرِنَا هَذَا الْبِرَّ وَالتَّقْوَى وَمِنَ الْعَمَلِ مَا تَرْضَى اللَّهُمَّ هَوِّنْ عَلَيْنَا سَفَرَنَا هَذَا وَاطْوِ عَنَّا بُعْدَهُ اللَّهُمَّ أَنْتَ الصَّاحِبُ فِي السَّفَرِ وَالْخَلِيفَةُ فِي الْأَهْلِ اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ وَعْثَاءِ السَّفَرِ وَكَآبَةِ الْمَنْظَرِ وَسُوءِ الْمُنْقَلَبِ فِي الْمَالِ وَالْأَهْلِ';

  @override
  String get duaTravelTransliteration =>
      'Subhanalladhi sakhkhara lana hadha wa ma kunna lahu muqrinin, wa inna ila rabbina lamunqalibun. Allahumma inna nas\'aluka fi safarina hadhal-birra wat-taqwa wa minal-\'amali ma tarda. Allahumma hawwin \'alayna safarana hadha watwi \'anna bu\'dahu. Allahumma antas-sahibu fis-safari wal-khalifatu fil-ahli. Allahumma inni a\'udhu bika min wa\'tha\'is-safari wa ka\'abatil-manzari wa su\'il-munqalabi fil-mali wal-ahli.';

  @override
  String get duaTravelMeaning =>
      'Glory is to the One who placed this at our service, though we could not have controlled it ourselves, and surely to our Lord we will return. O Allah, we ask You on this journey for righteousness, mindfulness of You, and deeds that please You. Make this journey easy for us and shorten its distance. You are our Companion on the journey and the Guardian of our family. I seek refuge in You from the hardship of travel, distressing sights, and an unhappy return to family and property.';

  @override
  String get duaTravelSource => 'Muslim, Hajj, 425';

  @override
  String get duaAfterPrayerDhikrTitle => 'Remembrance After Prayer';

  @override
  String get duaAfterPrayerDhikrWhen =>
      'After the obligatory prayer. This remembrance is recommended and is not part of the prayer itself.';

  @override
  String get duaAfterPrayerDhikrArabic =>
      'سُبْحَانَ اللَّهِ ×٣٣\nالْحَمْدُ لِلَّهِ ×٣٣\nاللَّهُ أَكْبَرُ ×٣٣\nلَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ';

  @override
  String get duaAfterPrayerDhikrTransliteration =>
      'Subhanallah ×33\nAlhamdulillah ×33\nAllahu Akbar ×33\nLa ilaha illallahu wahdahu la sharika lah, lahul-mulku wa lahul-hamdu wa huwa \'ala kulli shay\'in qadir.';

  @override
  String get duaAfterPrayerDhikrMeaning =>
      'Glory is to Allah ×33. All praise is for Allah ×33. Allah is the Greatest ×33. Then complete one hundred with: There is no deity except Allah alone, without partner. His is the dominion and His is all praise, and He has power over all things.';

  @override
  String get duaAfterPrayerDhikrSource => 'Muslim, Masajid, 146';

  @override
  String get menuWorshipRecords => 'Worship Records';

  @override
  String get ramadanTitle => 'Ramadan';

  @override
  String get ramadanIntro =>
      'A simple view of fasting times based on your current prayer location and calculation settings.';

  @override
  String get ramadanTodayTimes => 'Today\'s Fasting Times';

  @override
  String get ramadanImsak => 'Imsak';

  @override
  String get ramadanIftar => 'Iftar';

  @override
  String get ramadanUntilImsak => 'Until Imsak';

  @override
  String get ramadanUntilIftar => 'Until Iftar';

  @override
  String get ramadanUntilTomorrowImsak => 'Until Tomorrow\'s Imsak';

  @override
  String get ramadanIftarEntered => 'Iftar time has begun';

  @override
  String get ramadanTodayIftar => 'Today\'s Iftar';

  @override
  String get ramadanTomorrowImsak => 'Tomorrow\'s Imsak';

  @override
  String get ramadanTimesNote =>
      'Imsak and iftar times follow the prayer location and calculation method currently selected in IslamFull.';

  @override
  String get ramadanViewPrayerTimes => 'View Prayer Times';

  @override
  String get ramadanOutsideTitle => 'Ramadan is not currently in progress';

  @override
  String get ramadanOutsideDesc =>
      'The current Hijri date in your prayer schedule is outside Ramadan. You can still return to this page whenever you need it.';

  @override
  String get ramadanUnavailableTitle => 'Fasting times are not available yet';

  @override
  String get ramadanUnavailableDesc =>
      'Prayer or Hijri date information is not available yet. Refresh the prayer times and try again.';

  @override
  String get homeDailyVerseLoadFailed => 'The daily verse could not be loaded.';

  @override
  String get ramadanGuideSectionTitle => 'Ramadan Guide';

  @override
  String get ramadanGuideTitle => 'Ramadan Guide';

  @override
  String get ramadanGuideMenuDesc =>
      'Learn the essentials of fasting, sahur, iftar, Tarawih, fitra, Laylat al-Qadr and Eid.';

  @override
  String get ramadanGuideIntro =>
      'A concise reference for common Ramadan practices. Open a topic when you need it; the guide is for learning and reference, not for measuring worship.';

  @override
  String get ramadanGuideFastingTitle => 'Fasting in Ramadan';

  @override
  String get ramadanGuideFastingDesc =>
      'Fasting in Ramadan is obligatory for Muslims who meet the conditions of religious responsibility. The daily fast begins at imsak (true dawn) and continues until sunset. During this period, the fasting person abstains from eating, drinking and sexual relations with the intention of worship. Intention is a condition of the fast. Details concerning the timing of intention and valid exemptions can differ according to circumstances and schools of law.';

  @override
  String get ramadanGuideFastingSource =>
      'Source: Din İşleri Yüksek Kurulu — Orucun Mahiyeti, Farzları, Sünnetleri ve Adabı.';

  @override
  String get ramadanGuideSahurIftarTitle => 'Sahur and Iftar';

  @override
  String get ramadanGuideSahurIftarDesc =>
      'Sahur is the meal eaten before imsak. The Prophet encouraged Muslims to eat sahur, and delaying it without entering a doubtful time is regarded as recommended practice. Once sunset and the iftar time have certainly begun, unnecessarily delaying the breaking of the fast is not recommended. Iftar does not require a particular food; commonly mentioned foods such as dates or water are recommendations rather than conditions.';

  @override
  String get ramadanGuideSahurIftarSource =>
      'Source: Din İşleri Yüksek Kurulu — Sahur Yemeğinin Dindeki Önemi; Diyanet Oruç İlmihali.';

  @override
  String get ramadanGuideBreaksFastTitle => 'What Breaks the Fast?';

  @override
  String get ramadanGuideBreaksFastDesc =>
      'Intentionally eating, drinking or having sexual relations during the fasting period breaks the fast. Eating or drinking because one genuinely forgot that one was fasting does not break it; once remembered, the person stops and continues the fast. Medical treatments, medicines, injections, dental procedures and accidental swallowing can involve more detailed rulings. Do not rely on a short general list for an individual medical or legal case.';

  @override
  String get ramadanGuideBreaksFastSource =>
      'Source: Din İşleri Yüksek Kurulu — Orucu Bozan ve Bozmayan Haller.';

  @override
  String get ramadanGuideTarawihTitle => 'Tarawih Prayer';

  @override
  String get ramadanGuideTarawihDesc =>
      'Tarawih is a voluntary prayer associated with the nights of Ramadan. It is performed after the obligatory Isha prayer and may be prayed until the beginning of Fajr time. In the commonly taught Diyanet framework it is regarded as a strongly emphasised Sunnah for both women and men. It may be prayed individually or in congregation.';

  @override
  String get ramadanGuideTarawihSource =>
      'Source: Din İşleri Yüksek Kurulu — Teravih Namazının Hükmü ve Mahiyeti.';

  @override
  String get ramadanGuideFitraFidyaTitle => 'Fitra and Fidya';

  @override
  String get ramadanGuideFitraFidyaDesc =>
      'Fitra (sadaqat al-fitr) is a financial act of worship connected with reaching Eid al-Fitr and helping those in need. Fidya is different: in the fasting context it applies principally when a person cannot fast and also has no realistic ability to make up the missed fasts, such as permanent illness or advanced age. The monetary amount is determined according to current conditions and can change over time, so the current official amount should be checked rather than relying on an old figure.';

  @override
  String get ramadanGuideFitraFidyaSource =>
      'Source: Din İşleri Yüksek Kurulu — Fıtır Sadakası and Oruç Fidyesi guidance.';

  @override
  String get ramadanGuideLaylatQadrTitle => 'Laylat al-Qadr';

  @override
  String get ramadanGuideLaylatQadrDesc =>
      'Laylat al-Qadr is a night within Ramadan described in the Quran as better than a thousand months. The Prophet encouraged Muslims to seek it during the last ten nights of Ramadan, especially the odd-numbered nights. The 27th night is widely observed, but the guide does not present it as a date known with absolute certainty. Quran recitation, prayer, remembrance, repentance and supplication are appropriate ways to spend these nights.';

  @override
  String get ramadanGuideLaylatQadrSource =>
      'Source: Quran 97:1–5; Diyanet guidance on Laylat al-Qadr and the last ten nights of Ramadan.';

  @override
  String get ramadanGuideEidTitle => 'Eid al-Fitr';

  @override
  String get ramadanGuideEidDesc =>
      'Eid al-Fitr follows the completion of Ramadan. Eid prayer is performed in congregation; detailed legal classifications and some practices differ between schools of law. Fitra may be given before Eid and giving it before the Eid prayer is recommended so that those in need can share in the occasion.';

  @override
  String get ramadanGuideEidSource =>
      'Source: Din İşleri Yüksek Kurulu — Fıtır Sadakası and guidance on congregational Eid prayer.';

  @override
  String get ramadanGuideImportantNoteTitle =>
      'When personal guidance is needed';

  @override
  String get ramadanGuideImportantNote =>
      'Health conditions, pregnancy, breastfeeding, travel, medicines and medical procedures can require individual assessment. For a personal health decision, consult a qualified healthcare professional; for a detailed religious ruling, consult a reliable religious authority. Differences between schools of law may also affect some details.';

  @override
  String get ramadanGuideSourceNote =>
      'Primary religious reference: Presidency of Religious Affairs (Diyanet) and the High Board of Religious Affairs. This screen is a concise learning guide and does not replace an individual fatwa.';

  @override
  String get qurbanTitle => 'Qurban';

  @override
  String get qurbanIntro =>
      'Learn the essential guidance for the udhiyah offered during Eid al-Adha, including eligibility, animals, shares, timing, proxy arrangements and distribution.';

  @override
  String get qurbanScopeNote =>
      'This section focuses on udhiyah offered during Eid al-Adha. Hajj-related hady, vows and other types of sacrifice have separate rulings.';

  @override
  String get qurbanGuideTitle => 'Qurban Guide';

  @override
  String get qurbanGuideMenuDesc =>
      'Learn the essentials of udhiyah, eligible animals, shares, timing and proxy sacrifice.';

  @override
  String get qurbanGuideIntro =>
      'A concise guide to the shared fundamentals of udhiyah during Eid al-Adha. Detailed rulings can differ between schools of law and personal circumstances.';

  @override
  String get qurbanGuideTopicsTitle => 'Qurban Topics';

  @override
  String get qurbanGuideMeaningTitle => 'Meaning and Purpose';

  @override
  String get qurbanGuideMeaningDesc =>
      'Udhiyah is the sacrifice of an eligible animal during the specified days of Eid al-Adha as an act of worship seeking closeness to Allah. Its purpose is worship, gratitude and sharing rather than merely obtaining meat.';

  @override
  String get qurbanGuideResponsibilityTitle => 'Who Is Responsible?';

  @override
  String get qurbanGuideResponsibilityDesc =>
      'The legal ruling differs among schools of law. In the Hanafi school, an adult, sane and resident Muslim who owns nisab beyond basic needs and debts is responsible for udhiyah. Most other jurists regard it as an emphasized Sunnah for those who are able to offer it.';

  @override
  String get qurbanGuideAnimalsTitle => 'Eligible Animals and Ages';

  @override
  String get qurbanGuideAnimalsDesc =>
      'Udhiyah may be offered from sheep, goats, cattle, buffalo and camels. Based on lunar years, camels must normally be at least five years old, cattle and buffalo two, and sheep and goats one. A sheep that has completed six months may be eligible if it is as developed as a one-year-old sheep. The animal must also be healthy and free from defects that prevent its use for udhiyah.';

  @override
  String get qurbanGuideSharesTitle => 'Shares and Joint Qurban';

  @override
  String get qurbanGuideSharesDesc =>
      'A sheep or goat is offered for one person. Cattle, buffalo and camels may be shared by up to seven people, provided that each person\'s share is at least one seventh. The participants must join with an intention of worship.';

  @override
  String get qurbanGuideTimeTitle => 'Time of Sacrifice';

  @override
  String get qurbanGuideTimeDesc =>
      'In the common Hanafi guidance used by the Presidency of Religious Affairs, the time for udhiyah begins after the Eid prayer on the first day and continues until sunset on the third day. In the Shafii school it may continue until sunset on the fourth day.';

  @override
  String get qurbanGuideProxyTitle => 'Proxy and Donations';

  @override
  String get qurbanGuideProxyDesc =>
      'A person may appoint another person or an organisation to purchase, sacrifice and distribute the animal on their behalf when the required proxy is given. Donating money without an eligible animal actually being sacrificed does not itself fulfil the udhiyah.';

  @override
  String get qurbanGuideMeatTitle => 'Meat and Distribution';

  @override
  String get qurbanGuideMeatDesc =>
      'Sharing the meat between one\'s household, relatives or neighbours and people in need is recommended. Detailed distribution rules differ between schools of law. Meat, skin or other parts of the animal should not be used as payment for the slaughtering service.';

  @override
  String get qurbanGuideMisconceptionsTitle => 'Common Misconceptions';

  @override
  String get qurbanGuideMisconceptionsDesc =>
      'Being unmarried does not prevent an eligible person from offering udhiyah. Shares in a large animal do not have to total an odd number such as three, five or seven. When an animal\'s age is reliably known, changing its front teeth is not an additional requirement.';

  @override
  String get qurbanGuideSchoolNote =>
      'This guide provides shared fundamentals and brief orientation. Detailed rulings can vary by school of law, type of sacrifice and individual circumstances.';

  @override
  String get qurbanGuideSourceNote =>
      'Religious guidance is based primarily on information published by the Presidency of Religious Affairs and the High Board of Religious Affairs.';

  @override
  String qurbanSeasonDhulHijjahDayTitle(int day) {
    return 'Dhul Hijjah · Day $day';
  }

  @override
  String get qurbanSeasonDhulHijjahDesc =>
      'The current religious date is within the first eight days of Dhul Hijjah. Arafah is the 9th of Dhul Hijjah and Eid al-Adha begins on the 10th.';

  @override
  String get qurbanSeasonArafahTitle => 'Day of Arafah';

  @override
  String get qurbanSeasonArafahDesc =>
      'Today is 9 Dhul Hijjah. Eid al-Adha begins on 10 Dhul Hijjah.';

  @override
  String qurbanSeasonEidDayTitle(int day) {
    return 'Eid al-Adha · Day $day';
  }

  @override
  String get qurbanSeasonEidDesc =>
      'The current religious date is within 10–13 Dhul Hijjah, the days of Eid al-Adha.';

  @override
  String get qurbanGuidesTitle => 'Qurban & Eid Guidance';

  @override
  String get qurbanEidGuideTitle => 'Dhul Hijjah & Eid al-Adha Guide';

  @override
  String get qurbanEidGuideMenuDesc =>
      'Learn about the first days of Dhul Hijjah, Arafah, Eid prayer and the Takbirs of Tashriq.';

  @override
  String get qurbanEidGuideIntro =>
      'A concise guide to the days surrounding Eid al-Adha. Worship details that differ between schools of law are identified rather than presented as a single universal practice.';

  @override
  String get qurbanEidGuideTopicsTitle => 'Dhul Hijjah & Eid';

  @override
  String get qurbanEidFirstDaysTitle => 'The First Days of Dhul Hijjah';

  @override
  String get qurbanEidFirstDaysDesc =>
      'The first ten days of Dhul Hijjah are regarded as especially virtuous for righteous deeds. Fasting during the first nine days is considered recommended; a person may fast all of them or some of them. The 10th of Dhul Hijjah is the first day of Eid al-Adha and is not a fasting day.';

  @override
  String get qurbanEidArafahTitle => 'Day of Arafah';

  @override
  String get qurbanEidArafahDesc =>
      'Arafah is the 9th of Dhul Hijjah. Fasting on this day is especially encouraged for those who are not performing Hajj. For pilgrims standing at Arafat, not fasting is regarded as more appropriate so that the rites of Hajj can be performed with strength.';

  @override
  String get qurbanEidDaysTitle => 'Days of Eid al-Adha';

  @override
  String get qurbanEidDaysDesc =>
      'Eid al-Adha covers 10–13 Dhul Hijjah. These are days of worship, remembrance, family ties and sharing. Fasting is not observed during the days of Eid al-Adha.';

  @override
  String get qurbanEidPrayerTitle => 'Eid Prayer';

  @override
  String get qurbanEidPrayerDesc =>
      'Eid prayer consists of two rakahs and is performed without adhan or iqamah; the Eid sermon follows the prayer. In the Hanafi school it is wajib for those who meet its conditions and is performed in congregation. The common Hanafi method includes three additional takbirs in each rakah. Other schools differ in the ruling, number and placement of the additional takbirs; for example, the Shafii school regards the prayer as an emphasized Sunnah.';

  @override
  String get qurbanEidTashriqTitle => 'Takbirs of Tashriq';

  @override
  String get qurbanEidTashriqDesc =>
      'According to the preferred Hanafi view, the Takbir of Tashriq is recited once after each obligatory prayer from Fajr on the Day of Arafah through Asr on the fourth day of Eid, inclusive: 23 obligatory prayer times. This applies to men and women. In the Shafii school the practice is regarded as Sunnah.';

  @override
  String get qurbanEidTashriqTextTitle => 'Takbir of Tashriq';

  @override
  String get qurbanEidTashriqText =>
      'Allahu akbar, Allahu akbar. La ilaha illallahu wallahu akbar. Allahu akbar wa lillahil hamd.';

  @override
  String get qurbanEidSchoolNote =>
      'This guide gives a concise orientation. Eid prayer, additional takbirs and related rulings have differences between schools of law. Follow the practice of your congregation or seek qualified religious guidance when detailed application matters.';

  @override
  String get hajjHubIntro =>
      'Learn the shared foundations of Hajj and the basic sequence of Umrah. Detailed rulings can differ by school of law, type of Hajj and individual circumstances.';

  @override
  String get hajjLearnTitle => 'Hajj & Umrah Guidance';

  @override
  String get hajjOfficialInfoTitle => 'Official Information';

  @override
  String get hajjOfficialLinkError =>
      'The official Hajj and Umrah page could not be opened.';

  @override
  String get hajjFundamentalsTitle => 'Hajj Fundamentals';

  @override
  String get hajjFundamentalsMenuDesc =>
      'Learn the essential concepts of ihram, tawaf, sa\'y, Arafat, Muzdalifah and Mina.';

  @override
  String get hajjFundamentalsIntro =>
      'This guide introduces the main places and acts encountered during Hajj. It is an orientation guide rather than a personalised ruling or a complete day-by-day Hajj programme.';

  @override
  String get hajjFundamentalsTopicsTitle => 'Essential Concepts';

  @override
  String get hajjFundamentalsMeaningTitle => 'Meaning and Obligation of Hajj';

  @override
  String get hajjFundamentalsMeaningDesc =>
      'Hajj is one of the five pillars of Islam and is required once in a lifetime from a Muslim who meets the religious conditions of ability. Its rites are performed in and around Makkah during the prescribed Hajj period.';

  @override
  String get hajjFundamentalsIhramTitle => 'Ihram and Miqat';

  @override
  String get hajjFundamentalsIhramDesc =>
      'Ihram is the state in which a person enters Hajj or Umrah by intention. Those travelling for Hajj or Umrah from outside the miqat boundaries enter ihram before crossing the relevant miqat. In Hanafi teaching, intention and talbiyah together form ihram; other schools differ in the legal status of the talbiyah.';

  @override
  String get hajjFundamentalsTawafTitle => 'Tawaf';

  @override
  String get hajjFundamentalsTawafDesc =>
      'Tawaf consists of seven circuits around the Ka\'bah, beginning from the line of the Black Stone with the Ka\'bah kept to the left. Hajj contains different types of tawaf; the visitation or ifadah tawaf is a pillar of Hajj.';

  @override
  String get hajjFundamentalsSayTitle => 'Sa\'y';

  @override
  String get hajjFundamentalsSayDesc =>
      'Sa\'y is performed between Safa and Marwah in seven traversals, beginning at Safa and ending at Marwah. Its detailed legal classification and some conditions differ between schools of law.';

  @override
  String get hajjFundamentalsArafatTitle => 'Arafat';

  @override
  String get hajjFundamentalsArafatDesc =>
      'Standing at Arafat within its valid time is a pillar of Hajj. Missing the valid Arafat standing means that the Hajj cannot be completed for that year.';

  @override
  String get hajjFundamentalsMuzdalifahTitle => 'Muzdalifah';

  @override
  String get hajjFundamentalsMuzdalifahDesc =>
      'After Arafat, pilgrims proceed to Muzdalifah as part of the Hajj rites. The legal ruling and precise valid period for the Muzdalifah standing contain differences between schools of law, especially regarding the minimum time required.';

  @override
  String get hajjFundamentalsMinaTitle => 'Mina and the Jamarat';

  @override
  String get hajjFundamentalsMinaDesc =>
      'Mina is central to several rites of the Hajj days, including the stoning of the Jamarat. The timing, order and detailed rulings of these rites depend on the day, type of Hajj and school of law.';

  @override
  String get hajjFundamentalsReleaseTitle => 'Haircut and Leaving Ihram';

  @override
  String get hajjFundamentalsReleaseDesc =>
      'At the appropriate stage of Hajj, shaving or shortening the hair forms part of leaving the restrictions of ihram. The exact sequence with sacrifice, stoning and tawaf, and the legal consequences of changing that sequence, differ in detail between schools of law.';

  @override
  String get hajjFundamentalsSchoolNote =>
      'This screen introduces shared Hajj concepts. The exact sequence and legal details vary according to the type of Hajj, school of law and personal circumstances. A day-by-day guide and the types of Hajj are handled separately.';

  @override
  String get hajjUmrahSourceNote =>
      'Religious guidance is based primarily on information published by the Presidency of Religious Affairs and the High Board of Religious Affairs.';

  @override
  String get umrahGuideTitle => 'Umrah Guide';

  @override
  String get umrahGuideMenuDesc =>
      'Learn the basic sequence of ihram, tawaf, sa\'y and leaving ihram.';

  @override
  String get umrahGuideIntro =>
      'Umrah is performed through a concise sequence centred on ihram, tawaf, sa\'y and leaving ihram. This guide explains that shared basic flow without treating school-specific details as universal.';

  @override
  String get umrahGuideStepsTitle => 'Basic Umrah Sequence';

  @override
  String get umrahGuideStep1Title => '1. Enter Ihram';

  @override
  String get umrahGuideStep1Desc =>
      'Enter ihram for Umrah before crossing the relevant miqat. Ihram is a state of worship entered by intention, not merely the wearing of ihram clothing. Details concerning talbiyah and some ihram rules differ between schools of law.';

  @override
  String get umrahGuideStep2Title => '2. Perform Tawaf';

  @override
  String get umrahGuideStep2Desc =>
      'Perform the Umrah tawaf around the Ka\'bah in seven circuits. Tawaf is an essential part of Umrah according to all schools of law.';

  @override
  String get umrahGuideStep3Title => '3. Perform Sa\'y';

  @override
  String get umrahGuideStep3Desc =>
      'Perform seven traversals between Safa and Marwah: four journeys from Safa to Marwah and three from Marwah to Safa, finishing at Marwah. The detailed legal classification of sa\'y differs between schools of law.';

  @override
  String get umrahGuideStep4Title => '4. Cut the Hair and Leave Ihram';

  @override
  String get umrahGuideStep4Desc =>
      'After completing the Umrah rites, the hair is shaved or shortened as applicable and the person leaves the state of ihram. The amount and detailed rules differ according to circumstances and school of law.';

  @override
  String get umrahGuideSchoolNote =>
      'This is a basic learning sequence, not an individual fatwa. Questions involving missed rites, illness, menstruation, miqat mistakes, penalties or other exceptional circumstances require more specific guidance.';

  @override
  String get hajjTypesTitle => 'Types of Hajj';

  @override
  String get hajjTypesMenuDesc =>
      'Compare Ifrad, Tamattu and Qiran and understand their basic differences.';

  @override
  String get hajjTypesIntro =>
      'Hajj can be performed as Ifrad, Tamattu or Qiran. The main differences concern whether Umrah is combined with Hajj, whether ihram is exited between them, and whether a thanksgiving sacrifice is required.';

  @override
  String get hajjTypesThreeTitle => 'The Three Types';

  @override
  String get hajjTypeIfradTitle => 'Ifrad';

  @override
  String get hajjTypeIfradDesc =>
      'Ifrad is Hajj performed without performing Umrah as part of the same Hajj season. The pilgrim enters ihram with the intention of Hajj and remains in ihram through the relevant Hajj rites. A thanksgiving sacrifice is not required merely because the Hajj is Ifrad.';

  @override
  String get hajjTypeTamattuTitle => 'Tamattu';

  @override
  String get hajjTypeTamattuDesc =>
      'In Tamattu, the pilgrim first enters ihram for Umrah during the Hajj season, completes Umrah and leaves ihram. Before Arafat, the pilgrim enters ihram again for Hajj. A thanksgiving sacrifice is required for Tamattu according to the applicable rules.';

  @override
  String get hajjTypeQiranTitle => 'Qiran';

  @override
  String get hajjTypeQiranDesc =>
      'In Qiran, Hajj and Umrah are intended together and performed within one continuous state of ihram. After completing the Umrah rites, the pilgrim does not leave ihram before continuing with Hajj. A thanksgiving sacrifice is required for Qiran according to the applicable rules.';

  @override
  String get hajjTypesNote =>
      'The three types share the central rites of Hajj but differ in intention, ihram and the relationship between Hajj and Umrah. Changing from one type to another and exceptional situations have detailed school-specific rulings; follow qualified guidance for your actual Hajj.';

  @override
  String get hajjDaysTitle => 'Hajj Days';

  @override
  String get hajjDaysMenuDesc =>
      'Follow a concise overview of the main rites from 8 through 13 Dhul Hijjah.';

  @override
  String get hajjDaysIntro =>
      'This screen gives a learning overview of the main Hajj days. It is not a live itinerary: exact movement times, concessions and the order of some rites can differ by school of law, Hajj type, health, crowd conditions and official organisation instructions.';

  @override
  String get hajjDaysFlowTitle => 'Main Hajj Flow';

  @override
  String get hajjDay8Title => '8 Dhul Hijjah · Tarwiyah';

  @override
  String get hajjDay8Desc =>
      'Those performing Tamattu enter ihram again for Hajj on this day or earlier if they have not already done so. In the established Hajj sequence, pilgrims prepare for the days of Hajj and proceed toward Mina before Arafat.';

  @override
  String get hajjDay9Title => '9 Dhul Hijjah · Arafah';

  @override
  String get hajjDay9Desc =>
      'The standing at Arafat is a pillar of Hajj and must occur within its valid period. After Arafat, pilgrims proceed to Muzdalifah, where the Muzdalifah standing forms part of the Hajj rites. Detailed timing rules differ between schools of law.';

  @override
  String get hajjDay10Title => '10 Dhul Hijjah · First Day of Eid';

  @override
  String get hajjDay10Desc =>
      'The common sequence includes stoning the Aqabah Jamarah, the thanksgiving sacrifice for those performing Tamattu or Qiran, shaving or shortening the hair and the visitation tawaf. The legal status of this order differs between schools of law; the current Presidency of Religious Affairs fatwa and practice allow flexibility in the sequence without treating every change of order as requiring a penalty.';

  @override
  String get hajjDays11And12Title => '11–12 Dhul Hijjah · Days of Tashriq';

  @override
  String get hajjDays11And12Desc =>
      'These are Mina and Jamarat days. The three Jamarat are stoned as part of the Hajj rites. Detailed valid times and concessions can differ, especially in cases involving crowding, illness or inability.';

  @override
  String get hajjDay13Title => '13 Dhul Hijjah · Final Tashriq Day';

  @override
  String get hajjDay13Desc =>
      'Some pilgrims will have completed their Mina duties earlier, while those remaining in Mina can have further Jamarat duties on the fourth day of Eid. The point at which this duty applies differs between schools of law, so this screen does not make an automatic personal ruling.';

  @override
  String get hajjDaysNote =>
      'Treat this as an educational map, not as a substitute for your group leader, current official Hajj instructions or qualified religious guidance. In particular, timing, crowd-management concessions and penalties require situation-specific assessment.';

  @override
  String get ihramRulesTitle => 'Ihram Rules';

  @override
  String get ihramRulesMenuDesc =>
      'Learn what Ihram means and the main restrictions observed during Ihram.';

  @override
  String get ihramRulesIntro =>
      'Ihram is a state of worship entered for Hajj or Umrah, not simply a set of clothes. While in Ihram, some actions that are normally permitted become restricted. The consequences of a violation can differ according to the action, circumstances and school of law.';

  @override
  String get ihramRulesTopicsTitle => 'While in Ihram';

  @override
  String get ihramRulesMeaningTitle => 'Ihram Is a State of Worship';

  @override
  String get ihramRulesMeaningDesc =>
      'Ihram begins through the religious intention for Hajj or Umrah. In Hanafi teaching, intention and talbiyah together are integral to entering Ihram; other schools differ regarding the legal status of the talbiyah. Wearing Ihram clothing alone does not by itself explain the whole religious state.';

  @override
  String get ihramRulesClothingTitle => 'Clothing';

  @override
  String get ihramRulesClothingDesc =>
      'Clothing restrictions differ between men and women. Men in Ihram leave ordinary fitted clothing and use the customary izar and rida coverings. Women do not have a special two-piece Ihram garment and continue to observe their normal modest clothing requirements. Detailed cases involving coverings, medical supports or exceptional needs should be assessed separately.';

  @override
  String get ihramRulesHairNailsTitle => 'Hair and Nails';

  @override
  String get ihramRulesHairNailsDesc =>
      'Deliberately cutting or removing hair and cutting the nails are among the actions restricted during Ihram. Accidental breakage, medical necessity and the amount involved can affect the ruling, so this app does not calculate a penalty automatically.';

  @override
  String get ihramRulesFragranceTitle => 'Fragrance and Grooming';

  @override
  String get ihramRulesFragranceDesc =>
      'Using fragrance for the purpose of perfuming oneself is restricted during Ihram. Grooming products applied for adornment can also involve Ihram rulings. Medicines, ointments and treatments used for genuine medical purposes are assessed differently.';

  @override
  String get ihramRulesCleanlinessTitle => 'Bathing and Cleanliness';

  @override
  String get ihramRulesCleanlinessDesc =>
      'Being in Ihram does not prevent bathing or performing ghusl. Unscented cleaning products are a simple precaution. The Presidency of Religious Affairs also distinguishes ordinary cleaning from deliberately applying fragrance.';

  @override
  String get ihramRulesIntimacyTitle => 'Marital Intimacy';

  @override
  String get ihramRulesIntimacyDesc =>
      'Sexual intercourse is among the serious restrictions associated with Ihram. During Hajj, some related restrictions can continue beyond the first release from Ihram until the required visitation tawaf is performed. Questions involving an actual incident require individual religious guidance.';

  @override
  String get ihramRulesPenaltyNote =>
      'Do not use this screen to determine your own penalty. The result of an Ihram violation can depend on the act, amount, duration, intention or forgetfulness, necessity, type of Hajj and school of law.';

  @override
  String get hajjSpecialCasesTitle => 'Common Hajj & Umrah Situations';

  @override
  String get hajjSpecialCasesMenuDesc =>
      'Review common mistakes and situations that require more specific guidance.';

  @override
  String get hajjSpecialCasesIntro =>
      'Some Hajj and Umrah questions cannot be answered safely with a single rule. This guide highlights common situations and explains when a person should stop relying on a general checklist and seek situation-specific guidance.';

  @override
  String get hajjSpecialCasesTopicsTitle => 'Common Situations';

  @override
  String get hajjSpecialMiqatTitle => 'Crossing the Miqat Without Ihram';

  @override
  String get hajjSpecialMiqatDesc =>
      'If a person intending Hajj or Umrah crosses the relevant miqat without entering Ihram, the next step depends on what has happened since then. Returning to a valid miqat before beginning the rites can affect the ruling. Do not guess a penalty from the app; seek guidance before continuing where possible.';

  @override
  String get hajjSpecialMenstruationTitle =>
      'Menstruation or Postpartum Bleeding';

  @override
  String get hajjSpecialMenstruationDesc =>
      'Menstruation or postpartum bleeding does not prevent a woman from entering Ihram. Tawaf, however, has separate purity rulings, and the legal consequences differ between schools of law and according to the circumstances. Follow qualified guidance rather than treating the entire Hajj or Umrah as cancelled.';

  @override
  String get hajjSpecialForgottenViolationTitle =>
      'A Restriction Was Broken by Mistake';

  @override
  String get hajjSpecialForgottenViolationDesc =>
      'Forgetfulness or not knowing the rule does not have one universal consequence. Hanafi, Maliki, Shafii and Hanbali rulings differ, and some schools distinguish between types of restrictions. Record what happened and seek qualified guidance rather than assuming either that nothing is required or that a penalty is definitely due.';

  @override
  String get hajjSpecialMedicalNeedTitle => 'Illness or Medical Need';

  @override
  String get hajjSpecialMedicalNeedDesc =>
      'Medical treatment should not be abandoned merely because a person is in Ihram. Medicines and treatment creams are treated differently from products used for adornment. If treatment requires an action that is normally restricted, the person should receive the needed care and then ask about any religious consequence separately.';

  @override
  String get hajjSpecialCrowdingTitle => 'Crowding, Age or Physical Difficulty';

  @override
  String get hajjSpecialCrowdingDesc =>
      'Hajj rulings include concessions for genuine difficulty. For example, current Presidency of Religious Affairs guidance allows the visitation tawaf to be delayed because of severe crowding, old age or illness without automatically requiring a penalty. Follow official organisation instructions and qualified religious guidance for the actual situation.';

  @override
  String get hajjSpecialEarlyHaircutTitle => 'Hair Was Cut Too Early';

  @override
  String get hajjSpecialEarlyHaircutDesc =>
      'Cutting the hair does not always mean that a person has validly completed Hajj or Umrah or left Ihram. The result depends on which rites had already been completed and on the school of law. Do not simply continue as though the rites are finished; ask for situation-specific guidance.';

  @override
  String get hajjSpecialCasesNote =>
      'This guide intentionally avoids assigning penalties. When a rite was missed, performed in the wrong order or affected by illness, menstruation, crowding or an Ihram violation, use current official guidance and a qualified religious adviser who can evaluate the complete situation.';

  @override
  String get manualLocationTitle => 'Set location manually';

  @override
  String get manualLocationDescription =>
      'Enter latitude and longitude from a trusted map when your device cannot provide a precise location.';

  @override
  String get manualLocationButton => 'Enter coordinates manually';

  @override
  String get manualLatitudeLabel => 'Latitude';

  @override
  String get manualLongitudeLabel => 'Longitude';

  @override
  String get manualCoordinateRequired => 'Enter a valid number.';

  @override
  String get manualLatitudeRange => 'Latitude must be between -90 and 90.';

  @override
  String get manualLongitudeRange => 'Longitude must be between -180 and 180.';

  @override
  String get manualLocationSave => 'Use this location';

  @override
  String get manualLocationSaveFailed =>
      'This location could not be saved. Check the coordinates and try again.';

  @override
  String get locationAccuracyInsufficientMessage =>
      'Your device location is too approximate for reliable prayer times. Try again or enter coordinates manually.';

  @override
  String get locationServiceDisabledMessage =>
      'Location services are disabled on this device.';

  @override
  String get locationPermissionDeniedMessage =>
      'Location permission was denied. You can allow location access or enter coordinates manually.';

  @override
  String get locationPermissionDeniedForeverMessage =>
      'Location access is blocked in system or browser settings. Change the permission there or enter coordinates manually.';

  @override
  String get locationTimeoutMessage =>
      'A precise location could not be obtained in time. Try again or enter coordinates manually.';

  @override
  String get locationInvalidCoordinatesMessage =>
      'The location coordinates are invalid.';

  @override
  String get locationTimezoneErrorMessage =>
      'The timezone for this location could not be determined.';

  @override
  String get locationSaveFailedMessage =>
      'The selected location could not be saved.';

  @override
  String get prayerLocationUnavailableMessage =>
      'A location is required before prayer times can be calculated. Refresh the device location or enter coordinates manually.';
}
