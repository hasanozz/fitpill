// lib/in_exercise_page/mini_anatomy_heatmap.dart
import 'dart:async';

import 'package:fitpill/features/main_tabs/home/anatomy/anatomy_repository.dart'; // AnatomyRepository, AnatomySide
import 'package:fitpill/features/main_tabs/home/anatomy/muscle_region.dart'; // MuscleRegion (pointGroups + toPaths)
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Senin dosyaların:
import 'package:fitpill/features/main_tabs/home/anatomy/mapping.dart';

class MiniAnatomyHeatmap extends StatefulWidget {
  final AnatomySide side; // AnatomySide.front / AnatomySide.back
  final double width;
  final double height;

  /// Şimdilik SABİT—sonra provider’dan gelecek.
  final Map<String, int> activations;

  const MiniAnatomyHeatmap({
    super.key,
    required this.side,
    this.width = 110,
    this.height = 165,
    this.activations = const {
      'chest': 5,
      'anterior-deltoid': 3,
      'lateral-triceps': 3,
    },
  });

  @override
  State<MiniAnatomyHeatmap> createState() => _MiniAnatomyHeatmapState();
}

class _MiniAnatomyHeatmapState extends State<MiniAnatomyHeatmap> {
  final repo = AnatomyRepository();
  List<MuscleRegion>? _regions;
  String? _svgAsset;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final regions = await repo.loadRegions(widget.side);
    final svgAsset = repo.svgAssetOf(widget.side);
    if (!mounted) return;
    setState(() {
      _regions = regions;
      _svgAsset = svgAsset;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_regions == null || _svgAsset == null) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1) Arka plan: SENİN SVG – flutter_svg kendi içinde xMidYMid meet uygular
          SvgPicture.asset(
            _svgAsset!,
            fit: BoxFit.contain,
            allowDrawingOutsideViewBox: true,
          ),

          // 2) Üst katman: JSON → MuscleRegion → Path; aynı ölçek/merkezleme ile boya
          CustomPaint(
            painter: _HeatPainter(
              regions: _regions!,
              activations: widget.activations,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeatPainter extends CustomPainter {
  final List<MuscleRegion> regions;
  final Map<String, int> activations;

  _HeatPainter({
    required this.regions,
    required this.activations,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (regions.isEmpty) return;

    // Tüm bölgelerde viewBox AYNI; ilkinden alıyoruz.
    final vb = regions.first.viewBox;

    // Senin projedekiyle birebir: xMidYMid meet → uniform scale + center
    final draw = HitMapping.computeDrawRect(vb, size);

    canvas.save();
    canvas.translate(draw.left, draw.top);
    canvas.scale(draw.width / vb.width, draw.height / vb.height);

    // Aktivasyonları boya
    for (final r in regions) {
      final lvl = activations[r.id] ?? 0;
      if (lvl <= 0) continue;

      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color = _colorForActivation(lvl);

      // Bir bölge birden fazla polygon içerebilir → hepsini boya
      for (final path in r.toPaths()) {
        canvas.drawPath(path, paint);
      }
    }

    canvas.restore();
  }

  // Aynı renk skalası (şeffaf→sarı→turuncu→kırmızı)
  Color _colorForActivation(int level) {
    switch (level.clamp(0, 5)) {
      case 1:
        return const Color(0x66ADFF2F);
      case 2:
        return const Color(0x66FFFF00);
      case 3:
        return const Color(0x66FFA500);
      case 4:
        return const Color(0x66FF0000);
      case 5:
        return const Color(0x66800000);
      default:
        return const Color(0x00000000);
    }
  }

  @override
  bool shouldRepaint(covariant _HeatPainter old) =>
      old.regions != regions || old.activations != activations;
}
