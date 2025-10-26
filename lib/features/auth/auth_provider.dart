// auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ÖNEMLİ: Generator’ın ürettiği 'authProvider' için bu import şart:
import 'auth_notifier.dart'; // <-- part 'auth_notifier.g.dart' olan dosya

/// Null-safe UID
final userIdProvider = Provider<String?>((ref) {
  final auth = ref.watch(authProvider);   // AsyncValue<User?>
  // Riverpod 3'te genelde .valueOrNull var; yoksa aşağıdaki alternative satırı kullan.
  return auth.maybeWhen(data: (user)=>user?.uid, orElse: ()=>null);
  // ALTERNATİF (eğer valueOrNull görünmüyorsa):
  // return auth.maybeWhen(data: (u) => u?.uid, orElse: () => null);
});

/// Zorunlu UID (yoksa exception)
final requiredUserIdProvider = Provider<String>((ref) {
  final uid = ref.watch(userIdProvider);
  if (uid == null) {
    throw Exception("User is not authenticated");
  }
  return uid;
});
