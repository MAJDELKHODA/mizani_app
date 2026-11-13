import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mizani_app/app/core/theme/app_colors.dart';
import 'package:mizani_app/app/modules/splash/controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // أيقونات شريط الحالة بيضا عشان الخلفية غامقة
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.heroEnd,
                AppColors.heroStart,
              ],
            ),
          ),
          child: Stack(
            children: [
              // دوائر ديكور خفيفة
              Positioned(
                top: -90,
                right: -70,
                child: decorCircle(260, const Color(0x14FFFFFF)),
              ),
              Positioned(
                bottom: -120,
                left: -90,
                child: decorCircle(300, const Color(0x0DFFFFFF)),
              ),

              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo
                    FadeTransition(
                      opacity: controller.logoFade,
                      child: ScaleTransition(
                        scale: controller.logoScale,
                        child: Container(
                          width: 150,
                          height: 150,
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(42),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x4D000000),
                                blurRadius: 40,
                                offset: Offset(0, 18),
                              ),
                            ],
                          ),
                          child: Image.asset(
                            "images/mizani_logo.png",
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 36),

                    FadeTransition(
                      opacity: controller.textFade,
                      child: SlideTransition(
                        position: controller.textSlide,
                        child: const Column(
                          children: [
                            Text(
                              "ميزاني",
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              "MIZANI",
                              style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 8,
                                fontWeight: FontWeight.w600,
                                color: Color(0xB3FFFFFF),
                              ),
                            ),
                            SizedBox(height: 22),
                            Text(
                              "نظّم مصروفك اليومي بسهولة",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xCCFFFFFF),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // مؤشر تحميل صغير تحت
              Positioned(
                left: 0,
                right: 0,
                bottom: 60,
                child: FadeTransition(
                  opacity: controller.textFade,
                  child: const Center(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: Color(0x99FFFFFF),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget decorCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
