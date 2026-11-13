import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mizani_app/app/routes/app_routes.dart';

class OnboardingPage {
  final String image;
  final String title;
  final String description;

  const OnboardingPage({
    required this.image,
    required this.title,
    required this.description,
  });
}

class OnboardingController extends GetxController {
  final pageController = PageController();

  final currentIndex = 0.obs;

  final List<OnboardingPage> pages = const [
    OnboardingPage(
      image: "images/onboarding1.png",
      title: "تحكم بمصروفك بسهولة",
      description: "سجل مصاريفك اليومية واعرف أين تذهب أموالك بكل وضوح.",
    ),
    OnboardingPage(
      image: "images/onboarding2.png",
      title: "حدد ميزانيتك اليومية",
      description: "ضع حدًا للصرف وتابع المبلغ المتبقي لك خلال اليوم.",
    ),
    OnboardingPage(
      image: "images/onboarding3.png",
      title: "افهم عادات إنفاقك",
      description: "شاهد تقاريرك الشهرية وساعد نفسك على تنظيم أموالك بشكل أفضل.",
    ),
  ];

  bool get isLastPage => currentIndex.value == pages.length - 1;

  void onPageChanged(int index) => currentIndex.value = index;

  void nextPage() {
    if (isLastPage) {
      finish();
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  // نحفظ إنه المستخدم شاف الـ onboarding عشان ما يطلعله مرة ثانية
  Future<void> finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("seenOnboarding", true);

    Get.offAllNamed(Routes.login);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
