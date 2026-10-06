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
    if (imagePath.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.asset(
        imagePath,
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
          // Illustrations supplement the text. Missing optional assets must
          // never make religious guidance unavailable or break layout.
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
