import 'package:fitpill/features/main_tabs/home/premium/premium_cta.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:fitpill/features/settings/settings_page.dart';
import 'package:fitpill/core/system/config/theme/theme_helper.dart';

class ConstantAppBar {
  PreferredSizeWidget customAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      leadingWidth: 60,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Row(
          children: [
            const PremiumCrownButton(),
          ],
        ),
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        "Fit Pill",
                        style: GoogleFonts.bevan(
                          textStyle: TextStyle(
                            color: ThemeHelper.getTextColor(context),
                            fontFamily: 'Bevan',
                            fontSize: 32,
                            fontVariations: const [FontVariation('wght', 400)],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0, right: 8, left: 8),
                    child: Divider(
                      height: 1,
                      thickness: 0.5,
                      color: ThemeHelper.getTextColor(context)
                          .withValues(alpha: 0.3),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: IconButton(
            icon: const Icon(Icons.settings, size: 30),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SettingsPage(
                    currentThemeMode: ThemeMode.light,
                    onThemeChanged: (theme) {
                      // Handle theme change
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}