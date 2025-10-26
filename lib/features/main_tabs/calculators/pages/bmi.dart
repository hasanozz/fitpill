import 'package:fitpill/core/utils/get_translation.dart';
import 'package:fitpill/generated/l10n/l10n.dart';
import 'package:fitpill/core/ui/dialogs/show_dialogs.dart';
import 'package:fitpill/core/ui/widgets/textfield_design.dart';
import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class BmiPage extends StatefulWidget {
  const BmiPage({super.key});

  @override
  State<BmiPage> createState() => _BmiPageState();
}

class _BmiPageState extends State<BmiPage> {
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  double? bmiResult;
  double? lowerLimitBw;
  double? higherLimitBw;
  String resultTextKey = "BMI";
  Color? bgColor;
  Color tColor = Colors.black;

  void _updateResults() {
    double height = (double.tryParse(heightController.text) ?? 0) / 100;
    double weight = double.tryParse(weightController.text) ?? 0;

    if (height <= 0 || weight <= 0) {
      setState(() {
        bmiResult = null;
        lowerLimitBw = null;
        higherLimitBw = null;
      });
      return;
    }

    double resultBmi = weight / (height * height);
    double lowL = 18.5 * (height * height);
    double highL = 24.9 * (height * height);

    setState(() {
      bmiResult = resultBmi;
      lowerLimitBw = lowL;
      higherLimitBw = highL;
      if (resultBmi < 16) {
        resultTextKey = "severelyUnderweight";
        bgColor = Colors.redAccent;
      } else if (resultBmi >= 16 && resultBmi < 18.5) {
        resultTextKey = "underweight";
        bgColor = Colors.deepOrangeAccent;
      } else if (resultBmi >= 18.5 && resultBmi < 25) {
        resultTextKey = "idealWeight";
        bgColor = Colors.green;
      } else if (resultBmi >= 25 && resultBmi < 30) {
        resultTextKey = "overweight";
        bgColor = Colors.deepOrangeAccent;
      } else {
        resultTextKey = "obese";
        bgColor = Colors.redAccent;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    heightController.clear();
    weightController.clear();
    bmiResult = null;
    lowerLimitBw = null;
    higherLimitBw = null;
  }

  @override
  Widget build(BuildContext context) {
    bgColor ??= ThemeHelper.getCardColor2(context);
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkTheme ? const Color(0xFF1E1E1E) : Colors.white;
    final cardColor = isDarkTheme ? const Color(0xFF2C2C2C) : Colors.white;
    final textColor = isDarkTheme ? Colors.white54 : Colors.black87;
    final isWidthEnough = MediaQuery.of(context).size.width > 400;

    final String translatedResultText = getTranslate(context, resultTextKey);

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
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back, color: textColor),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    S.of(context)!.bmiCalculator,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
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
                        icon: Icons.info,
                        content: Text(
                          S.of(context)!.bmiInfo,
                          style: const TextStyle(fontSize: 16),
                        ),
                        confirmText: S.of(context)!.ok,
                        cancelText: S.of(context)!.cancel,
                        onConfirm: (_) {},
                      );
                    },
                    icon: Icon(Icons.info_outline, color: textColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(
                height: 0.5,
                color: ThemeHelper.getTextColor(context).withAlpha(50),
              ),
              // Custom TextFields
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
                child: Column(
                  children: [
                    buildInputField(
                      context: context,
                      controller: heightController,
                      labelText: S.of(context)!.height,
                      icon: Icons.height,
                      suffixText: 'cm',
                      onChanged: (value) => _updateResults(),
                    ),
                    const SizedBox(height: 16),
                    buildInputField(
                      context: context,
                      controller: weightController,
                      labelText: S.of(context)!.weight,
                      icon: Icons.monitor_weight,
                      suffixText: 'kg',
                      onChanged: (value) => _updateResults(),
                    ),
                  ],
                ),
              ),

              // BMI & Ideal Weight Grid
              Padding(
                padding: const EdgeInsets.all(8),
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 2 / 2,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    GridTile(
                      child: Card(
                        color: cardColor,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.calculate,
                                  size: isWidthEnough ? 40 : 30,
                                  color: Colors.redAccent),
                              const SizedBox(height: 10),
                              Text(
                                "BMI",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: isWidthEnough ? 18 : 14,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                bmiResult != null
                                    ? "${bmiResult!.toStringAsFixed(2)} kg/m²"
                                    : "--",
                                style: TextStyle(
                                  fontSize: isWidthEnough ? 20 : 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GridTile(
                      child: Card(
                        color: cardColor,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(FontAwesome.weight_scale_solid,
                                  size: isWidthEnough ? 30 : 25,
                                  color: Colors.greenAccent),
                              const SizedBox(height: 10),
                              Text(
                                S.of(context)!.idealWeight,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: isWidthEnough ? 16 : 14,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                lowerLimitBw != null && higherLimitBw != null
                                    ? "${S.of(context)!.lowerLimit}: ${lowerLimitBw!.toStringAsFixed(1)} kg\n"
                                        "${S.of(context)!.upperLimit}: ${higherLimitBw!.toStringAsFixed(1)} kg"
                                    : "--",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: isWidthEnough ? 15 : 12,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // BMI Classification
              Padding(
                padding: const EdgeInsets.all(8),
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 5 / 1,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    GridTile(
                      child: Card(
                        color: bgColor,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: Text(
                              translatedResultText,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
