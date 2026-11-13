import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mizani_app/app/data/repositories/auth_repository.dart';
import 'package:mizani_app/app/routes/app_routes.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final AuthRepository _authRepo = Get.find();

  late final AnimationController animation;

  late final Animation<double> logoScale;
  late final Animation<double> logoFade;
  late final Animation<double> textFade;
  late final Animation<Offset> textSlide;

  static const _splashDuration = Duration(milliseconds: 2600);

  @override
  void onInit() {
    super.onInit();

    animation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // اللوجو بيكبر بنعومة
    logoScale = Tween<double>(begin: 0.7, end: 1).animate(
      CurvedAnimation(
        parent: animation,
        curve: const Interval(0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    logoFade = CurvedAnimation(
      parent: animation,
      curve: const Interval(0, 0.4, curve: Curves.easeOut),
    );

    // النص بيطلع بعد اللوجو
    textFade = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.4, 1, curve: Curves.easeOut),
    );

    textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: animation,
        curve: const Interval(0.4, 1, curve: Curves.easeOutCubic),
      ),
    );

    animation.forward();
  }

  @override
  void onReady() {
    super.onReady();
    Future.delayed(_splashDuration, _goNext);
  }

  // مسجل دخول ← الهوم | شاف الـ onboarding ← الدخول | أول مرة ← onboarding
  Future<void> _goNext() async {
    if (isClosed) return;

    if (_authRepo.isLoggedIn) {
      Get.offAllNamed(Routes.home);
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final seenOnboarding = prefs.getBool("seenOnboarding") ?? false;

    Get.offAllNamed(seenOnboarding ? Routes.login : Routes.onboarding);
  }

  @override
  void onClose() {
    animation.dispose();
    super.onClose();
  }
}
