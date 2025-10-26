import 'package:fitpill/core/utils/formatter.dart';
import 'package:fitpill/features/main_tabs/exercises/exercise_tracker_page/user_exercise_provider.dart';
import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitpill/generated/l10n/l10n.dart';
import 'exercise_set_model.dart';

class PersonalBestCard extends ConsumerWidget {
  final String exerciseName;

  const PersonalBestCard({super.key, required this.exerciseName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bestAsync = ref.watch(personalBestProvider(exerciseName));

    return bestAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text("${S.of(context)!.error}: $e"),
      ),
      data: (best) {
        final heaviest = best?.heaviestSet;
        final volume = best?.highestVolumeSet;

        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: PersonalBestRow(
            heaviest: heaviest,
            volume: volume,
          ),
        );
      },
    );
  }
}

class PersonalBestRow extends StatelessWidget {
  final ExerciseSet? heaviest;
  final ExerciseSet? volume;

  const PersonalBestRow({
    super.key,
    required this.heaviest,
    required this.volume,
  });

  @override
  Widget build(BuildContext context) {
    final noSetsText = S.of(context)!.noSetsYet;

    return Row(
      children: [
        Expanded(
          child: _BestBox(
            title: S.of(context)!.heaviestSet,
            value: heaviest == null
                ? noSetsText
                : '${formatDoubleFromString(heaviest!.weight.toString())} kg × ${heaviest!.reps}',
            date: heaviest?.exerciseDate,
            context: context, // 🔧 eklendi
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _BestBox(
            title: S.of(context)!.highestVolume,
            value: volume == null
                ? noSetsText
                : '${formatDoubleFromString(volume!.weight.toString())} kg × ${volume!.reps}',
            date: volume?.exerciseDate,
            context: context, // 🔧 eklendi
          ),
        ),
      ],
    );
  }
}

// alt kutular
class _BestBox extends StatelessWidget {
  final String title;
  final String value;
  final DateTime? date;
  final BuildContext context;

  const _BestBox({
    required this.title,
    required this.value,
    this.date,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ThemeHelper.getCardColor2(context).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ThemeHelper.getFitPillColor(context).withValues(alpha: 0.4),
          width: 1.2,
        ),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: ThemeHelper.getTextColor(context).withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ThemeHelper.getTextColor(context),
            ),
          ),
          const SizedBox(height: 4),
          if (date != null)
            Text(
              formatDate(date!, context),
              style: TextStyle(
                fontSize: 12,
                color: ThemeHelper.getTextColor(context).withValues(alpha: 0.6),
              ),
            ),
        ],
      ),
    );
  }
}
