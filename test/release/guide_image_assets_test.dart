import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'All guide images and their screen references are bundled',
    () async {
      const requiredDirectories = <String>[
        'assets/images/eid_prayer',
        'assets/images/ghusl',
        'assets/images/hajj',
        'assets/images/prayer',
        'assets/images/qurban',
        'assets/images/umrah',
        'assets/images/wudu',
      ];

      const sourceFiles = <String>[
        'lib/features/guidance/presentation/screens/ghusl_guide_screen.dart',
        'lib/features/guidance/presentation/screens/prayer_guide_screen.dart',
        'lib/features/info/presentation/wudu_guide_screen.dart',
        'lib/features/hajj/presentation/screens/hajj_fundamentals_screen.dart',
        'lib/features/hajj/presentation/screens/hajj_days_screen.dart',
        'lib/features/hajj/presentation/screens/umrah_guide_screen.dart',
        'lib/features/qurban/presentation/screens/qurban_guide_screen.dart',
        'lib/features/qurban/presentation/screens/qurban_eid_guide_screen.dart',
      ];

      final manifest = await AssetManifest.loadFromAssetBundle(
        rootBundle,
      );

      final bundledAssets = manifest.listAssets().toSet();

      var checkedImages = 0;
      var checkedReferences = 0;

      for (final directoryPath in requiredDirectories) {
        final directory = Directory(directoryPath);

        expect(
          directory.existsSync(),
          isTrue,
          reason: 'Missing image directory: $directoryPath',
        );

        final images = directory
            .listSync()
            .whereType<File>()
            .where(
              (file) => file.path.toLowerCase().endsWith('.png'),
            )
            .toList();

        expect(
          images,
          isNotEmpty,
          reason: 'No PNG images found in $directoryPath',
        );

        for (final image in images) {
          final assetPath = image.path.replaceAll(
            '\\',
            '/',
          );

          expect(
            bundledAssets.contains(assetPath),
            isTrue,
            reason: 'Image not bundled: $assetPath',
          );

          checkedImages++;
        }
      }

      final imageReferencePattern = RegExp(
        r"imagePath:\s*'([^']+\.png)'",
      );

      for (final sourcePath in sourceFiles) {
        final sourceFile = File(sourcePath);

        expect(
          sourceFile.existsSync(),
          isTrue,
          reason: 'Missing guide source: $sourcePath',
        );

        final source = sourceFile.readAsStringSync();

        final matches = imageReferencePattern.allMatches(
          source,
        );

        for (final match in matches) {
          final referencedPath = match.group(1)!;

          final assetPath = referencedPath.startsWith('assets/')
              ? referencedPath
              : 'assets/$referencedPath';

          expect(
            File(assetPath).existsSync(),
            isTrue,
            reason: '$sourcePath references missing $assetPath',
          );

          expect(
            bundledAssets.contains(assetPath),
            isTrue,
            reason: '$sourcePath references unbundled $assetPath',
          );

          checkedReferences++;
        }
      }

      expect(
        checkedImages,
        greaterThanOrEqualTo(25),
      );

      expect(
        checkedReferences,
        greaterThanOrEqualTo(25),
      );
    },
  );
}
