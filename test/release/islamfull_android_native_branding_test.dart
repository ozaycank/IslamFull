import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Android legacy icons use all five required densities', () {
    const sizes = <String, int>{
      'mdpi': 48,
      'hdpi': 72,
      'xhdpi': 96,
      'xxhdpi': 144,
      'xxxhdpi': 192,
    };

    for (final entry in sizes.entries) {
      final path =
          'android/app/src/main/res/mipmap-${entry.key}/ic_launcher.png';

      final file = File(path);

      expect(
        file.existsSync(),
        isTrue,
        reason: path,
      );

      final bytes = file.readAsBytesSync();

      expect(
        bytes.length,
        greaterThan(100),
      );

      final header = ByteData.sublistView(bytes);

      expect(
        header.getUint32(0),
        0x89504E47,
        reason: path,
      );

      expect(
        header.getUint32(16),
        entry.value,
        reason: path,
      );

      expect(
        header.getUint32(20),
        entry.value,
        reason: path,
      );
    }
  });

  test('Android adaptive icon and launch screens use IslamFull resources', () {
    const root = 'android/app/src/main/res';

    final manifest =
        File('android/app/src/main/AndroidManifest.xml').readAsStringSync();

    expect(
      manifest,
      contains('android:icon="@mipmap/ic_launcher"'),
    );

    final adaptive =
        File('$root/mipmap-anydpi-v26/ic_launcher.xml').readAsStringSync();

    expect(
      adaptive,
      contains('@color/islamfull_icon_background'),
    );

    expect(
      adaptive,
      contains('@drawable/islamfull_launcher_foreground'),
    );

    expect(
      adaptive,
      contains('@drawable/islamfull_launcher_monochrome'),
    );

    expect(
      File('$root/drawable-nodpi/islamfull_launcher_foreground.png')
          .existsSync(),
      isTrue,
    );

    expect(
      File('$root/drawable-nodpi/islamfull_launcher_monochrome.png')
          .existsSync(),
      isTrue,
    );

    expect(
      File('$root/drawable-nodpi/islamfull_splash_icon.png').existsSync(),
      isTrue,
    );

    for (final qualifier in <String>[
      'drawable',
      'drawable-v21',
    ]) {
      final xml =
          File('$root/$qualifier/launch_background.xml').readAsStringSync();

      expect(
        xml,
        contains('@drawable/islamfull_splash_logo'),
      );

      expect(
        xml,
        contains('@drawable/islamfull_splash_background'),
      );
    }

    for (final qualifier in <String>[
      'values-v31',
      'values-night-v31',
    ]) {
      final xml = File('$root/$qualifier/styles.xml').readAsStringSync();

      expect(
        xml,
        contains('android:windowSplashScreenAnimatedIcon'),
      );

      expect(
        xml,
        contains('@drawable/islamfull_splash_icon'),
      );
    }

    final colors = File('$root/values/islamfull_colors.xml').readAsStringSync();

    expect(
      colors,
      contains('#1B5E20'),
    );
  });
}
