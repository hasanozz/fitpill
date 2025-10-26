import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityModel {
  final String id; // Firestore'daki belge ID'si
  final String activityName; // Yürüyüş, Koşu vs.
  final int durationInSeconds; // Süre (saniye cinsinden)
  final double caloriesBurned; // Yakılan kalori
  final DateTime timestamp; // Aktivite tarihi
  final double? incline; // (Opsiyonel) Eğimi (%)
  final String? tempoKey; // (Opsiyonel) Tempo bilgisi (low/medium/high)

  const ActivityModel({
    required this.id,
    required this.activityName,
    required this.durationInSeconds,
    required this.caloriesBurned,
    required this.timestamp,
    this.incline,
    this.tempoKey,
  });

  // Firebase'e kaydederken Map'e çevirme
  Map<String, dynamic> toMap() {
    return {
      'activityName': activityName,
      'durationInSeconds': durationInSeconds,
      'caloriesBurned': caloriesBurned,
      'timestamp': Timestamp.fromDate(timestamp),
      'incline': incline,
      'tempoKey': tempoKey,
    };
  }

  // Firebase'den okurken Map'ten nesne oluşturma (eski ve yeni kayıt uyumlu)
  factory ActivityModel.fromMap(String id, Map<String, dynamic> map) {
    return ActivityModel(
      id: id,
      activityName: map['activityName'] ?? map['activity'] ?? '',
      durationInSeconds:
          (map['durationInSeconds'] ?? map['duration'] ?? 0) as int,
      caloriesBurned:
          (map['caloriesBurned'] ?? map['calories'] ?? 0.0).toDouble(),
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      incline:
          map['incline'] != null ? (map['incline'] as num).toDouble() : null,
      tempoKey: map['tempoKey'],
    );
  }

  // Nesneden yeni kopya oluşturmak için copyWith
  ActivityModel copyWith({
    String? id,
    String? activityName,
    int? durationInSeconds,
    double? caloriesBurned,
    DateTime? timestamp,
    double? incline,
    String? tempoKey,
  }) {
    return ActivityModel(
      id: id ?? this.id,
      activityName: activityName ?? this.activityName,
      durationInSeconds: durationInSeconds ?? this.durationInSeconds,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      timestamp: timestamp ?? this.timestamp,
      incline: incline ?? this.incline,
      tempoKey: tempoKey ?? this.tempoKey,
    );
  }
}
