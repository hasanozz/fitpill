class Exercise {
  final String name;
  final String targetMuscle;
  final String videoUrl;

  Exercise({
    required this.name,
    required this.targetMuscle,
    required this.videoUrl,
  });

  factory Exercise.fromFirestore(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'] ?? '',
      targetMuscle: json['target_muscle'] ?? '',
      videoUrl: json['url'] ?? '',
    );
  }
}
