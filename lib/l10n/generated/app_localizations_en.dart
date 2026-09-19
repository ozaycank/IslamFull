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
  String get zakatReceivablesLabel => 'Receivables (Guaranteed)';

  @override
  String get zakatDebtsGroup => 'Deductions';

  @override
  String get zakatDebtsLabel => 'Debts & Basic Needs';

  @override
  String get zakatCalculateButton => 'Calculate Zakat';

  @override
  String get zakatResultTitle => 'Calculation Result';

  @override
  String get zakatTotalWealth => 'Total Net Wealth:';

  @override
  String get zakatNisabAmount => 'Nisab Threshold (80.18 gr):';

  @override
  String get zakatRequiredAmount => 'Required Zakat Amount:';

  @override
  String get zakatNotRequired =>
      'Your net wealth is below the Nisab threshold. Zakat is not obligatory.';

  @override
  String get zakatDiyanetNote =>
      'Note: This calculation uses the 80.18 grams of gold Nisab threshold according to the Presidency of Religious Affairs of Turkey. Your primary residence and personal vehicle are exempt. Please consult official sources for detailed jurisprudence.';

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
      'Wet your hands and wipe at least a quarter of your head.';

  @override
  String get wuduStep8Title => '8. Wipe Ears and Neck';

  @override
  String get wuduStep8Desc =>
      'Wipe the inside of the ears with index fingers, behind the ears with thumbs, and the neck with the back of the hands.';

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
}
