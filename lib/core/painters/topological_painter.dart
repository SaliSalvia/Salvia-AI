import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class TopologicalPainter extends CustomPainter {
  final double animationValue;
  ui.Picture? _cachedPicture;
  Size? _cachedSize;

  TopologicalPainter({this.animationValue = 0});

  @override
  void paint(Canvas canvas, Size size) {
    if (_cachedPicture == null || _cachedSize != size) {
      _cachedPicture = _renderToPicture(size);
      _cachedSize = size;
    }
    canvas.drawPicture(_cachedPicture!);
  }

  ui.Picture _renderToPicture(Size size) {
    final recorder = ui.PictureRecorder();
    final c = Canvas(recorder);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;

    const lines = 18;
    for (int i = 0; i < lines; i++) {
      final t = i / lines;
      final phase = t * math.pi * 2 + animationValue;
      final path = Path();
      for (double x = 0; x <= size.width; x += 2) {
        final normalizedX = x / size.width;
        final y = size.height * (0.1 + 0.8 * t) +
            math.sin(normalizedX * math.pi * 3 + phase) * 30 +
            math.cos(normalizedX * math.pi * 5 + phase * 0.7) * 12;
        if (x == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      final opacity = (0.04 + 0.06 * math.sin(t * math.pi)).clamp(0.0, 1.0);
      paint.color = AppColors.primary.withAlpha((opacity * 255).round());
      c.drawPath(path, paint);
    }
    return recorder.endRecording();
  }

  @override
  bool shouldRepaint(TopologicalPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
