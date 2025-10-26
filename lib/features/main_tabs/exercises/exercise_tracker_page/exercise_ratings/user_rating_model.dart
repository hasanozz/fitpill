//  kullanıcının verdiği puanın users_exercises'a kaydedilmesini sağlayan yapının modeli

import 'package:cloud_firestore/cloud_firestore.dart';

class UserExerciseRating {
  final String exerciseName; // docId (ör. "bench press")
  final String userId;
  final int rating; // 1..5
  final DateTime updatedAt;

  const UserExerciseRating({
    required this.exerciseName,
    required this.userId,
    required this.rating,
    required this.updatedAt,
  });

  factory UserExerciseRating.fromMap(
    String userId,
    String exerciseName,
    Map<String, dynamic> map,
  ) {
    return UserExerciseRating(
      exerciseName: exerciseName,
      userId: userId,
      rating: (map['rating'] ?? 0) as int,
      updatedAt: (map['ratingUpdatedAt'] as Timestamp?)?.toDate() ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  Map<String, dynamic> toMap() =>
      {'rating': rating, 'ratingUpdatedAt': Timestamp.fromDate(updatedAt)};

  UserExerciseRating copyWith({int? rating, DateTime? updatedAt}) {
    return UserExerciseRating(
      exerciseName: exerciseName,
      userId: userId,
      rating: rating ?? this.rating,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
