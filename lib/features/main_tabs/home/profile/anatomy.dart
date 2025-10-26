import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:flutter_svg/svg.dart';

class AnatomyPage extends StatefulWidget {
  const AnatomyPage({super.key});

  @override
  State<AnatomyPage> createState() => _AnatomyPageState();
}

class _AnatomyPageState extends State<AnatomyPage> {
  Offset? _tapPosition;
  String? _selectedMuscle;

  void _handleTap(String muscleGroup) {
    setState(() {
      _selectedMuscle = muscleGroup;
    });
    print('Tıklanan kas grubu: $muscleGroup');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kas Anatomisi")),
      body: GestureDetector(
        onTapDown: (details) {
          setState(() {
            _tapPosition = details.localPosition;
          });
        },
        child: CustomPaint(
          foregroundPainter: MusclePainter(
            tapPosition: _tapPosition,
            selectedMuscleGroup: _selectedMuscle,
            onTap: _handleTap,
          ),
          child: Image.asset('assets/images/m3_front.png'),
        ),
      ),
    );
  }
}

class MusclePainter extends CustomPainter {
  final Offset? tapPosition;
  final String? selectedMuscleGroup;
  final void Function(String muscleGroup)? onTap;

  MusclePainter({
    this.tapPosition,
    this.selectedMuscleGroup,
    this.onTap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final pecs1 = parseSvgPathData(
        "M292.96,203.05c-5.11-.44-10.65-.78-14.95,2.03-1.6,1.04-2.92,2.46-4.21,3.87-7.23,7.84-14.64,15.88-24.17,20.67-5.76,2.9-12.17,4.51-18.61,4.55-5.02.03-10.01-.88-14.85-2.22-2.88-.8-5.72-1.75-8.52-2.78-2.66-.97-5.56-2.24-6.68-4.84-.35-.81-.5-1.7-.63-2.58-1.34-8.87-1.74-17.89-1.19-26.84.43-7.08.46-14.72,2.13-21.62,1.24-5.13,3.39-10.63,8.11-13.01,6.95-3.5,14.5,4.46,21.67,7.5,1.5.64,3.03,1.19,4.51,1.87,5.32,2.45,9.86,6.45,15.33,8.55,5.98,2.3,11.66,5.32,17.32,8.33,2.04,1.09,4.09,2.17,6.13,3.26,5.43,2.89,10.87,5.79,15.89,9.34,1.67,1.18,1.69,2.16,2.74,3.92Z");

    final pecs2 = parseSvgPathData(
        "M107.45,203.76l5.4-.04c.62,0,1.26,0,1.85.17,1.11.32,1.96,1.2,2.75,2.04l4.64,4.94c7.02,7.47,14.23,15.1,23.39,19.7,1.62.82,3.33,1.54,5.13,1.78.64.09,1.29.11,1.93.13,7.94.26,15.88-.06,23.8-.59,1.55-.1,3.1-.22,4.62-.54,6.25-1.34,11.5-6.53,12.91-12.77,2.07-9.21.86-18.28.59-27.56-.07-2.48-.14-4.95-.14-7.43,0-5.04.24-10.3-1.86-14.88-2.14-4.67-6.74-8.13-11.83-8.89-.58.34-1.65.51-2.17.95-2.07,1.72-4.43,3.06-6.78,4.36-18.46,10.25-37.56,19.41-55.24,30.95-3.04,1.98-6.93,4.67-8.99,7.66Z");

    final isSelected = selectedMuscleGroup == "pecs_sternal_head";

    final paint = Paint()
      ..color = isSelected ? Colors.orange.withOpacity(0.5) : Colors.transparent
      ..style = PaintingStyle.fill;

    canvas.drawPath(pecs1, paint);
    canvas.drawPath(pecs2, paint);

    if (tapPosition != null &&
        (pecs1.contains(tapPosition!) || pecs2.contains(tapPosition!))) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        onTap?.call("pecs_sternal_head");
      });
    }
  }

  @override
  bool shouldRepaint(covariant MusclePainter oldDelegate) =>
      oldDelegate.tapPosition != tapPosition ||
      oldDelegate.selectedMuscleGroup != selectedMuscleGroup;
}
