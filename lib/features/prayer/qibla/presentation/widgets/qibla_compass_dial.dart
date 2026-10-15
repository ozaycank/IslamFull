import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A device-relative Qibla dial: the phone's top edge is always at 12 o'clock.
/// Both the compass rose and Qibla arrow rotate relative to the sensor heading.
class QiblaCompassDial extends StatelessWidget {
  final double headingDegrees;
  final double relativeQiblaAngle;
  final bool isAligned;
  final String northLabel;
  final String eastLabel;
  final String southLabel;
  final String westLabel;

  const QiblaCompassDial({
    super.key,
    required this.headingDegrees,
    required this.relativeQiblaAngle,
    required this.isAligned,
    required this.northLabel,
    required this.eastLabel,
    required this.southLabel,
    required this.westLabel,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = math.min(280.0, constraints.maxWidth);
        return Center(
          child: SizedBox.square(
            dimension: size,
            child: CustomPaint(
              painter: _QiblaCompassPainter(
                headingDegrees: headingDegrees,
                relativeQiblaAngle: relativeQiblaAngle,
                indicatorColor: isAligned ? scheme.primary : scheme.secondary,
                backgroundColor: scheme.surfaceContainerLow,
                ringColor: scheme.outlineVariant,
                labelColor: scheme.onSurface,
                centerColor: scheme.primary,
                northLabel: northLabel,
                eastLabel: eastLabel,
                southLabel: southLabel,
                westLabel: westLabel,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _QiblaCompassPainter extends CustomPainter {
  final double headingDegrees;
  final double relativeQiblaAngle;
  final Color indicatorColor;
  final Color backgroundColor;
  final Color ringColor;
  final Color labelColor;
  final Color centerColor;
  final String northLabel;
  final String eastLabel;
  final String southLabel;
  final String westLabel;

  const _QiblaCompassPainter({
    required this.headingDegrees,
    required this.relativeQiblaAngle,
    required this.indicatorColor,
    required this.backgroundColor,
    required this.ringColor,
    required this.labelColor,
    required this.centerColor,
    required this.northLabel,
    required this.eastLabel,
    required this.southLabel,
    required this.westLabel,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 7;

    canvas.drawCircle(
      center,
      radius,
      Paint()..color = backgroundColor,
    );
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = ringColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Directions are relative to the phone top edge (12 o'clock).
    for (var i = 0; i < 24; i++) {
      final angle = (i * 15 - headingDegrees) * math.pi / 180;
      final direction = Offset(math.sin(angle), -math.cos(angle));
      final cardinal = i % 6 == 0;
      final innerRadius = radius * (cardinal ? 0.83 : 0.90);
      canvas.drawLine(
        center + direction * innerRadius,
        center + direction * (radius * 0.95),
        Paint()
          ..color = ringColor
          ..strokeWidth = cardinal ? 2.7 : 1.3
          ..strokeCap = StrokeCap.round,
      );
    }

    final cardinalLabels = [
      northLabel,
      eastLabel,
      southLabel,
      westLabel,
    ];
    for (var i = 0; i < cardinalLabels.length; i++) {
      final angle = (i * 90 - headingDegrees) * math.pi / 180;
      final centerOfLabel =
          center + Offset(math.sin(angle), -math.cos(angle)) * (radius * 0.69);
      final textPainter = TextPainter(
        text: TextSpan(
          text: cardinalLabels[i],
          style: TextStyle(
            fontSize: math.max(12.0, radius * 0.11),
            fontWeight: FontWeight.w700,
            color: i == 0 ? indicatorColor : labelColor,
          ),
        ),
        textDirection: TextDirection.ltr,
        maxLines: 1,
      )..layout();
      textPainter.paint(
        canvas,
        centerOfLabel - Offset(textPainter.width / 2, textPainter.height / 2),
      );
    }

    // The pointer is relative to geographic Qibla bearing and sensor heading.
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(relativeQiblaAngle * math.pi / 180);
    final arrow = Path()
      ..moveTo(0, -radius * 0.58)
      ..lineTo(radius * 0.13, -radius * 0.08)
      ..lineTo(0, -radius * 0.18)
      ..lineTo(-radius * 0.13, -radius * 0.08)
      ..close();
    canvas.drawPath(arrow, Paint()..color = indicatorColor);
    canvas.restore();

    canvas.drawCircle(center, radius * 0.08, Paint()..color = centerColor);
    canvas.drawCircle(
      center,
      radius * 0.03,
      Paint()..color = backgroundColor,
    );

    // Fixed 12-o'clock marker indicates the physical top of the phone.
    final topMarker = Path()
      ..moveTo(center.dx, center.dy - radius * 0.99)
      ..lineTo(center.dx - radius * 0.06, center.dy - radius * 1.08)
      ..lineTo(center.dx + radius * 0.06, center.dy - radius * 1.08)
      ..close();
    canvas.drawPath(topMarker, Paint()..color = centerColor);
  }

  @override
  bool shouldRepaint(covariant _QiblaCompassPainter oldDelegate) {
    return oldDelegate.headingDegrees != headingDegrees ||
        oldDelegate.relativeQiblaAngle != relativeQiblaAngle ||
        oldDelegate.indicatorColor != indicatorColor ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.ringColor != ringColor ||
        oldDelegate.labelColor != labelColor ||
        oldDelegate.centerColor != centerColor ||
        oldDelegate.northLabel != northLabel ||
        oldDelegate.eastLabel != eastLabel ||
        oldDelegate.southLabel != southLabel ||
        oldDelegate.westLabel != westLabel;
  }
}
