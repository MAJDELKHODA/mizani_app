import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mizani_app/app/data/services/auth_service.dart';

// =========================
// كل عمليات الحساب: دخول، تسجيل، خروج، كلمة المرور
// الأخطاء بترجع كـ AuthFailure برسالة عربية جاهزة للعرض
// =========================
class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final AuthService _authService = AuthService.instance;

  User? get currentUser => _auth.currentUser;

  bool get isLoggedIn => _auth.currentUser != null;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_loginMessage(e.code), code: e.code);
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;

      await _db.collection("users").doc(uid).set({
        "uid": uid,
        "name": name,
        "email": email,
        "createdAt": FieldValue.serverTimestamp(),
      });
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_registerMessage(e.code), code: e.code);
    }
  }

  /// بيرجع false لو المستخدم سكّر نافذة Google
  Future<bool> signInWithGoogle() async {
    final result = await _authService.signInWithGoogle();

    final user = result?.user;
    if (user == null) return false;

    // أول مرة بيدخل بـ Google ← نعمله ملف زي التسجيل العادي
    final userRef = _db.collection("users").doc(user.uid);
    final userDoc = await userRef.get();

    if (!userDoc.exists) {
      await userRef.set({
        "uid": user.uid,
        "name": user.displayName ?? "",
        "email": user.email ?? "",
        "createdAt": FieldValue.serverTimestamp(),
      });
    }

    return true;
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(
        e.code == "invalid-email"
            ? "البريد الإلكتروني غير صالح"
            : "تعذر إرسال الرابط، حاول مرة أخرى",
        code: e.code,
      );
    }
  }

  /// بيطلع من Firebase ومن Google كمان
  Future<void> signOut() => _authService.signOut();

  // ----- رسائل الأخطاء -----

  String _loginMessage(String code) {
    switch (code) {
      case "invalid-email":
        return "البريد الإلكتروني غير صالح";
      case "user-disabled":
        return "تم تعطيل هذا الحساب";
      case "network-request-failed":
        return "تحقق من اتصالك بالإنترنت";
      case "too-many-requests":
        return "محاولات كثيرة، حاول بعد قليل";
      default:
        return "البريد الإلكتروني أو كلمة المرور غير صحيحة";
    }
  }

  String _registerMessage(String code) {
    switch (code) {
      case "email-already-in-use":
        return "البريد الإلكتروني مستخدم مسبقاً";
      case "weak-password":
        return "كلمة المرور ضعيفة، استخدم 6 أحرف على الأقل";
      case "invalid-email":
        return "البريد الإلكتروني غير صالح";
      case "network-request-failed":
        return "تحقق من اتصالك بالإنترنت";
      default:
        return "حدث خطأ أثناء إنشاء الحساب";
    }
  }
}
