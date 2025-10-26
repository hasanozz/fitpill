import 'package:fitpill/generated/l10n/l10n.dart';
import 'package:fitpill/core/ui/dialogs/show_dialogs.dart';
import 'package:fitpill/core/ui/widgets/textfield_design.dart';
import 'ffmi_bar.dart';
import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:flutter/material.dart';

class FFMICalculate extends StatefulWidget {
  const FFMICalculate({super.key});

  @override
  State<FFMICalculate> createState() => _FFMICalculateState();
}

class _FFMICalculateState extends State<FFMICalculate> {
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController fatController = TextEditingController();

  double? _ffmiResult;
  double? _leanMassResult;

  void _updateResults() {
    double height = double.tryParse(heightController.text) ?? 0;
    double weight = double.tryParse(weightController.text) ?? 0;
    double bodyFatPercentage = double.tryParse(fatController.text) ?? 0;

    if (height <= 0 || weight <= 0 || bodyFatPercentage < 0) {
      setState(() {
        _ffmiResult = null;
        _leanMassResult = null;
      });
      return;
    }

    double leanMass = weight * (1 - bodyFatPercentage / 100);
    double heightInMeters = (height / 100) * (height / 100);
    double ffmi = leanMass / heightInMeters;

    setState(() {
      _leanMassResult = leanMass;
      _ffmiResult = ffmi;
    });
  }

  String _getFFMILabel(double ffmi) {
    if (ffmi <= 17) return "Düşük Kas Kütlesi";
    if (ffmi > 17 && ffmi <= 18) return "Başlangıç Seviyesi";
    if (ffmi > 18 && ffmi <= 20) return "Ortalama Seviye";
    if (ffmi > 20 && ffmi <= 22) return "Belirgin Kas Kütlesi";
    if (ffmi > 22 && ffmi <= 23.5) return "Dikkat Çekici Kas Kütlesi";
    if (ffmi > 23.5 && ffmi <= 25) return "Genetik Avantaj, Rekabetçi Seviye";
    return "Muhtemel Steroid Kullanımı";
  }

  @override
  void initState() {
    super.initState();
    heightController.clear();
    weightController.clear();
    fatController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkTheme ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkTheme ? Colors.white54 : Colors.black87;
    final cardColor = isDarkTheme ? const Color(0xFF2C2C2C) : Colors.white;

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
                    S.of(context)!.ffmiCalculator,
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
                          S.of(context)!.ffmiInfo,
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Divider(
                height: 0.5,
                color: ThemeHelper.getTextColor(context).withAlpha(50),
              ),
              const SizedBox(height: 16),
              buildInputField(
                context: context,
                controller: heightController,
                labelText: S.of(context)!.height,
                icon: Icons.height,
                suffixText: 'cm',
                onChanged: (_) => _updateResults(),
              ),
              const SizedBox(height: 16),
              buildInputField(
                context: context,
                controller: weightController,
                labelText: S.of(context)!.bodyWeightKg,
                icon: Icons.monitor_weight,
                suffixText: 'kg',
                onChanged: (_) => _updateResults(),
              ),
              const SizedBox(height: 16),
              buildInputField(
                context: context,
                controller: fatController,
                labelText: S.of(context)!.bodyFatPercentage,
                icon: Icons.percent,
                suffixText: '%',
                onChanged: (_) => _updateResults(),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildResultCard(S.of(context)!.leanMass,
                        _leanMassResult?.toStringAsFixed(2), true),
                  ),
                  Expanded(
                    child: _buildResultCard(S.of(context)!.ffmi,
                        _ffmiResult?.toStringAsFixed(2), _ffmiResult != null),
                  ),
                ],
              ),
              if (_ffmiResult != null) ...[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
                  child: FFMIBar(min: 15, max: 25, value: _ffmiResult!),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Card(
                    color: cardColor,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        _getFFMILabel(_ffmiResult!),
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(String title, String? value, bool showResult) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDarkTheme ? const Color(0xFF2C2C2C) : Colors.white;
    final textColor = isDarkTheme ? Colors.white54 : Colors.black87;
    return Card(
      color: cardColor,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Icon(Icons.calculate, color: Colors.grey),
            const SizedBox(height: 10),
            Text(title,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor)),
            const SizedBox(height: 10),
            Text(showResult ? value ?? "" : "",
                style: TextStyle(fontSize: 18, color: textColor)),
          ],
        ),
      ),
    );
  }
}
