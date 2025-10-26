import 'package:fitpill/generated/l10n/l10n.dart';
import 'weekly_routine_models.dart';
import 'weekly_routine_provider.dart';
import 'package:fitpill/features/main_tabs/programs/fitpil_programs_data.dart';
import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitpill/features/main_tabs/programs/workouts_screen_provider.dart';

class WeeklyRoutinePage extends ConsumerWidget {
  const WeeklyRoutinePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = S.of(context);
    final weeklyRoutineAsync = ref.watch(weeklyRoutineProvider);

    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      appBar: AppBar(
        title: Text(l10n!.weeklyRoutineTitle),
      ),
      body: weeklyRoutineAsync.when(
        data: (routineData) {
          final routineState = routineData.routine;
          final today = DateTime.now();
          final todayWeekday = weekdayFromDate(today);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                l10n.weeklyRoutineDescription,
                style: TextStyle(
                  color: ThemeHelper.getTextColor(context).withValues(alpha: 0.8),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              ...Weekday.values.map(
                (day) => _WeeklyRoutineDayCard(
                  day: day,
                  entry: routineState.entries[day]!,
                  isToday: day == todayWeekday,
                ),
              ),
              const SizedBox(height: 48),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              "HATA: ${error.toString()}",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class _WeeklyRoutineDayCard extends ConsumerWidget {
  const _WeeklyRoutineDayCard({
    required this.day,
    required this.entry,
    required this.isToday,
  });

  final Weekday day;
  final WeeklyRoutineEntry entry;
  final bool isToday;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = S.of(context);
    final textColor = ThemeHelper.getTextColor(context);
    final cardColor = ThemeHelper.getCardColor(context);
    final accentColor = ThemeHelper.getFitPillColor(context);
    final dayLabel = _localizedDayLabel(l10n!, day);

    final hasPlan = entry.selection != null || entry.isOffDay;

    final subtitle = entry.isOffDay
        ? l10n.weeklyRoutineOffDay
        : entry.selection == null
            ? l10n.weeklyRoutineNotPlanned
            : entry.selection!.subtitle ?? entry.selection!.title;

    final canToggleCompletion =
        isToday && !entry.isOffDay && entry.selection != null;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isToday ? accentColor.withValues(alpha: 0.35) : Colors.transparent,
          width: 1.4,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dayLabel,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: textColor,
                        ),
                      ),
                      if (isToday) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            l10n.today,
                            style: TextStyle(
                              color: accentColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 6),
                      if (entry.selection != null && !entry.isOffDay)
                        Text(
                          entry.selection!.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: textColor.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Tooltip(
                  message: entry.isCompleted
                      ? l10n.weeklyRoutineMarkNotDone
                      : canToggleCompletion
                          ? l10n.weeklyRoutineMarkDone
                          : l10n.weeklyRoutineCompletionOnlyToday,
                  child: IconButton(
                    onPressed: canToggleCompletion
                        ? () {
                            ref
                                .read(weeklyRoutineProvider.notifier)
                                .toggleCompletion(day);
                          }
                        : null,
                    icon: Icon(
                      entry.isCompleted
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: entry.isCompleted
                          ? accentColor
                          : canToggleCompletion
                              ? textColor.withValues(alpha: 0.6)
                              : textColor.withValues(alpha: 0.25),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (!hasPlan)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showAssignmentSheet(context, ref, day, entry);
                      },
                      icon: const Icon(Icons.event_available),
                      label: Text(l10n.weeklyRoutineAddWorkout),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ref
                            .read(weeklyRoutineProvider.notifier)
                            .markOffDay(day);
                      },
                      icon: const Icon(Icons.weekend),
                      label: Text(l10n.weeklyRoutineSetOffDay),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: accentColor,
                        side: BorderSide(color: accentColor),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              )
            else
              Align(
                alignment: Alignment.centerRight,
                child: PopupMenuButton<_DayAction>(
                  onSelected: (action) {
                    switch (action) {
                      case _DayAction.addWorkout:
                        _showAssignmentSheet(context, ref, day, entry);
                        break;
                      case _DayAction.setRest:
                        ref
                            .read(weeklyRoutineProvider.notifier)
                            .markOffDay(day);
                        break;
                      case _DayAction.clear:
                        ref.read(weeklyRoutineProvider.notifier).clearDay(day);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: _DayAction.addWorkout,
                      child: Text(l10n.weeklyRoutineAddWorkout),
                    ),
                    PopupMenuItem(
                      value: _DayAction.setRest,
                      child: Text(l10n.weeklyRoutineSetOffDay),
                    ),
                    PopupMenuItem(
                      value: _DayAction.clear,
                      child: Text(l10n.weeklyRoutineClearDay),
                    ),
                  ],
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.more_horiz,
                          size: 20,
                          color: accentColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          l10n.edit,
                          style: TextStyle(
                            color: accentColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

enum _DayAction { addWorkout, setRest, clear }

String _localizedDayLabel(S l10n, Weekday day) {
  return day.localizedName(
    t: (key) {
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
    },
  );
}

void _showAssignmentSheet(
  BuildContext context,
  WidgetRef ref,
  Weekday day,
  WeeklyRoutineEntry entry,
) {
  final l10n = S.of(context);
  final dayLabel = _localizedDayLabel(l10n!, day);
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return DefaultTabController(
        length: 2,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Container(
                    width: 64,
                    height: 5,
                    decoration: BoxDecoration(
                      color:
                          ThemeHelper.getFitPillColor(context).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dayLabel,
                          style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: ThemeHelper.getFitPillColor(context),
                                  ) ??
                              TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                color: ThemeHelper.getFitPillColor(context),
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l10n.weeklyRoutineSelectSource,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: ThemeHelper.getTextColor(context)
                                            .withValues(alpha: 0.7),
                                      ) ??
                                  TextStyle(
                                    color: ThemeHelper.getTextColor(context)
                                        .withValues(alpha: 0.7),
                                    fontSize: 15,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: ThemeHelper.getCardColor(context),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: ThemeHelper.getFitPillColor(context)
                              .withValues(alpha: 0.2),
                        ),
                      ),
                      child: TabBar(
                        labelColor: ThemeHelper.getFitPillColor(context),
                        unselectedLabelColor:
                            ThemeHelper.getTextColor(context).withValues(alpha: 0.6),
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: ThemeHelper.getFitPillColor(context)
                              .withValues(alpha: 0.12),
                        ),
                        tabs: [
                          Tab(text: l10n.weeklyRoutineTabMyWorkouts),
                          Tab(text: l10n.weeklyRoutineTabFitpill),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _PersonalWorkoutsList(day: day),
                        _FitpilProgramList(day: day),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

class _PersonalWorkoutsList extends ConsumerWidget {
  const _PersonalWorkoutsList({required this.day});

  final Weekday day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = S.of(context);
    final routinesAsync = ref.watch(routineProvider);

    return routinesAsync.when(
      data: (routines) {
        if (routines.isEmpty) {
          return _EmptyStateMessage(
              message: l10n!.weeklyRoutineNoPersonalWorkouts);
        }

        return ListView.builder(
          itemCount: routines.length,
          itemBuilder: (context, index) {
            final routine = routines[index];
            return Consumer(
              builder: (context, ref, _) {
                final workoutsAsync =
                    ref.watch(workoutListProvider(routine.id));
                return workoutsAsync.when(
                  data: (workouts) {
                    if (workouts.isEmpty) {
                      return ListTile(
                        title: Text(routine.routineName),
                        subtitle:
                            Text(l10n!.weeklyRoutineNoWorkoutsInRoutine),
                      );
                    }
                    return ExpansionTile(
                      title: Text(routine.routineName),
                      children: workouts.map((workout) {
                        return ListTile(
                          title: Text(workout!.name),
                          subtitle: Text(workout.dayLabel),
                          onTap: () {
                            ref
                                .read(weeklyRoutineProvider.notifier)
                                .assignWorkout(
                                  day,
                                  WeeklyWorkoutSelection(
                                    id: workout.id,
                                    title: workout.name,
                                    subtitle: routine.routineName,
                                    source: WeeklyRoutineSource.personal,
                                    routineId: routine.id,
                                    routineName: routine.routineName,
                                  ),
                                );
                            Navigator.of(context).pop();
                          },
                        );
                      }).toList(),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, _) => ListTile(
                    title: Text(routine.routineName),
                    subtitle: Text(l10n!.weeklyRoutineFailedToLoadWorkouts),
                  ),
                );
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _EmptyStateMessage(
          message: l10n!.weeklyRoutineFailedToLoadWorkouts),
    );
  }
}

class _FitpilProgramList extends ConsumerWidget {
  const _FitpilProgramList({required this.day});

  final Weekday day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final l10n = S.of(context);
    final programs = fitpilPrograms;

    return ListView.builder(
      itemCount: programs.length,
      itemBuilder: (context, index) {
        final program = programs[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: ListTile(
            title: Text(program.title),
            subtitle: Text(program.description),
            trailing: const Icon(Icons.add_circle_outline),
            onTap: () {
              ref.read(weeklyRoutineProvider.notifier).assignWorkout(
                    day,
                    WeeklyWorkoutSelection(
                      id: program.id,
                      title: program.title,
                      subtitle: program.focus,
                      source: WeeklyRoutineSource.fitpil,
                    ),
                  );
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }
}

class _EmptyStateMessage extends StatelessWidget {
  const _EmptyStateMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Text(
          message,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
