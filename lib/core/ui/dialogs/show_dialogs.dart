import 'package:fitpill/generated/l10n/l10n.dart';
import 'package:fitpill/core/ui/widgets/day_iconbutton_labels.dart';
import 'package:fitpill/features/main_tabs/exercises/exercise_tracker_page/exercise_set_model.dart';
import 'package:fitpill/features/main_tabs/programs/workouts_screen_model.dart';
import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:fitpill/core/utils/formatter.dart';

// QUICKALERT YERINE KULLANACAĞIMIZ DIALOG. KULLANIM AŞAĞIDA
// LABELSİ DEĞİŞTİREREK TEXTFIELDLI KULLANILABİLİR.
// ÇOK AMAÇLI SHOW DIALOG
// showCustomTextFieldDialog(
// context: context,
// title: S.of(context).information,
// labels: [],
// // boş
// icon: Icons.info,
// content: Text(
// S.of(context).calorie_info,
// style: TextStyle(fontSize: 16),
// ),
// confirmText: S.of(context).confirm,
// onConfirm: (_) {}, // Gerekirse boş bir fonksiyon ver
// );

Future<void> showCustomTextFieldDialog({
  required BuildContext context,
  required String title,
  required List<String> labels, // label text listesi
  required IconData icon,
  int maxLength = 20,
  required void Function(List<String> values) onConfirm,
  VoidCallback? onCancel,
  String confirmText = 'Ekle',
  String cancelText = 'İptal',
  List<String>? initialValues,
  double? width,
  double? height,
  Widget? content,
}) async {
  final backgroundColor = ThemeHelper.getBackgroundColor(context);
  final textColor = ThemeHelper.getTextColor(context);

  final controllers = List.generate(
    labels.length,
    (i) => TextEditingController(
      text: (initialValues != null && i < initialValues.length)
          ? initialValues[i]
          : '',
    ),
  );

  await showDialog(
    context: context,
    builder: (context) {

      return Dialog(
        backgroundColor: ThemeHelper.getCardColor2(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: IntrinsicHeight(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  if (labels.isNotEmpty)
                    ...List.generate(
                        labels.length,
                        (i) => Column(
                              children: [
                                TextField(
                                  controller: controllers[i],
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(maxLength),
                                  ],
                                  cursorColor: ThemeHelper.isDarkTheme(context)
                                      ? Colors.orange
                                      : const Color(0xFF0D47A1),
                                  decoration: InputDecoration(
                                    labelText: labels[i],
                                    floatingLabelStyle:
                                        TextStyle(color: textColor),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: ThemeHelper.getFitPillColor(
                                              context),
                                          width: 1),
                                    ),
                                    prefixIcon: Icon(
                                      icon,
                                      color: ThemeHelper.isDarkTheme(context)
                                          ? Colors.orange
                                          : const Color(0xFF0D47A1),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                            )),
                  if (labels.isEmpty && content != null) content,
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          onCancel?.call();
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                        child: Text(cancelText,
                            style: const TextStyle(fontSize: 16)),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          final values = controllers
                              .map((controller) => controller.text.trim())
                              .toList();
                          Navigator.pop(context);
                          onConfirm(values);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ThemeHelper.isDarkTheme(context)
                              ? Colors.orange
                              : const Color(0xFF0D47A1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                        child: Text(
                          confirmText,
                          style: TextStyle(
                              color: backgroundColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
  if (onConfirm != true && onCancel != null) {
    onCancel();
  }
}

void openBottomSheetCreateWorkout(
  BuildContext context,
  String routineId,
  Future<void> Function(String routineId, WorkoutModel workout)
      onCreateOrUpdateWorkout, {
  bool isEditing = false,
  WorkoutModel? existingWorkout,
}) {
  final buttonDayLabels = AppConstants.getButtonDayLabels(context);

  TextEditingController workoutRoutineNameController = TextEditingController(
    text: isEditing ? existingWorkout?.name : '',
  );

  final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
  final backgroundColor = isDarkTheme ? const Color(0xFF1E1E1E) : Colors.white;
  final cardColor = isDarkTheme ? const Color(0xFF2C2C2C) : Colors.white;
  final textColor = isDarkTheme ? Colors.white : Colors.black87;

  int selectedIconDayIndex =
      isEditing ? existingWorkout!.dayIndex : 0; // seçili günü sıfırla

  showModalBottomSheet(
    backgroundColor: backgroundColor,
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Padding(
              padding: EdgeInsets.only(
                top: 8,
                right: 8,
                left: 8,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 0, top: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: isEditing
                            ? Text(
                                S.of(context)!.editWorkout,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              )
                            : Text(
                                S.of(context)!.createWorkout,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Divider(
                          height: 1,
                          thickness: 0.5,
                          color: ThemeHelper.getTextColor(context)
                              .withOpacity(0.2),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          cursorColor: ThemeHelper.isDarkTheme(context)
                              ? Colors.orange
                              : const Color(0xFF0D47A1),
                          controller: workoutRoutineNameController,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(
                                20), // Maksimum 20 karakter
                          ],
                          decoration: InputDecoration(
                            labelText: S.of(context)!.name,
                            labelStyle: TextStyle(color: textColor),
                            fillColor: cardColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: ThemeHelper.isDarkTheme(context)
                                      ? Colors.orange
                                      : const Color(0xFF0D47A1),
                                  width: 2),
                            ),
                            hintText: S.of(context)!.pushDay,
                            hintStyle: const TextStyle(color: Colors.grey),
                            prefixIcon: Icon(
                              Icons.fitness_center,
                              color: ThemeHelper.isDarkTheme(context)
                                  ? Colors.orange
                                  : const Color(0xFF0D47A1),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 16, left: 16, right: 16, top: 24),
                        child: Text(
                          S.of(context)!.chooseIcon,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Wrap(
                        spacing: 10, // Butonlar arasındaki yatay boşluk
                        runSpacing: 10, // Alt satıra geçtiğinde dikey boşluk
                        alignment: WrapAlignment.center,
                        children:
                            List.generate(buttonDayLabels.length, (index) {
                          final label = buttonDayLabels[index]['label'];
                          final icon = buttonDayLabels[index]['icon'];

                          return buildCircleDayIcon(
                            label: icon ?? label,
                            index: index,
                            selectedIndex: selectedIconDayIndex,
                            onSelected: (i) =>
                                setState(() => selectedIconDayIndex = i),
                            context: context,
                          );
                        }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(180, 48),
                              backgroundColor: ThemeHelper.isDarkTheme(context)
                                  ? Colors.orange
                                  : const Color(0xFF0D47A1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                            ),
                            onPressed: () async {
                              final workoutName =
                                  workoutRoutineNameController.text.trim();
                              if (workoutName.isEmpty) return;

                              final dayLabel =
                                  buttonDayLabels[selectedIconDayIndex]
                                      ['label'];

                              final workout = WorkoutModel(
                                id: isEditing ? existingWorkout!.id : '',
                                name: workoutName,
                                dayIndex: selectedIconDayIndex,
                                dayLabel: dayLabel,
                              );

                              await onCreateOrUpdateWorkout(routineId, workout);
                              Navigator.pop(context);
                            },
                            child: Text(
                              isEditing
                                  ? S.of(context)!.save
                                  : S.of(context)!.createWorkout,
                              style: TextStyle(
                                fontSize: 16,
                                color: ThemeHelper.getCardColor(context),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

void openBottomSheetAddSet({
  required BuildContext context,
  required WidgetRef ref,
  required String exerciseName,
  required Future<void> Function(ExerciseSet set) onSubmit,
}) {
  TextEditingController _weightController = TextEditingController();
  TextEditingController _repsController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  double? selectedRir;
  final List<double> rirValues = [0, 0.5, 1, 1.5, 2, 2.5, 3];

  showModalBottomSheet(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          DateTime today = DateTime.now();

          final langCode = Localizations.localeOf(context).languageCode;
          final formattedDate = langCode == 'tr'
              ? DateFormat('d MMMM y', 'tr_TR').format(selectedDate)
              : DateFormat('d MMM y', 'en_US').format(selectedDate);

          bool isSameDate(DateTime a, DateTime b) =>
              a.year == b.year && a.month == b.month && a.day == b.day;

          return Padding(
            padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          S.of(context)!.addSet,
                          style: TextStyle(
                            fontSize: 18,
                            color: ThemeHelper.getTextColor(context),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                dialogTheme: DialogThemeData(
                                  backgroundColor:
                                      ThemeHelper.getCardColor(context),
                                ),
                                colorScheme: ThemeHelper.isDarkTheme(context)
                                    ? const ColorScheme.dark(
                                        primary: Colors.orange,
                                        onPrimary: Colors.black,
                                        onSurface: Colors.white70,
                                      )
                                    : const ColorScheme.light(
                                        primary: Color(0xFF0D47A1),
                                        onPrimary: Colors.white,
                                        onSurface: Colors.black87,
                                      ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                      foregroundColor:
                                          ThemeHelper.getTextColor(context),
                                      textStyle: const TextStyle(
                                          fontSize:
                                              18) // 🔘 cancel & ok butonları
                                      ),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setState(() {
                            selectedDate =
                                DateTime(picked.year, picked.month, picked.day);
                          });
                        }
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 18,
                            color: ThemeHelper.getTextColor(context),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            isSameDate(selectedDate, today)
                                ? S.of(context)!.today
                                : formattedDate,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: ThemeHelper.getTextColor(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: TextField(
                              controller: _weightController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              inputFormatters: [CustomDecimalFormatter()],
                              cursorColor: ThemeHelper.getFitPillColor(context),
                              decoration: InputDecoration(
                                suffix: const Text(
                                  "kg",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                labelText: "Ağırlık",
                                labelStyle: TextStyle(
                                  color: ThemeHelper.getTextColor(context),
                                ),
                                border: const OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: ThemeHelper.getTextColor(context),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          ThemeHelper.getFitPillColor(context),
                                      width: 1),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: _repsController,
                              cursorColor: ThemeHelper.getFitPillColor(context),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(2),
                              ],
                              decoration: InputDecoration(
                                labelText: "Tekrar",
                                labelStyle: TextStyle(
                                  color: ThemeHelper.getTextColor(context),
                                ),
                                border: const OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: ThemeHelper.getTextColor(context),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          ThemeHelper.getFitPillColor(context),
                                      width: 1),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                              flex: 2,
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  canvasColor:
                                      ThemeHelper.getCardColor(context),
                                ),
                                child: DropdownButtonFormField<double>(
                                  decoration: InputDecoration(
                                    labelText: "RIR",
                                    labelStyle: TextStyle(
                                      color: ThemeHelper.getTextColor(context),
                                    ),
                                    border: const OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            ThemeHelper.getTextColor(context),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              ThemeHelper.getTextColor(context),
                                          width: 1),
                                    ),
                                  ),
                                  value: selectedRir,
                                  items: rirValues.map((rir) {
                                    return DropdownMenuItem<double>(
                                      value: rir,
                                      child: Text(rir.toString()),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      selectedRir = val;
                                    });
                                  },
                                ),
                              ))
                        ],
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 20),
                        child: SizedBox(
                          width: 150,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ThemeHelper.isDarkTheme(context)
                                  ? Colors.orange
                                  : const Color(0xFF0D47A1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {
                              final weight =
                                  double.tryParse(_weightController.text);
                              final reps = int.tryParse(_repsController.text);

                              if (weight == null ||
                                  reps == null ||
                                  selectedRir == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  // BİZİM SNACKBARA GEÇ BU OMAAZ
                                  const SnackBar(
                                    content: Text('tÜM ALANLARI DOLDUR'),
                                  ),
                                );
                                return;
                              }

                              final set = ExerciseSet(
                                  id: '',
                                  weight: weight,
                                  reps: reps,
                                  rir: selectedRir!,
                                  exerciseDate: selectedDate);

                              await onSubmit(set);
                              if (context.mounted) Navigator.pop(context);
                            },
                            child: Text(
                              "Ekle",
                              style: TextStyle(
                                fontSize: 16,
                                color: ThemeHelper.getBackgroundColor(context),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      });
}
