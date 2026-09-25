import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr')
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'IslamFull'**
  String get appTitle;

  /// Splash loading text
  ///
  /// In en, this message translates to:
  /// **'Loading application...'**
  String get splashLoading;

  /// General error message
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get generalError;

  /// Bottom navigation Home label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// Bottom navigation Prayer label
  ///
  /// In en, this message translates to:
  /// **'Prayer'**
  String get navPrayer;

  /// Bottom navigation Quran label
  ///
  /// In en, this message translates to:
  /// **'Quran'**
  String get navQuran;

  /// Bottom navigation Activity label
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get navActivity;

  /// Bottom navigation Profile label
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// Home placeholder page title
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// Home placeholder page description
  ///
  /// In en, this message translates to:
  /// **'Welcome to IslamFull. Your daily spiritual overview will appear here.'**
  String get homeDesc;

  /// Prayer placeholder page title
  ///
  /// In en, this message translates to:
  /// **'Prayer Times'**
  String get prayerTitle;

  /// Prayer placeholder page description
  ///
  /// In en, this message translates to:
  /// **'Accurate prayer times and qibla direction will be displayed here.'**
  String get prayerDesc;

  /// Quran placeholder page title
  ///
  /// In en, this message translates to:
  /// **'Al-Quran'**
  String get quranTitle;

  /// Quran placeholder page description
  ///
  /// In en, this message translates to:
  /// **'Holy Quran reading, audio recitations, and bookmarks will be available here.'**
  String get quranDesc;

  /// Activity placeholder page description
  ///
  /// In en, this message translates to:
  /// **'Track your daily prayers, dhikr, and fasting progress here.'**
  String get activityDesc;

  /// Profile placeholder page title
  ///
  /// In en, this message translates to:
  /// **'User Profile'**
  String get profileTitle;

  /// Profile placeholder page description
  ///
  /// In en, this message translates to:
  /// **'Manage your Islamic lifestyle, preferences, and personal statistics all in one place.'**
  String get profileDesc;

  /// Settings placeholder page title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Settings placeholder page description
  ///
  /// In en, this message translates to:
  /// **'Configure notifications, calculation methods, and app themes.'**
  String get settingsDesc;

  /// Open settings button label
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettingsButton;

  /// Default empty state title
  ///
  /// In en, this message translates to:
  /// **'No Content Available'**
  String get emptyStateDefaultTitle;

  /// Default empty state description
  ///
  /// In en, this message translates to:
  /// **'This module is currently under development for a future phase.'**
  String get emptyStateDefaultDesc;

  /// Default error state title
  ///
  /// In en, this message translates to:
  /// **'Something Went Wrong'**
  String get errorStateDefaultTitle;

  /// Retry button label
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryButton;

  /// Fajr prayer name
  ///
  /// In en, this message translates to:
  /// **'Fajr'**
  String get prayerFajr;

  /// Sunrise time
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get prayerSunrise;

  /// Dhuhr prayer name
  ///
  /// In en, this message translates to:
  /// **'Dhuhr'**
  String get prayerDhuhr;

  /// Asr prayer name
  ///
  /// In en, this message translates to:
  /// **'Asr'**
  String get prayerAsr;

  /// Maghrib prayer name
  ///
  /// In en, this message translates to:
  /// **'Maghrib'**
  String get prayerMaghrib;

  /// Isha prayer name
  ///
  /// In en, this message translates to:
  /// **'Isha'**
  String get prayerIsha;

  /// Next prayer label
  ///
  /// In en, this message translates to:
  /// **'Next Prayer'**
  String get prayerNextPrayer;

  /// Remaining time label
  ///
  /// In en, this message translates to:
  /// **'Remaining Time'**
  String get prayerRemainingTime;

  /// Calculation method setting label
  ///
  /// In en, this message translates to:
  /// **'Calculation Method'**
  String get prayerCalculationMethod;

  /// Madhab setting label
  ///
  /// In en, this message translates to:
  /// **'Madhab / Juristic Method'**
  String get prayerMadhab;

  /// Prayer location header
  ///
  /// In en, this message translates to:
  /// **'Prayer Location'**
  String get prayerLocationHeader;

  /// Refresh times button
  ///
  /// In en, this message translates to:
  /// **'Refresh Times'**
  String get prayerRefreshButton;

  /// Prayer settings screen title
  ///
  /// In en, this message translates to:
  /// **'Prayer Settings'**
  String get prayerSettingsTitle;

  /// Prayer settings screen description
  ///
  /// In en, this message translates to:
  /// **'Adjust your calculation methods and juristic preferences.'**
  String get prayerSettingsDesc;

  /// Location settings section title
  ///
  /// In en, this message translates to:
  /// **'Location Settings'**
  String get locationTitle;

  /// Fallback city name
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get currentLocation;

  /// Refresh location button text
  ///
  /// In en, this message translates to:
  /// **'Refresh Location'**
  String get refreshLocation;

  /// Location missing fallback
  ///
  /// In en, this message translates to:
  /// **'Location Unavailable'**
  String get locationUnavailable;

  /// Location permission denied error
  ///
  /// In en, this message translates to:
  /// **'Location permission is required.'**
  String get locationPermissionDenied;

  /// Location service disabled error
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled.'**
  String get locationServiceDisabled;

  /// Geocoding failure message
  ///
  /// In en, this message translates to:
  /// **'Failed to resolve address.'**
  String get locationGeocodingFailed;

  /// Timezone display label
  ///
  /// In en, this message translates to:
  /// **'Timezone'**
  String get timezoneLabel;

  /// Coordinates display label
  ///
  /// In en, this message translates to:
  /// **'Coordinates'**
  String get coordinatesLabel;

  /// Unknown country fallback
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknownCountry;

  /// Prayer calculation title
  ///
  /// In en, this message translates to:
  /// **'Prayer Calculation'**
  String get prayerCalculationTitle;

  /// Calculation method label
  ///
  /// In en, this message translates to:
  /// **'Calculation Method'**
  String get calculationMethodLabel;

  /// Madhab label
  ///
  /// In en, this message translates to:
  /// **'Madhab / Juristic Method'**
  String get madhabLabel;

  /// High latitude strategy label
  ///
  /// In en, this message translates to:
  /// **'High Latitude Strategy'**
  String get highLatitudeStrategyLabel;

  /// Calculation method saved message
  ///
  /// In en, this message translates to:
  /// **'Settings saved successfully.'**
  String get calculationMethodSaved;

  /// Settings save failed message
  ///
  /// In en, this message translates to:
  /// **'Failed to save settings.'**
  String get settingsSaveFailed;

  /// Angle based label
  ///
  /// In en, this message translates to:
  /// **'Angle Based'**
  String get angleBasedLabel;

  /// One seventh label
  ///
  /// In en, this message translates to:
  /// **'One Seventh'**
  String get oneSeventhLabel;

  /// Middle of the night label
  ///
  /// In en, this message translates to:
  /// **'Middle of the Night'**
  String get nightMiddleLabel;

  /// None label
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get noneLabel;

  /// Qibla direction title
  ///
  /// In en, this message translates to:
  /// **'Qibla Direction'**
  String get qiblaTitle;

  /// Qibla direction label
  ///
  /// In en, this message translates to:
  /// **'Direction'**
  String get qiblaDirection;

  /// Qibla bearing label
  ///
  /// In en, this message translates to:
  /// **'Bearing'**
  String get qiblaBearing;

  /// Qibla location label
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get qiblaLocation;

  /// Qibla unavailable message
  ///
  /// In en, this message translates to:
  /// **'Qibla calculation unavailable. Please ensure your location is set.'**
  String get qiblaUnavailable;

  /// Qibla calculation error message
  ///
  /// In en, this message translates to:
  /// **'Failed to calculate Qibla direction.'**
  String get qiblaCalculationError;

  /// North direction
  ///
  /// In en, this message translates to:
  /// **'N'**
  String get dirNorth;

  /// North east direction
  ///
  /// In en, this message translates to:
  /// **'NE'**
  String get dirNorthEast;

  /// East direction
  ///
  /// In en, this message translates to:
  /// **'E'**
  String get dirEast;

  /// South east direction
  ///
  /// In en, this message translates to:
  /// **'SE'**
  String get dirSouthEast;

  /// South direction
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get dirSouth;

  /// South west direction
  ///
  /// In en, this message translates to:
  /// **'SW'**
  String get dirSouthWest;

  /// West direction
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get dirWest;

  /// North west direction
  ///
  /// In en, this message translates to:
  /// **'NW'**
  String get dirNorthWest;

  /// Qibla disclaimer text
  ///
  /// In en, this message translates to:
  /// **'Calculated from your current location. Turn-by-turn compass guidance is not enabled yet.'**
  String get qiblaDisclaimer;

  /// Qibla undefined at Kaaba message
  ///
  /// In en, this message translates to:
  /// **'You are at the Kaaba. Qibla direction is undefined.'**
  String get qiblaUndefinedAtKaaba;

  /// Qibla compass title
  ///
  /// In en, this message translates to:
  /// **'Qibla Compass'**
  String get qiblaCompass;

  /// Qibla heading label
  ///
  /// In en, this message translates to:
  /// **'Device Heading'**
  String get qiblaHeading;

  /// Qibla relative angle label
  ///
  /// In en, this message translates to:
  /// **'Relative Angle'**
  String get qiblaRelativeAngle;

  /// Turn left degrees
  ///
  /// In en, this message translates to:
  /// **'Turn left {degrees}°'**
  String turnLeft(String degrees);

  /// Turn right degrees
  ///
  /// In en, this message translates to:
  /// **'Turn right {degrees}°'**
  String turnRight(String degrees);

  /// Qibla aligned message
  ///
  /// In en, this message translates to:
  /// **'Aligned with Qibla'**
  String get qiblaAligned;

  /// Compass unavailable title
  ///
  /// In en, this message translates to:
  /// **'Compass Unavailable'**
  String get compassUnavailable;

  /// Compass sensor unavailable message
  ///
  /// In en, this message translates to:
  /// **'Your device does not have a compass sensor.'**
  String get compassSensorUnavailable;

  /// Compass unsupported platform message
  ///
  /// In en, this message translates to:
  /// **'Compass is not supported on this platform.'**
  String get compassUnsupportedPlatform;

  /// Compass error message
  ///
  /// In en, this message translates to:
  /// **'Failed to read compass sensor.'**
  String get compassError;

  /// App language label
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get languageLabel;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// Turkish language option
  ///
  /// In en, this message translates to:
  /// **'Türkçe'**
  String get languageTurkish;

  /// Theme preference section title
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeTitle;

  /// Follow the device theme setting
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get themeSystem;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// MWL calculation method
  ///
  /// In en, this message translates to:
  /// **'Muslim World League'**
  String get methodMWL;

  /// ISNA calculation method
  ///
  /// In en, this message translates to:
  /// **'Islamic Society of North America'**
  String get methodISNA;

  /// Egypt calculation method
  ///
  /// In en, this message translates to:
  /// **'Egyptian General Authority'**
  String get methodEgypt;

  /// Makkah calculation method
  ///
  /// In en, this message translates to:
  /// **'Umm Al-Qura'**
  String get methodMakkah;

  /// Karachi calculation method
  ///
  /// In en, this message translates to:
  /// **'University of Islamic Sciences, Karachi'**
  String get methodKarachi;

  /// Tehran calculation method
  ///
  /// In en, this message translates to:
  /// **'Institute of Geophysics, University of Tehran'**
  String get methodTehran;

  /// Shia calculation method
  ///
  /// In en, this message translates to:
  /// **'Shia Ithna-Ashari'**
  String get methodShia;

  /// Gulf calculation method
  ///
  /// In en, this message translates to:
  /// **'Gulf Region'**
  String get methodGulf;

  /// Kuwait calculation method
  ///
  /// In en, this message translates to:
  /// **'Kuwait'**
  String get methodKuwait;

  /// Qatar calculation method
  ///
  /// In en, this message translates to:
  /// **'Qatar'**
  String get methodQatar;

  /// Singapore calculation method
  ///
  /// In en, this message translates to:
  /// **'Majlis Ugama Islam Singapura'**
  String get methodSingapore;

  /// France calculation method
  ///
  /// In en, this message translates to:
  /// **'Union des Organisations Islamiques de France'**
  String get methodFrance;

  /// Turkey calculation method
  ///
  /// In en, this message translates to:
  /// **'Diyanet Approximation Profile'**
  String get methodTurkey;

  /// Russia calculation method
  ///
  /// In en, this message translates to:
  /// **'Spiritual Administration of Muslims of Russia'**
  String get methodRussia;

  /// Moonsighting calculation method
  ///
  /// In en, this message translates to:
  /// **'Moonsighting Committee Worldwide'**
  String get methodMoonsighting;

  /// Dubai calculation method
  ///
  /// In en, this message translates to:
  /// **'Dubai'**
  String get methodDubai;

  /// Jakim calculation method
  ///
  /// In en, this message translates to:
  /// **'Jabatan Kemajuan Islam Malaysia'**
  String get methodJakim;

  /// Tunisia calculation method
  ///
  /// In en, this message translates to:
  /// **'Tunisian Ministry of Religious Affairs'**
  String get methodTunisia;

  /// Algeria calculation method
  ///
  /// In en, this message translates to:
  /// **'Algerian Ministry of Religious Affairs'**
  String get methodAlgeria;

  /// Kemenag calculation method
  ///
  /// In en, this message translates to:
  /// **'Indonesian Ministry of Religious Affairs'**
  String get methodKemenag;

  /// Morocco calculation method
  ///
  /// In en, this message translates to:
  /// **'Moroccan Ministry of Habous and Islamic Affairs'**
  String get methodMorocco;

  /// Portugal calculation method
  ///
  /// In en, this message translates to:
  /// **'Great Mosque of Paris'**
  String get methodPortugal;

  /// Jafari calculation method
  ///
  /// In en, this message translates to:
  /// **'Shia Ithna-Ashari'**
  String get methodJafari;

  /// Standard madhab option
  ///
  /// In en, this message translates to:
  /// **'Standard (Shafi / Maliki / Hanbali)'**
  String get madhabStandard;

  /// Hanafi madhab option
  ///
  /// In en, this message translates to:
  /// **'Hanafi'**
  String get madhabHanafi;

  /// Muharram hijri month
  ///
  /// In en, this message translates to:
  /// **'Muharram'**
  String get hijriMuharram;

  /// Safar hijri month
  ///
  /// In en, this message translates to:
  /// **'Safar'**
  String get hijriSafar;

  /// Rabi al-Awwal hijri month
  ///
  /// In en, this message translates to:
  /// **'Rabi\' al-Awwal'**
  String get hijriRabiAlAwwal;

  /// Rabi al-Thani hijri month
  ///
  /// In en, this message translates to:
  /// **'Rabi\' al-Thani'**
  String get hijriRabiAlThani;

  /// Jumada al-Awwal hijri month
  ///
  /// In en, this message translates to:
  /// **'Jumada al-Awwal'**
  String get hijriJumadaAlAwwal;

  /// Jumada al-Thani hijri month
  ///
  /// In en, this message translates to:
  /// **'Jumada al-Thani'**
  String get hijriJumadaAlThani;

  /// Rajab hijri month
  ///
  /// In en, this message translates to:
  /// **'Rajab'**
  String get hijriRajab;

  /// Shaaban hijri month
  ///
  /// In en, this message translates to:
  /// **'Sha\'ban'**
  String get hijriShaaban;

  /// Ramadan hijri month
  ///
  /// In en, this message translates to:
  /// **'Ramadan'**
  String get hijriRamadan;

  /// Shawwal hijri month
  ///
  /// In en, this message translates to:
  /// **'Shawwal'**
  String get hijriShawwal;

  /// Dhu al-Qi'dah hijri month
  ///
  /// In en, this message translates to:
  /// **'Dhu al-Qi\'dah'**
  String get hijriDhuAlQiDah;

  /// Dhu al-Hijjah hijri month
  ///
  /// In en, this message translates to:
  /// **'Dhu al-Hijjah'**
  String get hijriDhuAlHijjah;

  /// Asr calculation convention description
  ///
  /// In en, this message translates to:
  /// **'Asr calculation convention'**
  String get asrConventionDesc;

  /// Home greeting
  ///
  /// In en, this message translates to:
  /// **'Assalamu Alaikum'**
  String get homeGreeting;

  /// Home today's schedule section title
  ///
  /// In en, this message translates to:
  /// **'Today\'s Schedule'**
  String get homeToday;

  /// Home next prayer header
  ///
  /// In en, this message translates to:
  /// **'Next Prayer'**
  String get nextPrayerHeader;

  /// Home view qibla action
  ///
  /// In en, this message translates to:
  /// **'Qibla Direction'**
  String get viewQibla;

  /// Home open settings action
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get openSettings;

  /// Home prayer error state
  ///
  /// In en, this message translates to:
  /// **'Prayer times unavailable.'**
  String get homePrayerError;

  /// Home prayer retry button
  ///
  /// In en, this message translates to:
  /// **'Retry Location'**
  String get homePrayerRetry;

  /// Home coming soon label
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get homeComingSoon;

  /// Quran search input hint
  ///
  /// In en, this message translates to:
  /// **'Search Surah'**
  String get quranSearchHint;

  /// Quran empty search result
  ///
  /// In en, this message translates to:
  /// **'No Surah found.'**
  String get quranNoSurahFound;

  /// Quran meccan revelation type
  ///
  /// In en, this message translates to:
  /// **'Meccan'**
  String get quranMeccan;

  /// Quran medinan revelation type
  ///
  /// In en, this message translates to:
  /// **'Medinan'**
  String get quranMedinan;

  /// Quran ayah count formatting
  ///
  /// In en, this message translates to:
  /// **'{count} Ayahs'**
  String quranAyahCount(int count);

  /// Quran detail placeholder text
  ///
  /// In en, this message translates to:
  /// **'Quran text reader will be implemented in a later phase.'**
  String get quranDetailPlaceholderText;

  /// Quran continue reading button
  ///
  /// In en, this message translates to:
  /// **'Continue Reading'**
  String get quranContinueReading;

  /// Quran last read label
  ///
  /// In en, this message translates to:
  /// **'Last Read'**
  String get quranLastRead;

  /// Quran ayah label
  ///
  /// In en, this message translates to:
  /// **'Ayah'**
  String get quranAyah;

  /// Quran continue button
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get quranContinue;

  /// Quran no reading history message
  ///
  /// In en, this message translates to:
  /// **'No reading history yet.'**
  String get quranNoHistory;

  /// Bookmarks screen title
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get quranBookmarks;

  /// Add bookmark tooltip
  ///
  /// In en, this message translates to:
  /// **'Add Bookmark'**
  String get quranBookmarkAdd;

  /// Remove bookmark tooltip
  ///
  /// In en, this message translates to:
  /// **'Remove Bookmark'**
  String get quranBookmarkRemove;

  /// Empty state for bookmarks
  ///
  /// In en, this message translates to:
  /// **'No bookmarks yet.'**
  String get quranNoBookmarksYet;

  /// Reader settings sheet title
  ///
  /// In en, this message translates to:
  /// **'Reader Settings'**
  String get quranReaderSettings;

  /// Text size label
  ///
  /// In en, this message translates to:
  /// **'Text Size'**
  String get quranTextSize;

  /// Reset to default button
  ///
  /// In en, this message translates to:
  /// **'Reset to Default'**
  String get quranResetDefault;

  /// Toggle to show translation
  ///
  /// In en, this message translates to:
  /// **'Show Translation'**
  String get quranShowTranslation;

  /// Fallback when translation is missing
  ///
  /// In en, this message translates to:
  /// **'Translation unavailable.'**
  String get quranTranslationUnavailable;

  /// Home greeting header
  ///
  /// In en, this message translates to:
  /// **'Daily Overview'**
  String get homeDailyOverview;

  /// Home next prayer label
  ///
  /// In en, this message translates to:
  /// **'Next Prayer'**
  String get homeNextPrayer;

  /// Home remaining time label
  ///
  /// In en, this message translates to:
  /// **'remaining'**
  String get homeRemaining;

  /// Home prayer times section
  ///
  /// In en, this message translates to:
  /// **'Prayer Times'**
  String get homePrayerTimes;

  /// Home continue reading section
  ///
  /// In en, this message translates to:
  /// **'Continue Reading'**
  String get homeContinueReading;

  /// Home bookmarks shortcut label
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get homeBookmarks;

  /// Number of saved ayahs
  ///
  /// In en, this message translates to:
  /// **'{count} saved ayahs'**
  String homeSavedAyahs(int count);

  /// Home qibla shortcut label
  ///
  /// In en, this message translates to:
  /// **'Qibla'**
  String get homeQibla;

  /// Home settings shortcut label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get homeSettings;

  /// Home location unavailable fallback
  ///
  /// In en, this message translates to:
  /// **'Location unavailable'**
  String get homeLocationUnavailable;

  /// Home fajr label
  ///
  /// In en, this message translates to:
  /// **'Fajr'**
  String get homePrayerFajr;

  /// Home sunrise label
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get homePrayerSunrise;

  /// Home dhuhr label
  ///
  /// In en, this message translates to:
  /// **'Dhuhr'**
  String get homePrayerDhuhr;

  /// Home asr label
  ///
  /// In en, this message translates to:
  /// **'Asr'**
  String get homePrayerAsr;

  /// Home maghrib label
  ///
  /// In en, this message translates to:
  /// **'Maghrib'**
  String get homePrayerMaghrib;

  /// Home isha label
  ///
  /// In en, this message translates to:
  /// **'Isha'**
  String get homePrayerIsha;

  /// Diyanet method description
  ///
  /// In en, this message translates to:
  /// **'Diyanet Approximation using 18°/17° angles.'**
  String get descDiyarTurk;

  /// MWL method description
  ///
  /// In en, this message translates to:
  /// **'Standard method widely used across Europe and Asia.'**
  String get descMwl;

  /// ISNA method description
  ///
  /// In en, this message translates to:
  /// **'Standard method for North America.'**
  String get descIsna;

  /// Egypt method description
  ///
  /// In en, this message translates to:
  /// **'Standard method in Africa and Middle East.'**
  String get descEgypt;

  /// Makkah method description
  ///
  /// In en, this message translates to:
  /// **'Standard method in Arabian Peninsula.'**
  String get descMakkah;

  /// Activity tab title
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activityTitle;

  /// Activity today section header
  ///
  /// In en, this message translates to:
  /// **'Today\'s Activity'**
  String get activityToday;

  /// Activity prayers section
  ///
  /// In en, this message translates to:
  /// **'Prayers'**
  String get activityPrayers;

  /// Activity completed status
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get activityCompleted;

  /// Activity not completed status
  ///
  /// In en, this message translates to:
  /// **'Not Completed'**
  String get activityNotCompleted;

  /// Activity Quran reading section
  ///
  /// In en, this message translates to:
  /// **'Quran Reading'**
  String get activityQuranReading;

  /// Activity read today status
  ///
  /// In en, this message translates to:
  /// **'Read Today'**
  String get activityReadToday;

  /// Activity not recorded status
  ///
  /// In en, this message translates to:
  /// **'Not Recorded'**
  String get activityNotRecorded;

  /// Activity manual mark as read button
  ///
  /// In en, this message translates to:
  /// **'Mark as Read'**
  String get activityMarkAsRead;

  /// Activity history section
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get activityHistory;

  /// Activity statistics section
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get activityStatistics;

  /// Activity empty history
  ///
  /// In en, this message translates to:
  /// **'No past records found.'**
  String get activityEmptyHistory;

  /// Current streak stat label
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get statsStreak;

  /// Days count
  ///
  /// In en, this message translates to:
  /// **'{count} Days'**
  String statsDays(int count);

  /// 7-day average completion
  ///
  /// In en, this message translates to:
  /// **'7-Day Avg'**
  String get statsAvgCompletion;

  /// Quran days in last 7 days
  ///
  /// In en, this message translates to:
  /// **'Quran (7d)'**
  String get statsQuranDays;

  /// Profile guest user label
  ///
  /// In en, this message translates to:
  /// **'Guest User'**
  String get profileGuest;

  /// Profile guest user description
  ///
  /// In en, this message translates to:
  /// **'Sign in to backup your data.'**
  String get profileGuestDesc;

  /// Profile stats summary label
  ///
  /// In en, this message translates to:
  /// **'Your Progress'**
  String get profileStatsSummary;

  /// Title for daily verse card
  ///
  /// In en, this message translates to:
  /// **'Verse of the Day'**
  String get dailyVerseTitle;

  /// Settings notifications title
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// Toggle for master notifications
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get notificationsEnabled;

  /// Prayer reminder setting label
  ///
  /// In en, this message translates to:
  /// **'Prayer Reminders'**
  String get prayerReminders;

  /// Toggle for daily verse
  ///
  /// In en, this message translates to:
  /// **'Daily Quran Verse'**
  String get dailyVerseEnabled;

  /// Notification permission denied message shown when notifications are blocked
  ///
  /// In en, this message translates to:
  /// **'Notification permission denied. Please enable it in your device settings.'**
  String get notificationPermissionDeniedMessage;

  /// Motivational message on activity screen
  ///
  /// In en, this message translates to:
  /// **'Today is a great day to purify your heart.'**
  String get activityMotivation;

  /// Title for daily progress section
  ///
  /// In en, this message translates to:
  /// **'Daily Progress'**
  String get activityTodayProgress;

  /// Hint text for worship cards
  ///
  /// In en, this message translates to:
  /// **'Tap to complete'**
  String get activityTapToComplete;

  /// Empty state description for history
  ///
  /// In en, this message translates to:
  /// **'As you record your worship, this space will become the map of your spiritual journey.'**
  String get activityHistoryEmptyDesc;

  /// Arabic text for the Shahada
  ///
  /// In en, this message translates to:
  /// **'أَشْهَدُ أَنْ لَا إِلَٰهَ إِلَّا ٱللَّٰهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا رَسُولُ ٱللَّٰهِ'**
  String get homeShahadaArabic;

  /// Transliteration of the Shahada
  ///
  /// In en, this message translates to:
  /// **'Ash-hadu an la ilaha illallah, wa ash-hadu anna Muhammadan rasulullah.'**
  String get homeShahadaTransliteration;

  /// Bottom navigation Menu label replacing Profile
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get navMenu;

  /// Settings group header in menu
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get menuSettingsGroup;

  /// Menu item
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get menuLanguage;

  /// Menu item
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get menuTheme;

  /// Menu item
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get menuNotifications;

  /// Menu item
  ///
  /// In en, this message translates to:
  /// **'Prayer Calculation'**
  String get menuPrayerCalc;

  /// Menu item
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get menuLocation;

  /// Menu item
  ///
  /// In en, this message translates to:
  /// **'Notification Sounds'**
  String get menuSounds;

  /// Menu item
  ///
  /// In en, this message translates to:
  /// **'Personalization'**
  String get menuPersonalizationGroup;

  /// Menu item
  ///
  /// In en, this message translates to:
  /// **'Daily Goals'**
  String get menuDailyGoals;

  /// Menu item
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get menuPreferences;

  /// Menu item
  ///
  /// In en, this message translates to:
  /// **'Tools & Information'**
  String get menuToolsGroup;

  /// Menu item
  ///
  /// In en, this message translates to:
  /// **'Islamic Tools'**
  String get menuIslamicTools;

  /// Menu item
  ///
  /// In en, this message translates to:
  /// **'Information Center'**
  String get menuInfoCenter;

  /// Menu item
  ///
  /// In en, this message translates to:
  /// **'Hajj Guide'**
  String get menuHajjGuide;

  /// Menu item
  ///
  /// In en, this message translates to:
  /// **'Zakat Calculator'**
  String get menuZakatCalc;

  /// Menu item
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get menuAppGroup;

  /// Menu item
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get menuAbout;

  /// Menu item
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get menuPrivacy;

  /// Menu item
  ///
  /// In en, this message translates to:
  /// **'Sources'**
  String get menuSources;

  /// Zakat screen title
  ///
  /// In en, this message translates to:
  /// **'Zakat Calculator'**
  String get zakatTitle;

  /// Input label
  ///
  /// In en, this message translates to:
  /// **'Current Gold Price per Gram'**
  String get zakatGoldPriceLabel;

  /// Input group
  ///
  /// In en, this message translates to:
  /// **'Your Assets (Subject to Zakat)'**
  String get zakatAssetsGroup;

  /// Input label
  ///
  /// In en, this message translates to:
  /// **'Cash & Bank Accounts'**
  String get zakatCashLabel;

  /// Input label
  ///
  /// In en, this message translates to:
  /// **'Owned Gold (Grams)'**
  String get zakatGoldGramsLabel;

  /// Input label
  ///
  /// In en, this message translates to:
  /// **'Trade Goods Value'**
  String get zakatTradeGoodsLabel;

  /// Input label
  ///
  /// In en, this message translates to:
  /// **'Receivables (Guaranteed)'**
  String get zakatReceivablesLabel;

  /// Input group
  ///
  /// In en, this message translates to:
  /// **'Deductions'**
  String get zakatDebtsGroup;

  /// Input label
  ///
  /// In en, this message translates to:
  /// **'Debts & Basic Needs'**
  String get zakatDebtsLabel;

  /// Button
  ///
  /// In en, this message translates to:
  /// **'Calculate Zakat'**
  String get zakatCalculateButton;

  /// Result header
  ///
  /// In en, this message translates to:
  /// **'Calculation Result'**
  String get zakatResultTitle;

  /// Result row
  ///
  /// In en, this message translates to:
  /// **'Total Net Wealth:'**
  String get zakatTotalWealth;

  /// Result row
  ///
  /// In en, this message translates to:
  /// **'Nisab Threshold (80.18 gr):'**
  String get zakatNisabAmount;

  /// Result row
  ///
  /// In en, this message translates to:
  /// **'Required Zakat Amount:'**
  String get zakatRequiredAmount;

  /// Result row
  ///
  /// In en, this message translates to:
  /// **'Your net wealth is below the Nisab threshold. Zakat is not obligatory.'**
  String get zakatNotRequired;

  /// Disclaimer
  ///
  /// In en, this message translates to:
  /// **'Note: This calculation uses the 80.18 grams of gold Nisab threshold according to the Presidency of Religious Affairs of Turkey. Your primary residence and personal vehicle are exempt. Please consult official sources for detailed jurisprudence.'**
  String get zakatDiyanetNote;

  /// Hajj screen title
  ///
  /// In en, this message translates to:
  /// **'Hajj Guide'**
  String get hajjTitle;

  /// Hajj info
  ///
  /// In en, this message translates to:
  /// **'Hajj is one of the five pillars of Islam. In Turkey, Hajj registration and lottery processes are managed directly by the Presidency of Religious Affairs (Diyanet).'**
  String get hajjDiyanetInfo;

  /// Button
  ///
  /// In en, this message translates to:
  /// **'Official Diyanet Hajj Page'**
  String get hajjOfficialLinkButton;

  /// Alert
  ///
  /// In en, this message translates to:
  /// **'This feature will be added in the next phase.'**
  String get comingSoonAlert;

  /// About app description
  ///
  /// In en, this message translates to:
  /// **'IslamFull is a local, privacy-focused Islamic lifestyle assistant designed to help you track daily prayers, read the Quran, and reach your spiritual goals.'**
  String get aboutAppDescription;

  /// App version
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get aboutVersion;

  /// Copyright notice
  ///
  /// In en, this message translates to:
  /// **'© 2026 IslamFull. All rights reserved.'**
  String get aboutCopyright;

  /// Privacy policy full text
  ///
  /// In en, this message translates to:
  /// **'1. Data Privacy and Security\nIslamFull places the highest priority on user privacy. All your worship history, dhikr, Quran reading progress, and bookmarks are stored entirely encrypted on your device\'s local storage (offline).\n\n2. Data Sharing\nYour personal data or usage habits are never transmitted to external servers, shared with third-party companies, or sold.\n\n3. Location Usage\nYour device\'s location is used momentarily to calculate precise prayer times and the Qibla direction. This data is only processed locally during the calculation and is not logged on remote servers.\n\n4. External Links\nModules such as the Hajj Guide may contain external links to official institutions. The privacy policies of these sites are not under our responsibility.\n\nYou can use IslamFull safely and peacefully.'**
  String get privacyPolicyContent;

  /// Title
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferencesTitle;

  /// Setting
  ///
  /// In en, this message translates to:
  /// **'Haptic Feedback'**
  String get prefHapticFeedback;

  /// Setting desc
  ///
  /// In en, this message translates to:
  /// **'Vibration on Tasbih and buttons'**
  String get prefHapticDesc;

  /// Setting
  ///
  /// In en, this message translates to:
  /// **'Daily Verse'**
  String get prefDailyVerse;

  /// Setting desc
  ///
  /// In en, this message translates to:
  /// **'Show daily verse on home screen'**
  String get prefDailyVerseDesc;

  /// Title
  ///
  /// In en, this message translates to:
  /// **'Islamic Tools'**
  String get toolsTitle;

  /// Title
  ///
  /// In en, this message translates to:
  /// **'Tasbih (Dhikr)'**
  String get tasbihTitle;

  /// Button
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get tasbihReset;

  /// Label
  ///
  /// In en, this message translates to:
  /// **'Dhikr Count'**
  String get tasbihCount;

  /// Label
  ///
  /// In en, this message translates to:
  /// **'Goal: {goal}'**
  String tasbihGoal(int goal);

  /// Title
  ///
  /// In en, this message translates to:
  /// **'Information Center'**
  String get infoCenterTitle;

  /// Title
  ///
  /// In en, this message translates to:
  /// **'How to perform Wudu?'**
  String get wuduGuideTitle;

  /// Step
  ///
  /// In en, this message translates to:
  /// **'1. Intention and Bismillah'**
  String get wuduStep1Title;

  /// Step
  ///
  /// In en, this message translates to:
  /// **'Make intention for Wudu and say Bismillah.'**
  String get wuduStep1Desc;

  /// Step
  ///
  /// In en, this message translates to:
  /// **'2. Wash Hands'**
  String get wuduStep2Title;

  /// Step
  ///
  /// In en, this message translates to:
  /// **'Wash hands up to the wrists three times, ensuring water reaches between fingers.'**
  String get wuduStep2Desc;

  /// Step
  ///
  /// In en, this message translates to:
  /// **'3. Rinse Mouth'**
  String get wuduStep3Title;

  /// Step
  ///
  /// In en, this message translates to:
  /// **'Take water into the mouth with the right hand and rinse it three times.'**
  String get wuduStep3Desc;

  /// Step
  ///
  /// In en, this message translates to:
  /// **'4. Sniff Water into Nose'**
  String get wuduStep4Title;

  /// Step
  ///
  /// In en, this message translates to:
  /// **'Inhale water into the nose with the right hand and blow it out using the left hand, three times.'**
  String get wuduStep4Desc;

  /// Step
  ///
  /// In en, this message translates to:
  /// **'5. Wash Face'**
  String get wuduStep5Title;

  /// Step
  ///
  /// In en, this message translates to:
  /// **'Wash the whole face (from hairline to chin) three times.'**
  String get wuduStep5Desc;

  /// Step
  ///
  /// In en, this message translates to:
  /// **'6. Wash Arms'**
  String get wuduStep6Title;

  /// Step
  ///
  /// In en, this message translates to:
  /// **'Wash the right arm up to the elbow three times, then do the same for the left arm.'**
  String get wuduStep6Desc;

  /// Step
  ///
  /// In en, this message translates to:
  /// **'7. Wipe Head (Masah)'**
  String get wuduStep7Title;

  /// Step
  ///
  /// In en, this message translates to:
  /// **'Wipe the head once with wet hands. In Diyanet\'s Hanafi guidance, wiping at least one quarter of the head fulfills this requirement; details differ between schools of Islamic law.'**
  String get wuduStep7Desc;

  /// Step
  ///
  /// In en, this message translates to:
  /// **'8. Wipe Ears and Neck'**
  String get wuduStep8Title;

  /// Step
  ///
  /// In en, this message translates to:
  /// **'Wipe the ears. Diyanet\'s commonly taught sequence also includes wiping the neck with the backs of the hands. Some details of this step vary between schools of Islamic law.'**
  String get wuduStep8Desc;

  /// Step
  ///
  /// In en, this message translates to:
  /// **'9. Wash Feet'**
  String get wuduStep9Title;

  /// Step
  ///
  /// In en, this message translates to:
  /// **'Wash the right foot up to the ankles three times, starting from the toes. Repeat for the left foot.'**
  String get wuduStep9Desc;

  /// Prayer reminder offset in minutes
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes before'**
  String notificationMinutesBefore(int minutes);

  /// Time of day for the daily Quran verse notification
  ///
  /// In en, this message translates to:
  /// **'Daily verse time'**
  String get dailyVerseTime;

  /// Displayed when local notifications are unavailable on the current platform
  ///
  /// In en, this message translates to:
  /// **'Local notifications are not supported on this platform yet.'**
  String get notificationsUnsupportedPlatform;

  /// Information center introduction title
  ///
  /// In en, this message translates to:
  /// **'Learn at Your Own Pace'**
  String get infoCenterWelcomeTitle;

  /// Information center introduction
  ///
  /// In en, this message translates to:
  /// **'Explore clear, practical guides about the foundations of Islam and everyday worship.'**
  String get infoCenterWelcomeDesc;

  /// Information center learning guides section
  ///
  /// In en, this message translates to:
  /// **'Learning Guides'**
  String get infoCenterLearningGuides;

  /// Information center worship guides section
  ///
  /// In en, this message translates to:
  /// **'Worship Guides'**
  String get infoCenterWorshipGuides;

  /// New Muslim journey screen title
  ///
  /// In en, this message translates to:
  /// **'New Muslim Journey'**
  String get newMuslimJourneyTitle;

  /// New Muslim journey menu description
  ///
  /// In en, this message translates to:
  /// **'A simple starting path for learning the essentials of Islam.'**
  String get newMuslimJourneyMenuDesc;

  /// New Muslim journey welcome title
  ///
  /// In en, this message translates to:
  /// **'Welcome to Your Journey'**
  String get newMuslimJourneyWelcomeTitle;

  /// New Muslim journey introduction
  ///
  /// In en, this message translates to:
  /// **'You do not need to learn everything at once. Begin with the foundations, then build your knowledge and worship step by step.'**
  String get newMuslimJourneySubtitle;

  /// New Muslim journey first steps header
  ///
  /// In en, this message translates to:
  /// **'Start Here'**
  String get newMuslimJourneyStartHere;

  /// Journey foundations step title
  ///
  /// In en, this message translates to:
  /// **'Learn the Foundations'**
  String get newMuslimJourneyFoundationsTitle;

  /// Journey foundations step description
  ///
  /// In en, this message translates to:
  /// **'Understand the five pillars of Islam and the six articles of faith.'**
  String get newMuslimJourneyFoundationsDesc;

  /// Journey wudu step title
  ///
  /// In en, this message translates to:
  /// **'Learn Wudu'**
  String get newMuslimJourneyWuduTitle;

  /// Journey wudu step description
  ///
  /// In en, this message translates to:
  /// **'Learn the basic steps of purification before prayer.'**
  String get newMuslimJourneyWuduDesc;

  /// Journey prayer step title
  ///
  /// In en, this message translates to:
  /// **'Become Familiar with Prayer'**
  String get newMuslimJourneyPrayerTitle;

  /// Journey prayer step description
  ///
  /// In en, this message translates to:
  /// **'Explore daily prayer times and begin becoming familiar with the rhythm of the five prayers.'**
  String get newMuslimJourneyPrayerDesc;

  /// Journey Quran step title
  ///
  /// In en, this message translates to:
  /// **'Read the Quran'**
  String get newMuslimJourneyQuranTitle;

  /// Journey Quran step description
  ///
  /// In en, this message translates to:
  /// **'Read the Quran together with a translation in the language you understand best.'**
  String get newMuslimJourneyQuranDesc;

  /// Journey guidance note title
  ///
  /// In en, this message translates to:
  /// **'Learn Gradually'**
  String get newMuslimJourneyNoteTitle;

  /// Journey guidance disclaimer
  ///
  /// In en, this message translates to:
  /// **'IslamFull provides introductory guidance. For personal religious rulings or circumstances that require detailed guidance, consult a qualified and trusted scholar.'**
  String get newMuslimJourneyNoteBody;

  /// Islam foundations screen title
  ///
  /// In en, this message translates to:
  /// **'Foundations of Islam'**
  String get islamFoundationsTitle;

  /// Foundations menu description
  ///
  /// In en, this message translates to:
  /// **'Learn the five pillars of Islam and the core articles of faith.'**
  String get islamFoundationsMenuDesc;

  /// Islam foundations introduction
  ///
  /// In en, this message translates to:
  /// **'The pillars of Islam describe core acts of worship, while the articles of faith summarize fundamental beliefs. This guide offers a concise introduction.'**
  String get islamFoundationsIntro;

  /// Five pillars section title
  ///
  /// In en, this message translates to:
  /// **'The Five Pillars of Islam'**
  String get fivePillarsTitle;

  /// Five pillars section introduction
  ///
  /// In en, this message translates to:
  /// **'The five pillars form the central framework of Muslim worship and practice.'**
  String get fivePillarsIntro;

  /// Shahada pillar title
  ///
  /// In en, this message translates to:
  /// **'Shahada'**
  String get pillarShahadaTitle;

  /// Shahada pillar description
  ///
  /// In en, this message translates to:
  /// **'Bearing witness that there is no deity worthy of worship except Allah and that Muhammad is His Messenger.'**
  String get pillarShahadaDesc;

  /// Prayer pillar title
  ///
  /// In en, this message translates to:
  /// **'Salah'**
  String get pillarPrayerTitle;

  /// Prayer pillar description
  ///
  /// In en, this message translates to:
  /// **'Performing the five daily prayers at their prescribed times.'**
  String get pillarPrayerDesc;

  /// Zakat pillar title
  ///
  /// In en, this message translates to:
  /// **'Zakat'**
  String get pillarZakatTitle;

  /// Zakat pillar description
  ///
  /// In en, this message translates to:
  /// **'Giving obligatory charity when its religious conditions are met.'**
  String get pillarZakatDesc;

  /// Fasting pillar title
  ///
  /// In en, this message translates to:
  /// **'Fasting in Ramadan'**
  String get pillarFastingTitle;

  /// Fasting pillar description
  ///
  /// In en, this message translates to:
  /// **'Fasting during the month of Ramadan from dawn until sunset for those required and able to fast.'**
  String get pillarFastingDesc;

  /// Hajj pillar title
  ///
  /// In en, this message translates to:
  /// **'Hajj'**
  String get pillarHajjTitle;

  /// Hajj pillar description
  ///
  /// In en, this message translates to:
  /// **'Making the pilgrimage to Makkah once in a lifetime for Muslims who are able to undertake it.'**
  String get pillarHajjDesc;

  /// Articles of faith section title
  ///
  /// In en, this message translates to:
  /// **'The Six Articles of Faith'**
  String get articlesOfFaithTitle;

  /// Articles of faith introduction
  ///
  /// In en, this message translates to:
  /// **'These six principles summarize the foundational beliefs traditionally taught in Islamic creed.'**
  String get articlesOfFaithIntro;

  /// Belief in Allah title
  ///
  /// In en, this message translates to:
  /// **'Belief in Allah'**
  String get faithAllahTitle;

  /// Belief in Allah description
  ///
  /// In en, this message translates to:
  /// **'Believing in Allah, His oneness, and that He alone is worthy of worship.'**
  String get faithAllahDesc;

  /// Belief in angels title
  ///
  /// In en, this message translates to:
  /// **'Belief in the Angels'**
  String get faithAngelsTitle;

  /// Belief in angels description
  ///
  /// In en, this message translates to:
  /// **'Believing in the angels created by Allah and in the duties assigned to them.'**
  String get faithAngelsDesc;

  /// Belief in revealed books title
  ///
  /// In en, this message translates to:
  /// **'Belief in the Revealed Books'**
  String get faithBooksTitle;

  /// Belief in revealed books description
  ///
  /// In en, this message translates to:
  /// **'Believing in the scriptures revealed by Allah to His messengers.'**
  String get faithBooksDesc;

  /// Belief in messengers title
  ///
  /// In en, this message translates to:
  /// **'Belief in the Messengers'**
  String get faithMessengersTitle;

  /// Belief in messengers description
  ///
  /// In en, this message translates to:
  /// **'Believing in the prophets and messengers sent by Allah to guide humanity.'**
  String get faithMessengersDesc;

  /// Belief in the Last Day title
  ///
  /// In en, this message translates to:
  /// **'Belief in the Last Day'**
  String get faithLastDayTitle;

  /// Belief in the Last Day description
  ///
  /// In en, this message translates to:
  /// **'Believing in resurrection, judgment, and the life of the Hereafter.'**
  String get faithLastDayDesc;

  /// Belief in divine decree title
  ///
  /// In en, this message translates to:
  /// **'Belief in Divine Decree'**
  String get faithDivineDecreeTitle;

  /// Belief in divine decree description
  ///
  /// In en, this message translates to:
  /// **'Believing in Allah\'s complete knowledge and decree while recognizing human responsibility for choices.'**
  String get faithDivineDecreeDesc;

  /// Foundations educational disclaimer
  ///
  /// In en, this message translates to:
  /// **'This section provides a concise educational overview and is not intended to replace detailed religious instruction.'**
  String get islamFoundationsDisclaimer;

  /// Wudu guide menu description
  ///
  /// In en, this message translates to:
  /// **'Follow the basic steps of ablution before prayer.'**
  String get wuduGuideMenuDesc;

  /// Source note for religious guidance content
  ///
  /// In en, this message translates to:
  /// **'Content basis: Presidency of Religious Affairs (Diyanet), with differences between Islamic legal schools noted where relevant.'**
  String get guidanceSourceNote;

  /// Introduction shown at the top of the wudu guide
  ///
  /// In en, this message translates to:
  /// **'Wudu is the ritual purification performed before prayer and certain other acts of worship. The steps below follow the commonly taught Diyanet sequence.'**
  String get wuduGuideIntro;

  /// Note explaining school-specific differences in wudu
  ///
  /// In en, this message translates to:
  /// **'Some details of wudu, including how much of the head is wiped and certain recommended actions, differ between schools of Islamic law.'**
  String get wuduGuideSchoolNote;

  /// Prayer guide screen title
  ///
  /// In en, this message translates to:
  /// **'How to Perform Prayer'**
  String get prayerGuideTitle;

  /// Prayer guide description shown in the information center
  ///
  /// In en, this message translates to:
  /// **'Learn the preparation and basic sequence of Salah step by step.'**
  String get prayerGuideMenuDesc;

  /// Short prayer guide description shown on the prayer screen
  ///
  /// In en, this message translates to:
  /// **'Learn the basic movements and sequence of prayer.'**
  String get prayerGuideShortcutDesc;

  /// Introduction shown at the top of the prayer guide
  ///
  /// In en, this message translates to:
  /// **'This guide introduces the essential structure of Salah using a two-rak\'ah prayer as the learning model.'**
  String get prayerGuideIntro;

  /// Prayer preparation section title
  ///
  /// In en, this message translates to:
  /// **'Before Prayer'**
  String get prayerGuidePreparationTitle;

  /// Prayer preparation requirements summary
  ///
  /// In en, this message translates to:
  /// **'Before prayer, ensure ritual purity, cleanliness of the body, clothing and place, appropriate covering, the correct prayer time, facing the Qiblah, and intention for the prayer.'**
  String get prayerGuidePreparationDesc;

  /// Title for obligatory rakah count summary
  ///
  /// In en, this message translates to:
  /// **'Obligatory Rak\'ahs'**
  String get prayerGuideFarzRakahsTitle;

  /// Obligatory rakah counts for the five daily prayers
  ///
  /// In en, this message translates to:
  /// **'Fajr: 2 • Dhuhr: 4 • Asr: 4 • Maghrib: 3 • Isha: 4'**
  String get prayerGuideFarzRakahsDesc;

  /// Title for the basic two-rakah prayer sequence
  ///
  /// In en, this message translates to:
  /// **'Basic Two-Rak\'ah Sequence'**
  String get prayerGuideTwoRakahTitle;

  /// Prayer guide step 1 title
  ///
  /// In en, this message translates to:
  /// **'1. Intention and Opening Takbir'**
  String get prayerGuideStep1Title;

  /// Prayer guide step 1 description
  ///
  /// In en, this message translates to:
  /// **'Make the intention in your heart for the prayer you are about to perform. Begin the prayer by saying \'Allahu Akbar\'.'**
  String get prayerGuideStep1Desc;

  /// Prayer guide step 2 title
  ///
  /// In en, this message translates to:
  /// **'2. Standing and Recitation'**
  String get prayerGuideStep2Title;

  /// Prayer guide step 2 description
  ///
  /// In en, this message translates to:
  /// **'Remain standing for the recitation. In Diyanet\'s common two-rak\'ah example, the opening supplication is followed by seeking refuge, Bismillah, Al-Fatihah and a passage from the Quran.'**
  String get prayerGuideStep2Desc;

  /// Prayer guide step 3 title
  ///
  /// In en, this message translates to:
  /// **'3. Bowing (Ruku)'**
  String get prayerGuideStep3Title;

  /// Prayer guide step 3 description
  ///
  /// In en, this message translates to:
  /// **'Say \'Allahu Akbar\' and bow. In the commonly taught Diyanet practice, \'Subhana Rabbiyal Azim\' is recited three times.'**
  String get prayerGuideStep3Desc;

  /// Prayer guide step 4 title
  ///
  /// In en, this message translates to:
  /// **'4. Rise from Ruku'**
  String get prayerGuideStep4Title;

  /// Prayer guide step 4 description
  ///
  /// In en, this message translates to:
  /// **'Rise from bowing while saying \'Sami\'Allahu liman hamidah\'. Once fully upright, say \'Rabbana laka\'l-hamd\'. Remain briefly in the upright position before proceeding to prostration.'**
  String get prayerGuideStep4Desc;

  /// Prayer guide step 5 title
  ///
  /// In en, this message translates to:
  /// **'5. Two Prostrations'**
  String get prayerGuideStep5Title;

  /// Prayer guide step 5 description
  ///
  /// In en, this message translates to:
  /// **'Say \'Allahu Akbar\' to enter prostration, rise briefly to a sitting position, and then perform the second prostration. In the commonly taught practice, \'Subhana Rabbiyal A\'la\' is recited three times in each prostration.'**
  String get prayerGuideStep5Desc;

  /// Prayer guide step 6 title
  ///
  /// In en, this message translates to:
  /// **'6. Second Rak\'ah'**
  String get prayerGuideStep6Title;

  /// Prayer guide step 6 description
  ///
  /// In en, this message translates to:
  /// **'Stand for the second rak\'ah. Recite Al-Fatihah and a passage from the Quran, then repeat the bowing and two prostrations.'**
  String get prayerGuideStep6Desc;

  /// Prayer guide step 7 title
  ///
  /// In en, this message translates to:
  /// **'7. Final Sitting'**
  String get prayerGuideStep7Title;

  /// Prayer guide step 7 description
  ///
  /// In en, this message translates to:
  /// **'After the second rak\'ah, remain seated for the final sitting. In Diyanet\'s common teaching, the Tashahhud and the Salawat prayers are recited here.'**
  String get prayerGuideStep7Desc;

  /// Prayer guide step 8 title
  ///
  /// In en, this message translates to:
  /// **'8. Complete with Salam'**
  String get prayerGuideStep8Title;

  /// Prayer guide step 8 description
  ///
  /// In en, this message translates to:
  /// **'Complete the prayer by turning first to the right and then to the left, saying \'Assalamu alaykum wa rahmatullah\'.'**
  String get prayerGuideStep8Desc;

  /// Note explaining school-specific differences in prayer
  ///
  /// In en, this message translates to:
  /// **'The essential pillars of prayer are shared, while details such as hand placement, some recitations and sitting positions may differ between schools of Islamic law. This guide follows the commonly taught Diyanet sequence without presenting school-specific details as universal.'**
  String get prayerGuideSchoolNote;

  /// Ghusl guide screen title
  ///
  /// In en, this message translates to:
  /// **'How to Perform Ghusl'**
  String get ghuslGuideTitle;

  /// Ghusl guide description shown in the information center
  ///
  /// In en, this message translates to:
  /// **'Learn when full ritual purification is required and how it is performed.'**
  String get ghuslGuideMenuDesc;

  /// Introduction shown at the top of the ghusl guide
  ///
  /// In en, this message translates to:
  /// **'Ghusl is full ritual purification in which the body is washed thoroughly so that water reaches every required area.'**
  String get ghuslGuideIntro;

  /// Title for situations requiring ghusl
  ///
  /// In en, this message translates to:
  /// **'When is Ghusl Required?'**
  String get ghuslWhenRequiredTitle;

  /// Summary of situations requiring ghusl
  ///
  /// In en, this message translates to:
  /// **'Ghusl is required after major ritual impurity such as janabah, and after menstruation or postnatal bleeding has ended.'**
  String get ghuslWhenRequiredDesc;

  /// Ghusl guide step 1 title
  ///
  /// In en, this message translates to:
  /// **'1. Intention and Bismillah'**
  String get ghuslStep1Title;

  /// Ghusl guide step 1 description
  ///
  /// In en, this message translates to:
  /// **'Form the intention for purification and begin with Bismillah.'**
  String get ghuslStep1Desc;

  /// Ghusl guide step 2 title
  ///
  /// In en, this message translates to:
  /// **'2. Wash the Hands and Remove Impurity'**
  String get ghuslStep2Title;

  /// Ghusl guide step 2 description
  ///
  /// In en, this message translates to:
  /// **'Wash the hands and clean any physical impurity from the body and private area.'**
  String get ghuslStep2Desc;

  /// Ghusl guide step 3 title
  ///
  /// In en, this message translates to:
  /// **'3. Rinse the Mouth and Nose'**
  String get ghuslStep3Title;

  /// Ghusl guide step 3 description
  ///
  /// In en, this message translates to:
  /// **'Rinse the mouth thoroughly and clean the nose with water. Diyanet identifies these, together with washing the whole body, as obligatory elements of ghusl in the Hanafi school.'**
  String get ghuslStep3Desc;

  /// Ghusl guide step 4 title
  ///
  /// In en, this message translates to:
  /// **'4. Perform Wudu'**
  String get ghuslStep4Title;

  /// Ghusl guide step 4 description
  ///
  /// In en, this message translates to:
  /// **'Perform wudu as you would for prayer. If water is collecting around the feet, they may be washed at the end.'**
  String get ghuslStep4Desc;

  /// Ghusl guide step 5 title
  ///
  /// In en, this message translates to:
  /// **'5. Wash the Head and Hair'**
  String get ghuslStep5Title;

  /// Ghusl guide step 5 description
  ///
  /// In en, this message translates to:
  /// **'Pour water over the head and make sure it reaches the scalp and roots of the hair.'**
  String get ghuslStep5Desc;

  /// Ghusl guide step 6 title
  ///
  /// In en, this message translates to:
  /// **'6. Wash the Entire Body'**
  String get ghuslStep6Title;

  /// Ghusl guide step 6 description
  ///
  /// In en, this message translates to:
  /// **'Wash the entire body thoroughly, leaving no dry area. Pay attention to places that water may not easily reach.'**
  String get ghuslStep6Desc;

  /// Note explaining school-specific differences in ghusl
  ///
  /// In en, this message translates to:
  /// **'Details concerning the obligatory elements of ghusl differ between Islamic legal schools. The sequence above follows Diyanet\'s commonly taught Hanafi-oriented explanation while identifying the shared goal of complete ritual purification.'**
  String get ghuslSchoolNote;

  /// Title for the New Muslim journey learning path
  ///
  /// In en, this message translates to:
  /// **'Your Learning Path'**
  String get journeyLearningPathTitle;

  /// Explains the neutral purpose of journey progress markers
  ///
  /// In en, this message translates to:
  /// **'Use these simple markers only to remember what you have reviewed and where you would like to continue. They are not scores, rewards, or achievements.'**
  String get journeyLearningPathDesc;

  /// Journey step status indicating the topic was reviewed
  ///
  /// In en, this message translates to:
  /// **'Reviewed'**
  String get journeyReviewed;

  /// Journey step status indicating no review marker has been set
  ///
  /// In en, this message translates to:
  /// **'Not marked'**
  String get journeyNotReviewed;

  /// Action for marking a journey topic as reviewed
  ///
  /// In en, this message translates to:
  /// **'Mark as reviewed'**
  String get journeyMarkReviewed;

  /// Action for removing the reviewed marker from a journey topic
  ///
  /// In en, this message translates to:
  /// **'Remove review mark'**
  String get journeyRemoveReviewed;

  /// Button for continuing from the relevant journey topic
  ///
  /// In en, this message translates to:
  /// **'Continue Learning'**
  String get journeyContinueButton;

  /// Daily duas step title in the New Muslim journey
  ///
  /// In en, this message translates to:
  /// **'Learn Daily Duas'**
  String get newMuslimJourneyDuasTitle;

  /// Daily duas step description in the New Muslim journey
  ///
  /// In en, this message translates to:
  /// **'Read a small collection of sourced supplications for common moments in daily life.'**
  String get newMuslimJourneyDuasDesc;

  /// Daily duas screen title
  ///
  /// In en, this message translates to:
  /// **'Daily Duas'**
  String get duasTitle;

  /// Daily duas description shown in the information center
  ///
  /// In en, this message translates to:
  /// **'Read short, sourced supplications for everyday moments.'**
  String get duasMenuDesc;

  /// Introduction shown on the daily duas screen
  ///
  /// In en, this message translates to:
  /// **'A calm reference for learning supplications and remembrance from the Islamic tradition. Read them at your own pace and return whenever you need them.'**
  String get duasIntro;

  /// Section title for everyday supplications
  ///
  /// In en, this message translates to:
  /// **'Everyday Duas'**
  String get duasEverydaySection;

  /// Section title for remembrance after prayer
  ///
  /// In en, this message translates to:
  /// **'After Prayer'**
  String get duasAfterPrayerSection;

  /// Neutral educational note shown on the daily duas screen
  ///
  /// In en, this message translates to:
  /// **'These supplications and remembrances are presented for learning and voluntary practice. They are not a score, reward, or achievement system.'**
  String get duasRecommendationNote;

  /// Label describing when a dua may be read
  ///
  /// In en, this message translates to:
  /// **'When'**
  String get duaWhenLabel;

  /// Arabic text label on a dua card
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get duaArabicLabel;

  /// Transliteration label on a dua card
  ///
  /// In en, this message translates to:
  /// **'Transliteration'**
  String get duaTransliterationLabel;

  /// Meaning label on a dua card
  ///
  /// In en, this message translates to:
  /// **'Meaning'**
  String get duaMeaningLabel;

  /// Hadith or religious source label on a dua card
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get duaSourceLabel;

  /// Title for the supplication upon waking
  ///
  /// In en, this message translates to:
  /// **'Upon Waking'**
  String get duaWakeTitle;

  /// Usage context for the waking supplication
  ///
  /// In en, this message translates to:
  /// **'After waking from sleep.'**
  String get duaWakeWhen;

  /// Arabic text of the supplication upon waking
  ///
  /// In en, this message translates to:
  /// **'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ'**
  String get duaWakeArabic;

  /// Transliteration of the supplication upon waking
  ///
  /// In en, this message translates to:
  /// **'Al-hamdu lillahil-ladhi ahyana ba\'da ma amatana wa ilayhin-nushur.'**
  String get duaWakeTransliteration;

  /// Meaning of the supplication upon waking
  ///
  /// In en, this message translates to:
  /// **'All praise is for Allah who gave us life after causing us to die, and to Him is the resurrection.'**
  String get duaWakeMeaning;

  /// Hadith source for the supplication upon waking
  ///
  /// In en, this message translates to:
  /// **'Bukhari, Da\'awat, 7'**
  String get duaWakeSource;

  /// Title for the supplication before sleep
  ///
  /// In en, this message translates to:
  /// **'Before Sleep'**
  String get duaSleepTitle;

  /// Usage context for the sleep supplication
  ///
  /// In en, this message translates to:
  /// **'When going to bed.'**
  String get duaSleepWhen;

  /// Arabic text of the supplication before sleep
  ///
  /// In en, this message translates to:
  /// **'بِاسْمِكَ أَمُوتُ وَأَحْيَا'**
  String get duaSleepArabic;

  /// Transliteration of the supplication before sleep
  ///
  /// In en, this message translates to:
  /// **'Bismika amutu wa ahya.'**
  String get duaSleepTransliteration;

  /// Meaning of the supplication before sleep
  ///
  /// In en, this message translates to:
  /// **'In Your name I die and I live.'**
  String get duaSleepMeaning;

  /// Hadith source for the supplication before sleep
  ///
  /// In en, this message translates to:
  /// **'Bukhari, Da\'awat, 7'**
  String get duaSleepSource;

  /// Title for the supplication when leaving home
  ///
  /// In en, this message translates to:
  /// **'Leaving Home'**
  String get duaLeavingHomeTitle;

  /// Usage context for the leaving home supplication
  ///
  /// In en, this message translates to:
  /// **'When leaving your home.'**
  String get duaLeavingHomeWhen;

  /// Arabic text of the supplication when leaving home
  ///
  /// In en, this message translates to:
  /// **'بِسْمِ اللَّهِ، تَوَكَّلْتُ عَلَى اللَّهِ، لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ'**
  String get duaLeavingHomeArabic;

  /// Transliteration of the supplication when leaving home
  ///
  /// In en, this message translates to:
  /// **'Bismillah, tawakkaltu \'alallah, la hawla wa la quwwata illa billah.'**
  String get duaLeavingHomeTransliteration;

  /// Meaning of the supplication when leaving home
  ///
  /// In en, this message translates to:
  /// **'In the name of Allah; I place my trust in Allah. There is no power and no strength except through Allah.'**
  String get duaLeavingHomeMeaning;

  /// Hadith source for the supplication when leaving home
  ///
  /// In en, this message translates to:
  /// **'Abu Dawud, Adab, 102-103'**
  String get duaLeavingHomeSource;

  /// Title for the supplication before entering the restroom
  ///
  /// In en, this message translates to:
  /// **'Before Entering the Restroom'**
  String get duaRestroomTitle;

  /// Usage context for the restroom supplication
  ///
  /// In en, this message translates to:
  /// **'Before entering the restroom.'**
  String get duaRestroomWhen;

  /// Arabic text of the supplication before entering the restroom
  ///
  /// In en, this message translates to:
  /// **'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْخُبُثِ وَالْخَبَائِثِ'**
  String get duaRestroomArabic;

  /// Transliteration of the supplication before entering the restroom
  ///
  /// In en, this message translates to:
  /// **'Allahumma inni a\'udhu bika minal-khubthi wal-khaba\'ith.'**
  String get duaRestroomTransliteration;

  /// Meaning of the supplication before entering the restroom
  ///
  /// In en, this message translates to:
  /// **'O Allah, I seek refuge in You from evil and impure things.'**
  String get duaRestroomMeaning;

  /// Hadith source for the supplication before entering the restroom
  ///
  /// In en, this message translates to:
  /// **'Bukhari, Wudu, 9'**
  String get duaRestroomSource;

  /// Title for the supplication after eating
  ///
  /// In en, this message translates to:
  /// **'After Eating'**
  String get duaAfterMealTitle;

  /// Usage context for the supplication after eating
  ///
  /// In en, this message translates to:
  /// **'After eating or drinking.'**
  String get duaAfterMealWhen;

  /// Arabic text of the supplication after eating
  ///
  /// In en, this message translates to:
  /// **'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنَا وَسَقَانَا وَجَعَلَنَا مِنَ الْمُسْلِمِينَ'**
  String get duaAfterMealArabic;

  /// Transliteration of the supplication after eating
  ///
  /// In en, this message translates to:
  /// **'Al-hamdu lillahil-ladhi at\'amana wa saqana wa ja\'alana minal-muslimin.'**
  String get duaAfterMealTransliteration;

  /// Meaning of the supplication after eating
  ///
  /// In en, this message translates to:
  /// **'All praise is for Allah who fed us, gave us drink, and made us among the Muslims.'**
  String get duaAfterMealMeaning;

  /// Hadith source for the supplication after eating
  ///
  /// In en, this message translates to:
  /// **'Tirmidhi, Da\'awat, 56'**
  String get duaAfterMealSource;

  /// Title for the travel supplication
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get duaTravelTitle;

  /// Usage context for the travel supplication
  ///
  /// In en, this message translates to:
  /// **'When setting out on a journey.'**
  String get duaTravelWhen;

  /// Arabic text of the travel supplication
  ///
  /// In en, this message translates to:
  /// **'سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ وَإِنَّا إِلَى رَبِّنَا لَمُنْقَلِبُونَ اللَّهُمَّ إِنَّا نَسْأَلُكَ فِي سَفَرِنَا هَذَا الْبِرَّ وَالتَّقْوَى وَمِنَ الْعَمَلِ مَا تَرْضَى اللَّهُمَّ هَوِّنْ عَلَيْنَا سَفَرَنَا هَذَا وَاطْوِ عَنَّا بُعْدَهُ اللَّهُمَّ أَنْتَ الصَّاحِبُ فِي السَّفَرِ وَالْخَلِيفَةُ فِي الْأَهْلِ اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ وَعْثَاءِ السَّفَرِ وَكَآبَةِ الْمَنْظَرِ وَسُوءِ الْمُنْقَلَبِ فِي الْمَالِ وَالْأَهْلِ'**
  String get duaTravelArabic;

  /// Transliteration of the travel supplication
  ///
  /// In en, this message translates to:
  /// **'Subhanalladhi sakhkhara lana hadha wa ma kunna lahu muqrinin, wa inna ila rabbina lamunqalibun. Allahumma inna nas\'aluka fi safarina hadhal-birra wat-taqwa wa minal-\'amali ma tarda. Allahumma hawwin \'alayna safarana hadha watwi \'anna bu\'dahu. Allahumma antas-sahibu fis-safari wal-khalifatu fil-ahli. Allahumma inni a\'udhu bika min wa\'tha\'is-safari wa ka\'abatil-manzari wa su\'il-munqalabi fil-mali wal-ahli.'**
  String get duaTravelTransliteration;

  /// Meaning of the travel supplication
  ///
  /// In en, this message translates to:
  /// **'Glory is to the One who placed this at our service, though we could not have controlled it ourselves, and surely to our Lord we will return. O Allah, we ask You on this journey for righteousness, mindfulness of You, and deeds that please You. Make this journey easy for us and shorten its distance. You are our Companion on the journey and the Guardian of our family. I seek refuge in You from the hardship of travel, distressing sights, and an unhappy return to family and property.'**
  String get duaTravelMeaning;

  /// Hadith source for the travel supplication
  ///
  /// In en, this message translates to:
  /// **'Muslim, Hajj, 425'**
  String get duaTravelSource;

  /// Title for recommended remembrance after prayer
  ///
  /// In en, this message translates to:
  /// **'Remembrance After Prayer'**
  String get duaAfterPrayerDhikrTitle;

  /// Usage and religious status note for remembrance after prayer
  ///
  /// In en, this message translates to:
  /// **'After the obligatory prayer. This remembrance is recommended and is not part of the prayer itself.'**
  String get duaAfterPrayerDhikrWhen;

  /// Arabic text for recommended remembrance after prayer
  ///
  /// In en, this message translates to:
  /// **'سُبْحَانَ اللَّهِ ×٣٣\nالْحَمْدُ لِلَّهِ ×٣٣\nاللَّهُ أَكْبَرُ ×٣٣\nلَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ'**
  String get duaAfterPrayerDhikrArabic;

  /// Transliteration for recommended remembrance after prayer
  ///
  /// In en, this message translates to:
  /// **'Subhanallah ×33\nAlhamdulillah ×33\nAllahu Akbar ×33\nLa ilaha illallahu wahdahu la sharika lah, lahul-mulku wa lahul-hamdu wa huwa \'ala kulli shay\'in qadir.'**
  String get duaAfterPrayerDhikrTransliteration;

  /// Meaning and sequence of recommended remembrance after prayer
  ///
  /// In en, this message translates to:
  /// **'Glory is to Allah ×33. All praise is for Allah ×33. Allah is the Greatest ×33. Then complete one hundred with: There is no deity except Allah alone, without partner. His is the dominion and His is all praise, and He has power over all things.'**
  String get duaAfterPrayerDhikrMeaning;

  /// Hadith source for recommended remembrance after prayer
  ///
  /// In en, this message translates to:
  /// **'Muslim, Masajid, 146'**
  String get duaAfterPrayerDhikrSource;

  /// Menu item opening the user's personal worship records
  ///
  /// In en, this message translates to:
  /// **'Worship Records'**
  String get menuWorshipRecords;

  /// Title of the Ramadan hub
  ///
  /// In en, this message translates to:
  /// **'Ramadan'**
  String get ramadanTitle;

  /// Short introduction shown in the Ramadan hub
  ///
  /// In en, this message translates to:
  /// **'A simple view of fasting times based on your current prayer location and calculation settings.'**
  String get ramadanIntro;

  /// Section title for today's imsak and iftar times
  ///
  /// In en, this message translates to:
  /// **'Today\'s Fasting Times'**
  String get ramadanTodayTimes;

  /// Label for the beginning of the daily fasting period
  ///
  /// In en, this message translates to:
  /// **'Imsak'**
  String get ramadanImsak;

  /// Label for the daily iftar time
  ///
  /// In en, this message translates to:
  /// **'Iftar'**
  String get ramadanIftar;

  /// Countdown label shown before imsak
  ///
  /// In en, this message translates to:
  /// **'Until Imsak'**
  String get ramadanUntilImsak;

  /// Countdown label shown during the fasting period
  ///
  /// In en, this message translates to:
  /// **'Until Iftar'**
  String get ramadanUntilIftar;

  /// Countdown label shown after today's iftar
  ///
  /// In en, this message translates to:
  /// **'Until Tomorrow\'s Imsak'**
  String get ramadanUntilTomorrowImsak;

  /// Status shown after the daily iftar time has begun
  ///
  /// In en, this message translates to:
  /// **'Iftar time has begun'**
  String get ramadanIftarEntered;

  /// Label for today's iftar time after iftar
  ///
  /// In en, this message translates to:
  /// **'Today\'s Iftar'**
  String get ramadanTodayIftar;

  /// Label for the next day's imsak time
  ///
  /// In en, this message translates to:
  /// **'Tomorrow\'s Imsak'**
  String get ramadanTomorrowImsak;

  /// Explains that Ramadan times reuse the user's prayer calculation settings
  ///
  /// In en, this message translates to:
  /// **'Imsak and iftar times follow the prayer location and calculation method currently selected in IslamFull.'**
  String get ramadanTimesNote;

  /// Button opening the main prayer times screen from Ramadan hub
  ///
  /// In en, this message translates to:
  /// **'View Prayer Times'**
  String get ramadanViewPrayerTimes;

  /// Title displayed in the Ramadan hub outside Ramadan
  ///
  /// In en, this message translates to:
  /// **'Ramadan is not currently in progress'**
  String get ramadanOutsideTitle;

  /// Message displayed in the Ramadan hub outside Ramadan
  ///
  /// In en, this message translates to:
  /// **'The current Hijri date in your prayer schedule is outside Ramadan. You can still return to this page whenever you need it.'**
  String get ramadanOutsideDesc;

  /// Title displayed when Ramadan timing data cannot be resolved
  ///
  /// In en, this message translates to:
  /// **'Fasting times are not available yet'**
  String get ramadanUnavailableTitle;

  /// Message displayed when Ramadan timing data cannot be resolved
  ///
  /// In en, this message translates to:
  /// **'Prayer or Hijri date information is not available yet. Refresh the prayer times and try again.'**
  String get ramadanUnavailableDesc;

  /// Error message shown when the daily Quran verse content cannot be loaded on Home
  ///
  /// In en, this message translates to:
  /// **'The daily verse could not be loaded.'**
  String get homeDailyVerseLoadFailed;

  /// Section title linking to educational Ramadan guidance
  ///
  /// In en, this message translates to:
  /// **'Ramadan Guide'**
  String get ramadanGuideSectionTitle;

  /// Title of the educational Ramadan guide screen
  ///
  /// In en, this message translates to:
  /// **'Ramadan Guide'**
  String get ramadanGuideTitle;

  /// Short description for links to the Ramadan guide
  ///
  /// In en, this message translates to:
  /// **'Learn the essentials of fasting, sahur, iftar, Tarawih, fitra, Laylat al-Qadr and Eid.'**
  String get ramadanGuideMenuDesc;

  /// Introduction to the Ramadan educational guide
  ///
  /// In en, this message translates to:
  /// **'A concise reference for common Ramadan practices. Open a topic when you need it; the guide is for learning and reference, not for measuring worship.'**
  String get ramadanGuideIntro;

  /// Ramadan guide topic about the basic meaning of fasting
  ///
  /// In en, this message translates to:
  /// **'Fasting in Ramadan'**
  String get ramadanGuideFastingTitle;

  /// Basic educational explanation of Ramadan fasting
  ///
  /// In en, this message translates to:
  /// **'Fasting in Ramadan is obligatory for Muslims who meet the conditions of religious responsibility. The daily fast begins at imsak (true dawn) and continues until sunset. During this period, the fasting person abstains from eating, drinking and sexual relations with the intention of worship. Intention is a condition of the fast. Details concerning the timing of intention and valid exemptions can differ according to circumstances and schools of law.'**
  String get ramadanGuideFastingDesc;

  /// Source label for basic Ramadan fasting information
  ///
  /// In en, this message translates to:
  /// **'Source: Din İşleri Yüksek Kurulu — Orucun Mahiyeti, Farzları, Sünnetleri ve Adabı.'**
  String get ramadanGuideFastingSource;

  /// Ramadan guide topic about sahur and iftar
  ///
  /// In en, this message translates to:
  /// **'Sahur and Iftar'**
  String get ramadanGuideSahurIftarTitle;

  /// Educational information about sahur and iftar
  ///
  /// In en, this message translates to:
  /// **'Sahur is the meal eaten before imsak. The Prophet encouraged Muslims to eat sahur, and delaying it without entering a doubtful time is regarded as recommended practice. Once sunset and the iftar time have certainly begun, unnecessarily delaying the breaking of the fast is not recommended. Iftar does not require a particular food; commonly mentioned foods such as dates or water are recommendations rather than conditions.'**
  String get ramadanGuideSahurIftarDesc;

  /// Source label for sahur and iftar information
  ///
  /// In en, this message translates to:
  /// **'Source: Din İşleri Yüksek Kurulu — Sahur Yemeğinin Dindeki Önemi; Diyanet Oruç İlmihali.'**
  String get ramadanGuideSahurIftarSource;

  /// Ramadan guide topic about actions that may break the fast
  ///
  /// In en, this message translates to:
  /// **'What Breaks the Fast?'**
  String get ramadanGuideBreaksFastTitle;

  /// Carefully scoped overview of actions that break or do not break fasting
  ///
  /// In en, this message translates to:
  /// **'Intentionally eating, drinking or having sexual relations during the fasting period breaks the fast. Eating or drinking because one genuinely forgot that one was fasting does not break it; once remembered, the person stops and continues the fast. Medical treatments, medicines, injections, dental procedures and accidental swallowing can involve more detailed rulings. Do not rely on a short general list for an individual medical or legal case.'**
  String get ramadanGuideBreaksFastDesc;

  /// Source label for fasting validity information
  ///
  /// In en, this message translates to:
  /// **'Source: Din İşleri Yüksek Kurulu — Orucu Bozan ve Bozmayan Haller.'**
  String get ramadanGuideBreaksFastSource;

  /// Ramadan guide topic about Tarawih prayer
  ///
  /// In en, this message translates to:
  /// **'Tarawih Prayer'**
  String get ramadanGuideTarawihTitle;

  /// Educational explanation of Tarawih prayer
  ///
  /// In en, this message translates to:
  /// **'Tarawih is a voluntary prayer associated with the nights of Ramadan. It is performed after the obligatory Isha prayer and may be prayed until the beginning of Fajr time. In the commonly taught Diyanet framework it is regarded as a strongly emphasised Sunnah for both women and men. It may be prayed individually or in congregation.'**
  String get ramadanGuideTarawihDesc;

  /// Source label for Tarawih information
  ///
  /// In en, this message translates to:
  /// **'Source: Din İşleri Yüksek Kurulu — Teravih Namazının Hükmü ve Mahiyeti.'**
  String get ramadanGuideTarawihSource;

  /// Ramadan guide topic explaining fitra and fidya
  ///
  /// In en, this message translates to:
  /// **'Fitra and Fidya'**
  String get ramadanGuideFitraFidyaTitle;

  /// Educational distinction between fitra and fasting fidya
  ///
  /// In en, this message translates to:
  /// **'Fitra (sadaqat al-fitr) is a financial act of worship connected with reaching Eid al-Fitr and helping those in need. Fidya is different: in the fasting context it applies principally when a person cannot fast and also has no realistic ability to make up the missed fasts, such as permanent illness or advanced age. The monetary amount is determined according to current conditions and can change over time, so the current official amount should be checked rather than relying on an old figure.'**
  String get ramadanGuideFitraFidyaDesc;

  /// Source label for fitra and fidya information
  ///
  /// In en, this message translates to:
  /// **'Source: Din İşleri Yüksek Kurulu — Fıtır Sadakası and Oruç Fidyesi guidance.'**
  String get ramadanGuideFitraFidyaSource;

  /// Ramadan guide topic about Laylat al-Qadr
  ///
  /// In en, this message translates to:
  /// **'Laylat al-Qadr'**
  String get ramadanGuideLaylatQadrTitle;

  /// Educational explanation of Laylat al-Qadr without claiming a certain date
  ///
  /// In en, this message translates to:
  /// **'Laylat al-Qadr is a night within Ramadan described in the Quran as better than a thousand months. The Prophet encouraged Muslims to seek it during the last ten nights of Ramadan, especially the odd-numbered nights. The 27th night is widely observed, but the guide does not present it as a date known with absolute certainty. Quran recitation, prayer, remembrance, repentance and supplication are appropriate ways to spend these nights.'**
  String get ramadanGuideLaylatQadrDesc;

  /// Source label for Laylat al-Qadr information
  ///
  /// In en, this message translates to:
  /// **'Source: Quran 97:1–5; Diyanet guidance on Laylat al-Qadr and the last ten nights of Ramadan.'**
  String get ramadanGuideLaylatQadrSource;

  /// Ramadan guide topic about Eid al-Fitr
  ///
  /// In en, this message translates to:
  /// **'Eid al-Fitr'**
  String get ramadanGuideEidTitle;

  /// Educational explanation of Eid al-Fitr
  ///
  /// In en, this message translates to:
  /// **'Eid al-Fitr follows the completion of Ramadan. Eid prayer is performed in congregation; detailed legal classifications and some practices differ between schools of law. Fitra may be given before Eid and giving it before the Eid prayer is recommended so that those in need can share in the occasion.'**
  String get ramadanGuideEidDesc;

  /// Source label for Eid al-Fitr information
  ///
  /// In en, this message translates to:
  /// **'Source: Din İşleri Yüksek Kurulu — Fıtır Sadakası and guidance on congregational Eid prayer.'**
  String get ramadanGuideEidSource;

  /// Heading for the Ramadan guide caution note
  ///
  /// In en, this message translates to:
  /// **'When personal guidance is needed'**
  String get ramadanGuideImportantNoteTitle;

  /// Caution note for health, personal circumstances and school-specific rulings
  ///
  /// In en, this message translates to:
  /// **'Health conditions, pregnancy, breastfeeding, travel, medicines and medical procedures can require individual assessment. For a personal health decision, consult a qualified healthcare professional; for a detailed religious ruling, consult a reliable religious authority. Differences between schools of law may also affect some details.'**
  String get ramadanGuideImportantNote;

  /// General source and scope note for Ramadan guidance
  ///
  /// In en, this message translates to:
  /// **'Primary religious reference: Presidency of Religious Affairs (Diyanet) and the High Board of Religious Affairs. This screen is a concise learning guide and does not replace an individual fatwa.'**
  String get ramadanGuideSourceNote;

  /// Title of the Qurban hub
  ///
  /// In en, this message translates to:
  /// **'Qurban'**
  String get qurbanTitle;

  /// Introduction shown in the Qurban hub
  ///
  /// In en, this message translates to:
  /// **'Learn the essential guidance for the udhiyah offered during Eid al-Adha, including eligibility, animals, shares, timing, proxy arrangements and distribution.'**
  String get qurbanIntro;

  /// Clarifies the scope of the Qurban hub
  ///
  /// In en, this message translates to:
  /// **'This section focuses on udhiyah offered during Eid al-Adha. Hajj-related hady, vows and other types of sacrifice have separate rulings.'**
  String get qurbanScopeNote;

  /// Title of the Qurban religious guide
  ///
  /// In en, this message translates to:
  /// **'Qurban Guide'**
  String get qurbanGuideTitle;

  /// Short description for Qurban guide navigation
  ///
  /// In en, this message translates to:
  /// **'Learn the essentials of udhiyah, eligible animals, shares, timing and proxy sacrifice.'**
  String get qurbanGuideMenuDesc;

  /// Introduction to the Qurban guide
  ///
  /// In en, this message translates to:
  /// **'A concise guide to the shared fundamentals of udhiyah during Eid al-Adha. Detailed rulings can differ between schools of law and personal circumstances.'**
  String get qurbanGuideIntro;

  /// Heading above the Qurban guide topics
  ///
  /// In en, this message translates to:
  /// **'Qurban Topics'**
  String get qurbanGuideTopicsTitle;

  /// Title of the meaning and purpose topic
  ///
  /// In en, this message translates to:
  /// **'Meaning and Purpose'**
  String get qurbanGuideMeaningTitle;

  /// Explanation of the meaning of udhiyah
  ///
  /// In en, this message translates to:
  /// **'Udhiyah is the sacrifice of an eligible animal during the specified days of Eid al-Adha as an act of worship seeking closeness to Allah. Its purpose is worship, gratitude and sharing rather than merely obtaining meat.'**
  String get qurbanGuideMeaningDesc;

  /// Title of the Qurban responsibility topic
  ///
  /// In en, this message translates to:
  /// **'Who Is Responsible?'**
  String get qurbanGuideResponsibilityTitle;

  /// High-level explanation of who may be responsible for udhiyah
  ///
  /// In en, this message translates to:
  /// **'The legal ruling differs among schools of law. In the Hanafi school, an adult, sane and resident Muslim who owns nisab beyond basic needs and debts is responsible for udhiyah. Most other jurists regard it as an emphasized Sunnah for those who are able to offer it.'**
  String get qurbanGuideResponsibilityDesc;

  /// Title of the eligible Qurban animals topic
  ///
  /// In en, this message translates to:
  /// **'Eligible Animals and Ages'**
  String get qurbanGuideAnimalsTitle;

  /// Explanation of eligible animals, age limits and health requirements
  ///
  /// In en, this message translates to:
  /// **'Udhiyah may be offered from sheep, goats, cattle, buffalo and camels. Based on lunar years, camels must normally be at least five years old, cattle and buffalo two, and sheep and goats one. A sheep that has completed six months may be eligible if it is as developed as a one-year-old sheep. The animal must also be healthy and free from defects that prevent its use for udhiyah.'**
  String get qurbanGuideAnimalsDesc;

  /// Title of the Qurban shares topic
  ///
  /// In en, this message translates to:
  /// **'Shares and Joint Qurban'**
  String get qurbanGuideSharesTitle;

  /// Explanation of individual and shared Qurban
  ///
  /// In en, this message translates to:
  /// **'A sheep or goat is offered for one person. Cattle, buffalo and camels may be shared by up to seven people, provided that each person\'s share is at least one seventh. The participants must join with an intention of worship.'**
  String get qurbanGuideSharesDesc;

  /// Title of the Qurban timing topic
  ///
  /// In en, this message translates to:
  /// **'Time of Sacrifice'**
  String get qurbanGuideTimeTitle;

  /// Explanation of the period in which udhiyah is offered
  ///
  /// In en, this message translates to:
  /// **'In the common Hanafi guidance used by the Presidency of Religious Affairs, the time for udhiyah begins after the Eid prayer on the first day and continues until sunset on the third day. In the Shafii school it may continue until sunset on the fourth day.'**
  String get qurbanGuideTimeDesc;

  /// Title of the proxy Qurban topic
  ///
  /// In en, this message translates to:
  /// **'Proxy and Donations'**
  String get qurbanGuideProxyTitle;

  /// Explanation of proxy sacrifice and the distinction from ordinary donations
  ///
  /// In en, this message translates to:
  /// **'A person may appoint another person or an organisation to purchase, sacrifice and distribute the animal on their behalf when the required proxy is given. Donating money without an eligible animal actually being sacrificed does not itself fulfil the udhiyah.'**
  String get qurbanGuideProxyDesc;

  /// Title of the Qurban meat distribution topic
  ///
  /// In en, this message translates to:
  /// **'Meat and Distribution'**
  String get qurbanGuideMeatTitle;

  /// General guidance for distributing Qurban meat
  ///
  /// In en, this message translates to:
  /// **'Sharing the meat between one\'s household, relatives or neighbours and people in need is recommended. Detailed distribution rules differ between schools of law. Meat, skin or other parts of the animal should not be used as payment for the slaughtering service.'**
  String get qurbanGuideMeatDesc;

  /// Title of the common Qurban misconceptions topic
  ///
  /// In en, this message translates to:
  /// **'Common Misconceptions'**
  String get qurbanGuideMisconceptionsTitle;

  /// Clarifies several common misconceptions about Qurban
  ///
  /// In en, this message translates to:
  /// **'Being unmarried does not prevent an eligible person from offering udhiyah. Shares in a large animal do not have to total an odd number such as three, five or seven. When an animal\'s age is reliably known, changing its front teeth is not an additional requirement.'**
  String get qurbanGuideMisconceptionsDesc;

  /// Madhhab and circumstance disclaimer for the Qurban guide
  ///
  /// In en, this message translates to:
  /// **'This guide provides shared fundamentals and brief orientation. Detailed rulings can vary by school of law, type of sacrifice and individual circumstances.'**
  String get qurbanGuideSchoolNote;

  /// Source note for Qurban religious guidance
  ///
  /// In en, this message translates to:
  /// **'Religious guidance is based primarily on information published by the Presidency of Religious Affairs and the High Board of Religious Affairs.'**
  String get qurbanGuideSourceNote;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
