import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mizani_app/app/core/theme/app_colors.dart';
import 'package:mizani_app/app/modules/login/controllers/login_controller.dart';
import 'package:mizani_app/app/widgets/auth_widgets.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AuthBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
            child: AuthEntrance(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const AuthHeader(
                    title: "أهلاً بعودتك 👋",
                    subtitle: "سجّل دخولك لتتابع مصاريفك وميزانيتك",
                  ),
                  const SizedBox(height: 32),
                  AuthCard(child: _buildForm()),
                  const SizedBox(height: 20),
                  AuthSwitchRow(
                    question: "ليس لديك حساب؟",
                    action: "إنشاء حساب",
                    onTap: controller.goToRegister,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthTextField(
          controller: controller.emailController,
          label: "البريد الإلكتروني",
          hint: "أدخل بريدك الإلكتروني",
          icon: Icons.mail_outline_rounded,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        AuthTextField(
          controller: controller.passwordController,
          label: "كلمة المرور",
          hint: "أدخل كلمة المرور",
          icon: Icons.lock_outline_rounded,
          password: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => controller.login(),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildRememberMe(),
            const Spacer(),
            TextButton(
              onPressed: controller.resetPassword,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 4),
              ),
              child: const Text(
                "نسيت كلمة المرور؟",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Obx(
          () => AuthPrimaryButton(
            text: "تسجيل الدخول",
            isLoading: controller.isLoading.value,
            onPressed: controller.login,
          ),
        ),
        const SizedBox(height: 18),
        const AuthOrDivider(),
        const SizedBox(height: 18),
        Obx(
          () => GoogleSignInButton(
            isLoading: controller.isGoogleLoading.value,
            onPressed: controller.loginWithGoogle,
          ),
        ),
      ],
    );
  }

  // تذكرني
  Widget _buildRememberMe() {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: controller.toggleRememberMe,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Obx(() {
          final checked = controller.rememberMe.value;

          return Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: checked ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: checked ? AppColors.primary : AppColors.textHint,
                    width: 1.5,
                  ),
                ),
                child: checked
                    ? const Icon(
                        Icons.check_rounded,
                        size: 14,
                        color: Colors.white,
                      )
                    : null,
              ),
              const SizedBox(width: 8),
              Text(
                "تذكرني",
                style: TextStyle(fontSize: 13, color: AppColors.textDark),
              ),
            ],
          );
        }),
      ),
    );
  }
}
