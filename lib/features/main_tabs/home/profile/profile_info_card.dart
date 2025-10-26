import 'package:fitpill/core/ui/widgets/app_schimmer.dart';
import 'package:fitpill/features/main_tabs/home/profile/profil.dart';
import 'package:fitpill/features/main_tabs/home/profile/widgets/profile_avatar_image.dart';
import 'package:fitpill/features/auth/auth_provider.dart';
import 'package:fitpill/features/profile/user/user_providers.dart';
import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../badge/badge_display.dart';

class ProfileInfoCard extends ConsumerWidget {
  const ProfileInfoCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(userIdProvider);
    final userAsync = ref.watch(userProfileProvider(userId!));

    return userAsync.when(
      loading: () => const AppSectionShimmer(
        height: 150,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
      error: (e, _) => Center(child: Text('Hata: $e')),
      data: (data) {
        final name = data?['name'] ?? 'İsim Soyisim';
        final avatarName = data?['avatar'] ?? '';
        final profileImage = (data?['profile_image'] as String?) ?? '';

        final isDarkTheme = ThemeHelper.isDarkTheme(context);
        final textColor = ThemeHelper.getTextColor(context);

        return SizedBox(
          height: 150,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDarkTheme
                    ? [
                        const Color(0xFF1F1F1F),
                        const Color(0xFF2A2A2A),
                      ]
                    : [
                        const Color(0xFF14213D),
                        const Color(0xFF0D47A1),
                      ],
                // Color(0xFF14213D) bu nasul???? emre
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: isDarkTheme ? Colors.black54 : Colors.grey.shade400,
                  blurRadius: 3,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilePage(),
                      ),
                    );
                    ref.invalidate(userProfileProvider(
                        userId)); // Profil güncellendiğinde yenile
                  },
                  child: Hero(
                    tag: 'profile-photo-hero',
                    child: ProfileAvatarImage(
                      imagePath: profileImage,
                      avatarName: avatarName,
                      size: 100,
                      backgroundColor:
                          ThemeHelper.getBackgroundColor(context),
                      iconColor: textColor,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.tomorrow(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      const BadgeDisplay(), // 🎖 Rozet gösterimi
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
