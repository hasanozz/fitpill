import 'package:fitpill/core/ui/widgets/app_schimmer.dart';
import 'package:fitpill/features/main_tabs/exercises/exercise_tracker_page/exercise_overview.dart';
import 'package:fitpill/features/main_tabs/exercises/exercises_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'exercise_model.dart';

class ExercisesPage extends ConsumerStatefulWidget {
  const ExercisesPage({super.key});

  @override
  ConsumerState<ExercisesPage> createState() => _ExercisesPageState();
}

class _ExercisesPageState extends ConsumerState<ExercisesPage> {
  List<Exercise> filteredExercises = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      // build() zaten ilk yüklemeyi yapıyor; future ile sonucu bekleyebilirsin.
      final list = await ref.read(exercisesProvider.future); // => List<Exercise>
      if (!mounted) return;
      setState(() => filteredExercises = list);
    });
  }


  void _filterExercises(String query) {
    final asyncList = ref.read(exercisesProvider); // AsyncValue<List<Exercise>>
    final list = asyncList.value ?? []; // içteki listeyi çekiyoruz (boşsa [])

    final q = query.toLowerCase();

    setState(() {
      filteredExercises = q.isEmpty
          ? list
          : list.where((e) => e.name.toLowerCase().contains(q)).toList();
    });
  }


  @override
  Widget build(BuildContext context) {
    final exercises = ref.watch(exercisesProvider);

    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      appBar: AppBar(
          backgroundColor: ThemeHelper.getBackgroundColor(context),
          title: const Text('Exercises')),
      body: exercises.when(data: (list) =>list.isEmpty
          ? const AppPageShimmer(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              itemHeight: 90,
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 8,
                          child: TextField(
                            controller: searchController,
                            onChanged: _filterExercises,
                            decoration: InputDecoration(
                              hintText: "Search...",
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                              filled: true,
                              fillColor: ThemeHelper.getCardColor(context),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            child: Icon(
                              Icons.tune,
                              size: 27,
                              color: ThemeHelper.getTextColor(context)
                                  .withAlpha((255 * 0.8).toInt()),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(), // ✅ Scroll hatalarını önle
                    itemCount: filteredExercises
                        .length, // ✅ Filtrelenmiş listeyi kullan
                    itemBuilder: (context, index) {
                      final exercise = filteredExercises[
                          index]; // ✅ Filtrelenmiş listeye eriş

                      return ListTile(
                        leading: Icon(
                          Icons.library_books,
                          size: 28,
                          color: ThemeHelper.getTextColor(context)
                              .withValues(alpha: 0.9),
                        ),
                        title: Text(
                          exercise.name,
                          style: TextStyle(
                            fontSize: 18,
                            color: ThemeHelper.getTextColor(context)
                                .withValues(alpha: 0.9),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExerciseOverviewPage(
                                exerciseName: exercise.name,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e'),),)
    );
  }
}
