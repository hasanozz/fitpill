import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'setup_model.dart';

class SetupRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  SetupRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : firestore = firestore ?? FirebaseFirestore.instance,
        auth = auth ?? FirebaseAuth.instance;

  Future<void> saveSetupData(SetupData data) async {
    final user = auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    final uid = user.uid;

    await firestore
        .collection('users')
        .doc(uid)
        .collection('homepage')
        .doc('profile_data')
        .set({
      'birthDate': DateFormat('dd/MM/yyyy').format(data.birthDate!),
      'gender': data.gender!,
      'height': data.height!,
    }, SetOptions(merge: true));

    await firestore.collection('users').doc(uid).set({
      'setupCompleted': true,
    }, SetOptions(merge: true)); // ✅ varsa günceller, yoksa oluşturur

    await firestore
        .collection('users')
        .doc(uid)
        .collection('homepage')
        .doc('favorite_metric')
        .set({'measurement': 'weight'}, SetOptions(merge: true));

    final todayId = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await firestore
        .collection('users')
        .doc(uid)
        .collection('progress')
        .doc('weight')
        .collection('dates')
        .doc(todayId)
        .set({
      'date': todayId,
      'value': double.parse(data.weight!),
    });
  }
}

final setupRepositoryProvider = Provider<SetupRepository>((ref) {
  return SetupRepository();
});