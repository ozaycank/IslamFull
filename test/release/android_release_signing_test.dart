import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Android release signing configuration', () {
    test('release build uses a dedicated release signing config', () {
      final gradleFile = File(
        'android/app/build.gradle.kts',
      ).readAsStringSync();

      expect(
        gradleFile,
        contains('rootProject.file("key.properties")'),
      );

      expect(
        gradleFile,
        contains('create("release")'),
      );

      expect(
        gradleFile,
        contains(
          'signingConfig = signingConfigs.getByName("release")',
        ),
      );

      expect(
        gradleFile,
        isNot(
          contains(
            'signingConfig = signingConfigs.getByName("debug")',
          ),
        ),
      );
    });

    test('release signing fails clearly when configuration is missing', () {
      final gradleFile = File(
        'android/app/build.gradle.kts',
      ).readAsStringSync();

      expect(
        gradleFile,
        contains('if (releaseTaskRequested)'),
      );

      expect(
        gradleFile,
        contains('Release signing is not configured.'),
      );

      expect(
        gradleFile,
        contains('Missing required entries in android/key.properties'),
      );

      expect(
        gradleFile,
        contains('The release keystore file does not exist'),
      );
    });

    test('release signing secrets are excluded from version control', () {
      final gitignore = File('.gitignore').readAsStringSync();

      expect(
        gitignore,
        contains('android/key.properties'),
      );

      expect(
        gitignore,
        contains('*.jks'),
      );

      expect(
        gitignore,
        contains('*.keystore'),
      );
    });
  });
}
