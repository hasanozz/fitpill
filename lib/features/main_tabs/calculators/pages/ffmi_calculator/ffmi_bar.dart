import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:flutter/material.dart';

class FFMIBar extends StatelessWidget {
  final double min;
  final double max;
  final double value;

  const FFMIBar({
    super.key,
    required this.min,
    required this.max,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final barWidth = screenWidth;
    const barHeight = 5.0;
    const iconWidth = 34;

    final clampedValue = value.clamp(min, max);
    final percent = (clampedValue - min) / (max - min);
    final arrowOffset =
        ((percent * barWidth).clamp(iconWidth / 2, barWidth - iconWidth / 2));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Ok + bar aynı stack içinde
        Stack(
          clipBehavior: Clip.none,
          children: [
            // Gradient bar
            Container(
              width: barWidth,
              height: barHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: const LinearGradient(
                  colors: [Colors.green, Colors.yellow, Colors.red],
                ),
              ),
            ),
            // Ok işareti üstte
            Positioned(
              bottom: barHeight - iconWidth / 2,
              left: arrowOffset - iconWidth,
              child: Icon(
                Icons.arrow_drop_down,
                size: 34,
                color: ThemeHelper.getTextColor(context),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
