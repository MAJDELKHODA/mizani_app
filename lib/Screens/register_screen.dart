import 'package:flutter/material.dart';
import 'homescreen.dart';
import 'loginscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class RegisterScreen extends StatefulWidget {

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();

}



class _RegisterScreenState extends State<RegisterScreen> {


  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();


  bool hidePassword = true;
  bool hideConfirmPassword = true;


  Future<void> register() async {

    String name =
    nameController.text.trim();

    String email =
    emailController.text.trim();

    String password =
    passwordController.text.trim();

    String confirmPassword =
    confirmPasswordController.text.trim();


    if (
    name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty
    ) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
            "يرجى تعبئة جميع الحقول",
          ),
        ),

      );

      return;
    }


    if (password != confirmPassword) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
            "كلمة المرور غير متطابقة",
          ),
        ),

      );

      return;
    }


    try {
 // الجزء الاساسي لانشاء الحساب خدي الايميل والباسبورد وانشئ مستخدم جديد في الفير بيز
      UserCredential userCredential =
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(

        email: email,
        password: password,

      );

 // بياخد رقم المستخدم الفريد الي انشاو الفير بيز
      String uid =
          userCredential.user!.uid;


      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set({

        "uid": uid,
        "name": name,
        "email": email,
        "createdAt":
        FieldValue.serverTimestamp(),

      });


      if (!mounted) return;


      Navigator.pushReplacement(

        context,

        MaterialPageRoute(
          builder: (_) =>
          const Homescreen(),
        ),

      );

    }

    on FirebaseAuthException catch (e) {

      String message =
          "حدث خطأ أثناء إنشاء الحساب";


      if (e.code == "email-already-in-use") {

        message =
        "البريد الإلكتروني مستخدم مسبقاً";

      }

      else if (e.code == "weak-password") {

        message =
        "كلمة المرور ضعيفة";

      }

      else if (e.code == "invalid-email") {

        message =
        "البريد الإلكتروني غير صالح";

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
          const EdgeInsets.all(25),



          child: Column(


            children: [



              const SizedBox(height:40),




              Image.asset(

                "images/mizani_logo.png",

                height:140,

              ),




              const SizedBox(height:20),





              const Text(

                "إنشاء حساب",

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

                "ابدأ بتنظيم مصروفك اليومي",

                style: TextStyle(

                  color:
                  Color(0xff7C7195),

                  fontSize:17,


                ),

              ),





              const SizedBox(height:35),





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



                    buildField(

                      controller:
                      nameController,

                      hint:
                      "الاسم",

                      icon:
                      Icons.person_outline,

                    ),



                    const SizedBox(height:15),




                    buildField(

                      controller:
                      emailController,

                      hint:
                      "البريد الإلكتروني",

                      icon:
                      Icons.email_outlined,

                    ),




                    const SizedBox(height:15),




                    buildField(

                      controller:
                      passwordController,

                      hint:
                      "كلمة المرور",

                      icon:
                      Icons.lock_outline,

                      password:
                      true,

                    ),





                    const SizedBox(height:15),





                    buildField(

                      controller:
                      confirmPasswordController,

                      hint:
                      "تأكيد كلمة المرور",

                      icon:
                      Icons.lock_outline,

                      password:
                      true,

                    ),




                    const SizedBox(height:25),




                    SizedBox(


                      width:
                      double.infinity,


                      height:
                      55,



                      child:
                      ElevatedButton(


                        onPressed:
                        register,



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

                          "إنشاء الحساب",

                          style:
                          TextStyle(

                            color:
                            Colors.white,

                            fontSize:19,

                            fontWeight:
                            FontWeight.bold,

                          ),

                        ),



                      ),


                    ),



                  ],


                ),


              ),





              const SizedBox(height:20),




              Row(

                mainAxisAlignment:
                MainAxisAlignment.center,


                children: [


                  const Text(
                      "لديك حساب؟"
                  ),



                  TextButton(


                    onPressed: (){


                      Navigator.pushReplacement(

                        context,

                        MaterialPageRoute(

                          builder: (_) =>
                          const LoginScreen(),

                        ),

                      );


                    },


                    child:
                    const Text(


                      "تسجيل الدخول",


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






  Widget buildField({

    required TextEditingController controller,

    required String hint,

    required IconData icon,

    bool password = false,


  }){


    return TextField(


      controller:
      controller,


      obscureText:
      password,


      decoration:
      InputDecoration(


        hintText:
        hint,


        prefixIcon:
        Icon(icon),



        filled:
        true,


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


    );


  }


}