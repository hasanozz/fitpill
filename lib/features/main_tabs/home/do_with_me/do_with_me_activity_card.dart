import 'package:fitpill/generated/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:fitpill/l10n/l10n_extensions.dart';
import 'do_with_me_setup.dart';

// CARDLARIN DIŞ GÖRÜNÜMÜ

class Activity {
  final String name;
  final IconData icon;
  final Color color;

  Activity(this.name, this.icon, this.color);
}

class ActivityCard extends StatelessWidget {
  final Activity activity;

  const ActivityCard({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ActivitySetupScreen(activity)),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: activity.color.withAlpha((255 * 0.1).toInt()),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(activity.icon, size: 60, color: activity.color),
              const SizedBox(height: 15),
              Text(S.of(context)!.getActivityName(activity.name),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
