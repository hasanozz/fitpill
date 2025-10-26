import 'package:fitpill/features/main_tabs/home/profile/user_profile_model.dart';
import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:fitpill/core/utils/formatter.dart';

class ProfileUserInfoCard extends StatelessWidget {
  final UserProfileModel profile;
  final String
      weight; // 🔥 weight ayrı Future'dan geliyor, onu da dışarıdan alıyoruz.

  const ProfileUserInfoCard({
    required this.profile,
    required this.weight,
    super.key,
  });

  int calculateAge(String birthDate) {
    if (birthDate.isEmpty) return 0;
    try {
      List<String> parts = birthDate.split('/');
      if (parts.length != 3) return 0;

      int day = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int year = int.parse(parts[2]);

      DateTime birthDateTime = DateTime(year, month, day);
      DateTime today = DateTime.now();
      int age = today.year - birthDateTime.year;
      if (today.month < birthDateTime.month ||
          (today.month == birthDateTime.month &&
              today.day < birthDateTime.day)) {
        age--;
      }
      return age;
    } catch (e) {
      return 0;
    }
  }

  Widget _buildInfoRow(
      BuildContext context, String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 28,
            color: ThemeHelper.getFitPillColor(context),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 4),
              Text(value.isNotEmpty ? value : '-',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ThemeHelper.getCardColor(context),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildInfoRow(context, 'İsim', profile.name, Icons.person),
            const Divider(),
            _buildInfoRow(context, 'Yaş', "${calculateAge(profile.birthDate)}",
                Icons.cake),
            const Divider(),
            _buildInfoRow(
              context,
              'Cinsiyet',
              profile.gender == 'male'
                  ? 'Erkek'
                  : profile.gender == 'female'
                      ? 'Kadın'
                      : '-',
              FontAwesomeIcons.marsAndVenus,
            ),
            const Divider(),
            _buildInfoRow(context, 'Boy', "${profile.height} cm", Icons.height),
            const Divider(),
            _buildInfoRow(context, 'Kilo',
                "${formatDoubleFromString(weight)} kg", Icons.monitor_weight),
          ],
        ),
      ),
    );
  }
}
