import 'package:fitpill/generated/l10n/l10n.dart';
import 'package:fitpill/core/ui/widgets/app_schimmer.dart';
import 'activity_model.dart';
import 'activity_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitpill/l10n/l10n_extensions.dart';

class ActivityHistoryScreen extends ConsumerWidget {
  const ActivityHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activityState = ref.watch(activityProvider);
    final activityNotifier = ref.read(activityProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)!.activityHistory),
        centerTitle: true,
      ),
      body: activityState.when(
        loading: () => const AppPageShimmer(),
        error: (error, _) =>
            Center(child: Text('${S.of(context)!.error}: $error')),
        data: (activities) {
          if (activities.isEmpty) {
            return Center(child: Text(S.of(context)!.noData));
          }

          return ListView.builder(
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];

              return Dismissible(
                key: Key(activity.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  return await _showConfirmDeleteDialog(context);
                },
                onDismissed: (direction) {
                  activityNotifier.deleteActivity(activity.id);
                },
                child: ListTile(
                  leading: const Icon(Icons.fitness_center, color: Colors.blue),
                  title: Text(
                      S.of(context)!.getActivityName(activity.activityName)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          '${activity.durationInSeconds ~/ 60} ${S.of(context)!.minutes} • ${activity.caloriesBurned.round()} kcal'),
                      if (activity.incline != null)
                        Text(
                            '${S.of(context)!.incline}: ${activity.incline!.toStringAsFixed(1)}%'),
                      if (activity.tempoKey != null)
                        Text(
                            '${S.of(context)!.tempo}: ${S.of(context)!.getTempoName(activity.tempoKey!)}'),
                    ],
                  ),
                  trailing: Text(
                    '${activity.timestamp.day}/${activity.timestamp.month}/${activity.timestamp.year}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.insights),
        onPressed: () {
          _showCaloriesSummaryDialog(context, activityState);
        },
      ),
    );
  }

  Future<bool> _showConfirmDeleteDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    S.of(context)!.confirmDelete,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text(S.of(context)!.cancel),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () => Navigator.pop(context, true),
                          child: Text(S.of(context)!.delete,
                              style: const TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ) ??
        false;
  }

  void _showCaloriesSummaryDialog(
      BuildContext context, AsyncValue<List<ActivityModel>> activityState) {
    final activities = activityState.value ?? [];

    int weekTotal = 0;
    int monthTotal = 0;
    int allTimeTotal = 0;

    final now = DateTime.now();
    final oneWeekAgo = now.subtract(const Duration(days: 7));
    final oneMonthAgo = DateTime(now.year, now.month - 1, now.day);

    for (var activity in activities) {
      final ts = activity.timestamp;
      final cal = activity.caloriesBurned.round();

      if (ts.isAfter(oneWeekAgo)) weekTotal += cal;
      if (ts.isAfter(oneMonthAgo)) monthTotal += cal;
      allTimeTotal += cal;
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.local_fire_department,
                  size: 48, color: Colors.deepOrange),
              const SizedBox(height: 10),
              Text(S.of(context)!.caloriesSummary,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              _buildSummaryRow(
                  S.of(context)!.thisWeek, weekTotal, Colors.orange),
              _buildSummaryRow(
                  S.of(context)!.thisMonth, monthTotal, Colors.amber),
              _buildSummaryRow(
                  S.of(context)!.allTime, allTimeTotal, Colors.red),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(S.of(context)!.ok,
                    style: const TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, int value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Text('$value kcal',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
