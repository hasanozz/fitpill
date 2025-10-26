import 'package:fitpill/core/ui/widgets/day_iconbutton_labels.dart';
import 'package:fitpill/core/ui/dialogs/premium_upgrade_overlay.dart';
import 'package:fitpill/core/ui/dialogs/show_dialogs.dart';
import 'package:fitpill/core/ui/widgets/app_schimmer.dart';
import 'package:fitpill/features/main_tabs/home/profile/profile_provider.dart';
import 'package:fitpill/features/main_tabs/programs/workout_details_page.dart';
import 'package:fitpill/features/main_tabs/programs/workouts_screen_model.dart';
import 'package:fitpill/features/main_tabs/programs/workouts_screen_provider.dart';
import 'package:fitpill/generated/l10n/l10n.dart';
import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


class WorkoutScreen extends ConsumerWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routinesAsync = ref.watch(routineProvider);
    ref.watch(expandedTileIndexProvider);
    final premiumStatus = ref.watch(premiumStatusProvider);
    final profileState = ref.watch(profileProvider);
    final bool isPremium = premiumStatus.maybeWhen(
      data: (value) => value,
      orElse: () => false,
    );
    final bool isPremiumLoading =
        premiumStatus.isLoading || profileState.isLoading;

    if (isPremiumLoading) {
      return Scaffold(
        backgroundColor: ThemeHelper.getBackgroundColor(context),
        body: const AppPageShimmer(padding: EdgeInsets.all(16)),
      );
    }

    if (premiumStatus.hasError || profileState.hasError) {
      return Scaffold(
        backgroundColor: ThemeHelper.getBackgroundColor(context),
        body: Center(
          child: Text(
            S.of(context)!.anErrorOccurred,
            textAlign: TextAlign.center,
            style: TextStyle(color: ThemeHelper.getTextColor(context)),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      body: Stack(
        children: [
          routinesAsync.when(
            loading: () => const AppPageShimmer(padding: EdgeInsets.all(16)),
            error: (error, _) => Center(
                child: Text(
              S.of(context)!.errorWithMessage(error.toString()),
              textAlign: TextAlign.center,
            )),
            data: (routines) {
              if (routines.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.inbox, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        S.of(context)!.createRoutinePromptTitle,
                        style: TextStyle(
                          fontSize: 18,
                          color: ThemeHelper.getTextColor(context)
                              .withValues(alpha:0.5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        S.of(context)!.createRoutinePromptSubtitle,
                        style: TextStyle(
                          fontSize: 18,
                          color: ThemeHelper.getTextColor(context)
                              .withValues(alpha:0.5),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return SlidableAutoCloseBehavior(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 16, top: 8),
                  itemCount: routines.length,
                  itemBuilder: (context, index) {
                    final WorkoutRoutineModel routine = routines[index];
                    ref.watch(openTileKeyProvider);
                    final expandedIndex = ref.watch(expandedTileIndexProvider);
                    // final isTileExpanded = expandedIndex == index;
                    final expandedTileIds = ref.watch(expandedTileIdsProvider);

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        color: ThemeHelper.getCardColor(context),
                        clipBehavior: Clip.hardEdge,
                        child: Slidable(
                          key: ValueKey(routine.id),
                          enabled: expandedIndex != index,
                          closeOnScroll: true,
                          endActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            extentRatio: 0.5, // slidablelar %50 kadar açılıyor

                            children: [
                              CustomSlidableAction(
                                onPressed: (_) {
                                  showCustomTextFieldDialog(
                                      context: context,
                                      title: S.of(context)!.editRoutine,
                                      labels: [S.of(context)!.routineName],
                                      height: 225,
                                      icon: Icons.fitness_center,
                                      initialValues: [routine.routineName],
                                      confirmText: S.of(context)!.save,
                                      cancelText: S.of(context)!.cancel,
                                      onConfirm: (values) {
                                        final newName = values[0];
                                        if (newName.isNotEmpty &&
                                            newName != routine.routineName) {
                                          ref
                                              .read(routineProvider.notifier)
                                              .updateRoutine(
                                                  routine.id, newName);
                                        }
                                      });
                                },
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                child: const Icon(
                                  Icons.edit,
                                  size: 22,
                                ),
                              ),
                              CustomSlidableAction(
                                onPressed: (_) {
                                  showCustomTextFieldDialog(
                                      context: context,
                                      title: S.of(context)!.deleteRoutine,
                                      labels: [],
                                      height: 200,
                                      icon: Icons.fitness_center,
                                      confirmText: S.of(context)!.delete,
                                      cancelText: S.of(context)!.cancel,
                                      content: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Text(
                                          S.of(context)!.deleteRoutineConfirmation(
                                            routine.routineName,
                                          ),
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      onConfirm: (_) {
                                        ref
                                            .read(routineProvider.notifier)
                                            .deleteRoutine(routine.id);
                                      });
                                },
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                child: const Icon(
                                  Icons.delete,
                                  size: 22,
                                ),
                              ),
                            ],
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              dividerColor: Colors.transparent,
                            ),
                            child: ExpansionTile(
                              key: ValueKey(routine.id),
                              initiallyExpanded:
                                  expandedTileIds.contains(routine.id),
                              leading: Icon(
                                Icons.library_books,
                                size: 25,
                                color: expandedTileIds.contains(routine.id)
                                    ? ThemeHelper.isDarkTheme(context)
                                        ? Colors.orange
                                        : const Color(0xFF0D47A1)
                                    : ThemeHelper.getTextColor(context),
                              ),
                              title: Text(
                                routine.routineName,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: expandedTileIds.contains(routine.id)
                                      ? ThemeHelper.isDarkTheme(context)
                                          ? Colors.orange
                                          : const Color(0xFF0D47A1)
                                      : ThemeHelper.getTextColor(context),
                                ),
                              ),
                              trailing: AnimatedRotation(
                                duration: const Duration(milliseconds: 200),
                                turns: expandedTileIds.contains(routine.id)
                                    ? 0.25
                                    : 0.0,
                                // trailingdeki oku exponsiontile açılınca yönünü değiştiriyor
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20,
                                  color: expandedTileIds.contains(routine.id)
                                      ? ThemeHelper.isDarkTheme(context)
                                          ? Colors.orange
                                          : const Color(0xFF0D47A1)
                                      : ThemeHelper.getTextColor(context),
                                ),
                              ),
                              onExpansionChanged: (isExpanded) {
                                final notifier =
                                    ref.read(expandedTileIdsProvider.notifier);
                                if (isExpanded) {
                                  notifier.state = {
                                    ...notifier.state,
                                    routine.id
                                  };
                                } else {
                                  notifier.state = {...notifier.state}
                                    ..remove(routine.id);
                                }
                              },
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: TextButton(
                                    style: ElevatedButton.styleFrom(
                                        splashFactory: NoSplash.splashFactory,
                                        shadowColor: Colors.transparent),
                                    onPressed: isPremiumLoading
                                        ? null
                                        : () {
                                      if (!isPremium) {
                                        showPremiumUpgradeOverlay(context);
                                        return;
                                      }

                                      openBottomSheetCreateWorkout(
                                        context,
                                        routine.id,
                                            (routineId, workout) async {
                                          await ref
                                              .read(workoutProvider
                                              .notifier)
                                              .addWorkout(
                                              routineId, workout);
                                          ref.invalidate(
                                              workoutListProvider(
                                                  routineId));
                                        },
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.add,
                                          size: 27,
                                          color:
                                              ThemeHelper.getTextColor(context),
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        Text(
                                          S.of(context)!.addWorkout,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: ThemeHelper.getTextColor(
                                                context),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Divider(
                                    color: ThemeHelper.getTextColor(context)
                                        .withAlpha(34),
                                    height: 0.8,
                                  ),
                                ),
                                Consumer(
                                  builder: (context, ref, _) {
                                    final workoutListAsync = ref
                                        .watch(workoutListProvider(routine.id));
                                    ref.watch(openSlidableIdProvider);

                                    return workoutListAsync.when(
                                      data: (workouts) {
                                        if (workouts.isEmpty) {
                                          return Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Text(
                                              S
                                                  .of(context)!
                                                  .noWorkoutsAdded,
                                            ),
                                          );
                                        }

                                        return SlidableAutoCloseBehavior(
                                          child: Column(
                                            children: workouts.map((workout) {
                                              final iconData = AppConstants
                                                      .getButtonDayLabels(
                                                          context)[
                                                  workout.dayIndex]['icon'];
                                              final label = AppConstants
                                                      .getButtonDayLabels(
                                                          context)[
                                                  workout.dayIndex]['label'];

                                              return Slidable(
                                                key: ValueKey(workout.id),
                                                // benzersiz olmalı
                                                enabled: ref.watch(
                                                        openSlidableIdProvider) !=
                                                    workout.id,
                                                closeOnScroll: true,

                                                endActionPane: ActionPane(
                                                  motion: const DrawerMotion(),
                                                  extentRatio: 0.5,
                                                  // slidablelar %50 kadar açılıyor

                                                  children: [
                                                    CustomSlidableAction(
                                                      onPressed: (_) {
                                                        openBottomSheetCreateWorkout(
                                                          context,
                                                          routine.id,
                                                          (routineId,
                                                              workout) async {
                                                            await ref
                                                                .read(
                                                                    workoutProvider
                                                                        .notifier)
                                                                .updateWorkout(
                                                                    routineId:
                                                                        routineId,
                                                                    workoutId:
                                                                        workout
                                                                            .id,
                                                                    newName: workout
                                                                        .name,
                                                                    newDayIndex:
                                                                        workout
                                                                            .dayIndex,
                                                                    newDayLabel:
                                                                        workout
                                                                            .dayLabel);
                                                            ref.invalidate(
                                                                workoutListProvider(
                                                                    routineId));
                                                          },
                                                          isEditing: true,
                                                          existingWorkout:
                                                              workout,
                                                        );
                                                      },
                                                      backgroundColor:
                                                          Colors.orange,
                                                      foregroundColor:
                                                          Colors.white,
                                                      child: const Icon(
                                                        Icons.edit,
                                                        size: 22,
                                                      ),
                                                    ),
                                                    CustomSlidableAction(
                                                      onPressed: (_) {
                                                        showCustomTextFieldDialog(
                                                            context: context,
                                                            title: S
                                                                .of(context)!
                                                                .deleteWorkout,
                                                            labels: [],
                                                            height: 200,
                                                            icon: Icons
                                                                .fitness_center,
                                                            confirmText: S
                                                                .of(context)!
                                                                .delete,
                                                            cancelText: S
                                                                .of(context)!
                                                                .cancel,
                                                            content: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          8.0),
                                                              child: Text(
                                                                S
                                                                    .of(context)!
                                                                    .deleteWorkoutConfirmation(
                                                                        workout
                                                                            .name),
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            16),
                                                              ),
                                                            ),
                                                            onConfirm: (_) {
                                                              ref
                                                                  .read(workoutProvider
                                                                      .notifier)
                                                                  .deleteWorkout(
                                                                      routine
                                                                          .id,
                                                                      workout
                                                                          .id);
                                                              ref.invalidate(
                                                                  workoutListProvider(
                                                                      routine
                                                                          .id));
                                                            });
                                                      },
                                                      backgroundColor:
                                                          Colors.red,
                                                      foregroundColor:
                                                          Colors.white,
                                                      child: const Icon(
                                                        Icons.delete,
                                                        size: 22,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                child: ListTile(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            WorkoutDetailsPage(
                                                          routineId: routine.id,
                                                          workoutId: workout.id,
                                                          workoutName:
                                                              workout.name,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  title: Text(workout.name),
                                                  leading: iconData != null
                                                      ? Icon(iconData,
                                                          color: ThemeHelper
                                                              .getTextColor(
                                                                  context))
                                                      : Text(
                                                          label,
                                                          style: TextStyle(
                                                            color: ThemeHelper
                                                                .getTextColor(
                                                                    context),
                                                          ),
                                                        ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        );
                                      },
                                      loading: () => const Padding(
                                        padding: EdgeInsets.all(12),
                                        child: CircularProgressIndicator(),
                                      ),
                                      error: (err, stack) => Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Text(
                                          S
                                              .of(context)!
                                              .errorWithMessage(
                                                  err.toString()),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          // Sabit buton
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 180,
                height: 48,
                child: ElevatedButton(
                  onPressed: isPremiumLoading
                      ? null
                      : () {
                    if (!isPremium) {
                      showPremiumUpgradeOverlay(context);
                      return;
                    }

                          showCustomTextFieldDialog(
                            context: context,
                            title: S.of(context)!.createWorkoutRoutine,
                            labels: [S.of(context)!.routineName],
                            icon: Icons.fitness_center,
                            height: 225,
                            onConfirm: (values) async {
                              final name = values[0];
                              if (name.isEmpty) return;

                              try {
                                await ref
                                    .read(routineProvider.notifier)
                                    .addRoutine(name);
                              } on StateError catch (_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      S
                                          .of(context)!
                                          .upgradeToCreateRoutine,
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeHelper.isDarkTheme(context)
                        ? Colors.orange
                        : const Color(0xFF0D47A1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    S.of(context)!.createWorkoutRoutine,
                    style: TextStyle(
                      fontSize: 16,
                      color: ThemeHelper.getBackgroundColor(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
