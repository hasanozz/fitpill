import 'package:fitpill/generated/l10n/l10n.dart';
import 'package:fitpill/features/main_tabs/programs/fitpil_programs_tab.dart';
import 'package:fitpill/features/main_tabs/programs/workouts_screen.dart';
import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:flutter/material.dart';

class WorkoutsRootScreen extends StatelessWidget {
  const WorkoutsRootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: ThemeHelper.getBackgroundColor(context),
        appBar: AppBar(
          backgroundColor: ThemeHelper.getBackgroundColor(context),
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            l10n!.workoutTabHeader,
            style: TextStyle(
              color: ThemeHelper.getTextColor(context),
              fontWeight: FontWeight.w700,
            ),
          ),
          foregroundColor: ThemeHelper.getTextColor(context),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(64),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: ThemeHelper.getCardColor(context),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: ThemeHelper.getFitPillColor(context).withValues(alpha: 0.2),
                  ),
                ),
                child: TabBar(
                  labelColor: ThemeHelper.getFitPillColor(context),
                  unselectedLabelColor:
                      ThemeHelper.getTextColor(context).withValues(alpha: 0.6),
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color:
                        ThemeHelper.getFitPillColor(context).withValues(alpha: 0.12),
                  ),
                  tabs: [
                    Tab(text: l10n.workoutTabMyWorkouts),
                    Tab(text: l10n.workoutTabFitpillPrograms),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: const TabBarView(
          physics: BouncingScrollPhysics(),
          children: [
            WorkoutScreen(),
            FitpilProgramsTab(),
          ],
        ),
      ),
    );
  }
}

