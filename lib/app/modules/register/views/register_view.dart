import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mizani_app/app/core/theme/app_colors.dart';
import 'package:mizani_app/app/modules/register/controllers/register_controller.dart';
import 'package:mizani_app/app/widgets/auth_widgets.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AuthBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
            child: AuthEntrance(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const AuthHeader(
                    title: "إنشاء حساب جديد",
                    subtitle: "ابدأ بتنظيم مصروفك اليومي بخطوات بسيطة",
                    logoSize: 92,
                  ),
                  const SizedBox(height: 28),
                  AuthCard(child: _buildForm()),
                  const SizedBox(height: 16),
                  AuthSwitchRow(
                    question: "لديك حساب؟",
                    action: "تسجيل الدخول",
                    onTap: controller.goToLogin,
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
          controller: controller.nameController,
          label: "الاسم",
          hint: "أدخل اسمك",
          icon: Icons.person_outline_rounded,
          keyboardType: TextInputType.name,
        ),
        const SizedBox(height: 16),
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
          helperText: "6 أحرف على الأقل",
        ),
        const SizedBox(height: 12),
        AuthTextField(
          controller: controller.confirmPasswordController,
          label: "تأكيد كلمة المرور",
          hint: "أعد كتابة كلمة المرور",
          icon: Icons.lock_reset_rounded,
          password: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => controller.register(),
        ),
        const SizedBox(height: 24),
        Obx(
          () => AuthPrimaryButton(
            text: "إنشاء الحساب",
            isLoading: controller.isLoading.value,
            onPressed: controller.register,
          ),
        ),
        const SizedBox(height: 18),
        const AuthOrDivider(),
        const SizedBox(height: 18),
        Obx(
          () => GoogleSignInButton(
            isLoading: controller.isGoogleLoading.value,
            onPressed: controller.registerWithGoogle,
          ),
        ),
      ],
    );
  }
}
