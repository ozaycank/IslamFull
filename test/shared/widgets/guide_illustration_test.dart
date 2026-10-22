import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:islamfull/shared/widgets/guide_illustration.dart';

void main() {
  testWidgets(
    'missing optional illustration does not break the screen',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: GuideIllustration(
                imagePath: 'images/not-found/guide-image.png',
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        tester.takeException(),
        isNull,
      );
    },
  );

  testWidgets(
    'empty illustration path collapses safely',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GuideIllustration(
              imagePath: '',
            ),
          ),
        ),
      );

      expect(
        find.byType(Image),
        findsNothing,
      );

      expect(
        tester.takeException(),
        isNull,
      );
    },
  );

  testWidgets(
    'guide illustration resolves legacy image paths to bundled assets',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: GuideIllustration(
                imagePath: 'images/wudu/step1.png',
              ),
            ),
          ),
        ),
      );

      final image = tester.widget<Image>(
        find.byType(Image),
      );

      expect(
        image.image,
        isA<AssetImage>(),
      );

      expect(
        (image.image as AssetImage).assetName,
        'assets/images/wudu/step1.png',
      );

      await tester.pumpAndSettle();

      expect(
        tester.takeException(),
        isNull,
      );
    },
  );
}
