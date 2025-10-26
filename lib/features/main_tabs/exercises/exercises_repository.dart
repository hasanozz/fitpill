import 'package:cloud_firestore/cloud_firestore.dart';
import 'exercise_model.dart';

class ExerciseRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<List<Exercise>> loadExercisesFromFirestore() async {
    try {
      print("Firestore'dan egzersizler yükleniyor...");

      final snapshot = await _firestore.collection('exercises').get();

      final exercises = snapshot.docs
          .map((doc) => Exercise.fromFirestore(doc.data()))
          .toList();

      print("Egzersizler başarıyla çekildi. Toplam: ${exercises.length}");

      return exercises;
    } catch (e) {
      print("Egzersizleri çekerken hata oluştu: $e");
      return [];
    }
  }
}
