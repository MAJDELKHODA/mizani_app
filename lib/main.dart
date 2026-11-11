import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'Services/notification_service.dart';
import 'package:flutter/material.dart';

import 'Screens/homescreen.dart';
import 'Screens/loginscreen.dart';
import 'Screens/onboardingscreen.dart';
import 'Screens/register_screen.dart';
import 'Screens/splash.dart';
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

  runApp(
    const MyApp(),
  );
}



class MyApp extends StatelessWidget {

  const MyApp({
    super.key,
  });


  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,


      // =========================
      // منع تمدد الشاشة
      // عند السحب لأعلى أو لأسفل
      // =========================

      scrollBehavior:
      const MaterialScrollBehavior().copyWith(
        overscroll: false,
      ),


      locale: const Locale('ar'),


      theme: ThemeData(

        fontFamily: "Cairo",

        scaffoldBackgroundColor:
        const Color(0xffF7F2FF),


        textTheme: const TextTheme(

          bodyLarge: TextStyle(
            fontFamily: "Cairo",
          ),

          bodyMedium: TextStyle(
            fontFamily: "Cairo",
          ),

        ),

      ),



      // =========================
      // اتجاه التطبيق RTL
      // =========================

      builder: (context, child) {

        return Directionality(

          textDirection:
          TextDirection.rtl,

          child: child!,

        );

      },


      // =========================
      // أول شاشة تفتح
      // =========================

      initialRoute: '/',


      // =========================
      // Routes
      // =========================

      routes: {

        '/': (context) =>
        const SplashScreen(),


        '/onboarding': (context) =>
        const OnboardingScreen(),


        '/login': (context) =>
        const LoginScreen(),


        '/register': (context) =>
        const RegisterScreen(),


        '/home': (context) =>
        const Homescreen(),

      },

    );

  }

}