import 'package:flutter/material.dart';

import 'package:fitpill/generated/l10n/l10n.dart';
import 'do_with_me_activity_card.dart';
import 'do_with_me_history.dart';

// İLK AKTİVİTE SEÇİM EKRANI
class ActivitySelectionScreen extends StatelessWidget {
  const ActivitySelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Activity> activities = [
      Activity('walk', Icons.directions_walk, Colors.blue), // 🔑 Anahtar kelime
      Activity('run', Icons.directions_run, Colors.red),
      Activity('bicycle', Icons.directions_bike, Colors.green),
      Activity('weightlifting', Icons.fitness_center, Colors.orange),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context)!.selectActivity,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const ActivityHistoryScreen())),
          )
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.9,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemCount: activities.length,
        itemBuilder: (context, index) =>
            ActivityCard(activity: activities[index]),
      ),
    );
  }
}
