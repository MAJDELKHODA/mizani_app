import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mizani_app/app/core/utils/app_snackbar.dart';
import 'package:mizani_app/app/data/repositories/auth_repository.dart';
import 'package:mizani_app/app/data/services/auth_service.dart';
import 'package:mizani_app/app/routes/app_routes.dart';

class RegisterController extends GetxController {
  final AuthRepository _authRepo = Get.find();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;
  final isGoogleLoading = false.obs;

  Future<void> register() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      AppSnackbar.error("يرجى تعبئة جميع الحقول");
      return;
    }

    if (password != confirmPassword) {
      AppSnackbar.error("كلمة المرور غير متطابقة");
      return;
    }

    isLoading.value = true;

    try {
      await _authRepo.register(name: name, email: email, password: password);
      Get.offAllNamed(Routes.home);
    } on AuthFailure catch (e) {
      AppSnackbar.error(e.message);
    } catch (_) {
      AppSnackbar.error("حدث خطأ غير متوقع");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> registerWithGoogle() async {
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

  void goToLogin() => Get.offNamed(Routes.login);

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
