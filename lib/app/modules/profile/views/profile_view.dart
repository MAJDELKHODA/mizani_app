import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mizani_app/app/core/theme/app_colors.dart';
import 'package:mizani_app/app/core/theme/app_styles.dart';
import 'package:mizani_app/app/widgets/page_header.dart';
import 'package:mizani_app/app/widgets/skeleton.dart';
import 'package:mizani_app/app/widgets/theme_mode_selector.dart';
import 'package:mizani_app/app/modules/profile/controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (_) => _buildPage(context),
    );
  }

  Widget _buildPage(BuildContext context) {

    return Directionality(

      textDirection:
      TextDirection.rtl,


      child:
      Scaffold(

        backgroundColor:
        AppColors.background,


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

                    Get.back();

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
                    AppColors.primarySoft,


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
                            BoxDecoration(

                              color:
                              AppColors.primaryBorder,

                              shape:
                              BoxShape.circle,

                            ),


                            child:
                            Icon(

                              Icons.person,

                              size:
                              38,

                              color:
                              AppColors.primary,

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
                                BoxDecoration(

                                  color:
                                  AppColors.primary,

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


                            controller.isLoadingUser
? const Shimmer(child: SkeletonBox(width: 140, height: 15, radius: 6))
: Text(

                              controller.userName,


                              style:
                              TextStyle(

                                fontSize:
                                16,

                                fontWeight:
                                FontWeight.bold,

                                color:
                                AppColors.textDark,

                              ),

                            ),



                            const SizedBox(
                              height: 5,
                            ),



                            controller.isLoadingUser
? const Shimmer(child: SkeletonBox(width: 170, height: 10, radius: 6))
: Text(

                              controller.userEmail,


                              style:
                              TextStyle(

                                fontSize:
                                11,

                                color:
                                AppColors.textMuted,

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
                            AppColors.card,

                            borderRadius:
                            BorderRadius.circular(
                              11,
                            ),
  border: Border.all(color: AppColors.border),
  boxShadow: AppStyles.softShadow,
),


                          child:
                          Icon(

                            Icons
                                .arrow_forward_ios,

                            size:
                            15,

                            color:
                            AppColors.primary,

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
                    AppColors.card,

                    borderRadius:
                    BorderRadius.circular(
                      18,
                    ),
  border: Border.all(color: AppColors.border),
  boxShadow: AppStyles.softShadow,
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
                          (AppColors.isDark ? const Color(0xFF3A2F12) : const Color(0xFFFFF4CC)),

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



                      Expanded(

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
                                AppColors.textDark,

                              ),

                            ),



                            Text(

                              "استخدم الميزات الأساسية",


                              style:
                              TextStyle(

                                fontSize:
                                10,

                                color:
                                AppColors.textMuted,

                              ),

                            ),

                          ],

                        ),

                      ),



                      ElevatedButton.icon(

                        onPressed: () {

                          controller.showComingSoon(
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
                          AppColors.primary,


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
                    AppColors.card,

                    borderRadius:
                    BorderRadius.circular(
                      20,
                    ),
  border: Border.all(color: AppColors.border),
  boxShadow: AppStyles.softShadow,
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
                        AppColors.primary,


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
                        AppColors.expense,


                        title:
                        "الإشعارات",


                        subtitle:
                        "إدارة التنبيهات والإشعارات",


                        onTap: () {

                          controller.showComingSoon(
                            "الإشعارات",
                          );

                        },

                      ),



                      divider(),



                      profileItem(

                        icon:
                        Icons.language,


                        iconColor:
                        AppColors.income,


                        title:
                        "اللغة",


                        subtitle:
                        "العربية",


                        onTap: () {

                          controller.showComingSoon(
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

                          controller.showComingSoon(
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

                const ThemeModeSelector(),



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
                    AppColors.card,

                    borderRadius:
                    BorderRadius.circular(
                      20,
                    ),
  border: Border.all(color: AppColors.border),
  boxShadow: AppStyles.softShadow,
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

                          controller.showComingSoon(
                            "مركز المساعدة",
                          );

                        },

                      ),



                      divider(),



                      profileItem(

                        icon:
                        Icons.info_outline,


                        iconColor:
                        AppColors.primary,


                        title:
                        "عن التطبيق",


                        subtitle:
                        "معلومات الإصدار وسياسة الخصوصية",


                        onTap: () {

                          controller.showComingSoon(
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
                    Icon(

                      Icons.logout,

                      color:
                      AppColors.expense,

                    ),


                    label:
                    Text(

                      "تسجيل الخروج",


                      style:
                      TextStyle(

                        color:
                        AppColors.expense,

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
                      AppColors.expenseSoft,


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
                iconColor.withValues(alpha: 0.10),


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
                    TextStyle(

                      fontWeight:
                      FontWeight.bold,

                      color:
                      AppColors.textDark,

                    ),

                  ),



                  const SizedBox(
                    height: 2,
                  ),



                  Text(

                    subtitle,


                    style:
                    TextStyle(

                      fontSize:
                      9,

                      color:
                      AppColors.textMuted,

                    ),

                  ),

                ],

              ),

            ),



            Icon(

              Icons
                  .arrow_forward_ios,

              size:
              13,

              color:
              AppColors.primary,

            ),

          ],

        ),

      ),

    );

  }

  Widget divider() {

    return Divider(

      height:
      1,

      indent:
      15,

      endIndent:
      15,

      color:
      AppColors.border,

    );

  }

  // =========================
  // Dialogs
  // =========================

  void showEditNameDialog() {
    final nameController = TextEditingController(
      text: controller.editableName,
    );

    Get.dialog(
      AlertDialog(
        title: const Text("تعديل الاسم"),
        content: TextField(
          controller: nameController,
          autofocus: true,
          decoration: InputDecoration(
            labelText: "الاسم",
            hintText: "أدخل اسمك",
            prefixIcon: const Icon(Icons.person_outline),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text("إلغاء"),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty) return;
              Get.back();
              controller.updateName(nameController.text);
            },
            child: const Text("حفظ"),
          ),
        ],
      ),
    );
  }

  void changePassword() {
    Get.dialog(
      AlertDialog(
        title: const Text("تغيير كلمة المرور"),
        content: Text(
          "سنرسل رابط تغيير كلمة المرور إلى ${controller.userEmail}",
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text("إلغاء"),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.sendPasswordChangeEmail();
            },
            child: const Text("إرسال"),
          ),
        ],
      ),
    );
  }

  void showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text("تسجيل الخروج"),
        content: const Text("هل أنت متأكد أنك تريد تسجيل الخروج؟"),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text("إلغاء"),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.logout();
            },
            child: Text(
              "تسجيل الخروج",
              style: TextStyle(color: AppColors.expense),
            ),
          ),
        ],
      ),
    );
  }
}
