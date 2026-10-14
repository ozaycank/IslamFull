import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'Android disables application backup and references explicit rules',
    () {
      final manifest = File(
        'android/app/src/main/AndroidManifest.xml',
      ).readAsStringSync();

      expect(
        manifest,
        contains(
          'android:allowBackup="false"',
        ),
      );

      expect(
        manifest,
        contains(
          'android:fullBackupContent="@xml/backup_rules"',
        ),
      );

      expect(
        manifest,
        contains(
          'android:dataExtractionRules="@xml/data_extraction_rules"',
        ),
      );
    },
  );

  test(
    'Android extraction rules exclude cloud and device transfer data',
    () {
      final legacyRules = File(
        'android/app/src/main/res/xml/backup_rules.xml',
      ).readAsStringSync();

      final extractionRules = File(
        'android/app/src/main/res/xml/data_extraction_rules.xml',
      ).readAsStringSync();

      expect(
        legacyRules,
        contains(
          '<exclude domain="sharedpref" path="."',
        ),
      );

      expect(
        extractionRules,
        contains(
          '<cloud-backup>',
        ),
      );

      expect(
        extractionRules,
        contains(
          '<device-transfer>',
        ),
      );

      expect(
        extractionRules,
        contains(
          '<exclude domain="sharedpref" path="."',
        ),
      );

      expect(
        extractionRules,
        contains(
          '<exclude domain="device_sharedpref" path="."',
        ),
      );
    },
  );

  test(
    'Android requests foreground location but not background location',
    () {
      final manifest = File(
        'android/app/src/main/AndroidManifest.xml',
      ).readAsStringSync();

      expect(
        manifest,
        contains(
          'android.permission.ACCESS_COARSE_LOCATION',
        ),
      );

      expect(
        manifest,
        contains(
          'android.permission.ACCESS_FINE_LOCATION',
        ),
      );

      expect(
        manifest,
        isNot(
          contains(
            'android.permission.ACCESS_BACKGROUND_LOCATION',
          ),
        ),
      );
    },
  );

  test(
    'iOS declares only when-in-use location purpose',
    () {
      final infoPlist = File(
        'ios/Runner/Info.plist',
      ).readAsStringSync();

      expect(
        infoPlist,
        contains(
          'NSLocationWhenInUseUsageDescription',
        ),
      );

      expect(
        infoPlist,
        contains(
          'Qibla direction',
        ),
      );

      expect(
        infoPlist,
        isNot(
          contains(
            'NSLocationAlwaysAndWhenInUseUsageDescription',
          ),
        ),
      );
    },
  );

  test(
    'bundled Flutter assets do not contain a dotenv file',
    () {
      final pubspec = File('pubspec.yaml').readAsStringSync();
      expect(pubspec, isNot(contains('    - .env')));
      expect(pubspec, isNot(contains('flutter_dotenv:')));
    },
  );

  test(
    'iOS app-level privacy manifest is bundled by Runner target',
    () {
      final manifest = File(
        'ios/Runner/PrivacyInfo.xcprivacy',
      ).readAsStringSync();
      final project = File(
        'ios/Runner.xcodeproj/project.pbxproj',
      ).readAsStringSync();
      expect(manifest, contains('NSPrivacyTracking'));
      expect(manifest, contains('NSPrivacyCollectedDataTypes'));
      expect(manifest, contains('NSPrivacyAccessedAPITypes'));
      expect(project, contains('PrivacyInfo.xcprivacy in Resources'));
    },
  );

  test(
    'iOS location permission has English and Turkish purpose strings',
    () {
      final en = File(
        'ios/Runner/en.lproj/InfoPlist.strings',
      ).readAsStringSync();
      final tr = File(
        'ios/Runner/tr.lproj/InfoPlist.strings',
      ).readAsStringSync();
      final project = File(
        'ios/Runner.xcodeproj/project.pbxproj',
      ).readAsStringSync();
      expect(en, contains('NSLocationWhenInUseUsageDescription'));
      expect(tr, contains('NSLocationWhenInUseUsageDescription'));
      expect(project, contains('InfoPlist.strings in Resources'));
    },
  );

  test(
    'published Turkish notice covers local religious progress and contact',
    () {
      final notice = File('docs/privacy-tr.html').readAsStringSync();
      expect(notice, contains('religious-progress-v2'));
      expect(notice, contains('islamfull.app@gmail.com'));
      expect(notice, contains('Yeni Müslüman Yolculuğu'));
      expect(notice, contains('OpenStreetMap Nominatim'));
    },
  );
}
