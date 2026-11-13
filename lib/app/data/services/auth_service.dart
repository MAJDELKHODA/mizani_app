// ═══════════════════════════════════════════════════════════════════════════
//  auth_service.dart
//  تسجيل الدخول عبر Google و Apple باستخدام Firebase Authentication
//
//  الحزم (أكتوبر 2026):
//    firebase_core: ^4.14.0
//    firebase_auth: ^6.6.1
//    google_sign_in: ^7.2.0   ← واجهة جديدة: initialize() + authenticate()
//
//  Apple: نستخدم AppleAuthProvider المدمج في firebase_auth مباشرة،
//  فلا نحتاج حزمة sign_in_with_apple، ويعمل على iOS وأندرويد والويب.
// ═══════════════════════════════════════════════════════════════════════════

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// خطأ موحّد برسالة عربية جاهزة للعرض للمستخدم.
class AuthFailure implements Exception {
  const AuthFailure(this.message, {this.code});
  final String message;
  final String? code;

  @override
  String toString() => 'AuthFailure($code): $message';
}

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  /// اختياري: Web Client ID من Firebase Console (مطلوب أحياناً على أندرويد
  /// إذا لم يُقرأ تلقائياً من google-services.json).
  static const String? _serverClientId = null;

  Future<void>? _googleInit;

  // ─────────────────────────── حالة المستخدم ───────────────────────────────
  /// استخدمها مع StreamBuilder لتحديد الشاشة (Login / Home).
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;
  bool get isLoggedIn => _auth.currentUser != null;

  // ═════════════════════════════════════════════════════════════════════════
  //  Google Sign-In
  // ═════════════════════════════════════════════════════════════════════════

  /// في google_sign_in 7: يجب استدعاء initialize() مرة واحدة فقط قبل أي شيء.
  Future<void> _ensureGoogleInitialized() {
    return _googleInit ??=
        _googleSignIn.initialize(serverClientId: _serverClientId);
  }

  /// يرجع null إذا ألغى المستخدم العملية.
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // على الويب: نافذة Firebase المنبثقة مباشرة
      if (kIsWeb) {
        return await _auth.signInWithPopup(GoogleAuthProvider());
      }

      await _ensureGoogleInitialized();

      // 1) فتح نافذة اختيار حساب Google
      final GoogleSignInAccount account = await _googleSignIn.authenticate();

      // 2) الحصول على idToken (أصبح getter متزامن، بدون await)
      final String? idToken = account.authentication.idToken;
      if (idToken == null) {
        throw const AuthFailure('تعذّر الحصول على بيانات Google، حاول مجدداً');
      }

      // 3) إنشاء بيانات الاعتماد و 4) تسجيل الدخول في Firebase
      final credential = GoogleAuthProvider.credential(idToken: idToken);
      return await _auth.signInWithCredential(credential);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled ||
          e.code == GoogleSignInExceptionCode.interrupted) {
        return null; // المستخدم أغلق النافذة
      }
      throw AuthFailure(_googleMessage(e.code), code: e.code.name);
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_firebaseMessage(e.code), code: e.code);
    }
  }

  // ═════════════════════════════════════════════════════════════════════════
  //  Apple Sign-In
  // ═════════════════════════════════════════════════════════════════════════

  /// يرجع null إذا ألغى المستخدم العملية.
  /// iOS: نافذة Apple الأصلية — أندرويد/ويب: صفحة Apple عبر Firebase.
  Future<UserCredential?> signInWithApple() async {
    final provider = AppleAuthProvider()
      ..addScope('email')
      ..addScope('name');

    try {
      final UserCredential result = kIsWeb
          ? await _auth.signInWithPopup(provider)
          : await _auth.signInWithProvider(provider);

      // Apple يرسل الاسم في أول تسجيل دخول فقط → نحفظه إن وُجد
      await _saveAppleNameIfNeeded(result);
      return result;
    } on FirebaseAuthException catch (e) {
      const cancelCodes = {
        'canceled',
        'web-context-canceled',
        'popup-closed-by-user',
        'cancelled-popup-request',
      };
      if (cancelCodes.contains(e.code)) return null;
      throw AuthFailure(_firebaseMessage(e.code), code: e.code);
    }
  }

  Future<void> _saveAppleNameIfNeeded(UserCredential result) async {
    final user = result.user;
    if (user == null || (user.displayName?.isNotEmpty ?? false)) return;

    final profile = result.additionalUserInfo?.profile;
    final name = profile?['name'];
    String? fullName;
    if (name is Map) {
      fullName = [name['firstName'], name['lastName']]
          .whereType<String>()
          .where((s) => s.isNotEmpty)
          .join(' ');
    }
    if (fullName != null && fullName.isNotEmpty) {
      await user.updateDisplayName(fullName);
      await user.reload();
    }
  }

  // ═════════════════════════════════════════════════════════════════════════
  //  تسجيل الخروج وتحديث البيانات
  // ═════════════════════════════════════════════════════════════════════════
  Future<void> signOut() async {
    if (!kIsWeb && _googleInit != null) {
      try {
        await _googleSignIn.signOut();
      } catch (_) {/* المستخدم لم يكن مسجلاً بـ Google */}
    }
    await _auth.signOut();
  }

  /// تحديث بيانات المستخدم من السيرفر (الاسم، الصورة، الإيميل...).
  Future<User?> reloadUser() async {
    await _auth.currentUser?.reload();
    return _auth.currentUser;
  }

  // ═════════════════════════════════════════════════════════════════════════
  //  رسائل الأخطاء بالعربي
  // ═════════════════════════════════════════════════════════════════════════
  String _firebaseMessage(String code) {
    switch (code) {
      case 'account-exists-with-different-credential':
        return 'هذا البريد مسجّل مسبقاً بطريقة دخول أخرى';
      case 'invalid-credential':
        return 'بيانات الاعتماد غير صحيحة أو منتهية';
      case 'user-disabled':
        return 'تم تعطيل هذا الحساب';
      case 'operation-not-allowed':
        return 'طريقة الدخول هذه غير مفعّلة في Firebase Console';
      case 'network-request-failed':
        return 'تحقق من اتصالك بالإنترنت';
      case 'too-many-requests':
        return 'محاولات كثيرة، حاول بعد قليل';
      default:
        return 'حدث خطأ غير متوقع ($code)';
    }
  }

  String _googleMessage(GoogleSignInExceptionCode code) {
    switch (code) {
      case GoogleSignInExceptionCode.clientConfigurationError:
      case GoogleSignInExceptionCode.providerConfigurationError:
        return 'إعداد Google غير مكتمل (تحقق من SHA-1 وملفات Firebase)';
      case GoogleSignInExceptionCode.uiUnavailable:
        return 'لا يمكن فتح نافذة Google الآن';
      default:
        return 'تعذّر تسجيل الدخول عبر Google';
    }
  }
}
