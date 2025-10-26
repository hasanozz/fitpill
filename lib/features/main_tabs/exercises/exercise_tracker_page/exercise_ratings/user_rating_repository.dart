// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import 'rating_helpers.dart';
//
// class UserExerciseRatingRepository {
//   final FirebaseFirestore _db;
//
//   UserExerciseRatingRepository({FirebaseFirestore? firestore})
//       : _db = firestore ?? FirebaseFirestore.instance;
//
//   DocumentReference<Map<String, dynamic>> _doc({
//     required String userId,
//     required String exerciseName,
//   }) {
//     return _db
//         .collection('users')
//         .doc(userId)
//         .collection('user_exercises')
//         .doc(exerciseName);
//   }
//
//   /// Adım 1: Kullanıcının puanını kullanıcı tarafına kaydet. user_exercises
//   Future<void> setRating({
//     required String userId,
//     required String exerciseName,
//     required int rating, // 1..5
//   }) async {
//     assert(rating >= 1 && rating <= 5);
//     final ref = _doc(userId: userId, exerciseName: exerciseName);
//
//     await ref.set({
//       'rating': rating,
//       'ratingUpdatedAt': FieldValue.serverTimestamp(),
//     }, SetOptions(merge: true));
//   }
//
//   /// Adım 2 : kullanıcının verdiği puanı egzersizin total puanına ekle. exercises
//   // EKLE
//   Future<void> setRatingAndUpdateAggregate({
//     required String userId,
//     required String exerciseName,
//     required int rating, // 1..5
//   }) async {
//     assert(rating >= 1 && rating <= 5);
//
//     final userRef = _db
//         .collection('users')
//         .doc(userId)
//         .collection('user_exercises')
//         .doc(exerciseName);
//
//     final exerciseId = exerciseIdFromName(exerciseName);
//     print(exerciseId);
//
//     final aggRef = _db.collection('exercises').doc(exerciseId);
//
//     double round1(double v) => (v * 10).round() / 10.0;
//
//     await _db.runTransaction((tx) async {
//       // Eski kullanıcı puanı
//       final userSnap = await tx.get(userRef);
//       final bool isNew = !userSnap.exists;
//       final int old = (userSnap.data()?['rating'] as int?) ?? 0;
//
//       // Aggregate oku
//       final aggSnap = await tx.get(aggRef);
//       int ratingCount = (aggSnap.data()?['ratingCount'] as int?) ?? 0;
//       int sumStars = (aggSnap.data()?['sumStars'] as int?) ?? 0;
//
//       // Güncelleme mantığı
//       if (isNew) {
//         ratingCount += 1;
//         sumStars += rating;
//       } else {
//         sumStars += (rating - old); // count değişmez
//       }
//
//       final average = ratingCount > 0 ? round1(sumStars / ratingCount) : 0.0;
//
//       // Yazımlar (aynı transaction)
//       tx.set(
//           userRef,
//           {
//             'rating': rating,
//             'ratingUpdatedAt': FieldValue.serverTimestamp(),
//           },
//           SetOptions(merge: true));
//
//       tx.set(
//           aggRef,
//           {
//             'ratingCount': ratingCount,
//             'sumStars': sumStars,
//             'average': average,
//           },
//           SetOptions(merge: true));
//     });
//   }
//
// // Canlı aggregate izleme (UI için)
//   Stream<Map<String, dynamic>?> watchExerciseAggregate(String exerciseName) {
//     final exerciseId = exerciseIdFromName(exerciseName);
//     return _db
//         .collection('exercises')
//         .doc(exerciseId)
//         .snapshots()
//         .map((s) => s.data());
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

/// MODEL (basit): Firestore yazımı modelden gelsin
class UserExerciseRating {
  final int rating; // 1..5
  final FieldValue ratingUpdatedAt; // serverTimestamp sentinel

  UserExerciseRating(this.rating)
      : assert(rating >= 1 && rating <= 5),
        ratingUpdatedAt = FieldValue.serverTimestamp();

  Map<String, dynamic> toMap() => {
        'rating': rating,
        'ratingUpdatedAt': ratingUpdatedAt,
      };
}

/// (Opsiyonel) Aggregate read modeli
class ExerciseAggregate {
  final int ratingCount;
  final int sumStars;
  final double average;

  const ExerciseAggregate({
    required this.ratingCount,
    required this.sumStars,
    required this.average,
  });

  factory ExerciseAggregate.fromMap(Map<String, dynamic>? data) {
    final d = data ?? const {};
    return ExerciseAggregate(
      ratingCount: (d['ratingCount'] ?? 0) as int,
      sumStars: (d['sumStars'] ?? 0) as int,
      average: (d['average'] ?? 0).toDouble(),
    );
  }
}

/// UYGULAMA VE FUNCTIONS İLE AYNI DÖNÜŞÜM!
// "Bench Press" -> "bench_press"
String exerciseIdFromName(String name) => name
    .trim()
    .toLowerCase()
    .replaceAll(RegExp(r'[^\w\s]'), '')
    .replaceAll(RegExp(r'\s+'), '_');

class UserExerciseRatingRepository {
  final FirebaseFirestore _db;

  UserExerciseRatingRepository({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> _userExerciseDoc({
    required String userId,
    required String exerciseName,
  }) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('user_exercises')
        .doc(exerciseName);
  }

  /// SADECE kullanıcı puanını yazar (1..5). Aggregate'i Cloud Function günceller.
  Future<void> setRating({
    required String userId,
    required String exerciseName,
    required int rating,
  }) async {
    final ref = _userExerciseDoc(userId: userId, exerciseName: exerciseName);
    final payload = UserExerciseRating(rating).toMap();
    await ref.set(payload, SetOptions(merge: true));
  }

  /// (Opsiyonel) Kullanıcının mevcut puanını çek
  Future<int?> getUserRating({
    required String userId,
    required String exerciseName,
  }) async {
    final snap =
        await _userExerciseDoc(userId: userId, exerciseName: exerciseName)
            .get();
    return (snap.data()?['rating'] as int?);
  }

  /// Aggregate'i izlemek (UI göstermek için)
  Stream<ExerciseAggregate> watchExerciseAggregate(String exerciseName) {
    final exerciseId = exerciseIdFromName(exerciseName);
    return _db
        .collection('exercises')
        .doc(exerciseId)
        .snapshots()
        .map((s) => ExerciseAggregate.fromMap(s.data()));
  }

  // user_rating_repository.dart

// ... mevcut kodunun altına ekle:
  Stream<int?> watchMyRating({
    required String userId,
    required String exerciseName,
  }) {
    return _userExerciseDoc(userId: userId, exerciseName: exerciseName)
        .snapshots()
        .map((s) => (s.data()?['rating'] as int?));
  }
}
