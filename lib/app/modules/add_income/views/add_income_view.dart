import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mizani_app/app/core/theme/app_colors.dart';
import 'package:mizani_app/app/core/utils/app_formatters.dart';
import 'package:mizani_app/app/widgets/amount_card.dart';
import 'package:mizani_app/app/widgets/date_selector.dart';
import 'package:mizani_app/app/widgets/note_field.dart';
import 'package:mizani_app/app/widgets/page_header.dart';
import 'package:mizani_app/app/widgets/primary_button.dart';
import 'package:mizani_app/app/widgets/selection_grid.dart';
import 'package:mizani_app/app/widgets/skeleton.dart';
import 'package:mizani_app/app/modules/add_income/controllers/add_income_controller.dart';

class AddIncomeView extends GetView<AddIncomeController> {
  const AddIncomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddIncomeController>(
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
                // Header
                // =========================================

                PageHeader(


                  title:
                  "إضافة دخل",


                  subtitle:
                  "سجّل تفاصيل دخلك بكل سهولة",


                  onBack: () {


                    Get.back();


                  },


                ),



                const SizedBox(
                  height: 18,
                ),



                // =========================================
                // Balance Card
                // =========================================

                _buildBalanceCard(),



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

                    200,

                    500,

                    1000,

                    2000,

                  ],


                  onChanged: () {


                    
controller.update();


                  },


                ),



                const SizedBox(
                  height: 15,
                ),



                // =========================================
                // Income Source
                // =========================================

                SelectionGrid(


                  title:
                  "مصدر الدخل",


                  items:
                  controller.incomeSources,


                  selectedValue:
                  controller.selectedSource,


                  onSelected:
                      (value) {


                    controller.selectedSource =
                          value;
controller.update();


                  },


                  crossAxisCount:
                  3,


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
                // Save
                // =========================================

                PrimaryButton(


                  title:
                  "حفظ الدخل",


                  onPressed:
                  controller.saveIncome,


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

  Widget _buildBalanceCard() {


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
      controller.isFinancialLoading

          ?

      const SizedBox(


        height:
        75,


        child:
        OnDarkSkeleton(),


      )



      // =========================================
      // Financial Data
      // =========================================

          :

      Row(


        children: [



          // =========================================
          // Current Balance
          // =========================================

          Expanded(


            child:
            Column(


              crossAxisAlignment:
              CrossAxisAlignment.start,


              children: [



                const Text(


                  "رصيدك الحالي",


                  style:
                  TextStyle(


                    color:
                    Colors.white70,


                    fontSize:
                    13,


                  ),


                ),



                const SizedBox(
                  height: 7,
                ),



                Text(


                  "${AppFormatters.amount(controller.balance)} ₪",


                  style:
                  TextStyle(


                    color:
                    controller.balance >= 0

                        ?

                    Colors.white

                        :

                    AppColors.expenseBorder,


                    fontSize:
                    27,


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


            height:
            60,


            width:
            1,


            color:
            Colors.white24,


          ),



          const SizedBox(
            width: 15,
          ),



          // =========================================
          // Income & Expense
          // =========================================

          Expanded(


            child:
            Column(


              crossAxisAlignment:
              CrossAxisAlignment.start,


              children: [



                // =========================================
                // Total Income
                // =========================================

                const Text(


                  "إجمالي الدخل",


                  style:
                  TextStyle(


                    color:
                    Colors.white70,


                    fontSize:
                    11,


                  ),


                ),



                Text(


                  "${AppFormatters.amount(controller.totalIncome)} ₪",


                  style:
                  TextStyle(


                    color:
                    AppColors.incomeLight,


                    fontSize:
                    17,


                    fontWeight:
                    FontWeight.bold,


                  ),


                ),



                const SizedBox(
                  height: 7,
                ),



                // =========================================
                // Total Expense
                // =========================================

                const Text(


                  "إجمالي المصروف",


                  style:
                  TextStyle(


                    color:
                    Colors.white70,


                    fontSize:
                    11,


                  ),


                ),



                Text(


                  "${AppFormatters.amount(controller.totalExpense)} ₪",


                  style:
                  TextStyle(


                    color:
                    AppColors.expenseLight,


                    fontSize:
                    17,


                    fontWeight:
                    FontWeight.bold,


                  ),


                ),


              ],


            ),


          ),

        ],

      ),

    );

  }
}
