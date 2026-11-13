import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mizani_app/app/core/theme/app_colors.dart';
import 'package:mizani_app/app/core/theme/app_styles.dart';
import 'package:mizani_app/app/core/utils/app_formatters.dart';
import 'package:mizani_app/app/core/utils/transaction_display.dart';
import 'package:mizani_app/app/widgets/page_header.dart';
import 'package:mizani_app/app/widgets/skeleton.dart';
import 'package:mizani_app/app/widgets/transaction_item.dart';
import 'package:mizani_app/app/modules/transactions/controllers/transactions_controller.dart';

class TransactionsView extends GetView<TransactionsController> {
  const TransactionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TransactionsController>(
      builder: (_) => _buildPage(context),
    );
  }

  Widget _buildPage(BuildContext context) {


    final filtered =
        controller.filteredTransactions;


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

              horizontal: 18,

              vertical: 12,

            ),


            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,


              children: [



                // =========================
                // Header
                // =========================

                PageHeader(

                  title:
                  "العمليات",

                  subtitle:
                  "تابع جميع حركاتك المالية",

                  onBack: () {

                    Get.back();

                  },

                ),



                const SizedBox(
                  height: 20,
                ),



                // =========================
                // Summary
                // =========================

                Container(

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


                  child: Row(

                    children: [


                      Expanded(

                        child:
                        _summaryItem(

                          title:
                          "إجمالي الدخل",

                          amount:
                          "${AppFormatters.amount(controller.totalIncome)} ₪",

                          color:
                          AppColors.incomeLight,

                          icon:
                          Icons.arrow_downward,

                        ),

                      ),


                      Container(

                        width: 1,

                        height: 55,

                        color:
                        Colors.white24,

                      ),


                      Expanded(

                        child:
                        _summaryItem(

                          title:
                          "إجمالي المصروف",

                          amount:
                          "${AppFormatters.amount(controller.totalExpense)} ₪",

                          color:
                          AppColors.expenseLight,

                          icon:
                          Icons.arrow_upward,

                        ),

                      ),

                    ],

                  ),

                ),



                const SizedBox(
                  height: 18,
                ),



                // =========================
                // Period
                // =========================

                const Text(

                  "الفترة",

                  style:
                  TextStyle(

                    fontSize: 15,

                    fontWeight:
                    FontWeight.bold,

                  ),

                ),


                const SizedBox(
                  height: 10,
                ),


                Row(

                  children: [

                    _periodButton(
                      "اليوم",
                    ),

                    _periodButton(
                      "الأسبوع",
                    ),

                    _periodButton(
                      "الشهر",
                    ),

                  ],

                ),



                const SizedBox(
                  height: 18,
                ),



                // =========================
                // Type Filter
                // =========================

                Row(

                  mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,


                  children: [

                    Text(

                      "العمليات",

                      style:
                      TextStyle(

                        fontSize: 18,

                        fontWeight:
                        FontWeight.bold,

                        color:
                        AppColors.textDark,

                      ),

                    ),


                    Container(

                      padding:
                      const EdgeInsets
                          .symmetric(

                        horizontal: 10,

                      ),

                      decoration:
                      BoxDecoration(

                        color:
                        AppColors.card,

                        borderRadius:
                        BorderRadius.circular(
                          12,
                        ),
  border: Border.all(color: AppColors.border),
  boxShadow: AppStyles.softShadow,
),


                      child:
                      DropdownButtonHideUnderline(

                        child:
                        DropdownButton<String>(

                          value:
                          controller.selectedType,


                          icon:
                          Icon(

                            Icons
                                .keyboard_arrow_down,

                            color:
                            AppColors.primary,

                          ),


                          items:
                          const [


                            DropdownMenuItem(

                              value:
                              "الكل",

                              child:
                              Text(
                                "الكل",
                              ),

                            ),


                            DropdownMenuItem(

                              value:
                              "المصروفات",

                              child:
                              Text(
                                "المصروفات",
                              ),

                            ),


                            DropdownMenuItem(

                              value:
                              "الدخل",

                              child:
                              Text(
                                "الدخل",
                              ),

                            ),

                          ],


                          onChanged:
                              (value) {

                            if (
                            value != null
                            ) {

                              controller.selectedType =
                                    value;
controller.update();

                            }

                          },

                        ),

                      ),

                    ),

                  ],

                ),



                const SizedBox(
                  height: 12,
                ),



                // =========================
                // Transactions List
                // =========================

                if (controller.isLoading)

                  const TransactionListSkeleton()


                else if (
                filtered.isEmpty
                )

                  _emptyState()


                else

                  ...filtered.map(
                        (transaction) {


                      bool isIncome =
                          transaction.type ==
                              "income";


                      return TransactionItem(

                        title:
                        transaction.title,

                        subtitle:
                        transaction.details,


                        date:
                        AppFormatters.date(
                          transaction.date
                          ,
                        ),


                        amount:
                        AppFormatters.amount(
                          transaction.amount,
                        ),


                        icon:
                        transaction.icon,


                        iconColor:
                        transaction.color,


                        isIncome:
                        isIncome,


                        onTap: () => controller.openDetails(transaction),

                      );

                    },

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

  Widget _summaryItem({

    required String title,

    required String amount,

    required Color color,

    required IconData icon,

  }) {


    return Column(

      children: [

        Row(

          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [

            Icon(

              icon,

              color: color,

              size: 18,

            ),


            const SizedBox(
              width: 5,
            ),


            Text(

              title,

              style:
              const TextStyle(

                color:
                Colors.white70,

                fontSize: 12,

              ),

            ),

          ],

        ),


        const SizedBox(
          height: 7,
        ),


        Text(

          amount,

          style:
          TextStyle(

            color:
            color,

            fontSize: 20,

            fontWeight:
            FontWeight.bold,

          ),

        ),

      ],

    );

  }

  Widget _periodButton(
      String title,
      ) {


    bool selected =
        controller.selectedPeriod ==
            title;


    return Expanded(

      child:
      GestureDetector(

        onTap: () {

          controller.selectedPeriod =
                title;
controller.update();

        },


        child:
        Container(

          margin:
          const EdgeInsets.symmetric(
            horizontal: 4,
          ),

          padding:
          const EdgeInsets.symmetric(
            vertical: 11,
          ),

          decoration:
          BoxDecoration(

            color:
            selected
                ?
            AppColors.primary
                :
            Colors.white,

            borderRadius:
            BorderRadius.circular(
              15,
            ),

          ),


          child:
          Text(

            title,

            textAlign:
            TextAlign.center,

            style:
            TextStyle(

              color:
              selected
                  ?
              Colors.white
                  :
              AppColors.textMuted,

              fontWeight:
              FontWeight.bold,

            ),

          ),

        ),

      ),

    );

  }

  Widget _emptyState() {


    return Container(

      width:
      double.infinity,

      padding:
      const EdgeInsets.symmetric(

        vertical: 45,

        horizontal: 20,

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

      child:
      Column(

        children: [

          Icon(

            Icons
                .receipt_long_outlined,

            size: 55,

            color:
            AppColors.textHint,

          ),


          SizedBox(
            height: 12,
          ),


          Text(

            "لا توجد عمليات",

            style:
            TextStyle(

              fontSize: 17,

              fontWeight:
              FontWeight.bold,

              color:
              AppColors.textDark,

            ),

          ),


          SizedBox(
            height: 5,
          ),


          Text(

            "لا توجد عمليات خلال الفترة المحددة",

            textAlign:
            TextAlign.center,

            style:
            TextStyle(

              color:
              AppColors.textMuted,

              fontSize: 12,

            ),

          ),

        ],

      ),

    );

  }
}
