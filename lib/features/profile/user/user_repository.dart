import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final FirebaseFirestore firestore;

  UserRepository({required this.firestore});

  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    final doc = await firestore
        .collection('users')
        .doc(userId)
        .collection('homepage')
        .doc('profile_data')
        .get();
    if (!doc.exists) return null;
    final data = doc.data();
    if (data == null) return null;
    final dynamic expirationRaw = data['premiumExpiration'];
    final dynamic joinedRaw = data['premiumJoinedAt'];
    DateTime? premiumExpiration;
    DateTime? premiumJoinedAt;
    if (expirationRaw is Timestamp) {
      premiumExpiration = expirationRaw.toDate();
    } else if (expirationRaw is DateTime) {
      premiumExpiration = expirationRaw;
    } else if (expirationRaw is String) {
      premiumExpiration = DateTime.tryParse(expirationRaw);
    }
    if (joinedRaw is Timestamp) {
      premiumJoinedAt = joinedRaw.toDate();
    } else if (joinedRaw is DateTime) {
      premiumJoinedAt = joinedRaw;
    } else if (joinedRaw is String) {
      premiumJoinedAt = DateTime.tryParse(joinedRaw);
    }
    final bool originalPremium = (data['isPremium'] as bool?) ?? false;
    final bool hasActivePremium = premiumExpiration != null
        ? premiumExpiration.isAfter(DateTime.now())
        : originalPremium;
    return {
      ...data,
      'isPremium': hasActivePremium,
      'premiumExpiration': premiumExpiration,
      'premiumJoinedAt': premiumJoinedAt,
    };
  }

  Future<void> updateUserProfile(
      String userId, Map<String, dynamic> data) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('homepage')
        .doc('profile_data')
        .update(data);
  }
}
