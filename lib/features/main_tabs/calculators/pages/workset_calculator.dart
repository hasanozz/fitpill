import 'package:fitpill/generated/l10n/l10n.dart';
import 'package:fitpill/core/ui/dialogs/show_dialogs.dart';
import 'package:fitpill/core/ui/dialogs/snackbar_helper.dart';
import 'package:fitpill/core/ui/widgets/textfield_design.dart';
import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:flutter/material.dart';

class WorkSet extends StatefulWidget {
  const WorkSet({super.key});

  @override
  State<WorkSet> createState() => _WorkSetState();
}

class _WorkSetState extends State<WorkSet> {
  final TextEditingController _weightController = TextEditingController();
  final List<double> _selectedValues = [1, 1];
  final List<double> _sliderMins = [1, 1];
  final List<double> _sliderMax = [5, 10];
  String _selectedSystem = "sabit";
  String _selectedDif = "kolay";
  double _constReseult = -1;
  final List<double> _rampResults = [];
  final Map<String, Map<int, double>> rpeTable = {
    "zor": {
      1: 95.5,
      2: 92.2,
      3: 89.2,
      4: 86.3,
      5: 83.7,
      6: 81.1,
      7: 78.6,
      8: 76.2,
      9: 73.9,
      10: 70.7,
    },
    "orta": {
      1: 92.2,
      2: 89.2,
      3: 86.3,
      4: 83.7,
      5: 81.2,
      6: 78.6,
      7: 76.2,
      8: 73.9,
      9: 69.4,
      10: 68.0,
    },
    "kolay": {
      1: 89.2,
      2: 86.3,
      3: 83.7,
      4: 81.1,
      5: 78.6,
      6: 76.2,
      7: 73.9,
      8: 70.7,
      9: 68.0,
      10: 65.3,
    },
  };

  void _forConstSystCalc(
      String difficulty, double reps, double sets, String workSystem) {
    setState(() {
      String normalizedValue = _weightController.text.replaceAll(',', '.');
      double weight = double.tryParse(normalizedValue) ?? 0;
      double percentage = rpeTable[difficulty]![reps.toInt()]!;
      double reductionRate = 1 - ((sets - 1) * 0.015);
      double lastSet = weight * (percentage / 100) * reductionRate;

      if (weight <= 500) {
        if (workSystem == "sabit") {
          double result = (lastSet / 2.5).round() * 2.5;
          _constReseult = result;
          _rampResults.clear(); // Sabit sistemde ramp sonuçları temizlenir
        } else {
          _constReseult = -1;
          _rampResults.clear(); // Eski ramp sonuçlarını temizle
          double currentSet = lastSet;
          _rampResults.add((lastSet / 2.5).round() * 2.5);

          for (int set = 1; set < sets; set++) {
            // Hesaplamaları yap
            double increment = currentSet * 0.025; // %2.5 artış
            currentSet = (currentSet - increment);
            double currentValue = currentSet / 2.5;
            double currentSetWeight =
                currentValue.round() * 2.5; // 2.5'in katına yuvarla
            _rampResults.add(currentSetWeight); // Listeye ekle
          }
        }
      } else {
        _rampResults.clear();
        _constReseult = -1;
        SnackbarHelper.show(
          context,
          message: S.of(context)!.invalidWeightRm,
          icon: Icons.warning_amber,
          backgroundColor: Colors.redAccent,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> sliderTexts = [S.of(context)!.set, S.of(context)!.reps];

    final isWidthEnough = MediaQuery.of(context).size.width > 400;
    return Scaffold(
        backgroundColor: ThemeHelper.getBackgroundColor(context),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            color: ThemeHelper.getBackgroundColor(context),
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
                        color: ThemeHelper.getTextColor(context),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      S.of(context)!.workSetCalculator,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: ThemeHelper.getTextColor(context),
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
                          // boş
                          icon: Icons.info,
                          content: Text(
                            S.of(context)!.workSetInfo,
                            style: const TextStyle(fontSize: 16),
                          ),
                          confirmText: S.of(context)!.ok,
                          cancelText: S.of(context)!.cancel,
                          onConfirm: (_) {}, // Gerekirse boş bir fonksiyon ver
                        );
                      },
                      icon: Icon(
                        Icons.info_outline,
                        color: ThemeHelper.getTextColor(context),
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
            padding:
                const EdgeInsets.only(top: 0, bottom: 8, left: 8, right: 8),
            child: Column(
              children: [
                Divider(
                  height: 0.5,
                  color: ThemeHelper.getTextColor(context).withAlpha(50),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 8),
                    child: buildInputField(
                      context: context,
                      controller: _weightController,
                      labelText: S.of(context)!.oneRepMaxWeight,
                      icon: Icons.fitness_center,
                      suffixText: 'kg',
                      onChanged: (value) {
                        setState(() {
                          _forConstSystCalc(_selectedDif, _selectedValues[1],
                              _selectedValues[0], _selectedSystem);
                        });
                      },
                    )),
                Padding(
                  padding: EdgeInsets.only(top: 16.0, bottom: 4),
                  child: Text(
                    S.of(context)!.yourWishSet,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _selectedValues.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: ThemeHelper.getCardColor2(context),
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    sliderTexts[index],
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    width: 60,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color(0xFF2C3E50),
                                            width: 2),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                        child: Text(
                                            '${(_selectedValues[index]).toInt()}')),
                                  )
                                ],
                              ),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  tickMarkShape: SliderTickMarkShape.noTickMark,
                                  trackShape:
                                      const RectangularSliderTrackShape(),
                                  activeTrackColor:
                                      ThemeHelper.isDarkTheme(context)
                                          ? Colors.orange
                                          : const Color(0xFF0D47A1),
                                  thumbColor: ThemeHelper.isDarkTheme(context)
                                      ? Colors.orange
                                      : const Color(0xFF0D47A1),
                                  overlayColor: ThemeHelper.isDarkTheme(context)
                                      ? Colors.orange
                                      : const Color(0xFF0D47A1),
                                ),
                                child: Slider(
                                  value: _selectedValues[index],
                                  min: 1.0,
                                  max: _sliderMax[index],
                                  activeColor: ThemeHelper.isDarkTheme(context)
                                      ? Colors.orange
                                      : const Color(0xFF0D47A1),
                                  divisions:
                                      ((_sliderMax[index] - _sliderMins[index]))
                                          .toInt(),
                                  label:
                                      _selectedValues[index].toStringAsFixed(0),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedValues[index] = value;
                                      _forConstSystCalc(
                                          _selectedDif,
                                          _selectedValues[1],
                                          _selectedValues[0],
                                          _selectedSystem);
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                Padding(
                  padding: EdgeInsets.only(top: 16.0, bottom: 4),
                  child: Text(
                    S.of(context)!.setDifficult,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDif = "kolay";
                              _forConstSystCalc(
                                  _selectedDif,
                                  _selectedValues[1],
                                  _selectedValues[0],
                                  _selectedSystem);
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: ThemeHelper.getCardColor2(context),
                              border: Border.all(
                                color: _selectedDif == "kolay"
                                    ? ThemeHelper.isDarkTheme(context)
                                        ? Colors.orange
                                        : const Color(0xFF0D47A1)
                                    : Colors.grey.shade300,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                S.of(context)!.easy,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: _selectedDif == "kolay"
                                      ? ThemeHelper.isDarkTheme(context)
                                          ? Colors.orange
                                          : const Color(0xFF0D47A1)
                                      : ThemeHelper.getTextColor(context),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDif = "orta";
                              _forConstSystCalc(
                                  _selectedDif,
                                  _selectedValues[1],
                                  _selectedValues[0],
                                  _selectedSystem);
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: ThemeHelper.getCardColor2(context),
                              border: Border.all(
                                color: _selectedDif == "orta"
                                    ? ThemeHelper.isDarkTheme(context)
                                        ? Colors.orange
                                        : const Color(0xFF0D47A1)
                                    : Colors.grey.shade300,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                S.of(context)!.medium,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: _selectedDif == "orta"
                                      ? ThemeHelper.isDarkTheme(context)
                                          ? Colors.orange
                                          : const Color(0xFF0D47A1)
                                      : ThemeHelper.getTextColor(context),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDif = "zor";
                              _forConstSystCalc(
                                  _selectedDif,
                                  _selectedValues[1],
                                  _selectedValues[0],
                                  _selectedSystem);
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: ThemeHelper.getCardColor2(context),
                              border: Border.all(
                                color: _selectedDif == "zor"
                                    ? ThemeHelper.isDarkTheme(context)
                                        ? Colors.orange
                                        : const Color(0xFF0D47A1)
                                    : Colors.grey.shade300,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                S.of(context)!.hard,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: _selectedDif == "zor"
                                      ? ThemeHelper.isDarkTheme(context)
                                          ? Colors.orange
                                          : const Color(0xFF0D47A1)
                                      : ThemeHelper.getTextColor(context),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16.0, bottom: 4),
                  child: Text(
                    S.of(context)!.setType,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedSystem = "sabit";
                              _forConstSystCalc(
                                  _selectedDif,
                                  _selectedValues[1],
                                  _selectedValues[0],
                                  _selectedSystem);
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: ThemeHelper.getCardColor2(context),
                              border: Border.all(
                                color: _selectedSystem == "sabit"
                                    ? ThemeHelper.isDarkTheme(context)
                                        ? Colors.orange
                                        : const Color(0xFF0D47A1)
                                    : Colors.grey.shade300,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                S.of(context)!.fixedWeight,
                                style: TextStyle(
                                  fontSize: isWidthEnough ? 14 : 12,
                                  fontWeight: FontWeight.w600,
                                  color: _selectedSystem == "sabit"
                                      ? ThemeHelper.isDarkTheme(context)
                                          ? Colors.orange
                                          : const Color(0xFF0D47A1)
                                      : ThemeHelper.getTextColor(context),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedSystem = "rampa";
                              _forConstSystCalc(
                                  _selectedDif,
                                  _selectedValues[1],
                                  _selectedValues[0],
                                  _selectedSystem);
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: ThemeHelper.getCardColor2(context),
                              border: Border.all(
                                color: _selectedSystem == "rampa"
                                    ? ThemeHelper.isDarkTheme(context)
                                        ? Colors.orange
                                        : const Color(0xFF0D47A1)
                                    : Colors.grey.shade300,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                S.of(context)!.rampSystem,
                                style: TextStyle(
                                  fontSize: isWidthEnough ? 14 : 10,
                                  fontWeight: FontWeight.w600,
                                  color: _selectedSystem == "rampa"
                                      ? ThemeHelper.isDarkTheme(context)
                                          ? Colors.orange
                                          : const Color(0xFF0D47A1)
                                      : ThemeHelper.getTextColor(context),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_constReseult > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Card(
                      elevation: 3,
                      color: ThemeHelper.getCardColor(context),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black, // Çizgi rengi
                            width: 2.0, // Çizgi kalınlığı
                          ),
                          borderRadius:
                              BorderRadius.circular(12.0), // Köşeleri yuvarlat
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, bottom: 0, left: 8, right: 8),
                              child: Text(
                                S.of(context)!.workSets,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Divider(
                                color: ThemeHelper.getTextColor(context)
                                    .withAlpha(50),
                                height: 0.5,
                              ),
                            ),
                            SizedBox(
                              height: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Card(
                                    margin: const EdgeInsets.all(8),
                                    elevation: 3,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color:
                                            ThemeHelper.getCardColor2(context),
                                        border: Border.all(
                                          color: Colors.black, // Çizgi rengi
                                          width: 2.0, // Çizgi kalınlığı
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            12.0), // Köşeleri yuvarlat
                                      ),
                                      width: 100,
                                      // height: 100,
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            S.of(context)!.allSets,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            '${(_constReseult == _constReseult.toInt() ? _constReseult.toStringAsFixed(0) : _constReseult.toStringAsFixed(1))} kg',
                                            style: TextStyle(
                                                color:
                                                    ThemeHelper.getFitPillColor(
                                                        context),
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
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
                  ),
                if (_rampResults.isNotEmpty && _rampResults[0] > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Card(
                      elevation: 3,
                      color: ThemeHelper.getCardColor(context),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black, // Çizgi rengi
                            width: 2.0, // Çizgi kalınlığı
                          ),
                          borderRadius:
                              BorderRadius.circular(12.0), // Köşeleri yuvarlat
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, left: 8, right: 8),
                              child: Text(
                                S.of(context)!.workSets,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Divider(
                                height: 0.5,
                                color: ThemeHelper.getTextColor(context)
                                    .withAlpha(50),
                              ),
                            ),
                            SizedBox(
                              height: 100, // Yatay listenin yüksekliğini ayarla
                              child: ListView.builder(
                                scrollDirection:
                                    Axis.horizontal, // Yatay kaydırma
                                itemCount: _rampResults.length,
                                itemBuilder: (context, index) {
                                  final reversedIndex =
                                      _rampResults.length - 1 - index;
                                  return Card(
                                    // color: Colors.white,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 8.0),
                                    elevation: 3,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color:
                                            ThemeHelper.getCardColor2(context),
                                        border: Border.all(
                                          color: Colors.black, // Çizgi rengi
                                          width: 2.0, // Çizgi kalınlığı
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            12.0), // Köşeleri yuvarlat
                                      ),
                                      width:
                                          100, // Her kartın genişliğini ayarla
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${index + 1}. Set ',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            '${_rampResults[reversedIndex] == (_rampResults[reversedIndex]).toInt() ? (_rampResults[reversedIndex]).toInt() : (_rampResults[reversedIndex])} kg',
                                            style: TextStyle(
                                                color:
                                                    ThemeHelper.getFitPillColor(
                                                        context),
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ));
  }
}
