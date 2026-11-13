import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mizani_app/app/data/models/budget_model.dart';

// =========================
// الميزانية الحالية بـ Firestore
// =========================
class BudgetRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      _db.collection("users").doc(uid).collection("budget").doc("current");

  /// الميزانية الحالية (null لو ما في) — بتتحدث لحالها
  Stream<BudgetModel?> watch(String uid) {
    return _doc(uid)
        .snapshots()
        .map((doc) => doc.exists ? BudgetModel.fromMap(doc.data()) : null);
  }

  Future<void> save(BudgetModel budget) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return _doc(uid).set(budget.toMap());
  }
}
