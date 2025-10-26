// lib/model/progress_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class ProgressModel {
  final String date;
  final double value;

  ProgressModel({
    required this.date,
    required this.value,
  });

  factory ProgressModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ProgressModel(
      date: data['date'] ?? '',
      value: (data['value'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'value': value,
    };
  }
}
