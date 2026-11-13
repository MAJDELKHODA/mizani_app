import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mizani_app/app/core/theme/app_colors.dart';
import 'package:mizani_app/app/core/theme/app_styles.dart';
import 'package:mizani_app/app/core/utils/app_formatters.dart';
import 'package:mizani_app/app/widgets/amount_card.dart';
import 'package:mizani_app/app/widgets/date_selector.dart';
import 'package:mizani_app/app/widgets/note_field.dart';
import 'package:mizani_app/app/widgets/page_header.dart';
import 'package:mizani_app/app/widgets/primary_button.dart';
import 'package:mizani_app/app/widgets/selection_grid.dart';
import 'package:mizani_app/app/widgets/skeleton.dart';
import 'package:mizani_app/app/modules/add_expense/controllers/add_expense_controller.dart';

class AddExpenseView extends GetView<AddExpenseController> {
  const AddExpenseView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddExpenseController>(
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
              12,

            ),



            child:
            Column(


              children: [



                // =========================================
                // Header Widget
                // =========================================

                PageHeader(


                  title:
                  "إضافة مصروف",


                  subtitle:
                  "سجّل تفاصيل مصروفك بكل سهولة",


                  onBack: () {


                    Get.back();


                  },


                ),



                const SizedBox(
                  height: 18,
                ),



                // =========================================
                // Budget Card
                // =========================================

                _buildBudgetCard(),



                const SizedBox(
                  height: 15,
                ),



                // =========================================
                // Amount
                // =========================================

                AmountCard(


                  controller:
                  controller.amountController,


                  quickAmounts:
                  const [

                    10,

                    20,

                    50,

                    100,

                    200,

                  ],


                  onChanged: () {


                    
controller.update();


                  },


                ),



                const SizedBox(
                  height: 15,
                ),



                // =========================================
                // Categories
                // =========================================

                SelectionGrid(


                  title:
                  "تصنيف المصروف",


                  items:
                  controller.categories,


                  selectedValue:
                  controller.selectedCategory,


                  onSelected:
                      (value) {


                    controller.selectedCategory =
                          value;
controller.update();


                  },


                  crossAxisCount:
                  4,


                ),



                const SizedBox(
                  height: 15,
                ),



                // =========================================
                // Date
                // =========================================

                DateSelector(


                  date:
                  controller.selectedDate,


                  onTap:
                  controller.pickDate,


                ),



                const SizedBox(
                  height: 15,
                ),



                // =========================================
                // Payment Method
                // =========================================

                _buildPaymentMethod(),



                const SizedBox(
                  height: 15,
                ),



                // =========================================
                // Note
                // =========================================

                NoteField(


                  controller:
                  controller.noteController,


                ),



                const SizedBox(
                  height: 18,
                ),



                // =========================================
                // Save Button
                // =========================================

                PrimaryButton(


                  title:
                  "حفظ المصروف",


                  onPressed:
                  controller.saveExpense,


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

  Widget _buildBudgetCard() {


    // =========================================
    // اسم الميزانية حسب الفترة
    // =========================================

    String budgetTitle =
        "ميزانيتك";


    if (
    controller.budgetPeriod ==
        "يومية"
    ) {

      budgetTitle =
      "ميزانيتك اليوم";

    }

    else if (
    controller.budgetPeriod ==
        "أسبوعية"
    ) {

      budgetTitle =
      "ميزانيتك الأسبوعية";

    }

    else if (
    controller.budgetPeriod ==
        "شهرية"
    ) {

      budgetTitle =
      "ميزانيتك الشهرية";

    }



    int progressPercent =
    (controller.budgetProgress * 100)
        .round();



    return Container(


      width:
      double.infinity,



      padding:
      const EdgeInsets.all(
        18,
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
      controller.isBudgetLoading

          ?

      const SizedBox(


        height:
        72,


        child:
        OnDarkSkeleton(),


      )



      // =========================================
      // No Budget
      // =========================================

          :

      !controller.hasBudget

          ?

      const SizedBox(


        height:
        72,


        child:
        Center(


          child:
          Column(


            mainAxisAlignment:
            MainAxisAlignment.center,


            children: [


              Icon(


                Icons
                    .account_balance_wallet_outlined,


                color:
                Colors.white,


                size:
                25,


              ),



              SizedBox(
                height: 5,
              ),



              Text(


                "لم يتم تحديد ميزانية بعد",


                style:
                TextStyle(


                  color:
                  Colors.white,


                  fontWeight:
                  FontWeight.bold,


                ),


              ),


            ],


          ),


        ),


      )



      // =========================================
      // Budget Data
      // =========================================

          :

      Row(


        children: [



          // =========================================
          // Budget Amount
          // =========================================

          Expanded(


            child:
            Column(


              crossAxisAlignment:
              CrossAxisAlignment.start,


              children: [



                Text(


                  budgetTitle,


                  style:
                  const TextStyle(


                    color:
                    Colors.white,


                    fontSize:
                    15,


                  ),


                ),



                const SizedBox(
                  height: 8,
                ),



                Text(


                  "${AppFormatters.amount(controller.budgetAmount)} ₪",


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


              ],


            ),


          ),



          // =========================================
          // Divider
          // =========================================

          Container(


            width:
            1,


            height:
            55,


            color:
            Colors.white24,


          ),



          // =========================================
          // Remaining
          // =========================================

          Expanded(


            child:
            Column(


              children: [



                const Text(


                  "المتبقي",


                  style:
                  TextStyle(


                    color:
                    Colors.white70,


                  ),


                ),



                const SizedBox(
                  height: 7,
                ),



                Text(


                  "${AppFormatters.amount(controller.budgetRemaining)} ₪",


                  style:
                  TextStyle(


                    color:
                    AppColors.incomeLight,


                    fontSize:
                    20,


                    fontWeight:
                    FontWeight.bold,


                  ),


                ),


              ],


            ),


          ),



          // =========================================
          // Progress
          // =========================================

          SizedBox(


            width:
            72,


            height:
            72,



            child:
            Stack(


              alignment:
              Alignment.center,


              children: [



                SizedBox(


                  width:
                  65,


                  height:
                  65,



                  child:
                  CircularProgressIndicator(


                    value:
                    controller.budgetProgress,


                    strokeWidth:
                    6,


                    backgroundColor:
                    Colors.white24,


                    color:
                    Colors.white,


                  ),


                ),



                Column(


                  mainAxisSize:
                  MainAxisSize.min,


                  children: [



                    Text(


                      "$progressPercent%",


                      style:
                      const TextStyle(


                        color:
                        Colors.white,


                        fontWeight:
                        FontWeight.bold,


                      ),


                    ),



                    const Text(


                      "تم الصرف",


                      style:
                      TextStyle(


                        color:
                        Colors.white70,


                        fontSize:
                        8,


                      ),


                    ),


                  ],


                ),


              ],


            ),


          ),

        ],

      ),

    );

  }

  Widget _buildPaymentMethod() {


    return Container(


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
      Column(


        crossAxisAlignment:
        CrossAxisAlignment.start,


        children: [



          Row(


            children: [



              Icon(


                Icons.credit_card,


                size:
                18,


                color:
                AppColors.textDark,


              ),



              SizedBox(
                width: 6,
              ),



              Text(


                "طريقة الدفع",


                style:
                TextStyle(


                  fontWeight:
                  FontWeight.bold,


                ),


              ),


            ],


          ),



          const SizedBox(
            height: 10,
          ),



          Container(


            padding:
            const EdgeInsets.symmetric(
              horizontal: 12,
            ),



            decoration:
            BoxDecoration(


              color:
              AppColors.surfaceSoft,



              borderRadius:
              BorderRadius.circular(
                13,
              ),



              border:
              Border.all(


                color:
                AppColors.primarySoft,


              ),


            ),



            child:
            DropdownButtonHideUnderline(


              child:
              DropdownButton<String>(


                value:
                controller.selectedPayment,



                isExpanded:
                true,



                icon:
                Icon(


                  Icons
                      .keyboard_arrow_down,


                  color:
                  AppColors.primary,


                ),



                items:
                [



                  // =========================================
                  // Cash
                  // =========================================

                  DropdownMenuItem(


                    value:
                    "نقدي",


                    child:
                    Row(


                      children: [


                        Icon(

                          Icons
                              .payments_outlined,

                          size:
                          20,

                          color:
                          AppColors.primary,

                        ),


                        SizedBox(
                          width: 8,
                        ),


                        Text(
                          "نقدي",
                        ),


                      ],


                    ),


                  ),



                  // =========================================
                  // Card
                  // =========================================

                  DropdownMenuItem(


                    value:
                    "بطاقة",


                    child:
                    Row(


                      children: [


                        Icon(

                          Icons.credit_card,

                          size:
                          20,

                          color:
                          AppColors.primary,

                        ),


                        SizedBox(
                          width: 8,
                        ),


                        Text(
                          "بطاقة",
                        ),


                      ],


                    ),


                  ),



                  // =========================================
                  // Wallet
                  // =========================================

                  DropdownMenuItem(


                    value:
                    "محفظة إلكترونية",


                    child:
                    Row(


                      children: [


                        Icon(

                          Icons
                              .account_balance_wallet_outlined,

                          size:
                          20,

                          color:
                          AppColors.primary,

                        ),


                        SizedBox(
                          width: 8,
                        ),


                        Text(
                          "محفظة إلكترونية",
                        ),


                      ],


                    ),


                  ),



                  // =========================================
                  // Other
                  // =========================================

                  DropdownMenuItem(


                    value:
                    "أخرى",


                    child:
                    Row(


                      children: [


                        Icon(

                          Icons.more_horiz,

                          size:
                          20,

                          color:
                          AppColors.primary,

                        ),


                        SizedBox(
                          width: 8,
                        ),


                        Text(
                          "أخرى",
                        ),


                      ],


                    ),


                  ),

                ],



                onChanged:
                    (value) {


                  if (
                  value !=
                      null
                  ) {


                    controller.selectedPayment =
                          value;
controller.update();


                  }


                },


              ),


            ),


          ),

        ],

      ),

    );

  }
}
