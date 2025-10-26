import 'package:cloud_firestore/cloud_firestore.dart';

class ProgressGoal {
  final String id;
  final String metric;
  final double startValue;
  final double targetValue;
  final DateTime targetDate;
  final DateTime createdAt;
  final bool isCompleted;
  final DateTime? completedAt;
  final double? finalValue;

  const ProgressGoal({
    required this.id,
    required this.metric,
    required this.startValue,
    required this.targetValue,
    required this.targetDate,
    required this.createdAt,
    required this.isCompleted,
    this.completedAt,
    this.finalValue,
  });

  double get progressFraction {
    if (isCompleted) {
      return 1.0;
    }

    final difference = targetValue - startValue;
    if (difference == 0) {
      return 0;
    }

    final currentValue = finalValue ?? startValue;
    final travelled = currentValue - startValue;
    final fraction = travelled / difference;

    if (difference > 0) {
      return fraction.clamp(0.0, 1.0);
    }
    return (1 - fraction).clamp(0.0, 1.0);
  }

  ProgressGoal copyWith({
    String? id,
    String? metric,
    double? startValue,
    double? targetValue,
    DateTime? targetDate,
    DateTime? createdAt,
    bool? isCompleted,
    DateTime? completedAt,
    double? finalValue,
  }) {
    return ProgressGoal(
      id: id ?? this.id,
      metric: metric ?? this.metric,
      startValue: startValue ?? this.startValue,
      targetValue: targetValue ?? this.targetValue,
      targetDate: targetDate ?? this.targetDate,
      createdAt: createdAt ?? this.createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      finalValue: finalValue ?? this.finalValue,
    );
  }

  factory ProgressGoal.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return ProgressGoal(
      id: doc.id,
      metric: data['metric'] as String? ?? '',
      startValue: (data['startValue'] as num?)?.toDouble() ?? 0,
      targetValue: (data['targetValue'] as num?)?.toDouble() ?? 0,
      targetDate: (data['targetDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isCompleted: data['isCompleted'] as bool? ?? false,
      completedAt: (data['completedAt'] as Timestamp?)?.toDate(),
      finalValue: (data['finalValue'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'metric': metric,
      'startValue': startValue,
      'targetValue': targetValue,
      'targetDate': Timestamp.fromDate(targetDate),
      'createdAt': Timestamp.fromDate(createdAt),
      'isCompleted': isCompleted,
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'finalValue': finalValue,
    }..removeWhere((key, value) => value == null);
  }
}
