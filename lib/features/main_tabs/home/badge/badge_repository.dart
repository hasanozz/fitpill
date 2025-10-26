import 'package:cloud_firestore/cloud_firestore.dart';

import 'badge_data.dart';

class BadgeRepository {
  BadgeRepository({
    required this.userId,
    FirebaseFirestore? firestoreInstance,
  }) : firestore = firestoreInstance ?? FirebaseFirestore.instance;

  final String userId;
  final FirebaseFirestore firestore;

  DocumentReference<Map<String, dynamic>> get _docRef => firestore
      .collection('users')
      .doc(userId)
      .collection('homepage')
      .doc('badges');

  Future<BadgeData> getBadgeData() async {
    final doc = await _docRef.get();
    if (!doc.exists) {
      final data = BadgeData(totalBadges: 0, tier: _determineTier(0));
      await _docRef.set({
        'totalBadges': data.totalBadges,
        'tier': data.tier,
      });
      return data;
    }

    final snapshot = doc.data() ?? <String, dynamic>{};
    return BadgeData(
      totalBadges: (snapshot['totalBadges'] as num?)?.toInt() ?? 0,
      tier: snapshot['tier'] as String? ?? _determineTier(0),
      lastAwardedAt: (snapshot['lastAwardedAt'] as Timestamp?)?.toDate(),
    );
  }

  Future<BadgeData> incrementBadgeCount() async {
    return firestore.runTransaction((transaction) async {
      final doc = await transaction.get(_docRef);
      int totalBadges = 0;
      if (doc.exists) {
        totalBadges = (doc.data()?['totalBadges'] as num?)?.toInt() ?? 0;
      }
      totalBadges += 1;

      final tier = _determineTier(totalBadges);
      final now = DateTime.now();
      transaction.set(
        _docRef,
        {
          'totalBadges': totalBadges,
          'tier': tier,
          'lastAwardedAt': Timestamp.fromDate(now),
        },
        SetOptions(merge: true),
      );

      return BadgeData(
        totalBadges: totalBadges,
        tier: tier,
        lastAwardedAt: now,
      );
    });
  }

  String _determineTier(int totalBadges) {
    if (totalBadges >= 20) {
      return 'Elite Challenger';
    }
    if (totalBadges >= 15) {
      return 'Gold Challenger';
    }
    if (totalBadges >= 10) {
      return 'Silver Challenger';
    }
    if (totalBadges >= 5) {
      return 'Bronze Challenger';
    }
    return 'Rookie Challenger';
  }
}
