import 'package:flutter/material.dart';

class GuideIllustration extends StatelessWidget {
  final String imagePath;
  final BorderRadius borderRadius;

  const GuideIllustration({
    super.key,
    required this.imagePath,
    this.borderRadius = const BorderRadius.all(
      Radius.circular(12),
    ),
  });

  @override
  Widget build(BuildContext context) {
    final normalizedPath = imagePath.trim();

    if (normalizedPath.isEmpty) {
      return const SizedBox.shrink();
    }

    // Existing guide screens use paths such as images/wudu/step1.png.
    // The Flutter asset bundle uses assets/images/wudu/step1.png.
    final assetPath = normalizedPath.startsWith('images/')
        ? 'assets/$normalizedPath'
        : normalizedPath;

    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.asset(
        assetPath,
        width: double.infinity,
        fit: BoxFit.fitWidth,
        alignment: Alignment.topCenter,
        filterQuality: FilterQuality.medium,
        excludeFromSemantics: true,
        errorBuilder: (
          context,
          error,
          stackTrace,
        ) {
          // Illustrations supplement the text. Missing optional assets
          // must not make religious guidance unavailable or break layout.
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
