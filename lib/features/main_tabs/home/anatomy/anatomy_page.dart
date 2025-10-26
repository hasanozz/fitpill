// pages/anatomy_page.dart
import 'package:fitpill/features/main_tabs/exercises/exercises_screen.dart';
import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'anatomy_providers.dart';
import 'anatomy_repository.dart';
import 'mapping.dart';
import 'muscle_region.dart';

class AnatomyPage extends ConsumerWidget {
  const AnatomyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(anatomyProvider);
    final notifier = ref.read(anatomyProvider.notifier);
    final svgAsset = ref.read(anatomyRepositoryProvider).svgAssetOf(state.side);

    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);

          return Stack(
            children: [
              // 1) Ana SVG
              Positioned.fill(
                child: SvgPicture.asset(
                  svgAsset,
                  fit: BoxFit.contain,
                ),
              ),

              // 2) Flash overlay (CustomPaint)
              if (state.regions is AsyncData<List<MuscleRegion>>)
                Positioned.fill(
                  child: CustomPaint(
                    painter: _FlashPainter(
                      regions: (state.regions as AsyncData<List<MuscleRegion>>)
                          .value,
                      flashId: state.flashRegionId,
                      widgetSize: size,
                    ),
                  ),
                ),

              // 3) Tap yakalayıcı
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown: (d) async {
                    final hit = await notifier.onTap(d.localPosition, size);

                    if (hit == null) return;
                    final r = notifier.regionById(hit);
                    if (r == null) return;

                    if (context.mounted) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const ExercisesPage()));
                    }
                  },
                ),
              ),

              // 4) Sağ altta pasif preview (side toggle için tıklanabilir yapmak istersen buton koy)
              Positioned(
                right: 0,
                bottom: 12,
                child: Opacity(
                  opacity: 0.5,
                  child: GestureDetector(
                    onTap: () =>
                        ref.read(anatomyProvider.notifier).toggleSide(),
                    child: SizedBox(
                      width: 100,
                      height: 130,
                      child: SvgPicture.asset(
                        ref.read(anatomyRepositoryProvider).svgAssetOf(
                            state.side == AnatomySide.front
                                ? AnatomySide.back
                                : AnatomySide.front),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FlashPainter extends CustomPainter {
  final List<MuscleRegion> regions;
  final String? flashId;
  final Size widgetSize;

  _FlashPainter({
    required this.regions,
    required this.flashId,
    required this.widgetSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (flashId == null) return;

    final region = regions.firstWhere(
      (e) => e.id == flashId,
      orElse: () => regions.first,
    );

    final draw = HitMapping.computeDrawRect(region.viewBox, widgetSize);
    canvas.save();
    canvas.translate(draw.left, draw.top);
    canvas.scale(
      draw.width / region.viewBox.width,
      draw.height / region.viewBox.height,
    );

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFFF0000).withAlpha(100);

    // TÜM grupları (çoklu poligon) boya
    for (final path in region.toPaths()) {
      canvas.drawPath(path, paint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _FlashPainter old) =>
      old.flashId != flashId ||
      old.widgetSize != widgetSize ||
      old.regions != regions;
}
