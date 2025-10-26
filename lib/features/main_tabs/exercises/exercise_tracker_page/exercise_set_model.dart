import 'package:cloud_firestore/cloud_firestore.dart';

class ExerciseSet {
  final String id;
  final double weight;
  final int reps;
  final double rir;
  final DateTime exerciseDate;

  const ExerciseSet({
    required this.id,
    required this.weight,
    required this.reps,
    required this.rir,
    required this.exerciseDate,
  });

  factory ExerciseSet.fromMap(String id, Map<String, dynamic> map) {
    return ExerciseSet(
      id: id,
      weight: (map['weight'] ?? 0).toDouble(),
      reps: (map['reps'] ?? 0).toInt(),
      rir: (map['rir'] ?? 0).toDouble(),
      exerciseDate: (map['exercise_date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'weight': weight,
      'reps': reps,
      'rir': rir,
      'exercise_date': Timestamp.fromDate(exerciseDate),
    };
  }

  ExerciseSet copyWith({
    String? id,
    double? weight,
    int? reps,
    double? rir,
    DateTime? exerciseDate,
  }) {
    return ExerciseSet(
        id: id ?? this.id,
        weight: weight ?? this.weight,
        reps: reps ?? this.reps,
        rir: rir ?? this.rir,
        exerciseDate: exerciseDate ?? this.exerciseDate);
  }
}
