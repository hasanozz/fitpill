import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitpill/features/main_tabs/exercises/exercise_tracker_page/exercise_set_model.dart';

class UserExerciseRepository {
  final String userId;
  final FirebaseFirestore firestore;

  UserExerciseRepository({required this.userId})
      : firestore = FirebaseFirestore.instance;

  Future<void> addExerciseSet({
    required ExerciseSet set,
    required String exerciseId,
  }) async {
    final setsCollectionRef = firestore
        .collection('users')
        .doc(userId)
        .collection('user_exercises')
        .doc(exerciseId)
        .collection('sets');

    await setsCollectionRef.add(set.toMap());
  }

  Future<void> deleteExerciseSet({
    required String exerciseId,
    required String setId,
  }) async {
    final setDocRef = firestore
        .collection('users')
        .doc(userId)
        .collection('user_exercises')
        .doc(exerciseId)
        .collection('sets')
        .doc(setId);

    await setDocRef.delete();
  }

  Future<List<ExerciseSet>> fetchSetsForExercise({
    required String exerciseId,
  }) async {
    final setsSnapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('user_exercises')
        .doc(exerciseId)
        .collection('sets')
        .orderBy('exercise_date', descending: true)
        .get();

    return setsSnapshot.docs
        .map((doc) => ExerciseSet.fromMap(doc.id, doc.data()))
        .toList();
  }
}
