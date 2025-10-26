import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutRoutineModel {
  final String id;
  final String routineName;

  WorkoutRoutineModel({required this.id, required this.routineName});

  factory WorkoutRoutineModel.fromMap(String id, Map<String, dynamic> map) {
    return WorkoutRoutineModel(
      id: id,
      routineName: map['routine_name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'routine_name': routineName,
    };
  }

  WorkoutRoutineModel copyWith({String? routineName}) {
    return WorkoutRoutineModel(
      id: id,
      routineName: routineName ?? this.routineName,
    );
  }
}

class WorkoutModel {
  final String id;
  final String name;
  final int dayIndex;
  final String dayLabel;
  final DateTime? createdAt;

  WorkoutModel({
    required this.id,
    required this.name,
    required this.dayIndex,
    required this.dayLabel,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dayIndex': dayIndex,
      'dayLabel': dayLabel,
      'created_at': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  factory WorkoutModel.fromMap(String id, Map<String, dynamic> map) {
    return WorkoutModel(
      id: id,
      name: map['name'] ?? '',
      dayIndex: map['dayIndex'] ?? 0,
      dayLabel: map['dayLabel'] ?? '',
      createdAt: map['created_at'] is Timestamp
          ? (map['created_at'] as Timestamp).toDate()
          : null,
    );
  }

  WorkoutModel copyWith({
    String? id,
    String? name,
    int? dayIndex,
    String? dayLabel,
    DateTime? createdAt,
  }) {
    return WorkoutModel(
      id: id ?? this.id,
      name: name ?? this.name,
      dayIndex: dayIndex ?? this.dayIndex,
      dayLabel: dayLabel ?? this.dayLabel,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
