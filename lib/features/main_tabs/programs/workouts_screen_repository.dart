import 'package:cloud_firestore/cloud_firestore.dart';
import 'workouts_screen_model.dart';

class RoutineRepository {
  final FirebaseFirestore firestore;

  RoutineRepository({required this.firestore});

  CollectionReference<Map<String, dynamic>> _routineRef(String userId) {
    return firestore
        .collection('users')
        .doc(userId)
        .collection('workout_routines');
  }

  Future<void> addRoutine(String userId, String name) async {
    await _routineRef(userId).add({'routine_name': name});
  }

  Future<void> deleteRoutine(String userId, String routineId) async {
    await _routineRef(userId).doc(routineId).delete();
  }

  Future<void> updateRoutine(
      String userId, String routineId, String newName) async {
    await _routineRef(userId).doc(routineId).update({'routine_name': newName});
  }

  Future<List<WorkoutRoutineModel>> fetchRoutines(String userId) async {
    final snapshot = await _routineRef(userId).orderBy('routine_name').get();
    return snapshot.docs
        .map((doc) => WorkoutRoutineModel.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<void> addWorkout({
    required String userId,
    required String routineId,
    required WorkoutModel workout,
  }) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('workout_routines')
        .doc(routineId)
        .collection('workouts')
        .add(workout.toMap()); // workout ismi doc ID oluyor
  }

  Future<List<WorkoutModel>> getWorkouts({
    required String userId,
    required String routineId,
  }) async {
    final snapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('workout_routines')
        .doc(routineId)
        .collection('workouts')
        .orderBy('created_at', descending: false)
        .get();

    return snapshot.docs
        .map((doc) => WorkoutModel.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<void> deleteWorkout(
      {required String userId,
      required String routineId,
      required String workoutId}) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('workout_routines')
        .doc(routineId)
        .collection('workouts')
        .doc(workoutId)
        .delete();
  }

  Future<void> updateWorkoutData({
    required String userId,
    required String routineId,
    required String workoutId,
    required String newName,
    required int newDayIndex,
    required String newDayLabel,
  }) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('workout_routines')
        .doc(routineId)
        .collection('workouts')
        .doc(workoutId)
        .update({
      'name': newName,
      'dayIndex': newDayIndex,
      'dayLabel': newDayLabel,
    });
  }
}
