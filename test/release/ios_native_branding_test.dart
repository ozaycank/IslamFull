import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('iOS native branding', () {
    test('AppIcon catalog contains valid opaque IslamFull icons', () {
      const catalogPath =
          'ios/Runner/Assets.xcassets/AppIcon.appiconset/Contents.json';

      final catalog = jsonDecode(
        File(catalogPath).readAsStringSync(),
      ) as Map<String, dynamic>;

      final entries = (catalog['images'] as List<dynamic>)
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();

      expect(entries, isNotEmpty);

      final marketingIcons =
          entries.where((entry) => entry['idiom'] == 'ios-marketing').toList();

      expect(marketingIcons, hasLength(1));

      for (final entry in entries) {
        final filename = entry['filename'] as String;
        final dimensions = (entry['size'] as String).split('x');
        final scale = double.parse(
          (entry['scale'] as String).replaceAll('x', ''),
        );

        final expectedWidth = (double.parse(dimensions[0]) * scale).round();

        final expectedHeight = (double.parse(dimensions[1]) * scale).round();

        _expectPng(
          'ios/Runner/Assets.xcassets/AppIcon.appiconset/$filename',
          expectedWidth,
          expectedHeight,
          expectedColorType: 2,
        );
      }

      final marketingIcon = marketingIcons.single;

      expect(
        marketingIcon['filename'],
        'Icon-App-1024x1024@1x.png',
      );

      _expectPng(
        'ios/Runner/Assets.xcassets/AppIcon.appiconset/'
        'Icon-App-1024x1024@1x.png',
        1024,
        1024,
        expectedColorType: 2,
      );
    });

    test('LaunchImage assets are real branded images, not placeholders', () {
      const catalogPath =
          'ios/Runner/Assets.xcassets/LaunchImage.imageset/Contents.json';

      final catalog = jsonDecode(
        File(catalogPath).readAsStringSync(),
      ) as Map<String, dynamic>;

      final entries = (catalog['images'] as List<dynamic>)
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();

      expect(entries, hasLength(3));

      const expectedDimensions = <String, int>{
        '1x': 180,
        '2x': 360,
        '3x': 540,
      };

      for (final entry in entries) {
        final scale = entry['scale'] as String;
        final filename = entry['filename'] as String;
        final dimension = expectedDimensions[scale];

        expect(dimension, isNotNull);

        _expectPng(
          'ios/Runner/Assets.xcassets/LaunchImage.imageset/$filename',
          dimension!,
          dimension,
          expectedColorType: 6,
        );
      }
    });

    test('LaunchScreen references the branded image and matching background',
        () {
      final storyboard = File(
        'ios/Runner/Base.lproj/LaunchScreen.storyboard',
      ).readAsStringSync();

      expect(storyboard, contains('image="LaunchImage"'));
      expect(storyboard, contains('red="0.9686"'));
      expect(storyboard, contains('green="0.9804"'));
      expect(storyboard, contains('blue="0.9608"'));
      expect(storyboard, contains('contentMode="scaleAspectFit"'));
    });

    test('iOS app identity and AppIcon catalog remain configured', () {
      final infoPlist = File(
        'ios/Runner/Info.plist',
      ).readAsStringSync();

      final project = File(
        'ios/Runner.xcodeproj/project.pbxproj',
      ).readAsStringSync();

      expect(
        RegExp(
          r'<key>CFBundleDisplayName</key>\s*<string>IslamFull</string>',
        ).hasMatch(infoPlist),
        isTrue,
      );

      expect(
        project,
        contains(
          'PRODUCT_BUNDLE_IDENTIFIER = com.ozaycank.islamfull;',
        ),
      );

      expect(
        project,
        contains(
          'ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;',
        ),
      );

      expect(
        project,
        contains('IPHONEOS_DEPLOYMENT_TARGET = 13.0;'),
      );
    });
  });
}

void _expectPng(
  String path,
  int expectedWidth,
  int expectedHeight, {
  required int expectedColorType,
}) {
  final file = File(path);

  expect(
    file.existsSync(),
    isTrue,
    reason: 'Missing iOS image: $path',
  );

  final bytes = file.readAsBytesSync();

  expect(
    bytes.length,
    greaterThan(64),
    reason: 'Image is empty or too small: $path',
  );

  expect(
    bytes.sublist(0, 8),
    <int>[137, 80, 78, 71, 13, 10, 26, 10],
    reason: 'Invalid PNG signature: $path',
  );

  final header = ByteData.sublistView(bytes);

  expect(
    header.getUint32(16, Endian.big),
    expectedWidth,
    reason: 'Unexpected image width: $path',
  );

  expect(
    header.getUint32(20, Endian.big),
    expectedHeight,
    reason: 'Unexpected image height: $path',
  );

  expect(
    header.getUint8(25),
    expectedColorType,
    reason: 'Unexpected PNG color type: $path',
  );
}
