import 'package:fitpill/generated/l10n/l10n.dart';
import 'package:fitpill/core/ui/dialogs/show_dialogs.dart';
import 'package:fitpill/core/ui/dialogs/snackbar_helper.dart';
import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CaloriePage extends StatefulWidget {
  const CaloriePage({super.key});

  @override
  State<CaloriePage> createState() => _CaloriePageState();
}

class _CaloriePageState extends State<CaloriePage> {
  TextEditingController fatPercentageController = TextEditingController();
  TextEditingController bodyWeightController = TextEditingController();

  int? selectedLevelIndex; // aktivite seviyesinin indexi
  int? selectedTargetIndex; // kilo alma-verme? indexi

  double? targetCalorie;
  double bmr = 0;
  double? protein;
  double? carb;
  double? fat;
  double? fiber;
  double? water;
  String fatRateWarning = '';
  String bwWarning = '';

  void _calculateCalori() {
    double fatRate = double.tryParse(fatPercentageController.text) ?? 0;
    double bw = double.tryParse(bodyWeightController.text) ?? 0;

    if (fatPercentageController.text.isEmpty ||
        bodyWeightController.text.isEmpty) return;

    if (bw < 25 || bw > 300) {
      SnackbarHelper.show(
        context,
        message: S.of(context)!.weightRangeWarning,
        icon: Icons.warning_amber,
        backgroundColor: Colors.redAccent,
      );
      return;
    }

    if (fatRate < 2 || fatRate > 60) {
      SnackbarHelper.show(
        context,
        message: S.of(context)!.fatPercentageRangeWarning,
        icon: Icons.warning_amber,
        backgroundColor: Colors.redAccent,
      );
      return;
    }

    if (selectedTargetIndex == null || selectedLevelIndex == null) {
      return; // seçilmemişse hesaplama yapılmaz, ama crash de olmaz
    }

    //Hesaplamalar
    double leanBodyMass = bw * (1 - (fatRate / 100));
    double _bmr = 370 + (21.6 * leanBodyMass);
    double waterRatio = [0.033, 0.037, 0.04, 0.044, 0.048][selectedLevelIndex!];
    double activityMultiplier =
        [1.2, 1.375, 1.55, 1.725, 1.9][selectedLevelIndex!];

    double proteinRatio = [1.5, 1.8, 2.1, 2.2, 2.5][selectedLevelIndex!];
    double fatRatio = 0.9;

    double _tdee = _bmr * activityMultiplier;

    double _target;
    if (selectedTargetIndex == 0) {
      _target = _tdee * 0.9;
    } else if (selectedTargetIndex == 1) {
      _target = _tdee;
    } else {
      _target = _tdee * 1.1;
    }

    const fiberPerKcal = 14 / 1000;

    final proteinGram = bw * proteinRatio;

    final fatGram = bw * fatRatio;

    final carbGram = (_target - (proteinGram * 4 + fatGram * 9)) / 4;

    final fiberGram = _target * fiberPerKcal;
    final waterNeed = bw * waterRatio;

    setState(() {
      bmr = _bmr;
      targetCalorie = _target;
      protein = proteinGram;
      carb = carbGram;
      fat = fatGram;
      fiber = fiberGram;
      water = waterNeed;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> activityLevels = [
      S.of(context)!.sedentary,
      S.of(context)!.lightlyActive,
      S.of(context)!.moderatelyActive,
      S.of(context)!.veryActive,
      S.of(context)!.athletic
    ];

    List<String> targets = [S.of(context)!.burnFat , S.of(context)!.maintainMass, S.of(context)!.gainMass];

    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkTheme ? const Color(0xFF1E1E1E) : Colors.white;
    final cardColor = isDarkTheme ? const Color(0xFF2C2C2C) : Colors.white;
    final textColor = isDarkTheme ? Colors.white54 : Colors.black87;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          color: backgroundColor,
          child: SafeArea(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: textColor,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    S.of(context)!.calorieCalculator,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      showCustomTextFieldDialog(
                        context: context,
                        title: S.of(context)!.information,
                        labels: [],
                        // boş
                        icon: Icons.info,
                        content: Text(
                          S.of(context)!.calorieInfo,
                          style: const TextStyle(fontSize: 16),
                        ),
                        confirmText: S.of(context)!.ok,
                        cancelText: S.of(context)!.cancel,
                        onConfirm: (_) {}, // Gerekirse boş bir fonksiyon ver
                      );
                    },
                    icon: Icon(
                      Icons.info_outline,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(
                height: 0.5,
                color: ThemeHelper.getTextColor(context).withAlpha(50),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: bodyWeightController,
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  buildCounter: (context,
                      {required currentLength, required isFocused, maxLength}) {
                    return null;
                  },
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    counterStyle: null,
                    counterText: null,
                    prefixIcon: Icon(
                      Icons.monitor_weight,
                      color: ThemeHelper.getFitPillColor(context),
                    ),
                    labelText: S.of(context)!.bodyWeightKg,
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                    filled: true,
                    fillColor: cardColor,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: ThemeHelper.getFitPillColor(context),
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: textColor,
                        width: 1,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                  ),
                  onChanged: (_) => _calculateCalori(),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: fatPercentageController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  buildCounter: (context,
                      {required currentLength, required isFocused, maxLength}) {
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}$')),
                  ],
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.percent,
                      color: ThemeHelper.getFitPillColor(context),
                    ),
                    labelText: "${S.of(context)!.bodyFatPercentage} (%)",
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                    filled: true,
                    fillColor: cardColor,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: ThemeHelper.getFitPillColor(context),
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: textColor,
                        width: 1,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                  ),
                  onChanged: (_) => _calculateCalori(),
                ),
              ),
              const SizedBox(height: 24),
              Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: ThemeHelper.getCardColor(context),
                ),
                child: DropdownButtonFormField<int>(
                  isExpanded: true,
                  initialValue: selectedLevelIndex,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.fitness_center,
                        color: ThemeHelper.getFitPillColor(context),
                      ),
                      filled: true,
                      fillColor: cardColor,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: textColor, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: textColor, width: 1),
                      )),
                  hint: Text(S.of(context)!.yourActivityLevel),
                  items: List.generate(activityLevels.length, (index) {
                    return DropdownMenuItem(
                        value: index, child: Text(activityLevels[index]));
                  }),
                  onChanged: (index) {
                    setState(() {
                      selectedLevelIndex = index;
                    });
                    _calculateCalori();
                  },
                ),
              ),
              const SizedBox(height: 24.0),
              Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: ThemeHelper.getCardColor(context),
                ),
                child: DropdownButtonFormField<int>(
                  initialValue: selectedTargetIndex,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        MingCute.target_line,
                        color: ThemeHelper.getFitPillColor(context),
                      ),
                      filled: true,
                      fillColor: cardColor,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: textColor, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: textColor, width: 1),
                      )),
                  hint: Text(S.of(context)!.yourDestination),
                  items: List.generate(targets.length, (index) {
                    return DropdownMenuItem(
                        value: index, child: Text(targets[index]));
                  }),
                  onChanged: (index) {
                    setState(() {
                      selectedTargetIndex = index;
                    });
                    _calculateCalori();
                  },
                ),
              ),
              if (targetCalorie != null) ...[
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      buildMacroOverview(
                        context: context,
                        protein: protein ?? 0,
                        carb: carb ?? 0,
                        fat: fat ?? 0,
                        fiber: fiber ?? 0,
                      ),

                      // BMR Değeri Card
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0, bottom: 8),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Card(
                                color: ThemeHelper.getCardColor(context),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: ListTile(
                                  leading: const Icon(Icons.restaurant,
                                      color: Colors.green),
                                  title: const Text(
                                    "Target Calorie",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  subtitle: Text(
                                    "${targetCalorie!.isNaN ? "Tanımsız" : targetCalorie!.toStringAsFixed(0)} kcal",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.green[700]),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Card(
                                color: ThemeHelper.getCardColor(context),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: ListTile(
                                  leading: const Icon(Icons.energy_savings_leaf,
                                      color: Colors.green),
                                  title: Text(
                                    S.of(context)!.bmrValue,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                  subtitle: Text(
                                    "${bmr.toStringAsFixed(0)} kcal",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.green[700]),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Card(
                              color: ThemeHelper.getCardColor(context),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 0),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ListTile(
                                leading: const Icon(
                                    FontAwesome.whiskey_glass_solid,
                                    color: Colors.blue),
                                title: Text(
                                  S.of(context)!.dailyWaterNeed,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                                subtitle: Text(
                                  "${water!.toStringAsFixed(1)} lt",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.blue[700]),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class MacroData {
  final String label;
  final double value;

  MacroData(this.label, this.value);
}

Widget buildMacroOverview({
  required BuildContext context,
  required double protein,
  required double carb,
  required double fat,
  required double fiber,
}) {
  final total = protein + carb + fat + fiber;

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      buildMacroColumn(context, "Protein", protein, total),
      buildMacroColumn(context, S.of(context)!.carbohydrate, carb, total),
      buildMacroColumn(context, S.of(context)!.fat, fat, total),
      buildMacroColumn(context, S.of(context)!.fiber, fiber, total),
    ],
  );
}

Widget buildMacroColumn(
    BuildContext context, String label, double value, double total) {
  final percentage = total == 0 ? 0.0 : (value / total) * 100;

  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      const SizedBox(height: 4),
      SizedBox(
        width: 50,
        height: 50,
        child: SfCircularChart(
          margin: EdgeInsets.zero,
          series: <CircularSeries>[
            RadialBarSeries<MacroData, String>(
              dataSource: [MacroData(label, percentage)],
              maximumValue: 100,
              radius: '100%',
              innerRadius: '85%',
              cornerStyle: CornerStyle.bothCurve,
              pointColorMapper: (_, __) => ThemeHelper.getFitPillColor(context),
              trackColor: Colors.grey.shade300,
              xValueMapper: (data, _) => data.label,
              yValueMapper: (data, _) => data.value,
              dataLabelSettings: const DataLabelSettings(isVisible: false),
            )
          ],
        ),
      ),
      const SizedBox(height: 4),
      Text("${value.toStringAsFixed(0)}g",
          style: const TextStyle(fontWeight: FontWeight.bold)),
    ],
  );
}
