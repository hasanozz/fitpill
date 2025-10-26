import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitpill/generated/l10n/l10n.dart';

class WorkoutDetailsPage extends ConsumerStatefulWidget {
  final String routineId;
  final String workoutId;
  final String workoutName;

  const WorkoutDetailsPage({
    super.key,
    required this.routineId,
    required this.workoutId,
    required this.workoutName,
  });

  @override
  ConsumerState<WorkoutDetailsPage> createState() => _WorkoutDetailsPageState();
}

class _WorkoutDetailsPageState extends ConsumerState<WorkoutDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: ThemeHelper.getBackgroundColor(context),
        title: Text(widget.workoutName),
      ),
      body: Stack(
        children: [
          const SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 100),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Divider(
                    height: 0.5,
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 180,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeHelper.isDarkTheme(context)
                        ? Colors.orange
                        : const Color(0xFF0D47A1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    S.of(context)!.addExercise,
                    style: TextStyle(
                      fontSize: 16,
                      color: ThemeHelper.getBackgroundColor(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
