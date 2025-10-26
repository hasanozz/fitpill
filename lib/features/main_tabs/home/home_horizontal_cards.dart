import 'package:fitpill/features/main_tabs/home/backpack/backpack.dart';
import 'package:fitpill/features/main_tabs/home/weekly_routine/weekly_routine_page.dart';
import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:fitpill/generated/l10n/l10n.dart';

class HomeHorizontalCards extends StatelessWidget {
  const HomeHorizontalCards({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: _buildHorizontalCard(
                context,
                title: S.of(context)!.weeklyRoutineCardTitle,
                icon: const Icon(
                  FontAwesomeIcons.calendarDays,
                  size: 36,
                  color: Colors.black,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const WeeklyRoutinePage(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildHorizontalCard(
                context,
                title: S.of(context)!.myBags,
                icon: Image.asset(
                  'assets/images/gymbag_wout_icon.png',
                  width: 50,
                  color: ThemeHelper.getTextColor(context),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const BackpackPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalCard(
    BuildContext context, {
    required String title,
    required Widget icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ThemeHelper.getCardColor(context),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: ThemeHelper.isDarkTheme(context)
                  ? Colors.black54
                  : Colors.grey.shade400,
              blurRadius: 3,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(child: icon),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.tomorrow(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: ThemeHelper.getTextColor(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
