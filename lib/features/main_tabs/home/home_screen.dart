import 'package:fitpill/core/ui//widgets/app_schimmer.dart';
import 'package:fitpill/features/main_tabs/home/body_fat/body_fat_info_card.dart';
import 'package:fitpill/features/main_tabs/home/home_horizontal_cards.dart';
import 'package:fitpill/features/main_tabs/home/measurement_files/measurement_mini_graph_card.dart';
import 'package:fitpill/features/main_tabs/home/premium/goal_summary_card.dart';
import 'package:fitpill/features/main_tabs/home/profile/profile_info_card.dart';
import 'package:fitpill/features/main_tabs/home/weekly_routine/weekly_routine_analytics_card.dart';
import 'package:fitpill/features/main_tabs/progress/progress_provider.dart';
import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:fitpill/core/system/config/theme/theme_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage>, RouteAware {
  @override
  bool get wantKeepAlive => true;

  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final selectedMetricAsync = ref.watch(favoriteMetricProvider);
    final themeMode = ref.watch(themeNotifierProvider);
    final isDarkTheme = themeMode == ThemeMode.dark;

    return selectedMetricAsync.when(
      data: (_) {
        const pageCount = 3;
        return Scaffold(
          backgroundColor: ThemeHelper.getBackgroundColor(context),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 150,
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      children: const [
                        ProfileInfoCard(),
                        BodyFatInfoCard(),
                        WeeklyRoutineAnalyticsCard(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(pageCount, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentIndex == index ? 20 : 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: _currentIndex == index
                              ? isDarkTheme
                                  ? Colors.orange
                                  : const Color(0xFF0D47A1)
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  const MeasurementMiniGraphCard(),
                  const SizedBox(height: 16),
                  const GoalSummaryCard(),
                  const SizedBox(height: 16),
                  const HomeHorizontalCards(),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: AppPageShimmer(),
      ),
      error: (e, st) => Scaffold(
        body: Center(child: Text('Hata: $e')),
      ),
    );
  }
}
