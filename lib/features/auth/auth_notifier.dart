import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auth_notifier.g.dart';
/// Riverpod 3.x: AsyncNotifier<User?> kullanıyoruz.
/// - state: AsyncValue<User?>
/// - build(): ilk state'i üretir ve authStateChanges()'e abone olur.
///
///
@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {


  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  StreamSubscription<User?>? _sub;

  @override
  Future<User?> build() async {
    // Başlangıçta mevcut kullanıcıyı data olarak yayınla:
    final current = _auth.currentUser;
    state = AsyncData(current);

    // Auth stream'e abone ol ve state'i senkronize et
    _sub = _auth.authStateChanges().listen((user) {
      // Hata/Loading durumlarını ezmeden data yayınla
      state = AsyncData(user);
    });

    // Aboneliği temizle
    ref.onDispose(() {
      _sub?.cancel();
    });

    return current;
  }

  Future<String?> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      state = const AsyncLoading();

      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = cred.user;

      if (user == null) {

        state = const AsyncData(null);
        return "user_creation_failed";
      }


      // --- Firestore Yazma İşlemi ---
      try {
        await user.updateDisplayName(name);

        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'createdAt': Timestamp.now(),

        });

        // 2.5 KRİTİK ADIM: users/{uid}/homepage/profile_data alt koleksiyonuna yazar
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('homepage')
            .doc('profile_data')
            .set({
          'name': name,
          'isPremium': false,
          'premiumExpiration': null,
          'premiumJoinedAt': null,
        });


      } on FirebaseException catch (e) {
        // Auth başarılı, ama Firestore başarısız oldu.
        // Kullanıcı Auth'ta kayıtlı kalır, ancak bir hata döndürülür.
        return "firestore_error"; // register_page'e dönen spesifik hata
      }
      // ----------------------------

      // Her iki adım da başarılı:
      state = AsyncData(user);
      return null;

    } on FirebaseAuthException catch (e) {
      // FirebaseAuth hataları (zayıf şifre, e-posta kullanımda vb.)
      state = AsyncError(e, StackTrace.current);
      return _handleAuthError(e);

    } catch (e, st) {
      // Diğer genel hatalar (Network, cihaz vb.)
      state = AsyncError(e, st);
      return "unknown_error";
    }
  }

  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      state = const AsyncLoading();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      // Stream tetikleyecek fakat anında güncelle:
      state = AsyncData(_auth.currentUser);
      return null;
    } on FirebaseAuthException catch (e) {
      state = AsyncError(e, StackTrace.current);
      return _handleAuthError(e);
    } catch (e, st) {
      state = AsyncError(e, st);
      return "unknown_error";
    }
  }

  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;
      final snap = await _firestore.collection('users').doc(user.uid).get();
      return snap.data();
    } catch (_) {
      return null;
    }
  }

  Future<void> updateUserData(Map<String, dynamic> data) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;
      await _firestore.collection('users').doc(user.uid).update(data);
    } catch (e) {
      // log/analytics tercih edebilirsin
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    // Stream zaten null yayınlar; yine de anında UI için:
    state = const AsyncData(null);
  }

  Future<String?> deleteAccountWithPassword(String password) async {
    try {
      final user = _auth.currentUser;
      if (user == null || user.email == null) return "user_not_found";

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);

      final uid = user.uid;
      final userDoc = _firestore.collection('users').doc(uid);

      // Not: Bu sadece 1 seviye alt koleksiyonu siler.
      // Daha derin/çok seviyeli yapı için Cloud Functions "recursive delete"
      // veya Firebase CLI/Extensions düşünebilirsin.
      final subCollections = ['progress', 'homepage', 'activities', 'backpack_items'];
      for (final sub in subCollections) {
        final snapshot = await userDoc.collection(sub).get();
        for (final doc in snapshot.docs) {
          await doc.reference.delete();
        }
      }

      await userDoc.delete();  // users/{uid}
      await user.delete();     // Auth hesabı
      state = const AsyncData(null);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') return 'wrong_password';
      return 'auth_error';
    } catch (_) {
      return 'unknown_error';
    }
  }

  String? _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return "weak_password";
      case 'email-already-in-use':
        return "email_exists";
      case 'user-not-found':
        return "user_not_found";
      case 'wrong-password':
        return "wrong_password";
      default:
        return "unknown_error";
    }
  }
}
