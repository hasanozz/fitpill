import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'user_rating_repository.dart'; // içinde ExerciseAggregate ve exerciseIdFromName var

// --- FIREBASE INSTANCES (injection) ---
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final authProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

// --- REPO ---
final userExerciseRatingRepositoryProvider =
    Provider<UserExerciseRatingRepository>((ref) {
  final db = ref.watch(firestoreProvider);
  return UserExerciseRatingRepository(firestore: db);
});

// --- AUTH (reaktif) ---
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authProvider).authStateChanges();
});

// UID gerektiren provider (okur tarafında handle et)
final currentUserIdProvider = Provider<String>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) throw Exception('Kullanıcı oturumu yok');
  return user.uid;
});

// --- ACTION: sadece user_exercises altına rating yaz ---
final setMyExerciseRatingProvider = Provider((ref) {
  final repo = ref.watch(userExerciseRatingRepositoryProvider);
  final uid = ref.watch(currentUserIdProvider);
  return ({
    required String exerciseName,
    required int rating,
  }) {
    return repo.setRating(
      userId: uid,
      exerciseName: exerciseName,
      rating: rating,
    );
  };
});

// --- (ESKİ) rate + aggregate provider ARTIK YOK ---
// final rateExerciseAndAggregateProvider = ...  // SİL

// --- STREAM: exercises/{id} aggregate'ını model olarak izle ---
final exerciseAggregateProvider =
    StreamProvider.family<ExerciseAggregate, String>((ref, exerciseName) {
  final repo = ref.watch(userExerciseRatingRepositoryProvider);
  return repo.watchExerciseAggregate(exerciseName);
});

// (Opsiyonel) Kullanıcının mevcut puanını izlemek istersen:
final myExerciseRatingProvider =
    StreamProvider.family<int?, String>((ref, exerciseName) {
  final repo = ref.watch(userExerciseRatingRepositoryProvider);
  final uid = ref.watch(currentUserIdProvider);
  return repo.watchMyRating(userId: uid, exerciseName: exerciseName);
});
