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
  String get menuHajjGuide => 'Hajj Guide';

  @override
  String get menuZakatCalc => 'Zakat Calculator';

  @override
  String get menuAppGroup => 'Application';

  @override
  String get menuAbout => 'About';

  @override
  String get menuPrivacy => 'Privacy Policy';

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
  String get hajjTitle => 'Hajj Guide';

  @override
  String get hajjDiyanetInfo =>
      'Hajj is one of the five pillars of Islam. In Turkey, Hajj registration and lottery processes are managed directly by the Presidency of Religious Affairs (Diyanet).';

  @override
  String get hajjOfficialLinkButton => 'Official Diyanet Hajj Page';

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
      '1. Data Privacy and Security\nIslamFull places the highest priority on user privacy. All your worship history, dhikr, Quran reading progress, and bookmarks are stored entirely encrypted on your device\'s local storage (offline).\n\n2. Data Sharing\nYour personal data or usage habits are never transmitted to external servers, shared with third-party companies, or sold.\n\n3. Location Usage\nYour device\'s location is used momentarily to calculate precise prayer times and the Qibla direction. This data is only processed locally during the calculation and is not logged on remote servers.\n\n4. External Links\nModules such as the Hajj Guide may contain external links to official institutions. The privacy policies of these sites are not under our responsibility.\n\nYou can use IslamFull safely and peacefully.';

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
}
