// lib/repository/progress_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitpill/core/models/chartData_model.dart';

import 'progress_model.dart';

class ProgressRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId;

  ProgressRepository({required this.userId});

  Future<void> saveMeasurement(String metric, double value, String date) async {
    await _firestore
        .collection("users")
        .doc(userId)
        .collection("progress")
        .doc(metric)
        .collection("dates")
        .doc(date)
        .set({
      "value": value,
      "date": date,
    }, SetOptions(merge: true));
  }

  Future<void> deleteMeasurement(String metric, String date) async {
    await _firestore
        .collection("users")
        .doc(userId)
        .collection("progress")
        .doc(metric)
        .collection("dates")
        .doc(date)
        .delete();
  }

  Future<List<ProgressModel>> getMeasurements(String metric) async {
    final snapshot = await _firestore
        .collection("users")
        .doc(userId)
        .collection("progress")
        .doc(metric)
        .collection("dates")
        .orderBy("date", descending: true)
        .get();

    return snapshot.docs.map((doc) => ProgressModel.fromDoc(doc)).toList();
  }

  Future<ProgressModel?> getMeasurementForDate(
      String metric, String date) async {
    final doc = await _firestore
        .collection("users")
        .doc(userId)
        .collection("progress")
        .doc(metric)
        .collection("dates")
        .doc(date)
        .get();

    if (!doc.exists) {
      return null;
    }

    return ProgressModel.fromDoc(doc);
  }

  Future<ProgressModel?> getLatestMeasurement(String metric) async {
    final snapshot = await _firestore
        .collection("users")
        .doc(userId)
        .collection("progress")
        .doc(metric)
        .collection("dates")
        .orderBy("date", descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    return ProgressModel.fromDoc(snapshot.docs.first);
  }

  // -----------------------FULLSCREEN GRAPH FIREBASE KODLARI--------------------------------------------
  Future<List<ChartData>> getChartData(String metric) async {
    final snapshot = await _firestore
        .collection("users")
        .doc(userId)
        .collection("progress")
        .doc(metric)
        .collection("dates")
        .orderBy("date", descending: false)
        .get();

    return snapshot.docs.map((doc) {
      return ChartData(
        date: DateTime.tryParse(doc.id) ?? DateTime.now(),
        value: (doc.data())["value"]?.toDouble() ?? 0,
      );
    }).toList();
  }

  // --------------- MEASUREMENT_SELECTION_TOHOMEPAGE SAYFASININ FIREBASE KODLARI---------------------------
  Future<String?> getFavoriteMetric() async {
    final doc = await _firestore
        .collection("users")
        .doc(userId)
        .collection("homepage")
        .doc("favorite_metric")
        .get();

    if (doc.exists && doc.data()?["measurement"] != null) {
      return doc.data()!["measurement"] as String;
    }
    return null;
  }

  Future<void> saveFavoriteMetric(String metric) async {
    await _firestore
        .collection("users")
        .doc(userId)
        .collection("homepage")
        .doc("favorite_metric")
        .set({"measurement": metric}, SetOptions(merge: true));
  }

  Future<Map<String, List<ChartData>>> getAllProgressData(
      List<String> metrics) async {
    final Map<String, List<ChartData>> result = {};

    for (String metric in metrics) {
      final snapshot = await _firestore
          .collection("users")
          .doc(userId)
          .collection("progress")
          .doc(metric)
          .collection("dates")
          .orderBy("date", descending: false)
          .get();

      final data = snapshot.docs.map((doc) {
        final d = doc.data();
        return ChartData(
          date: DateTime.tryParse(doc.id) ?? DateTime.now(),
          value: (d["value"] as num?)?.toDouble() ?? 0.0,
        );
      }).toList();

      result[metric] = data;
    }

    return result;
  }

  Stream<ProgressModel?> watchLatestMeasurement(String metric) {
    return _firestore
        .collection("users")
        .doc(userId)
        .collection("progress")
        .doc(metric)
        .collection("dates")
        .orderBy("date", descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return null;
      }
      final doc = snapshot.docs.first;
      final data = doc.data();
      final value = (data["value"] as num?)?.toDouble();
      if (value == null) {
        return null;
      }
      final date = data["date"] as String?;
      return ProgressModel(
        date: date ?? doc.id,
        value: value,
      );
    });
  }
}
