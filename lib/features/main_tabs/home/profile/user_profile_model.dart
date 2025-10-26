import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileModel {
  final String name;
  final String birthDate;
  final String gender;
  final String height;
  final String? avatar;
  final String? profileImage; // Dosya yolu, localde olabilir
  final String? id; // userId (opsiyonel)
  final bool isPremium;
  final DateTime? premiumExpiration;
  final DateTime? premiumJoinedAt;

  bool get hasActivePremium {
    if (premiumExpiration != null) {
      return premiumExpiration!.isAfter(DateTime.now());
    }
    return isPremium;
  }

  UserProfileModel({
    required this.name,
    required this.birthDate,
    required this.gender,
    required this.height,
    this.avatar,
    this.profileImage,
    this.id,
    this.isPremium = false,
    this.premiumExpiration,
    this.premiumJoinedAt,
  });

  // Firestore'dan çekilen veriyi modele çevirir
  factory UserProfileModel.fromMap(Map<String, dynamic> map, {String? id}) {
    final dynamic expirationRaw = map['premiumExpiration'];
    final dynamic joinedRaw = map['premiumJoinedAt'];
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

    return UserProfileModel(
      name: map['name'] ?? '',
      birthDate: map['birthDate'] ?? '',
      gender: map['gender'] ?? '',
      height: map['height'] ?? '',
      avatar: map['avatar'],
      profileImage: map['profile_image'],
      id: id,
      isPremium: (map['isPremium'] as bool?) ?? false,
      premiumExpiration: premiumExpiration,
      premiumJoinedAt: premiumJoinedAt,
    );
  }

  // Modeli Firestore'a kaydetmek için Map'e çevirir
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'birthDate': birthDate,
      'gender': gender,
      'height': height,
      'avatar': avatar,
      'profile_image': profileImage,
      'isPremium': isPremium,
      'premiumExpiration': premiumExpiration,
      'premiumJoinedAt': premiumJoinedAt,
    };
  }

  // Kolay güncelleme için bir copyWith fonksiyonu
  static const _unset = Object();

  UserProfileModel copyWith({
    String? name,
    String? birthDate,
    String? gender,
    String? height,
    Object? avatar = _unset,
    Object? profileImage = _unset,
    String? id,
    bool? isPremium,
    DateTime? premiumExpiration,
    DateTime? premiumJoinedAt,
  }) {
    return UserProfileModel(
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      avatar: identical(avatar, _unset) ? this.avatar : avatar as String?,
      profileImage: identical(profileImage, _unset)
          ? this.profileImage
          : profileImage as String?,
      id: id ?? this.id,
      isPremium: isPremium ?? this.isPremium,
      premiumExpiration: premiumExpiration ?? this.premiumExpiration,
      premiumJoinedAt: premiumJoinedAt ?? this.premiumJoinedAt,
    );
  }
}
