import 'dart:ui';

// mapping.dart
class HitMapping {
  static Rect computeDrawRect(Size viewBox, Size widgetSize) {
    final vbW = viewBox.width;
    final vbH = viewBox.height;
    final ww = widgetSize.width;
    final wh = widgetSize.height;

    // flutter_svg default davranış: xMidYMid meet (oranı koru, ortala)
    final scale = (ww / vbW < wh / vbH) ? (ww / vbW) : (wh / vbH);
    final drawW = vbW * scale;
    final drawH = vbH * scale;
    final dx = (ww - drawW) / 2;
    final dy = (wh - drawH) / 2;
    return Rect.fromLTWH(dx, dy, drawW, drawH);
  }

  static Offset widgetToViewBox({
    required Offset localTap,
    required Size widgetSize,
    required Size viewBoxOrViewport,
  }) {
    final draw = computeDrawRect(viewBoxOrViewport, widgetSize);
    final nx = ((localTap.dx - draw.left) / draw.width).clamp(0.0, 1.0);
    final ny = ((localTap.dy - draw.top) / draw.height).clamp(0.0, 1.0);
    return Offset(nx * viewBoxOrViewport.width, ny * viewBoxOrViewport.height);
  }
}
