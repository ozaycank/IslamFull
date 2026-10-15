import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('IslamFull branded assets are included in source tree', () {
    const paths = [
      'assets/branding/islamfull_app_icon.svg',
      'assets/branding/islamfull_mark.svg',
      'web/favicon.png',
      'web/icons/Icon-192.png',
      'web/icons/Icon-512.png',
      'web/icons/Icon-maskable-192.png',
      'web/icons/Icon-maskable-512.png',
    ];
    for (final path in paths) {
      expect(File(path).existsSync(), isTrue, reason: 'Missing asset: $path');
    }
  });

  test('Web theme and package branding are consistent', () {
    final manifest = File('web/manifest.json').readAsStringSync();
    final pubspec = File('pubspec.yaml').readAsStringSync();
    expect(manifest, contains('"name": "IslamFull"'));
    expect(manifest, contains('"theme_color": "#1B5E20"'));
    expect(pubspec, contains('assets/branding/islamfull_app_icon.svg'));
  });
}
