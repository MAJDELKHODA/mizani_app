import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'homescreen.dart';


class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();

}



class _LoginScreenState extends State<LoginScreen> {


  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  bool hidePassword = true;
  bool rememberMe = false;



  Future<void> login() async {

    String email =
    emailController.text.trim();

    String password =
    passwordController.text.trim();


    if(email.isEmpty || password.isEmpty){

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
              "يرجى تعبئة جميع الحقول"
          ),
        ),

      );

      return;
    }


    try {
      // روح على الفير بيز اثنتكيشن وشوف هل يوجد حساب بهذا الإيميل وكلمة السر
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(

        email: email,
        password: password,

      );


      if (!mounted) return;


      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder: (_) =>
          const Homescreen(),

        ),

      );


    } on FirebaseAuthException catch (e) {

      String message =
          "البريد الإلكتروني أو كلمة المرور غير صحيحة";


      if (e.code == "invalid-email") {

        message =
        "البريد الإلكتروني غير صالح";

      }

      else if (e.code == "user-disabled") {

        message =
        "تم تعطيل هذا الحساب";

      }


      if (!mounted) return;


      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(message),
        ),

      );

    }

    catch (e) {

      if (!mounted) return;


      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
            "حدث خطأ غير متوقع",
          ),
        ),

      );

    }
  }







  @override
  Widget build(BuildContext context) {


    return Scaffold(


      backgroundColor:
      const Color(0xffF7F2FF),



      body: SafeArea(


        child: SingleChildScrollView(


          padding:
          const EdgeInsets.symmetric(
            horizontal:25,
          ),



          child: Column(


            children: [


              const SizedBox(height:50),



              Image.asset(

                "images/mizani_logo.png",

                height:170,

              ),




              const SizedBox(height:25),





              const Text(

                "تسجيل الدخول",

                style: TextStyle(

                  fontSize:34,

                  fontWeight:
                  FontWeight.bold,

                  color:
                  Color(0xff352080),

                ),

              ),




              const SizedBox(height:10),




              const Text(

                "سجّل دخولك لمتابعة أموالك",

                style: TextStyle(

                  fontSize:17,

                  color:
                  Color(0xff7C7195),

                ),

              ),




              const SizedBox(height:40),





              Container(


                padding:
                const EdgeInsets.all(20),


                decoration:
                BoxDecoration(

                  color:
                  Colors.white,

                  borderRadius:
                  BorderRadius.circular(25),

                ),



                child: Column(


                  children: [



                    TextField(


                      controller:
                      emailController,


                      keyboardType:
                      TextInputType.emailAddress,


                      decoration:
                      InputDecoration(


                        hintText:
                        "البريد الإلكتروني",


                        prefixIcon:
                        const Icon(
                          Icons.email_outlined,
                        ),


                        filled:true,


                        fillColor:
                        const Color(0xffF8F6FF),


                        border:
                        OutlineInputBorder(


                          borderRadius:
                          BorderRadius.circular(15),


                          borderSide:
                          BorderSide.none,


                        ),


                      ),


                    ),





                    const SizedBox(height:18),





                    TextField(


                      controller:
                      passwordController,


                      obscureText:
                      hidePassword,


                      decoration:
                      InputDecoration(


                        hintText:
                        "كلمة المرور",


                        prefixIcon:
                        const Icon(
                          Icons.lock_outline,
                        ),



                        suffixIcon:
                        IconButton(


                          icon:
                          Icon(

                            hidePassword
                                ?
                            Icons.visibility_off
                                :
                            Icons.visibility,

                          ),



                          onPressed: (){


                            setState(() {

                              hidePassword =
                              !hidePassword;

                            });


                          },


                        ),



                        filled:true,


                        fillColor:
                        const Color(0xffF8F6FF),


                        border:
                        OutlineInputBorder(


                          borderRadius:
                          BorderRadius.circular(15),


                          borderSide:
                          BorderSide.none,


                        ),


                      ),


                    ),




                    const SizedBox(height:15),




                    Row(


                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,


                      children: [



                        TextButton(


                          onPressed: (){},


                          child:
                          const Text(


                            "نسيت كلمة المرور؟",


                            style:
                            TextStyle(

                              color:
                              Color(0xff6D3CE8),

                            ),


                          ),


                        ),





                        Row(


                          children: [


                            const Text(
                              "تذكرني",
                            ),


                            Switch(


                              value:
                              rememberMe,


                              activeColor:
                              const Color(0xff6D3CE8),


                              onChanged:(value){


                                setState(() {

                                  rememberMe =
                                      value;

                                });


                              },


                            ),


                          ],


                        ),


                      ],


                    ),





                    const SizedBox(height:20),





                    SizedBox(


                      width:
                      double.infinity,


                      height:
                      55,



                      child:
                      ElevatedButton(


                        onPressed:
                        login,



                        style:
                        ElevatedButton.styleFrom(


                          backgroundColor:
                          const Color(0xff6D3CE8),



                          shape:
                          RoundedRectangleBorder(


                            borderRadius:
                            BorderRadius.circular(18),


                          ),


                        ),




                        child:
                        const Text(


                          "دخول",


                          style:
                          TextStyle(


                            color:
                            Colors.white,


                            fontSize:20,


                            fontWeight:
                            FontWeight.bold,


                          ),


                        ),


                      ),


                    ),



                  ],


                ),


              ),





              const SizedBox(height:25),





              Row(


                mainAxisAlignment:
                MainAxisAlignment.center,


                children: [


                  const Text(
                      "ليس لديك حساب؟"
                  ),



                  TextButton(


                    onPressed: (){


                      Navigator.push(


                        context,


                        MaterialPageRoute(


                          builder: (_) =>
                          const RegisterScreen(),


                        ),


                      );


                    },


                    child:
                    const Text(


                      "إنشاء حساب",


                      style:
                      TextStyle(


                        color:
                        Color(0xff6D3CE8),


                        fontWeight:
                        FontWeight.bold,


                      ),


                    ),


                  )


                ],


              )


            ],


          ),


        ),


      ),


    );

  }

}