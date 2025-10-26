import 'package:fitpill/generated/l10n/l10n.dart';
import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:flutter/material.dart';

class AvatarSelectionScreen extends StatelessWidget {
  final Function(String) onAvatarSelected;

  const AvatarSelectionScreen({super.key, required this.onAvatarSelected});

  @override
  Widget build(BuildContext context) {
    final avatars = [
      'avatar_man_1',
      'avatar_man_2',
      'avatar_man_3',
      'avatar_man_4',
      'avatar_man_5',
      'avatar_girl_1',
      'avatar_girl_2',
      'avatar_girl_3',
      'avatar_girl_4',
      'avatar_girl_5',
    ];

    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: ThemeHelper.getBackgroundColor(context),
        title: Text(S.of(context)!.selectAvatar),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemCount: avatars.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              onAvatarSelected(avatars[index]);
              Navigator.pop(context);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/avatars/${avatars[index]}.png',
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
