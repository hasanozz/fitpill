import 'package:fitpill/generated/l10n/l10n.dart';
import 'package:fitpill/core/ui/dialogs/show_dialogs.dart';
import 'package:fitpill/core/ui/dialogs/snackbar_helper.dart';
import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icons_plus/icons_plus.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  TextEditingController bodyWeightController = TextEditingController();
  int selectedCardIndex = -1;
  int selectedFoodIndex = 0;
  String _selectedTempo = "Dengeli";
  double? result;
  String ifWrongBw = '';
  double _sliderValue = 60;

  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Food> foodList = [];
  late final List<Exercise> exerciseList;
  late final S? s = S.of(context);

  @override
  void initState() {
    super.initState();

    exerciseList = [
      Exercise(
        name: s!.walk,
        icon: FontAwesomeIcons.personWalking,
        slowMet: 2.8,
        moderateMet: 3.8,
        fastMet: 4.8,
      ),
      Exercise(
        name: s!.inclinedWalk,
        icon: MingCute.arrow_right_up_line,
        slowMet: 5.3,
        moderateMet: 7.0,
        fastMet: 8.8,
      ),
      Exercise(
        name: s!.run,
        icon: FontAwesomeIcons.personRunning,
        slowMet: 6.5,
        moderateMet: 8.5,
        fastMet: 9.3,
      ),
      Exercise(
        name: s!.bicycle,
        icon: Bootstrap.bicycle,
        slowMet: 4.0,
        moderateMet: 7.0,
        fastMet: 9.0,
      ),
      Exercise(
        name: s!.swimming,
        icon: Icons.pool,
        slowMet: 5.8,
        moderateMet: 8.0,
        fastMet: 10.5,
      ),
      Exercise(
        name: s!.weightlifting,
        icon: MingCute.barbell_line,
        slowMet: 3.5,
        moderateMet: 5.0,
        fastMet: 6.0,
      ),
      Exercise(
        name: s!.rowing,
        icon: Icons.rowing,
        slowMet: 5.0,
        moderateMet: 7.3,
        fastMet: 11.0,
      ),
      Exercise(
        name: s!.jumpRope,
        icon: Icons.accessibility,
        slowMet: 8.3,
        moderateMet: 11.8,
        fastMet: 12.3,
      ),
      Exercise(
        name: s!.stairs,
        icon: FontAwesomeIcons.stairs,
        slowMet: 4.5,
        moderateMet: 6.8,
        fastMet: 9.3,
      ),
      Exercise(
        name: s!.hiit,
        icon: FontAwesomeIcons.stopwatch20,
        slowMet: 4.0,
        moderateMet: 7.0,
        fastMet: 11.0,
      ),
      Exercise(
        name: s!.football,
        icon: LineAwesome.futbol,
        slowMet: 4.0,
        moderateMet: 7.8,
        fastMet: 8.0,
      ),
      Exercise(
        name: s!.basketball,
        icon: FontAwesomeIcons.basketball,
        slowMet: 5.0,
        moderateMet: 7.5,
        fastMet: 8.0,
      ),
      Exercise(
        name: s!.volleyball,
        icon: FontAwesomeIcons.volleyball,
        slowMet: 3.0,
        moderateMet: 4.0,
        fastMet: 6.0,
      ),
      Exercise(
        name: s!.boxing,
        icon: Icons.sports_martial_arts_outlined,
        slowMet: 5.8,
        moderateMet: 7.8,
        fastMet: 12.3,
      ),
      Exercise(
        name: s!.dance,
        icon: Icons.music_note,
        slowMet: 3.0,
        moderateMet: 5.0,
        fastMet: 9.8,
      ),
      Exercise(
        name: s!.housework,
        icon: Icons.home_outlined,
        slowMet: 2.3,
        moderateMet: 3.3,
        fastMet: 3.8,
      ),
      Exercise(
        name: s!.sex,
        icon: EvaIcons.heart,
        slowMet: 1.8,
        moderateMet: 3.0,
        fastMet: 5.8,
      ),
      Exercise(
        name: s!.sleep,
        icon: MingCute.sleep_line,
        slowMet: 1.0,
        moderateMet: 1.0,
        fastMet: 1.0,
      ),
    ];
  }



  void _calculateCaloriesBurned() {
    if (selectedCardIndex < 0 || selectedCardIndex >= exerciseList.length) {
      return; // Fonksiyonu sonlandır
    }

    double bodyWeight = double.tryParse(bodyWeightController.text) ?? 0;
    double duration = _sliderValue / 60;
    Exercise exercise = exerciseList[selectedCardIndex];
    double metValue = exercise.moderateMet;

    if (bodyWeightController.text != '') {
      if (bodyWeight > 25 && bodyWeight < 250) {
        ifWrongBw = '';
        if (_selectedTempo == 'Sakin') {
          metValue = exercise.slowMet;
        } else if (_selectedTempo == 'Dengeli') {
          metValue = exercise.moderateMet;
        } else if (_selectedTempo == 'Yoğun') {
          metValue = exercise.fastMet;
        }
        result = bodyWeight * metValue * duration;
        _updateFoodList(context);
      } else {
        result = null;
        SnackbarHelper.show(
          context,
          message: S.of(context)!.invalidWeight,
          icon: Icons.warning_amber,
          backgroundColor: Colors.redAccent,
        );
      }
    }
  }

  void _updateFoodList(BuildContext context) {
    setState(() {
      if (result != null) {
        foodList.clear();
        foodList.addAll([
          Food(
              name: S.of(context)!.baklava,
              icon: FontAwesomeIcons.cheese,
              calorie: 175,
              burnedText:
                  '${(result! / 175).toStringAsFixed(1)} ${s!.slice}'),
          Food(
              name: s!.pizza,
              icon: FontAwesomeIcons.pizzaSlice,
              calorie: 250,
              burnedText:
                  '${(result! / 250).toStringAsFixed(1)} ${s!.slice}'),
          Food(
              name: s!.hamburger,
              icon: FontAwesomeIcons.burger,
              calorie: 300,
              burnedText:
                  '${(result! / 300).toStringAsFixed(1)} ${s!.piece}'),
          Food(
              name: s!.bread,
              icon: MingCute.bread_line,
              calorie: 65,
              burnedText:
                  '${(result! / 65).toStringAsFixed(1)} ${s!.slice}'),
          Food(
              name: s!.soda,
              icon: FontAwesomeIcons.whiskeyGlass,
              calorie: 84,
              burnedText:
                  '${(result! / 84).toStringAsFixed(1)} ${s!.glass}'),
          Food(
              name: s!.creamyCoffee,
              icon: FontAwesomeIcons.mugHot,
              calorie: 300,
              burnedText:
                  '${(result! / 300).toStringAsFixed(1)} ${s!.grande}'),
        ]);
      }
    });
  }

  void _showFoodList() {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkTheme ? const Color(0xFF1E1E1E) : Colors.white;
    final cardColor = isDarkTheme ? const Color(0xFF2C2C2C) : Colors.white54;
    final textColor = isDarkTheme ? Colors.white54 : Colors.black87;
    showModalBottomSheet(
      backgroundColor: backgroundColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, modalSetState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: ListView.builder(
                  itemCount: foodList.length,
                  itemBuilder: (context, index) {
                    bool isSelected = index == selectedFoodIndex;
                    return GestureDetector(
                      onTap: () {
                        // Seçilen öğeyi güncelle
                        setState(() {
                          selectedFoodIndex = index;
                        });
                        modalSetState(() {});
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: cardColor,
                          border: Border.all(
                            color: isSelected
                                ? ThemeHelper.getFitPillColor(context)
                                : Colors.grey.shade300,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            if (isSelected)
                              BoxShadow(
                                color: ThemeHelper.getFitPillColor(context)
                                    .withAlpha((255 * 0.4).toInt()),
                                blurRadius: 3,
                                offset: const Offset(0, 2),
                              )
                            else
                              BoxShadow(
                                color:
                                    Colors.grey.withAlpha((255 * 0.1).toInt()),
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              foodList[index].icon,
                              size: 30,
                              color: isSelected
                                  ? ThemeHelper.getFitPillColor(context)
                                  : Colors.grey[700],
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                foodList[index].name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? ThemeHelper.getFitPillColor(context)
                                      : textColor,
                                ),
                              ),
                            ),
                            Text(
                              '${foodList[index].calorie} kcal',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: isSelected
                                    ? ThemeHelper.getFitPillColor(context)
                                    : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkTheme ? const Color(0xFF1E1E1E) : Colors.white;
    final cardColor = isDarkTheme ? const Color(0xFF2C2C2C) : Colors.white;
    final textColor = isDarkTheme ? Colors.white54 : Colors.black87;
    final isWidthEnough = MediaQuery.of(context).size.width > 400;
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
                    s!.activityCalorieCalculator,
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
                        title: s!.information,
                        labels: [],
                        // boş
                        icon: Icons.info,
                        content: Text(
                          s!.metInfoText,
                          style: const TextStyle(fontSize: 16),
                        ),
                        confirmText:s!.ok,
                        cancelText: s!.cancel,
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
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(
                height: 0.5,
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                    cursorColor: ThemeHelper.getFitPillColor(context),
                    controller: bodyWeightController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(
                            r'^[0-9]*\.?[0-9]*$'), // Sadece pozitif sayılar ve ondalık değerler
                      ),
                    ],
                    maxLength: 6,
                    buildCounter: (context,
                        {required currentLength,
                        required isFocused,
                        maxLength}) {
                      return null;
                    },
                    decoration: InputDecoration(
                      counterStyle: null,
                      counterText: null,
                      prefixIcon: Icon(
                        Icons.monitor_weight,
                        color: ThemeHelper.getFitPillColor(context),
                      ),
                      labelText:s!.bodyWeightKg,
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
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                    ),
                    onSubmitted: (_) {
                      setState(() {
                        _calculateCaloriesBurned();
                      });
                    }),
              ),
              const SizedBox(
                height: 8,
              ),
              Center(
                child: Text(s!.exercises,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              SizedBox(
                height: 230,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount:
                      (exerciseList.length / 6).ceil(), // Her sayfada 6 kart
                  itemBuilder: (context, pageIndex) {
                    // Sayfa için egzersiz listesini bölüyoruz
                    final start = pageIndex * 6;
                    final end = (start + 6) > exerciseList.length
                        ? exerciseList.length
                        : start + 6;
                    final exercises = exerciseList.sublist(start, end);

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // Her satırda 3 kart
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 1.2,
                        ),
                        itemCount: exercises.length,
                        itemBuilder: (context, index) {
                          final globalIndex = start + index;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                // Yalnızca bir kart seçilebilir
                                selectedCardIndex =
                                    (selectedCardIndex == globalIndex)
                                        ? -1
                                        : globalIndex;
                                _calculateCaloriesBurned();
                              });
                            },
                            child: Card(
                              color: selectedCardIndex == globalIndex
                                  ? ThemeHelper.getFitPillColor(context)
                                  : cardColor,
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    exercises[index].icon,
                                    size: isWidthEnough ? 40 : 30,
                                    color: selectedCardIndex == globalIndex
                                        ? cardColor
                                        : textColor,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    exercises[index].name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: isWidthEnough ? 12 : 10,
                                      color: selectedCardIndex == globalIndex
                                          ? cardColor
                                          : textColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  (exerciseList.length / 6).ceil(),
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 20 : 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? ThemeHelper.getFitPillColor(context)
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              if (selectedCardIndex != 17)
                Center(
                  child: Text(s!.tempo,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                ),
              if (selectedCardIndex != 17)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Yavaş Tempo
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTempo = "Sakin";

                            _calculateCaloriesBurned();
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          width: 110,
                          height: 110,
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: _selectedTempo == "Sakin"
                                ? const LinearGradient(
                                    colors: [Colors.green, Colors.lightGreen],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : LinearGradient(
                                    colors: [
                                      Colors.grey[300]!,
                                      Colors.grey[400]!
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: _selectedTempo == "Sakin"
                                    ? Colors.green
                                        .withAlpha((255 * 0.1).toInt())
                                    : Colors.grey
                                        .withAlpha((255 * 0.1).toInt()),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(2, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FontAwesomeIcons.faceGrinWink,
                                size: 40,
                                color: _selectedTempo == "Sakin"
                                    ? Colors.white
                                    : Colors.black54,
                              ),
                              const SizedBox(height: 5),
                              Center(
                                child: Text(
                                  s!.slow,
                                  style: TextStyle(
                                    color: _selectedTempo == "Sakin"
                                        ? Colors.white
                                        : Colors.black54,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Orta Tempo
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTempo = "Dengeli";

                            _calculateCaloriesBurned();
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          width: 110,
                          height: 110,
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: _selectedTempo == "Dengeli"
                                ? const LinearGradient(
                                    colors: [
                                      Colors.orangeAccent,
                                      Colors.orange
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : LinearGradient(
                                    colors: [
                                      Colors.grey[300]!,
                                      Colors.grey[400]!
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: _selectedTempo == "Dengeli"
                                    ? Colors.orange
                                        .withAlpha((255 * 0.1).toInt())
                                    : Colors.grey
                                        .withAlpha((255 * 0.1).toInt()),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(2, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                MingCute.sweats_line,
                                size: 40,
                                color: _selectedTempo == "Dengeli"
                                    ? Colors.white
                                    : Colors.black54,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                s!.moderate,
                                style: TextStyle(
                                  color: _selectedTempo == "Dengeli"
                                      ? Colors.white
                                      : Colors.black54,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Yoğun Tempo
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTempo = "Yoğun";

                            _calculateCaloriesBurned();
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          width: 110,
                          height: 110,
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: _selectedTempo == "Yoğun"
                                ? const LinearGradient(
                                    colors: [Colors.red, Colors.redAccent],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : LinearGradient(
                                    colors: [
                                      Colors.grey[300]!,
                                      Colors.grey[400]!
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: _selectedTempo == "Yoğun"
                                    ? Colors.red.withAlpha((255 * 0.1).toInt())
                                    : Colors.grey
                                        .withAlpha((255 * 0.1).toInt()),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(2, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FontAwesome.face_dizzy,
                                size: 40,
                                color: _selectedTempo == "Yoğun"
                                    ? Colors.white
                                    : Colors.black54,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                s!.fast,
                                style: TextStyle(
                                  color: _selectedTempo == "Yoğun"
                                      ? Colors.white
                                      : Colors.black54,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(
                height: 16,
              ),
              Center(
                child: Text(s!.duration,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          valueIndicatorTextStyle: TextStyle(
                            color: ThemeHelper.getBackgroundColor(
                                context), // Labelın metin rengini değiştiri
                          ),
                        ),
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            thumbShape:
                                RoundSliderThumbShape(enabledThumbRadius: 15),
                            overlayShape:
                                RoundSliderOverlayShape(overlayRadius: 24),
                          ),
                          child: Slider(
                            value: _sliderValue,
                            min: 1,
                            max: 300,
                            divisions: 300,
                            label:
                                "${_sliderValue.round()} ${s!.minutes}",
                            onChanged: (double value) {
                              setState(() {
                                _sliderValue = value;

                                _calculateCaloriesBurned();
                              });
                            },
                            activeColor: ThemeHelper.getFitPillColor(context),
                            inactiveColor: Colors.grey[300],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  )
                ],
              ),
              if (result != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Toplam 2 sütun olacak
                      crossAxisSpacing: 10, // Sütunlar arası boşluk
                      mainAxisSpacing: 10, // Satırlar arası boşluk
                      childAspectRatio: 2 / 2, // Kartların boy/en oranı
                    ),
                    shrinkWrap:
                        true, // GridView'ın kendi boyutuna sığmasını sağlar
                    physics:
                        const NeverScrollableScrollPhysics(), // Kaydırma kapalı
                    children: [
                      // Yakılan Kalori Kartı (2 sütun genişlik)
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
                                const Icon(
                                  FontAwesomeIcons.fire,
                                  size: 50,
                                  color: Colors.redAccent,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  s!.burnedCalories,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: isWidthEnough ? 16 : 14),
                                ),
                                SizedBox(height: isWidthEnough ? 10 : 5),
                                Text(
                                  "${result!.round()} kcal",
                                  style: TextStyle(
                                      fontSize: isWidthEnough ? 20 : 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.redAccent),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Baklava Kartı (1 sütun genişlik)
                      GridTile(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _showFoodList();
                            });
                          },
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
                                  Icon(
                                    foodList[selectedFoodIndex].icon,
                                    size: 40,
                                    color: Colors.amber,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    foodList[selectedFoodIndex].name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: isWidthEnough ? 16 : 14),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    foodList[selectedFoodIndex].burnedText,
                                    style: TextStyle(
                                        fontSize: isWidthEnough ? 18 : 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.amber),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
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

class Exercise {
  final String name;
  final IconData icon;
  final double slowMet; // Yavaş tempo MET
  final double moderateMet; // Orta tempo MET
  final double fastMet; // Hızlı tempo MET

  Exercise({
    required this.name,
    required this.icon,
    required this.slowMet,
    required this.moderateMet,
    required this.fastMet,
  });
}

class Food {
  final String name;
  final IconData icon;
  final int calorie;
  final String burnedText;

  Food({
    required this.name,
    required this.icon,
    required this.calorie,
    required this.burnedText,
  });
}
