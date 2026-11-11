import 'dart:async';
import 'package:flutter/material.dart';

import 'onboardingscreen.dart';

//import 'onboarding_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});


  @override
  State<SplashScreen> createState() => _SplashScreenState();
}



class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    super.initState();


    Timer(
      const Duration(seconds: 3),
          () {

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const OnboardingScreen(),
          ),
        );

      },
    );

  }




  @override
  Widget build(BuildContext context) {


    return Scaffold(

      body: Container(

        width: double.infinity,

        height: double.infinity,


        decoration: const BoxDecoration(

          gradient: LinearGradient(

            begin: Alignment.topLeft,

            end: Alignment.bottomRight,


            colors: [

              Color(0xffF7F1FF),

              Color(0xffDCCBFF),

              Color(0xffB58CFF),

            ],

          ),

        ),



        child: Column(

          mainAxisAlignment:
          MainAxisAlignment.center,


          children: [



            // Logo Container

            Container(

              width: 160,

              height: 160,


              padding:
              const EdgeInsets.all(20),


              decoration: BoxDecoration(

                color:
                Colors.white.withOpacity(0.35),


                borderRadius:
                BorderRadius.circular(45),


                boxShadow: [

                  BoxShadow(

                    color:
                    Colors.deepPurple.withOpacity(0.15),

                    blurRadius: 30,

                    spreadRadius: 5,

                  ),

                ],

              ),



              child: Image.asset(

                "images/mizani_logo.png",

              ),

            ),




            const SizedBox(height: 35),




            const Text(

              "ميزاني",

              style: TextStyle(

                fontSize: 42,

                fontWeight:
                FontWeight.bold,



                color:
                Color(0xff48258A),

              ),

            ),




            const SizedBox(height: 8),




            const Text(

              "Mizani",

              style: TextStyle(

                fontSize: 20,


                letterSpacing: 6,


                color:
                Color(0xff7554B5),

              ),

            ),




            const SizedBox(height: 25),




            const Text(

              "نظّم مصروفك اليومي بسهولة",

              style: TextStyle(

                fontSize: 17,



                color:
                Color(0xff69558E),

              ),

            ),



          ],

        ),

      ),

    );

  }

}