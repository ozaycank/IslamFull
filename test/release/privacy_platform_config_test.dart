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
}
