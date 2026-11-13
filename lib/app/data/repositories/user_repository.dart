import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mizani_app/app/data/models/user_model.dart';

// =========================
// بيانات المستخدم بـ Firestore
// =========================
class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      _db.collection("users").doc(uid);

  /// بيانات المستخدم — بتتحدث لحالها
  Stream<UserModel> watch(String uid) {
    return _doc(uid).snapshots().map((doc) {
      final model = UserModel.fromMap(uid, doc.data());

      // الإيميل الأدق من Firebase Auth
      final authEmail = FirebaseAuth.instance.currentUser?.email;

      return UserModel(
        uid: model.uid,
        name: model.name,
        email: authEmail ?? model.email,
      );
    });
  }

  Future<void> updateName(String name) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return _doc(uid).set({
      "name": name,
      "updatedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
