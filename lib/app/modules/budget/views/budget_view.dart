import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mizani_app/app/core/theme/app_colors.dart';
import 'package:mizani_app/app/core/theme/app_styles.dart';
import 'package:mizani_app/app/core/utils/app_formatters.dart';
import 'package:mizani_app/app/widgets/amount_card.dart';
import 'package:mizani_app/app/widgets/page_header.dart';
import 'package:mizani_app/app/widgets/primary_button.dart';
import 'package:mizani_app/app/widgets/date_selector.dart';
import 'package:mizani_app/app/widgets/skeleton.dart';
import 'package:mizani_app/app/modules/budget/controllers/budget_controller.dart';

class BudgetView extends GetView<BudgetController> {
  const BudgetView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BudgetController>(
      builder: (_) => _buildPage(context),
    );
  }

  Widget _buildPage(BuildContext context) {

    return Directionality(

      textDirection:
      TextDirection.rtl,


      child: Scaffold(

        backgroundColor:
        AppColors.background,


        body: SafeArea(

          child:
          SingleChildScrollView(

            padding:
            const EdgeInsets.symmetric(

              horizontal:
              18,

              vertical:
              12,

            ),


            child: Column(

              children: [


                // =========================================
                // Header
                // =========================================

                PageHeader(

                  title:
                  "تحديد الميزانية",

                  subtitle:
                  "حدد الحد الأقصى لمصروفك بسهولة",

                  onBack: () {

                    Get.back();

                  },

                ),


                const SizedBox(
                  height: 18,
                ),


                // =========================================
                // Current Budget Card
                // =========================================

                _buildCurrentBudgetCard(),


                const SizedBox(
                  height: 15,
                ),


                // =========================================
                // Amount
                // =========================================

                AmountCard(

                  controller:
                  controller.budgetController,

                  quickAmounts:
                  const [

                    100,

                    200,

                    500,

                    1000,

                  ],

                  subtitle:
                  "كم تريد أن تصرف؟",

                  onChanged: () {

                    
controller.update();

                  },

                ),


                const SizedBox(
                  height: 15,
                ),


                // =========================================
                // Budget Type
                // =========================================

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
                      20,
                    ),
  border: Border.all(color: AppColors.border),
  boxShadow: AppStyles.softShadow,
),


                  child: Column(

                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [


                      const Text(

                        "نوع الميزانية",

                        style:
                        TextStyle(

                          fontSize:
                          15,

                          fontWeight:
                          FontWeight.bold,

                        ),

                      ),


                      const SizedBox(
                        height: 5,
                      ),


                      Text(

                        "اختر الفترة المناسبة لك",

                        style:
                        TextStyle(

                          fontSize:
                          12,

                          color:
                          AppColors.textMuted,

                        ),

                      ),


                      const SizedBox(
                        height: 15,
                      ),


                      Row(

                        children:
                        controller.budgetTypes
                            .map(

                              (type) {

                            bool selected =
                                controller.selectedPeriod ==
                                    type.name;


                            return Expanded(

                              child:
                              InkWell(

                                onTap: () {

                                  controller.selectedPeriod =
                                    type.name;
controller.update();

                                },

                                borderRadius:
                                BorderRadius.circular(
                                  15,
                                ),


                                child:
                                Container(

                                  margin:
                                  const EdgeInsets.symmetric(

                                    horizontal:
                                    4,

                                  ),

                                  padding:
                                  const EdgeInsets.symmetric(

                                    vertical:
                                    15,

                                    horizontal:
                                    5,

                                  ),

                                  decoration:
                                  BoxDecoration(

                                    color:
                                    selected

                                        ?

                                    AppColors.primarySoft

                                        :

                                    AppColors.surfaceSoft,


                                    border:
                                    Border.all(

                                      color:
                                      selected

                                          ?

                                      AppColors.primary

                                          :

                                      Colors.transparent,

                                    ),


                                    borderRadius:
                                    BorderRadius.circular(
                                      15,
                                    ),

                                  ),


                                  child:
                                  Column(

                                    children: [


                                      Icon(

                                        type.icon,

                                        color:
                                        selected

                                            ?

                                        AppColors.primary

                                            :

                                        AppColors.textMuted,

                                      ),


                                      const SizedBox(
                                        height: 7,
                                      ),


                                      Text(

                                        type.name,

                                        style:
                                        TextStyle(

                                          fontSize:
                                          13,

                                          fontWeight:
                                          FontWeight.bold,

                                          color:
                                          selected

                                              ?

                                          AppColors.primary

                                              :

                                          AppColors.textDark,

                                        ),

                                      ),


                                      const SizedBox(
                                        height: 4,
                                      ),


                                      Text(

                                        type.desc,

                                        textAlign:
                                        TextAlign.center,

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

                              ),

                            );

                          },

                        ).toList(),

                      ),

                    ],

                  ),

                ),


                const SizedBox(
                  height: 15,
                ),


                // =========================================
                // Budget Alert
                // =========================================

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
                      20,
                    ),
  border: Border.all(color: AppColors.border),
  boxShadow: AppStyles.softShadow,
),


                  child: Column(

                    children: [


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
                              AppColors.primarySoft,

                              borderRadius:
                              BorderRadius.circular(
                                12,
                              ),

                            ),

                            child:
                            Icon(

                              Icons
                                  .notifications_none,

                              color:
                              AppColors.primary,

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

                                  "تنبيه الميزانية",

                                  style:
                                  TextStyle(

                                    fontWeight:
                                    FontWeight.bold,

                                    fontSize:
                                    15,

                                  ),

                                ),


                                Text(

                                  "احصل على تنبيه عند الاقتراب من الحد",

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


                          Switch(

                            value:
                            controller.enableAlert,

                            activeThumbColor:
                            AppColors.primary,

                            onChanged:
                                (value) {

                              controller.enableAlert =
                                    value;
controller.update();

                            },

                          ),

                        ],

                      ),


                      if (controller.enableAlert) ...[


                        const SizedBox(
                          height: 15,
                        ),


                        Row(

                          mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,

                          children: [


                            const Text(

                              "نسبة التنبيه",

                              style:
                              TextStyle(

                                fontWeight:
                                FontWeight.bold,

                              ),

                            ),


                            Text(

                              "${controller.alertPercent.toInt()}%",

                              style:
                              TextStyle(

                                color:
                                AppColors.primary,

                                fontWeight:
                                FontWeight.bold,

                              ),

                            ),

                          ],

                        ),


                        Slider(

                          value:
                          controller.alertPercent,

                          min:
                          50,

                          max:
                          100,

                          divisions:
                          10,

                          activeColor:
                          AppColors.primary,

                          inactiveColor:
                          AppColors.primarySoft,

                          onChanged:
                              (value) {

                            controller.alertPercent =
                                  value;
controller.update();

                          },

                        ),

                      ],

                    ],

                  ),

                ),


                const SizedBox(
                  height: 15,
                ),


                // =========================================
                // Start Date
                // =========================================

                DateSelector(

                  title:
                  "تاريخ البدء",

                  date:
                  controller.startDate,

                  onTap:
                  controller.pickDate,

                ),


                const SizedBox(
                  height: 15,
                ),


                // =========================================
                // Summary
                // =========================================

                Container(

                  width:
                  double.infinity,

                  padding:
                  const EdgeInsets.all(
                    17,
                  ),

                  decoration:
                  BoxDecoration(

                    color:
                    AppColors.primarySoft,

                    borderRadius:
                    BorderRadius.circular(
                      18,
                    ),

                  ),


                  child: Column(

                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [


                      Text(

                        "ملخص الميزانية الجديدة",

                        style:
                        TextStyle(

                          fontWeight:
                          FontWeight.bold,

                          color:
                          AppColors.textDark,

                        ),

                      ),


                      const SizedBox(
                        height: 15,
                      ),


                      Row(

                        mainAxisAlignment:
                        MainAxisAlignment
                            .spaceAround,

                        children: [


                          // =========================================
                          // Amount
                          // =========================================

                          Column(

                            children: [


                              Text(

                                "المبلغ",

                                style:
                                TextStyle(

                                  color:
                                  AppColors.textMuted,

                                  fontSize:
                                  11,

                                ),

                              ),


                              const SizedBox(
                                height: 5,
                              ),


                              Text(

                                "${controller.budgetController.text} ₪",

                                style:
                                TextStyle(

                                  color:
                                  AppColors.textDark,

                                  fontWeight:
                                  FontWeight.bold,

                                  fontSize:
                                  14,

                                ),

                              ),

                            ],

                          ),


                          // =========================================
                          // Period
                          // =========================================

                          Column(

                            children: [


                              Text(

                                "النوع",

                                style:
                                TextStyle(

                                  color:
                                  AppColors.textMuted,

                                  fontSize:
                                  11,

                                ),

                              ),


                              const SizedBox(
                                height: 5,
                              ),


                              Text(

                                controller.selectedPeriod,

                                style:
                                TextStyle(

                                  color:
                                  AppColors.textDark,

                                  fontWeight:
                                  FontWeight.bold,

                                  fontSize:
                                  14,

                                ),

                              ),

                            ],

                          ),


                          // =========================================
                          // Alert
                          // =========================================

                          Column(

                            children: [


                              Text(

                                "التنبيه",

                                style:
                                TextStyle(

                                  color:
                                  AppColors.textMuted,

                                  fontSize:
                                  11,

                                ),

                              ),


                              const SizedBox(
                                height: 5,
                              ),


                              Text(

                                controller.enableAlert

                                    ?

                                "${controller.alertPercent.toInt()}%"

                                    :

                                "مغلق",

                                style:
                                TextStyle(

                                  color:
                                  AppColors.textDark,

                                  fontWeight:
                                  FontWeight.bold,

                                  fontSize:
                                  14,

                                ),

                              ),

                            ],

                          ),

                        ],

                      ),

                    ],

                  ),

                ),


                const SizedBox(
                  height: 18,
                ),


                // =========================================
                // Save
                // =========================================

                PrimaryButton(

                  title:
                  "حفظ الميزانية",

                  onPressed:
                  controller.saveBudget,

                ),


                const SizedBox(
                  height: 10,
                ),

              ],

            ),

          ),

        ),

      ),

    );

  }

  Widget _buildCurrentBudgetCard() {

    return Container(

      width:
      double.infinity,

      padding:
      const EdgeInsets.all(
        20,
      ),

      decoration:
      BoxDecoration(

        gradient:
        LinearGradient(

          colors: [

            AppColors.primaryLight,

            AppColors.primaryDark,

          ],

        ),

        borderRadius:
        BorderRadius.circular(
          22,
        ),

      ),


      // =========================================
      // Loading
      // =========================================

      child:
      controller.isCurrentBudgetLoading

          ?

      const SizedBox(

        height:
        55,

        child:
        OnDarkSkeleton(),

      )


      // =========================================
      // No Budget
      // =========================================

          :

      !controller.hasCurrentBudget

          ?

      const SizedBox(

        height:
        55,

        child:
        Row(

          children: [


            Icon(

              Icons
                  .account_balance_wallet_outlined,

              color:
              Colors.white,

              size:
              28,

            ),


            SizedBox(
              width: 12,
            ),


            Text(

              "لا توجد ميزانية حالية",

              style:
              TextStyle(

                color:
                Colors.white,

                fontSize:
                16,

                fontWeight:
                FontWeight.bold,

              ),

            ),

          ],

        ),

      )


      // =========================================
      // Budget Exists
      // =========================================

          :

      Row(

        children: [


          // =========================================
          // Icon
          // =========================================

          Container(

            width:
            55,

            height:
            55,

            decoration:
            BoxDecoration(

              color:
              Colors.white24,

              borderRadius:
              BorderRadius.circular(
                16,
              ),

            ),

            child:
            const Icon(

              Icons.track_changes,

              color:
              Colors.white,

              size:
              30,

            ),

          ),


          const SizedBox(
            width: 15,
          ),


          // =========================================
          // Budget Data
          // =========================================

          Expanded(

            child:
            Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [


                const Text(

                  "ميزانيتك الحالية",

                  style:
                  TextStyle(

                    color:
                    Colors.white70,

                    fontSize:
                    14,

                  ),

                ),


                const SizedBox(
                  height: 5,
                ),


                Text(

                  "${AppFormatters.amount(controller.currentBudgetAmount)} ₪",

                  style:
                  const TextStyle(

                    color:
                    Colors.white,

                    fontSize:
                    28,

                    fontWeight:
                    FontWeight.bold,

                  ),

                ),


                if (
                controller.currentBudgetPeriod
                    .isNotEmpty
                ) ...[


                  const SizedBox(
                    height: 2,
                  ),


                  Text(

                    "ميزانية ${controller.currentBudgetPeriod}",

                    style:
                    const TextStyle(

                      color:
                      Colors.white70,

                      fontSize:
                      11,

                    ),

                  ),

                ],

              ],

            ),

          ),

        ],

      ),

    );

  }
}
