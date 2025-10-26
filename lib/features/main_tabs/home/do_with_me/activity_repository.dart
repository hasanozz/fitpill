import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitpill/features/main_tabs/home/do_with_me/activity_model.dart';

class ActivityRepository {
  final String userId;
  final FirebaseFirestore firestore;

  ActivityRepository({
    required this.userId,
    FirebaseFirestore? firestoreInstance,
  }) : firestore = firestoreInstance ?? FirebaseFirestore.instance;

  // Aktiviteyi Firestore'a kaydet
  Future<void> addActivity(ActivityModel activity) async {
    final docRef = firestore
        .collection('users')
        .doc(userId)
        .collection('activities')
        .doc(); // Firestore otomatik ID oluşturacak

    await docRef.set(activity.toMap());
  }

  // Kullanıcının aktivitelerini çek
  Future<List<ActivityModel>> fetchActivities() async {
    final querySnapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('activities')
        .orderBy('timestamp', descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) => ActivityModel.fromMap(doc.id, doc.data()))
        .toList();
  }

  // Belirli bir aktiviteyi sil
  Future<void> deleteActivity(String activityId) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('activities')
        .doc(activityId)
        .delete();
  }
}
