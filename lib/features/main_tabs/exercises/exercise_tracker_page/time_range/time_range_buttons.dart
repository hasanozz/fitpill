import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'time_range_provider.dart';

Widget buildTimeRangeButton({
  required BuildContext context,
  required String label,
  required bool isSelected,
  required VoidCallback onPressed,
}) {
  return TextButton(
    onPressed: onPressed,
    style: TextButton.styleFrom(
      backgroundColor: isSelected
          ? ThemeHelper.getFitPillColor(context).withValues(alpha: 0.6)
          : Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      foregroundColor: isSelected
          ? (ThemeHelper.isDarkTheme(context)
              ? const Color(0xFF181818)
              : Colors.white)
          : (ThemeHelper.isDarkTheme(context)
              ? Colors.white
              : const Color(0xFF181818)),
    ),
    child: Text(label),
  );
}

class TimeRangeRow extends ConsumerWidget {
  const TimeRangeRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedRangeProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (final r in TimeRange.values)
          buildTimeRangeButton(
            context: context,
            label: r.label,
            isSelected: selected == r,
            onPressed: () => ref.read(selectedRangeProvider.notifier).state = r,
          ),
      ],
    );
  }
}
