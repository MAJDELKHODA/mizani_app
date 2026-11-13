import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mizani_app/app/data/models/transaction_model.dart';

// =========================
// العمليات المالية بـ Firestore
// =========================
class TransactionRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _collection(String uid) =>
      _db.collection("users").doc(uid).collection("transactions");

  String get _uid {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw StateError("No logged-in user");
    return user.uid;
  }

  /// كل عمليات المستخدم (الأحدث أولاً) — بتتحدث لحالها
  Stream<List<TransactionModel>> watchAll(String uid) {
    return _collection(uid)
        .orderBy("date", descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map(TransactionModel.fromDoc).toList(),
        );
  }

  Future<void> add(TransactionModel transaction) {
    return _collection(_uid).add({
      ...transaction.toMap(),
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> update(TransactionModel transaction) {
    return _collection(_uid).doc(transaction.id).update({
      ...transaction.toMap(),
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> delete(String id) {
    return _collection(_uid).doc(id).delete();
  }
}
