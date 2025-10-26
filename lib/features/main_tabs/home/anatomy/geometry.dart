import 'dart:ui';

bool pointInPolygon(Offset p, List<Offset> polygon) {
  // Ray casting (even-odd) – robust ve hızlıdır.
  bool inside = false;
  for (int i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
    final xi = polygon[i].dx, yi = polygon[i].dy;
    final xj = polygon[j].dx, yj = polygon[j].dy;
    final intersect = ((yi > p.dy) != (yj > p.dy)) &&
        (p.dx < (xj - xi) * (p.dy - yi) / (yj - yi + 0.0000001) + xi);
    if (intersect) inside = !inside;
  }
  return inside;
}
