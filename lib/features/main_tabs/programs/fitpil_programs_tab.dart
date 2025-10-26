import 'package:fitpill/generated/l10n/l10n.dart';
import 'package:fitpill/features/main_tabs/home/weekly_routine/weekly_routine_models.dart';
import 'package:fitpill/features/main_tabs/home/weekly_routine/weekly_routine_provider.dart';
import 'fitpil_programs_data.dart';
import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FitpilProgramsTab extends ConsumerWidget {
  const FitpilProgramsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final l10n = S.of(context);
    final programs = fitpilPrograms;

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      itemBuilder: (context, index) {
        final program = programs[index];
        return _ProgramCard(program: program);
      },
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemCount: programs.length,
    );
  }
}

class _ProgramCard extends ConsumerWidget {
  const _ProgramCard({required this.program});

  final FitpilProgram program;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = S.of(context);
    final textColor = ThemeHelper.getTextColor(context);
    final cardColor = ThemeHelper.getCardColor(context);

    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    program.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    program.duration,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              program.description,
              style: TextStyle(
                color: textColor.withValues(alpha: 0.8),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            if (program.level != null)
              Text(
                '${l10n!.fitpillProgramLevel}: ${program.level}',
                style: TextStyle(
                  color: textColor.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w600,
                ),
              ),
            if (program.highlights.isNotEmpty) ...[
              const SizedBox(height: 10),
              ...program.highlights.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          item,
                          style: TextStyle(
                            color: textColor.withValues(alpha: 0.75),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () async {
                final day = await _pickDay(context, ref);
                if (day == null) return;

                await ref.read(weeklyRoutineProvider.notifier).assignWorkout(
                      day,
                      WeeklyWorkoutSelection(
                        id: program.id,
                        title: program.title,
                        subtitle: program.focus,
                        source: WeeklyRoutineSource.fitpil,
                      ),
                    );

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        S.of(context)!.fitpillProgramAddedToWeeklyRoutine,
                      ),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.calendar_month),
              label: Text(l10n!.fitpillProgramAddToRoutine),
              style: FilledButton.styleFrom(
                backgroundColor: ThemeHelper.getFitPillColor(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Weekday?> _pickDay(BuildContext context, WidgetRef ref) async {
    final l10n = S.of(context);
    return showModalBottomSheet<Weekday>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 60,
                height: 5,
                decoration: BoxDecoration(
                  color: ThemeHelper.getFitPillColor(context).withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n!.fitpillProgramSelectDay,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ThemeHelper.getFitPillColor(context),
                ),
              ),
              const SizedBox(height: 12),
              ...Weekday.values.map(
                (day) => ListTile(
                  leading: const Icon(Icons.calendar_today_outlined),
                  title: Text(
                    day.localizedName(
                      t: (key) => _localizedDayName(S.of(context)!, key),
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: ThemeHelper.getFitPillColor(context).withValues(alpha: 0.7),
                  ),
                  onTap: () => Navigator.of(context).pop(day),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  String _localizedDayName(S l10n, String key) {
    switch (key) {
      case 'monday':
        return l10n.monday;
      case 'tuesday':
        return l10n.tuesday;
      case 'wednesday':
        return l10n.wednesday;
      case 'thursday':
        return l10n.thursday;
      case 'friday':
        return l10n.friday;
      case 'saturday':
        return l10n.saturday;
      case 'sunday':
        return l10n.sunday;
      default:
        return '';
    }
  }
}

