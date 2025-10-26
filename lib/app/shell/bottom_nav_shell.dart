// bottom_nav_shell.dart

import 'package:fitpill/features/main_tabs/home/anatomy/anatomy_page.dart';
import 'package:fitpill/generated/l10n/l10n.dart';
import 'package:fitpill/core/ui/widgets/day_iconbutton_labels.dart';
import 'package:fitpill/features/main_tabs/calculators/calculators_screen.dart';
import 'package:fitpill/features/main_tabs/home/home_screen.dart';
import 'package:fitpill/features/main_tabs/progress/progress_page.dart';
import 'package:fitpill/features/main_tabs/programs/workouts_root_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:fitpill/core/ui/app_bars/main_app_bar.dart';


// ----------------------------------------------------------------------
// RİVERPOD 3.0 GÜNCELLEMESİ
// StateProvider yerine Notifier ve NotifierProvider kullanılır.
// ----------------------------------------------------------------------

/// StateProvider'ın yerini alan Notifier
class SelectedIndexNotifier extends Notifier<int> {
  // Başlangıç değerini döndürür (Home ekranı için 2)
  @override
  int build() => 2;

  // Durumu güncellemek için bir metot tanımlanır
  void setIndex(int index) {
    state = index;
  }
}

/// Yeni NotifierProvider tanımı
final selectedIndexProvider = NotifierProvider<SelectedIndexNotifier, int>(
  SelectedIndexNotifier.new,
);

// ----------------------------------------------------------------------
// WIDGET KODU
// ----------------------------------------------------------------------

class MainMenu extends ConsumerStatefulWidget {
  const MainMenu({super.key});

  @override
  MainMenuState createState() => MainMenuState();
}

class MainMenuState extends ConsumerState<MainMenu> {
  final List<Widget> _pages = [
    const ProgressPage(),
    const AnatomyPage(),
    const HomePage(),
    const WorkoutsRootScreen(),
    const CalculatorsPage()
  ];

  // navbar widgetın fonksu
  Widget navigationBar(int selectedIndex) {
    final isWidthEnough = MediaQuery.of(context).size.width > 400;

    return Theme(
      data: Theme.of(context).copyWith(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedLabelStyle: GoogleFonts.tomorrow(
            fontSize: 9,
            color: ThemeHelper.getTextColor(context),
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: GoogleFonts.tomorrow(
            fontSize: 8,
            color: Colors.grey.withValues(alpha: 0.7),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          // Güncelleme: StateProvider'daki .state yerine Notifier'daki setIndex metodu çağırılır.
          ref.read(selectedIndexProvider.notifier).setIndex(index);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              selectedIndex == 0 ? Icons.analytics : Icons.analytics_outlined,
              size: isWidthEnough ? 35 : 30,
            ),
            label: S.of(context)!.progress,
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              const AssetImage("assets/images/dumbbell2.png"),
              size: isWidthEnough ? 35 : 30,
            ),
            label: S.of(context)!.exercises,
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              // ikon ile border arasında boşluk

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selectedIndex == 2
                      ? ThemeHelper.getTextColor(context)
                      : Colors.grey,
                  width: 2, // Border kalınlığı
                ),
              ),
              child: SizedBox(
                height: 38,
                width: 38,
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/pill_cropped.png',
                    color: selectedIndex == 2
                        ? ThemeHelper.getTextColor(context)
                        : Colors.grey,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              selectedIndex == 3
                  ? MingCute.fitness_fill
                  : MingCute.fitness_line,
              size: isWidthEnough ? 35 : 30,
            ),
            label: S.of(context)!.workout,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              selectedIndex == 4
                  ? Clarity.calculator_solid
                  : Clarity.calculator_line,
              size: isWidthEnough ? 35 : 30,
            ),
            label: S.of(context)!.calculators,
          ),
        ],
        // Yazılar sabit kalır
        type: BottomNavigationBarType.fixed,
        // Seçili sekme yazı boyutu
        selectedFontSize: 11,
        // Seçili olmayan sekme yazı boyutu
        unselectedFontSize: 10,
        // Seçili sekme rengi
        selectedItemColor: ThemeHelper.getTextColor(context),
        // Seçili olmayan sekme rengi)
        unselectedItemColor: Colors.grey,

        backgroundColor: ThemeHelper.getBackgroundColor(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // İzleme (watch) aynı kalır
    final selectedIndex = ref.watch(selectedIndexProvider);
    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      key: globalScaffoldKey,
      appBar: ConstantAppBar().customAppBar(context),
      // IndexedStack navbar sayfa geçişlerinde state'i korur sayfa güncellenmes
      body: IndexedStack(
        index: selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: navigationBar(selectedIndex),
    );
  }
}