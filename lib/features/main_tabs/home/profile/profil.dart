import 'package:fitpill/core/ui/widgets/app_schimmer.dart';
import 'package:fitpill/features/main_tabs/home/profile/edit_profile_panel_page.dart';
import 'package:fitpill/features/main_tabs/home/profile/profile_page_image_section.dart';
import 'package:fitpill/features/main_tabs/home/profile/profile_provider.dart';
import 'package:fitpill/features/main_tabs/home/profile/profile_user_info_card.dart';
import 'package:fitpill/features/main_tabs/progress/progress_provider.dart';
import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitpill/generated/l10n/l10n.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weightHistoryAsync = ref.watch(progressHistoryProvider(('weight')));

    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: ThemeHelper.getBackgroundColor(context),
        title: Text(
          S.of(context)!.profile,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const EditProfilePanelPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const AppPageShimmer(),
        error: (e, st) => Center(child: Text('Hata: $e')),
        data: (profile) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                ProfilePageImageSection(profile: profile),
                const SizedBox(height: 30),
                profileAsync.when(
                  data: (profile) {
                    return weightHistoryAsync.when(
                      data: (history) {
                        final latestWeight = history.isNotEmpty
                            ? history.first.value.toString()
                            : '-';

                        return ProfileUserInfoCard(
                          profile: profile,
                          weight: latestWeight,
                        );
                      },
                      loading: () => const AppSectionShimmer(height: 220),
                      error: (e, st) => Center(child: Text('Hata: $e')),
                    );
                  },
                  loading: () => const AppSectionShimmer(height: 220),
                  error: (e, st) => Center(child: Text('Hata: $e')),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
