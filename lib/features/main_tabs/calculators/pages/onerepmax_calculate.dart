import 'package:fitpill/generated/l10n/l10n.dart';
import 'package:fitpill/core/ui/dialogs/show_dialogs.dart';
import 'package:fitpill/core/ui/dialogs/snackbar_helper.dart';
import 'package:fitpill/core/ui/widgets/textfield_design.dart';
import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:flutter/material.dart';

class RmCalculate extends StatefulWidget {
  const RmCalculate({super.key});

  @override
  State<RmCalculate> createState() => _RmCalculateState();
}

class _RmCalculateState extends State<RmCalculate> {
  final TextEditingController liftController = TextEditingController();
  List<double> repResults = [];
  List<double> weights = [];
  int selectedRep = 1;
  late PageController _controller;
  final List<int> reps = List<int>.generate(10, (index) => index + 1); // 1-10

  void calculateRepMax() {
    double weight = double.parse(liftController.text);
    int reps = selectedRep;
    if (weight <= 500) {
      double oneRepMax = weight / (1.0278 - (0.0278 * reps));

      // 1'den 10'a kadar olan tekrarlar için ağırlıkları hesapla
      List<double> repMaxList = List.generate(10, (index) {
        int currentRep = index + 1; // 1'den 10'a kadar tekrar
        return oneRepMax * (1.0278 - (0.0278 * currentRep));
      });

      // Sonuçları güncelle
      setState(() {
        repResults = repMaxList; // Listeyi bir değişkene ata
      });
    } else {
      setState(() {
        repResults = [];
        SnackbarHelper.show(
          context,
          message: S.of(context)!.invalidWeightRm,
          icon: Icons.warning_amber,
          backgroundColor: Colors.redAccent,
        ); // Listeyi temizle
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      initialPage: reps.length * 500, // Sonsuz döngü için ortadan başlat
      viewportFraction:
          0.3, // Görünüm genişliği: önceki ve sonraki değerler için
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkTheme ? const Color(0xFF1E1E1E) : Colors.white;
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
                    S.of(context)!.repMaxCalculator,
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
                          S.of(context)!.brzyckiFormulaInfo,
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
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Divider(
                height: 0.5,
                color: ThemeHelper.getTextColor(context).withAlpha(50),
              ),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: buildInputField(
                    context: context,
                    controller: liftController,
                    labelText: '${S.of(context)!.weight} (kg)',
                    icon: Icons.fitness_center,
                    suffixText: 'kg',
                    onChanged: (value) => calculateRepMax(),
                  )),
              const SizedBox(
                height: 16,
              ),
              Column(
                children: [
                  Text(
                    S.of(context)!.reps,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(
                    height: 100, // Kaydırma alanı yüksekliği
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: reps.length *
                          1000, // Sonsuz döngü için büyük bir sayı
                      onPageChanged: (page) {
                        setState(() {
                          selectedRep = reps[page % reps.length];
                          // calculateRepMax();
                          if (liftController.text != '') {
                            calculateRepMax();
                          }
                        });
                      },
                      itemBuilder: (context, index) {
                        final currentRep = reps[index % reps.length];
                        final isSelected = currentRep == selectedRep;

                        return Opacity(
                          opacity: isSelected
                              ? 1.0
                              : 0.5, // Önceki/sonraki değerleri soluklaştır
                          child: Center(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: isSelected ? 120 : 60,
                              // Seçili olan büyük
                              height: isSelected ? 50 : 50,
                              decoration: isSelected
                                  ? BoxDecoration(
                                      border: Border.all(
                                        color: ThemeHelper.getFitPillColor(
                                            context),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    )
                                  : null,
                              alignment: Alignment.center,
                              child: Text(
                                '$currentRep',
                                style: TextStyle(
                                  fontSize: isSelected ? 32 : 24,
                                  color: isSelected
                                      ? ThemeHelper.getFitPillColor(context)
                                      : Colors.grey,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              if (repResults.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        // Kaydırmayı kapat
                        shrinkWrap: true,
                        // Alanı dinamik yap
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Her satırda 2 sütun
                          mainAxisSpacing: 12, // Satırlar arası boşluk
                          crossAxisSpacing: 12, // Sütunlar arası boşluk
                          childAspectRatio: 2.5, // Kart oranı
                        ),
                        itemCount: repResults.length,
                        itemBuilder: (context, index) {
                          // Tekrar sayısı
                          int currentRep = index + 1;
                          bool isSelected = currentRep == selectedRep;

                          return Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? ThemeHelper.getFitPillColor(context)
                                  : ThemeHelper.getTextColor(context)
                                      .withAlpha(150),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected
                                    ? ThemeHelper.getFitPillColor(context)
                                    : Colors.black,
                                width: 1,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$currentRep ${S.of(context)!.reps}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        ThemeHelper.getBackgroundColor(context),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${repResults[index].toStringAsFixed(2)} kg',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color:
                                        ThemeHelper.getBackgroundColor(context),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
