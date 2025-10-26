// import 'dart:ui';
//
// class MuscleRegion {
//   final String id;
//   final List<Offset>
//       points; // JSON 'points' string'inden parse edilmiş piksel noktaları
//   final Size viewBox; // JSON viewBox (w,h) -> ölçek eşlemede kullanacağız
//
//   const MuscleRegion({
//     required this.id,
//     required this.points,
//     required this.viewBox,
//   });
//
//   factory MuscleRegion.fromJson(Map<String, dynamic> map) {
//     final vb = map['__viewBox__']
//         as Map<String, dynamic>; // Repo parse ederken enjekte edeceğiz
//     final w = (vb['w'] as num).toDouble();
//     final h = (vb['h'] as num).toDouble();
//
//     final raw = (map['points'] as String).trim().split(RegExp(r'\s+'));
//     final pts = <Offset>[];
//     for (int i = 0; i < raw.length - 1; i += 2) {
//       final x = double.parse(raw[i]);
//       final y = double.parse(raw[i + 1]);
//       pts.add(Offset(x, y));
//     }
//     return MuscleRegion(
//       id: map['id'] as String,
//       points: pts,
//       viewBox: Size(w, h),
//     );
//   }
// }

import 'dart:ui';

class MuscleRegion {
  final String id;
  final String name;
  final List<List<Offset>> pointGroups;
  final Size viewBox;

  // Lazy cache (ilk erişimde hesaplanır)
  List<Path>? _paths;
  List<Rect>? _bounds;

  // NOT const: cache kullanacağız
  MuscleRegion({
    required this.id,
    required this.name,
    required this.pointGroups,
    required this.viewBox,
  });

  factory MuscleRegion.fromJson(Map<String, dynamic> map) {
    final vb = map['__viewBox__'] as Map<String, dynamic>;
    final w = (vb['w'] as num).toDouble();
    final h = (vb['h'] as num).toDouble();

    List<List<Offset>> groups;
    if (map['pointGroups'] != null) {
      final groupsRaw = (map['pointGroups'] as List).cast<String>();
      groups = groupsRaw.map(_parsePointsString).toList();
    } else {
      groups = [_parsePointsString(map['points'] as String)];
    }

    return MuscleRegion(
      id: map['id'] as String,
      name: (map['name'] as String?) ?? (map['id'] as String),
      pointGroups: groups,
      viewBox: Size(w, h),
    );
  }

  // ---- helpers ----
  static List<Offset> _parsePointsString(String s) {
    final raw = s.trim().split(RegExp(r'\s+'));
    final pts = <Offset>[];
    for (int i = 0; i + 1 < raw.length; i += 2) {
      final x = double.parse(raw[i]);
      final y = double.parse(raw[i + 1]);
      pts.add(Offset(x, y));
    }
    return pts;
  }

  static Path _buildPath(List<Offset> pg) {
    final p = Path()..moveTo(pg.first.dx, pg.first.dy);
    for (int i = 1; i < pg.length; i++) {
      p.lineTo(pg[i].dx, pg[i].dy);
    }
    p.close();
    return p;
  }

  static Rect _computeBounds(List<Offset> pg) {
    double minX = pg.first.dx,
        maxX = pg.first.dx,
        minY = pg.first.dy,
        maxY = pg.first.dy;
    for (final o in pg) {
      if (o.dx < minX) minX = o.dx;
      if (o.dx > maxX) maxX = o.dx;
      if (o.dy < minY) minY = o.dy;
      if (o.dy > maxY) maxY = o.dy;
    }
    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }

  // ---- public API (mevcut imzaları bozmadan) ----
  List<Path> toPaths() {
    _paths ??= pointGroups.map(_buildPath).toList();
    return _paths!;
  }

  List<Rect> groupBounds() {
    _bounds ??= pointGroups.map(_computeBounds).toList();
    return _bounds!;
  }
}
