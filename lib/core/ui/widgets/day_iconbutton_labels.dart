import 'package:fitpill/generated/l10n/l10n.dart';
import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icons_plus/icons_plus.dart';

final GlobalKey<ScaffoldState> globalScaffoldKey = GlobalKey<ScaffoldState>();

class AppConstants {
  static List<dynamic> getButtonDayLabels(BuildContext context) {
    return [
      {'label': S.of(context)?.shortMon, 'icon': null},
      {'label': S.of(context)?.shortTue, 'icon': null},
      {'label': S.of(context)?.shortWed, 'icon': null},
      {'label': S.of(context)?.shortThu, 'icon': null},
      {'label': S.of(context)?.shortFri, 'icon': null},
      {'label': S.of(context)?.shortSat, 'icon': null},
      {'label': S.of(context)?.shortSun, 'icon': null},
      {'label': 'Gym', 'icon': MingCute.barbell_line},
      {'label': 'Run', 'icon': FontAwesomeIcons.personRunning},
      {'label': 'Plan', 'icon': Icons.assignment},
    ];
  }
}

// Pzt, Sal şeklindeki iconların tasarımının olduğu fonks.
Widget buildCircleDayIcon({
  required dynamic label,
  required int index,
  required int selectedIndex, // dışarıdan gelecek
  required void Function(int) onSelected, // seçimi dışarı bildirecek
  required BuildContext context,
}) {
  final textColor = ThemeHelper.getTextColor(context);
  final cardColor = ThemeHelper.getCardColor(context);

  final bool isSelected = selectedIndex == index;

  return ElevatedButton(
    onPressed: () => onSelected(index),
    style: ElevatedButton.styleFrom(
      shape: const CircleBorder(),
      padding: const EdgeInsets.all(16),
      backgroundColor: isSelected ? textColor : textColor.withValues(alpha: 0.5),
      elevation: 0,
    ),
    child: label is String
        ? Text(
      label,
      style: TextStyle(
        color: cardColor,
        fontWeight: FontWeight.bold,
      ),
    )
        : Icon(
      label,
      color: cardColor,
    ),
  );
}