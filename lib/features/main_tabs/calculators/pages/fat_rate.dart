import 'dart:math';

import 'package:fitpill/generated/l10n/l10n.dart';
import 'package:fitpill/core/ui/dialogs/show_dialogs.dart';
import 'package:fitpill/core/ui/dialogs/snackbar_helper.dart';
import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FatRatePage extends StatefulWidget {
  const FatRatePage({super.key});

  @override
  State<FatRatePage> createState() => _FatRatePageState();
}

class _FatRatePageState extends State<FatRatePage> {
  String _selectedGender = "Erkek";
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _neckController = TextEditingController();
  final TextEditingController _waistController = TextEditingController();
  final TextEditingController _hipController = TextEditingController();
  final TextEditingController _resultController = TextEditingController();
  bool _isFatRateCalculated = false;

  @override
  void initState() {
    super.initState();
  }

  void _calculateFatRate(StateSetter setState) {
    double height = double.tryParse(_heightController.text) ?? 0;
    double neck = double.tryParse(_neckController.text) ?? 0;
    double waist = double.tryParse(_waistController.text) ?? 0;
    double hip = double.tryParse(_hipController.text) ?? 0;
    double bodyFat;

    setState(() {
      if (_heightController.text.isEmpty ||
          _neckController.text.isEmpty ||
          _waistController.text.isEmpty ||
          (_selectedGender == "Kadın" && _hipController.text.isEmpty)) {
        _resultController.text = "";
        _isFatRateCalculated = false;
      } else if (height < 100 ||
          height > 260 ||
          neck < 15 ||
          neck > 70 ||
          waist < 30 ||
          waist > 250 ||
          (_selectedGender == "Kadın" &&
              (hip < 30 || hip > 250 || (hip <= neck))) ||
          (waist <= neck)) {
        SnackbarHelper.show(
          context,
          message: S.of(context)!.enterValidNumber,
          icon: Icons.warning_amber,
          backgroundColor: Colors.redAccent,
        );
        _isFatRateCalculated = false;
      } else if (_selectedGender == "Erkek") {
        bodyFat = 495 /
                (1.0324 -
                    0.19077 * log(waist - neck) / ln10 +
                    0.15456 * log(height) / ln10) -
            450;
        if (bodyFat < 0) {
          SnackbarHelper.show(
            context,
            message: S.of(context)!.enterValidNumber,
            icon: Icons.warning_amber,
            backgroundColor: Colors.redAccent,
          );
          _isFatRateCalculated = false;
        } else {
          _resultController.text = bodyFat.toStringAsFixed(1);
          _isFatRateCalculated = true;
        }
      } else if (_selectedGender == "Kadın" && _hipController.text.isNotEmpty) {
        bodyFat = 495 /
                (1.29579 -
                    0.35004 * (log(waist + hip - neck) / ln10) +
                    0.22100 * (log(height) / ln10)) -
            450;
        if (bodyFat < 0) {
          SnackbarHelper.show(
            context,
            message: S.of(context)!.enterValidNumber,
            icon: Icons.warning_amber,
            backgroundColor: Colors.redAccent,
          );
          _isFatRateCalculated = false;
        } else {
          _resultController.text = bodyFat.toStringAsFixed(1);
          _isFatRateCalculated = true;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkTheme ? const Color(0xFF1E1E1E) : Colors.white;
    final cardColor = isDarkTheme ? const Color(0xFF2C2C2C) : Colors.white54;
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
                    S.of(context)!.fatRateCalculator,
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
                          S.of(context)!.fatRateInfo,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Divider(
                height: 0.5,
                color: ThemeHelper.getTextColor(context).withAlpha(50),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    // Erkek Butonu
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedGender = "Erkek";
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        width: 75,
                        height: 75,
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _selectedGender == "Erkek"
                              ? ThemeHelper.getFitPillColor(context)
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: _selectedGender == "Erkek"
                                  ? ThemeHelper.getFitPillColor(context)
                                      .withAlpha((255 * 0.2).toInt())
                                  : Colors.grey.withAlpha((255 * 0.1).toInt()),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(2, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.man,
                              size: 40,
                              color: _selectedGender == "Erkek"
                                  ? ThemeHelper.getBackgroundColor(context)
                                  : Colors.black54,
                            ),
                            const SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ),
                    // Kadın Butonu
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedGender = "Kadın";
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        width: 75,
                        height: 75,
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _selectedGender == "Kadın"
                              ? ThemeHelper.getFitPillColor(context)
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: _selectedGender == "Kadın"
                                  ? ThemeHelper.getFitPillColor(context)
                                      .withAlpha((255 * 0.2).toInt())
                                  : Colors.grey.withAlpha((255 * 0.1).toInt()),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(2, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.woman,
                              size: 40,
                              color: _selectedGender == "Kadın"
                                  ? ThemeHelper.getBackgroundColor(context)
                                  : Colors.black54,
                            ),
                            const SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                style: const TextStyle(fontSize: 18),
                // Yazı boyutu
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.straighten,
                      color: ThemeHelper.getFitPillColor(context)),
                  labelText: "${S.of(context)!.height} (cm)",
                  labelStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                  filled: true,
                  fillColor: cardColor,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: ThemeHelper.getFitPillColor(context),
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: textColor,
                      width: 1,
                    ),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                ),
                onChanged: (value) {
                  setState(() {
                    _calculateFatRate(setState);
                  });
                },
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _waistController,
                keyboardType: TextInputType.number,

                style: const TextStyle(fontSize: 18),
                // Yazı boyutu
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.straighten,
                      color: ThemeHelper.getFitPillColor(context)),
                  labelText: "${S.of(context)!.waist} (cm)",
                  labelStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                  filled: true,
                  fillColor: cardColor,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: ThemeHelper.getFitPillColor(context),
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: textColor,
                      width: 1,
                    ),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                ),
                onChanged: (value) {
                  setState(() {
                    _calculateFatRate(setState);
                  });
                },
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _neckController,
                keyboardType: TextInputType.number,

                style: const TextStyle(fontSize: 18),
                // Yazı boyutu
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.straighten,
                      color: ThemeHelper.getFitPillColor(context)),
                  labelText: "${S.of(context)!.neck} (cm)",
                  labelStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                  filled: true,
                  fillColor: cardColor,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: ThemeHelper.getFitPillColor(context),
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: textColor,
                      width: 1,
                    ),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                ),
                onChanged: (value) {
                  setState(() {
                    _calculateFatRate(setState);
                  });
                },
              ),
              const SizedBox(height: 16),
              if (_selectedGender == "Kadın")
                TextField(
                  controller: _hipController,
                  keyboardType: TextInputType.number,

                  style: const TextStyle(fontSize: 18),
                  // Yazı boyutu
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.straighten,
                      color: ThemeHelper.getFitPillColor(context),
                    ),
                    labelText: "${S.of(context)!.hip} (cm)",
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                    filled: true,
                    fillColor: cardColor,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: ThemeHelper.getFitPillColor(context),
                        width: 2,
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
                  onChanged: (value) {
                    setState(() {
                      _calculateFatRate(setState);
                    });
                  },
                ),
              const SizedBox(height: 16.0),
              Card(
                color: ThemeHelper.getCardColor(context),
                elevation: 0,
                // Hafif gölgelendirme
                shadowColor: ThemeHelper.getTextColor(context)
                    .withAlpha((255 * 0.1).toInt()),

                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(15), // Yuvarlatılmış köşeler
                ),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1.5,
                      color: ThemeHelper.getTextColor(context).withAlpha(
                        (255 * 0.2).toInt(),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // İkon
                      Icon(
                        Icons.percent,
                        size: 50,
                        color: ThemeHelper.getTextColor(context),
                      ),
                      const SizedBox(width: 20),
                      // Yağ Oranı Metni
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            S.of(context)!.yourFatPercentage,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ThemeHelper.getTextColor(context),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _resultController.text.isEmpty
                                ? ""
                                : _resultController.text,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: ThemeHelper.getTextColor(context),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
