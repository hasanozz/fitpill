import 'pages/activity_page.dart';
import 'pages/body_type_calculator.dart';
import 'pages/calorie_dart.dart';
import 'pages/fat_rate.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

import 'package:fitpill/generated/l10n/l10n.dart';
import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'pages/bmi.dart';
import 'pages/ffmi_calculator/ffmi_calculate.dart';
import 'pages/onerepmax_calculate.dart';
import 'pages/workset_calculator.dart';

class CalculatorsPage extends StatefulWidget {
  const CalculatorsPage({super.key});

  @override
  CalculatorsPageState createState() => CalculatorsPageState();
}

class CalculatorsPageState extends State<CalculatorsPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double buttonHeight = screenHeight * 0.236;
    double buttonWidth = screenWidth * 0.45;

    if (MediaQuery.of(context).size.width < 400) {
      buttonHeight = screenHeight * 0.2225;
    }

    return Material(
      child: Scaffold(
        backgroundColor: ThemeHelper.getBackgroundColor(context),
        body: Padding(
          padding:
              const EdgeInsets.only(top: 4, bottom: 8.0, left: 8, right: 8),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(height: 2.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.zero,
                      child: Material(
                        elevation: 3, // Gölgenin derinliği
                        shadowColor: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            // Butonun arka planı
                            padding: EdgeInsets.zero,
                            shadowColor: Colors
                                .transparent, // Varsayılan gölge kaldırıldı
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12), // Köşe yuvarlatma
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RmCalculate(),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: ThemeHelper.getCardColor(context),
                                borderRadius: BorderRadius.circular(12)),
                            width: buttonWidth,
                            height: buttonHeight,
                            alignment: Alignment.center,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: ImageIcon(
                                    AssetImage("assets/images/dumbbell2.png"),
                                    color: ThemeHelper.isDarkTheme(context)
                                        ? Colors.white
                                        : Colors.black,
                                    size: 60.0,
                                  ),
                                ),
                                // SizedBox(height: 10.0),

                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 12.0),
                                    child: Text(
                                      S.of(context)!.rm,
                                      style: GoogleFonts.russoOne(
                                        fontSize: 18,
                                        color:
                                            ThemeHelper.getTextColor(context),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.zero,
                      child: Material(
                        elevation: 3, // Gölgenin derinliği
                        shadowColor: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
// Butonun arka planı
                            padding: EdgeInsets.zero,
                            shadowColor: Colors
                                .transparent, // Varsayılan gölge kaldırıldı
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12), // Köşe yuvarlatma
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WorkSet(),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: ThemeHelper.getCardColor(context),
                                borderRadius: BorderRadius.circular(12)),
                            width: buttonWidth,
                            height: buttonHeight,
                            alignment: Alignment.center,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: InkWell(
                                    child: Transform.scale(
                                      scale: 0.4,
                                      child: Image.asset(
                                        'assets/images/chart-pyramid.png',
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 12.0),
                                    child: Text(
                                      S.of(context)!.workSet,
                                      // style: TextStyle(
                                      //     color:
                                      //         ThemeHelper.getTextColor(context),
                                      //     fontSize: 18.0,
                                      //     fontWeight: FontWeight.bold),
                                      style: GoogleFonts.russoOne(
                                        fontSize: 18,
                                        color:
                                            ThemeHelper.getTextColor(context),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.zero,
                      child: Material(
                        elevation: 3,
                        shadowColor: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            // Butonun arka planı
                            padding: EdgeInsets.zero,
                            shadowColor: Colors
                                .transparent, // Varsayılan gölge kaldırıldı
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12), // Köşe yuvarlatma
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FFMICalculate(),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: ThemeHelper.getCardColor(context),
                                borderRadius: BorderRadius.circular(12)),
                            width: buttonWidth,
                            height: buttonHeight,
                            alignment: Alignment.center,
                            child: Stack(
                              alignment: Alignment
                                  .center, // Tüm öğeleri buton içinde hizalar
                              children: [
                                const Align(
                                  alignment:
                                      Alignment.center, // İkon tam ortada kalır
                                  child: Icon(
                                    MingCute.fitness_fill,
                                    color: Color(0xFFE3B78F),
                                    size: 60.0,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment
                                      .bottomCenter, // Yazı en alt hizalanır
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 12.0),
                                    child: Text(
                                      S.of(context)!.ffmi,
                                      // style: TextStyle(
                                      //   color:
                                      //       ThemeHelper.getTextColor(context),
                                      //   fontSize: 18.0,
                                      //   fontWeight: FontWeight.bold,
                                      // ),
                                      style: GoogleFonts.russoOne(
                                        fontSize: 18,
                                        color:
                                            ThemeHelper.getTextColor(context),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.zero,
                      child: Material(
                        elevation: 3,
                        shadowColor: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            // Butonun arka planı
                            padding: EdgeInsets.zero,
                            shadowColor: Colors
                                .transparent, // Varsayılan gölge kaldırıldı
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12), // Köşe yuvarlatma
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ActivityPage(),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: ThemeHelper.getCardColor(context),
                                borderRadius: BorderRadius.circular(12)),
                            width: buttonWidth,
                            height: buttonHeight,
                            alignment: Alignment.center,
                            child: Stack(
                              alignment: Alignment
                                  .center, // Tüm öğeleri buton içinde hizalar
                              children: [
                                const Align(
                                  alignment:
                                      Alignment.center, // İkon tam ortada kalır
                                  child: Icon(
                                    FontAwesomeIcons.personRunning,
                                    color: Colors.blue,
                                    size: 60.0,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment
                                      .bottomCenter, // Yazı en alt hizalanır
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 12.0),
                                    child: Text(
                                      S.of(context)!.activity,
                                      // style: TextStyle(
                                      //   color:
                                      //       ThemeHelper.getTextColor(context),
                                      //   fontSize: 18.0,
                                      //   fontWeight: FontWeight.bold,
                                      // ),
                                      style: GoogleFonts.russoOne(
                                        fontSize: 18,
                                        color:
                                            ThemeHelper.getTextColor(context),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),

                // Kalori ve Yağ Oranı Butonları
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Kalori Butonu
                    Padding(
                      padding: EdgeInsets.zero,
                      child: Material(
                        elevation: 3, // Gölgenin derinliği
                        shadowColor: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            // Butonun arka planı
                            padding: EdgeInsets.zero,
                            shadowColor: Colors
                                .transparent, // Varsayılan gölge kaldırıldı
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12), // Köşe yuvarlatma
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FatRatePage(),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: ThemeHelper.getCardColor(context),
                                borderRadius: BorderRadius.circular(12)),
                            width: buttonWidth,
                            height: buttonHeight,
                            alignment: Alignment.center,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                const Align(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.water_drop,
                                    color: Colors.amber,
                                    size: 60.0,
                                  ),
                                ),
                                // SizedBox(height: 10.0),

                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 12.0),
                                    child: Text(
                                      S.of(context)!.fatPercentage,
                                      // style: TextStyle(
                                      //     color:
                                      //         ThemeHelper.getTextColor(context),
                                      //     fontSize: 18.0,
                                      //     fontWeight: FontWeight.bold),
                                      style: GoogleFonts.russoOne(
                                        fontSize: 18,
                                        color:
                                            ThemeHelper.getTextColor(context),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Yağ Oranı Butonu
                    Padding(
                      padding: EdgeInsets.zero,
                      child: Material(
                        elevation: 3,
                        shadowColor: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shadowColor: Colors
                                .transparent, // Varsayılan gölge kaldırıldı
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12), // Köşe yuvarlatma
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CaloriePage(),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: ThemeHelper.getCardColor(context),
                                borderRadius: BorderRadius.circular(12)),
                            width: buttonWidth,
                            height: buttonHeight,
                            alignment: Alignment.center,
                            child: Stack(
                              alignment: Alignment
                                  .center, // Tüm öğeleri buton içinde hizalar
                              children: [
                                const Align(
                                  alignment:
                                      Alignment.center, // İkon tam ortada kalır
                                  child: Icon(
                                    Icons.restaurant,
                                    color: Colors.green,
                                    size: 60.0,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment
                                      .bottomCenter, // Yazı en alt hizalanır
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 12.0),
                                    child: Text(
                                      S.of(context)!.calories,
                                      // style: TextStyle(
                                      //   color:
                                      //       ThemeHelper.getTextColor(context),
                                      //   fontSize: 18.0,
                                      //   fontWeight: FontWeight.bold,
                                      // ),
                                      style: GoogleFonts.russoOne(
                                        fontSize: 18,
                                        color:
                                            ThemeHelper.getTextColor(context),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.zero,
                      child: Material(
                        elevation: 3,
                        shadowColor: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shadowColor: Colors
                                .transparent, // Varsayılan gölge kaldırıldı
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12), // Köşe yuvarlatma
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BmiPage(),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: ThemeHelper.getCardColor(context),
                                borderRadius: BorderRadius.circular(12)),
                            width: buttonWidth,
                            height: buttonHeight,
                            alignment: Alignment.center,
                            child: Stack(
                              alignment: Alignment
                                  .center, // Tüm öğeleri buton içinde hizalar
                              children: [
                                const Align(
                                  alignment:
                                      Alignment.center, // İkon tam ortada kalır
                                  child: Icon(
                                    FontAwesome.weight_scale_solid,
                                    color: Colors.blueGrey,
                                    size: 60.0,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment
                                      .bottomCenter, // Yazı en alt hizalanır
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 12.0),
                                    child: Text(
                                      S.of(context)!.bmi,
                                      // style: TextStyle(
                                      //   color:
                                      //       ThemeHelper.getTextColor(context),
                                      //   fontSize: 18.0,
                                      //   fontWeight: FontWeight.bold,
                                      // ),
                                      style: GoogleFonts.russoOne(
                                        fontSize: 18,
                                        color:
                                            ThemeHelper.getTextColor(context),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.zero,
                      child: Material(
                        elevation: 3, // Gölgenin derinliği
                        shadowColor: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            // Butonun arka planı
                            padding: EdgeInsets.zero,
                            shadowColor: Colors
                                .transparent, // Varsayılan gölge kaldırıldı
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12), // Köşe yuvarlatma
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const BodyTypeCalculator(),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: ThemeHelper.getCardColor(context),
                                borderRadius: BorderRadius.circular(12)),
                            width: buttonWidth,
                            height: buttonHeight,
                            alignment: Alignment.center,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Align(
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      "assets/images/body_type.png",
                                      color: Colors.deepOrangeAccent,
                                      scale: 10,
                                    )),
                                // SizedBox(height: 10.0),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 12.0),
                                    child: Text(
                                      S.of(context)!.bodyType,
                                      style: GoogleFonts.russoOne(
                                        fontSize: 18,
                                        color:
                                            ThemeHelper.getTextColor(context),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
