import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitpill/features/main_tabs/home/badge/badge_repository.dart';

import 'progress_goal_model.dart';

class ProgressGoalsRepository {
  ProgressGoalsRepository({
    required this.userId,
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final String userId;
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection => _firestore
      .collection('users')
      .doc(userId)
      .collection('progress_goals');

  Future<List<ProgressGoal>> fetchGoals() async {
    final snapshot = await _collection.orderBy('createdAt', descending: true).get();
    return snapshot.docs.map(ProgressGoal.fromFirestore).toList();
  }

  Stream<List<ProgressGoal>> watchGoals() {
    return _collection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(ProgressGoal.fromFirestore).toList());
  }

  Future<ProgressGoal> createGoal({
    required String metric,
    required double startValue,
    required double targetValue,
    required DateTime targetDate,
  }) async {
    final now = DateTime.now();
    final docRef = await _collection.add({
      'metric': metric,
      'startValue': startValue,
      'targetValue': targetValue,
      'targetDate': Timestamp.fromDate(targetDate),
      'createdAt': Timestamp.fromDate(now),
      'isCompleted': false,
    });

    final snapshot = await docRef.get();
    return ProgressGoal.fromFirestore(snapshot);
  }

  Future<void> updateGoal(ProgressGoal goal) async {
    await _collection.doc(goal.id).update(goal.toFirestore());
  }

  Future<void> deleteGoal(String id) async {
    await _collection.doc(id).delete();
  }

  Future<void> markGoalCompleted(
    ProgressGoal goal, {
    double? finalValue,
  }) async {
    final now = DateTime.now();
    final updateData = <String, dynamic>{
      'isCompleted': true,
      'completedAt': Timestamp.fromDate(now),
    };
    if (finalValue != null) {
      updateData['finalValue'] = finalValue;
    }

    await _collection.doc(goal.id).update(updateData);

    final badgeRepository =
        BadgeRepository(userId: userId, firestoreInstance: _firestore);
    await badgeRepository.incrementBadgeCount();
  }

  Future<void> evaluateGoalsForMetric({
    required String metric,
    required double newValue,
  }) async {
    final query = await _collection
        .where('metric', isEqualTo: metric)
        .where('isCompleted', isEqualTo: false)
        .get();

    for (final doc in query.docs) {
      final goal = ProgressGoal.fromFirestore(doc);
      final isTargetLower = goal.targetValue < goal.startValue;
      final hasReached = isTargetLower
          ? newValue <= goal.targetValue
          : newValue >= goal.targetValue;

      if (hasReached) {
        await markGoalCompleted(goal, finalValue: newValue);
      } else {
        await _collection.doc(goal.id).update({'finalValue': newValue});
      }
    }
  }
}
