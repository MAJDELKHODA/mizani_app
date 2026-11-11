import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Widgets/page_header.dart';


class ProfileScreen extends StatefulWidget {

  const ProfileScreen({
    super.key,
  });


  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}



class _ProfileScreenState
    extends State<ProfileScreen> {


  // =========================
  // User Data
  // =========================

  String userName = "";

  String userEmail = "";

  bool isLoadingUser = true;

  bool darkMode = false;



  // =========================
  // Init
  // =========================

  @override
  void initState() {

    super.initState();

    getUserData();

  }



  // =========================
  // Get User Data
  // =========================

  Future<void> getUserData() async {

    try {

      User? user =
          FirebaseAuth.instance.currentUser;


      if (user == null) {

        if (!mounted) return;


        setState(() {

          isLoadingUser = false;

        });


        return;
      }


      String uid =
          user.uid;


      final doc =
      await FirebaseFirestore
          .instance
          .collection("users")
          .doc(uid)
          .get();


      String name = "";


      if (doc.exists) {

        final data =
        doc.data();


        name =
            data?["name"] ?? "";

      }


      // الإيميل الأفضل ناخذه من Firebase Auth
      // لأنه هو المسؤول عن تسجيل الدخول

      String email =
          user.email ?? "";


      if (!mounted) return;


      setState(() {

        userName =
        name.isEmpty
            ? "مستخدم"
            : name;


        userEmail =
            email;


        isLoadingUser =
        false;

      });

    }

    catch (e) {

      if (!mounted) return;


      setState(() {

        isLoadingUser =
        false;

      });


      ScaffoldMessenger
          .of(context)
          .showSnackBar(

        const SnackBar(

          content:
          Text(
            "حدث خطأ أثناء تحميل بيانات الحساب",
          ),

        ),

      );

    }

  }



  // =========================
  // Edit Name
  // =========================

  Future<void> showEditNameDialog() async {

    String editedName =
    userName == "مستخدم"
        ? ""
        : userName;


    String? newName =
    await showDialog<String>(

      context: context,

      builder: (dialogContext) {

        return Directionality(

          textDirection:
          TextDirection.rtl,

          child: AlertDialog(

            title: const Text(
              "تعديل الاسم",
            ),

            content: TextFormField(

              initialValue:
              editedName,

              autofocus: true,

              textDirection:
              TextDirection.rtl,

              onChanged: (value) {

                editedName = value;

              },

              decoration: InputDecoration(

                labelText:
                "الاسم",

                hintText:
                "أدخل اسمك",

                prefixIcon:
                const Icon(
                  Icons.person_outline,
                ),

                border:
                OutlineInputBorder(

                  borderRadius:
                  BorderRadius.circular(
                    14,
                  ),

                ),

              ),

            ),

            actions: [

              TextButton(

                onPressed: () {

                  Navigator.pop(
                    dialogContext,
                  );

                },

                child:
                const Text(
                  "إلغاء",
                ),

              ),

              ElevatedButton(

                onPressed: () {

                  String value =
                  editedName.trim();


                  if (value.isEmpty) {

                    ScaffoldMessenger
                        .of(context)
                        .showSnackBar(

                      const SnackBar(

                        content: Text(
                          "يرجى إدخال الاسم",
                        ),

                      ),

                    );

                    return;
                  }


                  Navigator.pop(
                    dialogContext,
                    value,
                  );

                },

                style:
                ElevatedButton.styleFrom(

                  backgroundColor:
                  const Color(
                    0xff6D3CE8,
                  ),

                  foregroundColor:
                  Colors.white,

                ),

                child:
                const Text(
                  "حفظ",
                ),

              ),

            ],

          ),

        );

      },

    );


    if (
    newName == null ||
        newName.trim().isEmpty
    ) {

      return;

    }


    if (
    newName.trim() ==
        userName
    ) {

      return;

    }


    try {

      String uid =
          FirebaseAuth
              .instance
              .currentUser!
              .uid;


      await FirebaseFirestore
          .instance
          .collection("users")
          .doc(uid)
          .set(

        {
          "name":
          newName.trim(),
        },

        SetOptions(
          merge: true,
        ),

      );


      if (!mounted) return;


      setState(() {

        userName =
            newName.trim();

      });


      ScaffoldMessenger
          .of(context)
          .showSnackBar(

        const SnackBar(

          content: Text(
            "تم تعديل الاسم بنجاح",
          ),

        ),

      );

    }

    on FirebaseException catch (e) {

      if (!mounted) return;


      ScaffoldMessenger
          .of(context)
          .showSnackBar(

        SnackBar(

          content: Text(
            "خطأ Firebase: ${e.code}",
          ),

        ),

      );

    }

    catch (e) {

      if (!mounted) return;


      ScaffoldMessenger
          .of(context)
          .showSnackBar(

        SnackBar(

          content: Text(
            "حدث خطأ: $e",
          ),

        ),

      );

    }

  }



  // =========================
  // Change Password
  // =========================

  Future<void> changePassword() async {

    String email =
        FirebaseAuth
            .instance
            .currentUser
            ?.email ??
            userEmail;


    if (email.isEmpty) {

      ScaffoldMessenger
          .of(context)
          .showSnackBar(

        const SnackBar(

          content:
          Text(
            "لا يوجد بريد إلكتروني للحساب",
          ),

        ),

      );


      return;
    }


    bool? confirm =
    await showDialog<bool>(

      context:
      context,


      builder:
          (dialogContext) {


        return Directionality(

          textDirection:
          TextDirection.rtl,


          child:
          AlertDialog(

            title:
            const Text(
              "تغيير كلمة المرور",
            ),


            content:
            Text(

              "سيتم إرسال رابط تغيير كلمة المرور إلى:\n\n$email",

            ),


            actions: [


              TextButton(

                onPressed: () {

                  Navigator.pop(
                    dialogContext,
                    false,
                  );

                },

                child:
                const Text(
                  "إلغاء",
                ),

              ),



              ElevatedButton(

                onPressed: () {

                  Navigator.pop(
                    dialogContext,
                    true,
                  );

                },


                style:
                ElevatedButton.styleFrom(

                  backgroundColor:
                  const Color(
                    0xff6D3CE8,
                  ),

                  foregroundColor:
                  Colors.white,

                ),


                child:
                const Text(
                  "إرسال الرابط",
                ),

              ),

            ],

          ),

        );

      },

    );


    if (confirm != true) {

      return;

    }


    try {

      await FirebaseAuth
          .instance
          .sendPasswordResetEmail(

        email:
        email,

      );


      if (!mounted) return;


      ScaffoldMessenger
          .of(context)
          .showSnackBar(

        const SnackBar(

          content:
          Text(
            "تم إرسال رابط تغيير كلمة المرور إلى بريدك الإلكتروني",
          ),

        ),

      );

    }

    on FirebaseAuthException catch (e) {

      if (!mounted) return;


      String message =
          "تعذر إرسال رابط تغيير كلمة المرور";


      if (
      e.code ==
          "too-many-requests"
      ) {

        message =
        "تم إرسال طلبات كثيرة، حاول مرة أخرى لاحقاً";

      }


      ScaffoldMessenger
          .of(context)
          .showSnackBar(

        SnackBar(

          content:
          Text(
            message,
          ),

        ),

      );

    }

    catch (e) {

      if (!mounted) return;


      ScaffoldMessenger
          .of(context)
          .showSnackBar(

        const SnackBar(

          content:
          Text(
            "حدث خطأ، حاول مرة أخرى",
          ),

        ),

      );

    }

  }



  // =========================
  // Logout
  // =========================

  Future<void> logout() async {

    try {

      await FirebaseAuth
          .instance
          .signOut();


      if (!mounted) return;


      Navigator
          .pushNamedAndRemoveUntil(

        context,

        '/login',

            (route) =>
        false,

      );

    }

    catch (e) {

      if (!mounted) return;


      ScaffoldMessenger
          .of(context)
          .showSnackBar(

        const SnackBar(

          content:
          Text(
            "تعذر تسجيل الخروج",
          ),

        ),

      );

    }

  }



  // =========================
  // Logout Dialog
  // =========================

  void showLogoutDialog() {

    showDialog(

      context:
      context,


      builder:
          (dialogContext) {


        return Directionality(

          textDirection:
          TextDirection.rtl,


          child:
          AlertDialog(

            title:
            const Text(
              "تسجيل الخروج",
            ),


            content:
            const Text(
              "هل أنت متأكد أنك تريد تسجيل الخروج؟",
            ),


            actions: [


              TextButton(

                onPressed: () {

                  Navigator.pop(
                    dialogContext,
                  );

                },

                child:
                const Text(
                  "إلغاء",
                ),

              ),



              TextButton(

                onPressed: () async {

                  Navigator.pop(
                    dialogContext,
                  );


                  await logout();

                },


                child:
                const Text(

                  "تسجيل الخروج",

                  style:
                  TextStyle(

                    color:
                    Colors.red,

                  ),

                ),

              ),

            ],

          ),

        );

      },

    );

  }



  // =========================
  // Coming Soon
  // =========================

  void showComingSoon(
      String feature,
      ) {

    ScaffoldMessenger
        .of(context)
        .showSnackBar(

      SnackBar(

        content:
        Text(
          "$feature ستكون متاحة لاحقاً",
        ),

      ),

    );

  }



  // =========================
  // Build
  // =========================

  @override
  Widget build(
      BuildContext context,
      ) {

    return Directionality(

      textDirection:
      TextDirection.rtl,


      child:
      Scaffold(

        backgroundColor:
        const Color(
          0xffF7F2FF,
        ),


        body:
        SafeArea(

          child:
          SingleChildScrollView(

            padding:
            const EdgeInsets.symmetric(

              horizontal:
              18,

              vertical:
              15,

            ),


            child:
            Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,


              children: [


                // =========================
                // Header
                // =========================

                PageHeader(

                  title:
                  "حسابي",


                  subtitle:
                  "إدارة حسابي وتخصيص تجربتك",


                  onBack: () {

                    Navigator.pop(
                      context,
                    );

                  },

                ),



                const SizedBox(
                  height: 18,
                ),



                // =========================
                // Profile Card
                // =========================

                Container(

                  width:
                  double.infinity,


                  padding:
                  const EdgeInsets.all(
                    15,
                  ),


                  decoration:
                  BoxDecoration(

                    color:
                    const Color(
                      0xffEEE7FF,
                    ),


                    borderRadius:
                    BorderRadius.circular(
                      20,
                    ),

                  ),


                  child:
                  Row(

                    children: [


                      // =========================
                      // User Image
                      // =========================

                      Stack(

                        clipBehavior:
                        Clip.none,


                        children: [


                          Container(

                            width:
                            65,

                            height:
                            65,


                            decoration:
                            const BoxDecoration(

                              color:
                              Color(
                                0xffD8CCFF,
                              ),

                              shape:
                              BoxShape.circle,

                            ),


                            child:
                            const Icon(

                              Icons.person,

                              size:
                              38,

                              color:
                              Color(
                                0xff6D3CE8,
                              ),

                            ),

                          ),



                          Positioned(

                            bottom:
                            -2,

                            left:
                            -2,


                            child:
                            GestureDetector(

                              onTap:
                              showEditNameDialog,


                              child:
                              Container(

                                width:
                                23,

                                height:
                                23,


                                decoration:
                                const BoxDecoration(

                                  color:
                                  Color(
                                    0xff6D3CE8,
                                  ),

                                  shape:
                                  BoxShape.circle,

                                ),


                                child:
                                const Icon(

                                  Icons.edit,

                                  size:
                                  13,

                                  color:
                                  Colors.white,

                                ),

                              ),

                            ),

                          ),

                        ],

                      ),



                      const SizedBox(
                        width: 12,
                      ),



                      // =========================
                      // User Information
                      // =========================

                      Expanded(

                        child:
                        Column(

                          crossAxisAlignment:
                          CrossAxisAlignment.start,


                          children: [


                            Text(

                              isLoadingUser
                                  ? "جاري التحميل..."
                                  : userName,


                              style:
                              const TextStyle(

                                fontSize:
                                16,

                                fontWeight:
                                FontWeight.bold,

                                color:
                                Color(
                                  0xff241653,
                                ),

                              ),

                            ),



                            const SizedBox(
                              height: 5,
                            ),



                            Text(

                              isLoadingUser
                                  ? ""
                                  : userEmail,


                              style:
                              const TextStyle(

                                fontSize:
                                11,

                                color:
                                Color(
                                  0xff81779A,
                                ),

                              ),

                            ),

                          ],

                        ),

                      ),



                      GestureDetector(

                        onTap:
                        showEditNameDialog,


                        child:
                        Container(

                          width:
                          35,

                          height:
                          35,


                          decoration:
                          BoxDecoration(

                            color:
                            Colors.white,

                            borderRadius:
                            BorderRadius.circular(
                              11,
                            ),

                          ),


                          child:
                          const Icon(

                            Icons
                                .arrow_forward_ios,

                            size:
                            15,

                            color:
                            Color(
                              0xff6D3CE8,
                            ),

                          ),

                        ),

                      ),

                    ],

                  ),

                ),



                const SizedBox(
                  height: 14,
                ),



                // =========================
                // Premium Card
                // =========================

                Container(

                  padding:
                  const EdgeInsets.all(
                    15,
                  ),


                  decoration:
                  BoxDecoration(

                    color:
                    Colors.white,

                    borderRadius:
                    BorderRadius.circular(
                      18,
                    ),

                  ),


                  child:
                  Row(

                    children: [


                      Container(

                        width:
                        40,

                        height:
                        40,


                        decoration:
                        BoxDecoration(

                          color:
                          const Color(
                            0xfffff4cc,
                          ),

                          borderRadius:
                          BorderRadius.circular(
                            12,
                          ),

                        ),


                        child:
                        const Icon(

                          Icons
                              .workspace_premium,

                          color:
                          Color(
                            0xffF5A623,
                          ),

                        ),

                      ),



                      const SizedBox(
                        width: 10,
                      ),



                      const Expanded(

                        child:
                        Column(

                          crossAxisAlignment:
                          CrossAxisAlignment.start,


                          children: [


                            Text(

                              "نسخة مجانية",


                              style:
                              TextStyle(

                                fontWeight:
                                FontWeight.bold,

                                color:
                                Color(
                                  0xff241653,
                                ),

                              ),

                            ),



                            Text(

                              "استخدم الميزات الأساسية",


                              style:
                              TextStyle(

                                fontSize:
                                10,

                                color:
                                Colors.grey,

                              ),

                            ),

                          ],

                        ),

                      ),



                      ElevatedButton.icon(

                        onPressed: () {

                          showComingSoon(
                            "ترقية الحساب",
                          );

                        },


                        icon:
                        const Icon(

                          Icons
                              .workspace_premium,

                          size:
                          17,

                          color:
                          Colors.white,

                        ),


                        label:
                        const Text(

                          "ترقية الحساب",


                          style:
                          TextStyle(

                            color:
                            Colors.white,

                            fontSize:
                            11,

                          ),

                        ),


                        style:
                        ElevatedButton.styleFrom(

                          elevation:
                          0,

                          backgroundColor:
                          const Color(
                            0xff6D3CE8,
                          ),


                          shape:
                          RoundedRectangleBorder(

                            borderRadius:
                            BorderRadius.circular(
                              15,
                            ),

                          ),

                        ),

                      ),

                    ],

                  ),

                ),



                const SizedBox(
                  height: 14,
                ),



                // =========================
                // Settings
                // =========================

                Container(

                  decoration:
                  BoxDecoration(

                    color:
                    Colors.white,

                    borderRadius:
                    BorderRadius.circular(
                      20,
                    ),

                  ),


                  child:
                  Column(

                    children: [


                      // =========================
                      // Edit Name
                      // =========================

                      profileItem(

                        icon:
                        Icons.person_outline,


                        iconColor:
                        const Color(
                          0xff6D3CE8,
                        ),


                        title:
                        "البيانات الشخصية",


                        subtitle:
                        "تعديل الاسم الشخصي",


                        onTap:
                        showEditNameDialog,

                      ),



                      divider(),



                      // =========================
                      // Change Password
                      // =========================

                      profileItem(

                        icon:
                        Icons.lock_outline,


                        iconColor:
                        const Color(
                          0xff3B82F6,
                        ),


                        title:
                        "تغيير كلمة المرور",


                        subtitle:
                        "إرسال رابط تغيير كلمة المرور إلى بريدك",


                        onTap:
                        changePassword,

                      ),



                      divider(),



                      profileItem(

                        icon:
                        Icons
                            .notifications_none,


                        iconColor:
                        const Color(
                          0xffF45B69,
                        ),


                        title:
                        "الإشعارات",


                        subtitle:
                        "إدارة التنبيهات والإشعارات",


                        onTap: () {

                          showComingSoon(
                            "الإشعارات",
                          );

                        },

                      ),



                      divider(),



                      profileItem(

                        icon:
                        Icons.language,


                        iconColor:
                        const Color(
                          0xff20B875,
                        ),


                        title:
                        "اللغة",


                        subtitle:
                        "العربية",


                        onTap: () {

                          showComingSoon(
                            "تغيير اللغة",
                          );

                        },

                      ),



                      divider(),



                      profileItem(

                        icon:
                        Icons
                            .monetization_on_outlined,


                        iconColor:
                        const Color(
                          0xffFF9C55,
                        ),


                        title:
                        "العملة",


                        subtitle:
                        "الشيكل الإسرائيلي (₪)",


                        onTap: () {

                          showComingSoon(
                            "تغيير العملة",
                          );

                        },

                      ),

                    ],

                  ),

                ),



                const SizedBox(
                  height: 14,
                ),



                // =========================
                // Dark Mode
                // =========================

                Container(

                  padding:
                  const EdgeInsets.all(
                    14,
                  ),


                  decoration:
                  BoxDecoration(

                    color:
                    Colors.white,

                    borderRadius:
                    BorderRadius.circular(
                      18,
                    ),

                  ),


                  child:
                  Row(

                    children: [


                      Container(

                        width:
                        40,

                        height:
                        40,


                        decoration:
                        BoxDecoration(

                          color:
                          const Color(
                            0xffEEE7FF,
                          ),

                          borderRadius:
                          BorderRadius.circular(
                            12,
                          ),

                        ),


                        child:
                        const Icon(

                          Icons
                              .dark_mode_outlined,

                          color:
                          Color(
                            0xff6D3CE8,
                          ),

                        ),

                      ),



                      const SizedBox(
                        width: 10,
                      ),



                      const Expanded(

                        child:
                        Column(

                          crossAxisAlignment:
                          CrossAxisAlignment.start,


                          children: [


                            Text(

                              "الوضع الليلي",


                              style:
                              TextStyle(

                                fontWeight:
                                FontWeight.bold,

                                color:
                                Color(
                                  0xff241653,
                                ),

                              ),

                            ),



                            Text(

                              "تغيير مظهر التطبيق",


                              style:
                              TextStyle(

                                fontSize:
                                10,

                                color:
                                Colors.grey,

                              ),

                            ),

                          ],

                        ),

                      ),



                      Switch(

                        value:
                        darkMode,


                        activeColor:
                        const Color(
                          0xff6D3CE8,
                        ),


                        onChanged:
                            (value) {

                          setState(() {

                            darkMode =
                                value;

                          });

                        },

                      ),

                    ],

                  ),

                ),



                const SizedBox(
                  height: 14,
                ),



                // =========================
                // Help
                // =========================

                Container(

                  decoration:
                  BoxDecoration(

                    color:
                    Colors.white,

                    borderRadius:
                    BorderRadius.circular(
                      20,
                    ),

                  ),


                  child:
                  Column(

                    children: [


                      profileItem(

                        icon:
                        Icons.help_outline,


                        iconColor:
                        const Color(
                          0xff3B82F6,
                        ),


                        title:
                        "مركز المساعدة",


                        subtitle:
                        "الأسئلة الشائعة وطرق التواصل",


                        onTap: () {

                          showComingSoon(
                            "مركز المساعدة",
                          );

                        },

                      ),



                      divider(),



                      profileItem(

                        icon:
                        Icons.info_outline,


                        iconColor:
                        const Color(
                          0xff6D3CE8,
                        ),


                        title:
                        "عن التطبيق",


                        subtitle:
                        "معلومات الإصدار وسياسة الخصوصية",


                        onTap: () {

                          showComingSoon(
                            "عن التطبيق",
                          );

                        },

                      ),

                    ],

                  ),

                ),



                const SizedBox(
                  height: 15,
                ),



                // =========================
                // Logout
                // =========================

                SizedBox(

                  width:
                  double.infinity,

                  height:
                  55,


                  child:
                  ElevatedButton.icon(

                    onPressed:
                    showLogoutDialog,


                    icon:
                    const Icon(

                      Icons.logout,

                      color:
                      Color(
                        0xffF45B69,
                      ),

                    ),


                    label:
                    const Text(

                      "تسجيل الخروج",


                      style:
                      TextStyle(

                        color:
                        Color(
                          0xffF45B69,
                        ),

                        fontSize:
                        15,

                        fontWeight:
                        FontWeight.bold,

                      ),

                    ),


                    style:
                    ElevatedButton.styleFrom(

                      elevation:
                      0,

                      backgroundColor:
                      const Color(
                        0xffFFF0F2,
                      ),


                      shape:
                      RoundedRectangleBorder(

                        borderRadius:
                        BorderRadius.circular(
                          18,
                        ),

                      ),

                    ),

                  ),

                ),



                const SizedBox(
                  height: 20,
                ),

              ],

            ),

          ),

        ),

      ),

    );

  }



  // =========================
  // Profile Item
  // =========================

  Widget profileItem({

    required IconData icon,

    required Color iconColor,

    required String title,

    required String subtitle,

    required VoidCallback onTap,

  }) {

    return InkWell(

      onTap:
      onTap,


      child:
      Padding(

        padding:
        const EdgeInsets.symmetric(

          horizontal:
          14,

          vertical:
          11,

        ),


        child:
        Row(

          children: [


            Container(

              width:
              40,

              height:
              40,


              decoration:
              BoxDecoration(

                color:
                iconColor.withOpacity(
                  0.10,
                ),


                borderRadius:
                BorderRadius.circular(
                  12,
                ),

              ),


              child:
              Icon(

                icon,

                color:
                iconColor,

                size:
                21,

              ),

            ),



            const SizedBox(
              width: 10,
            ),



            Expanded(

              child:
              Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,


                children: [


                  Text(

                    title,


                    style:
                    const TextStyle(

                      fontWeight:
                      FontWeight.bold,

                      color:
                      Color(
                        0xff241653,
                      ),

                    ),

                  ),



                  const SizedBox(
                    height: 2,
                  ),



                  Text(

                    subtitle,


                    style:
                    const TextStyle(

                      fontSize:
                      9,

                      color:
                      Colors.grey,

                    ),

                  ),

                ],

              ),

            ),



            const Icon(

              Icons
                  .arrow_forward_ios,

              size:
              13,

              color:
              Color(
                0xff6D3CE8,
              ),

            ),

          ],

        ),

      ),

    );

  }



  // =========================
  // Divider
  // =========================

  Widget divider() {

    return Divider(

      height:
      1,

      indent:
      15,

      endIndent:
      15,

      color:
      Colors.grey.shade200,

    );

  }

}