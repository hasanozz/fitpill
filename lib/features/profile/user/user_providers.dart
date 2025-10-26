import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitpill/features/profile/user/user_repository.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(firestore: FirebaseFirestore.instance);
});

final userProfileProvider =
    FutureProvider.family<Map<String, dynamic>?, String>((ref, userId) async {
  final repo = ref.read(userRepositoryProvider);
  return await repo.getUserProfile(userId);
});
