import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'app/core/bindings/initial_binding.dart';
import 'app/core/theme/app_colors.dart';
import 'app/core/theme/app_theme.dart';
import 'app/data/services/notification_service.dart';
import 'app/data/services/theme_service.dart';
import 'app/routes/app_pages.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,
  );

  await NotificationService.instance.init();

  // اقرأ الوضع المحفوظ (فاتح / داكن / تلقائي) قبل أول شاشة
  await Get.putAsync<ThemeService>(
    () => ThemeService().init(),
    permanent: true,
  );

  runApp(const MizaniApp());
}

class MizaniApp extends StatelessWidget {
  const MizaniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "ميزاني",
      debugShowCheckedModeBanner: false,

      // منع تمدد الشاشة عند السحب لأعلى أو لأسفل
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        overscroll: false,
      ),

      locale: const Locale('ar'),

      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeService.to.mode.value,

      initialBinding: InitialBinding(),
      initialRoute: AppPages.initial,
      getPages: AppPages.pages,

      // اتجاه التطبيق RTL + لون أيقونات شريط الحالة حسب الوضع
      builder: (context, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: AppColors.isDark
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          ),
        );
      },
    );
  }
}
