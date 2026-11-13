import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mizani_app/app/core/utils/app_snackbar.dart';
import 'package:mizani_app/app/data/repositories/auth_repository.dart';
import 'package:mizani_app/app/data/services/auth_service.dart';
import 'package:mizani_app/app/routes/app_routes.dart';

class LoginController extends GetxController {
  final AuthRepository _authRepo = Get.find();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final rememberMe = false.obs;
  final isLoading = false.obs; // عشان ما يكبس الزر مرتين
  final isGoogleLoading = false.obs;

  void toggleRememberMe() => rememberMe.toggle();

  Future<void> login() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      AppSnackbar.error("يرجى تعبئة جميع الحقول");
      return;
    }

    isLoading.value = true;

    try {
      await _authRepo.signIn(email: email, password: password);
      Get.offAllNamed(Routes.home);
    } on AuthFailure catch (e) {
      AppSnackbar.error(e.message);
    } catch (_) {
      AppSnackbar.error("حدث خطأ غير متوقع");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithGoogle() async {
    isGoogleLoading.value = true;

    try {
      final success = await _authRepo.signInWithGoogle();
      if (success) Get.offAllNamed(Routes.home);
    } on AuthFailure catch (e) {
      AppSnackbar.error(e.message);
    } catch (_) {
      AppSnackbar.error("تعذّر تسجيل الدخول عبر Google");
    } finally {
      isGoogleLoading.value = false;
    }
  }

  // نسيت كلمة المرور: بيبعت رابط على الإيميل المكتوب
  Future<void> resetPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      AppSnackbar.error("اكتب بريدك الإلكتروني أولاً");
      return;
    }

    try {
      await _authRepo.sendPasswordReset(email);
      AppSnackbar.success("أرسلنا رابط استعادة كلمة المرور إلى بريدك");
    } on AuthFailure catch (e) {
      AppSnackbar.error(e.message);
    }
  }

  void goToRegister() => Get.toNamed(Routes.register);

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
