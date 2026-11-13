import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mizani_app/app/core/theme/app_colors.dart';
import 'package:mizani_app/app/core/theme/app_styles.dart';
import 'package:mizani_app/app/core/utils/app_formatters.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mizani_app/app/widgets/page_header.dart';
import 'package:mizani_app/app/widgets/skeleton.dart';
import 'package:mizani_app/app/modules/reports/controllers/reports_controller.dart';

class ReportsView extends GetView<ReportsController> {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportsController>(
      builder: (_) => _buildPage(context),
    );
  }

  Widget _buildPage(BuildContext context) {


    final categories =
        controller.sortedCategories;



    final Color budgetColor =

    controller.budgetAmount > 0

        &&

        controller.budgetSpent >
            controller.budgetAmount

        ?

    AppColors.expense

        :

    AppColors.primary;



    return Directionality(


      textDirection:
      TextDirection.rtl,



      child: Scaffold(


        backgroundColor:
        AppColors.background,



        body:
        SafeArea(


          child:
          SingleChildScrollView(


            padding:
            const EdgeInsets
                .fromLTRB(

              18,

              15,

              18,

              25,

            ),



            child:
            Column(


              crossAxisAlignment:
              CrossAxisAlignment.start,



              children: [



                // =========================================
                // Header
                // =========================================

                PageHeader(


                  title:
                  "التقارير",


                  subtitle:
                  "حلّل مصروفاتك ودخلك بسهولة",


                  onBack: () {


                    Get.back();


                  },


                ),



                const SizedBox(
                  height: 20,
                ),



                // =========================================
                // Loading
                // =========================================

                if (controller.isLoading)

                  const ReportsSkeleton()


                // =========================================
                // Error
                // =========================================

                else if (
                controller.errorMessage.isNotEmpty
                )

                  Container(

                    width:
                    double.infinity,

                    padding:
                    const EdgeInsets.all(
                      20,
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
                              .error_outline,

                          color:
                          AppColors.expense,

                          size:
                          35,

                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        Text(
                          controller.errorMessage,
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        TextButton(

                          onPressed: controller.loadReportsData,

                          child:
                          const Text(
                            "إعادة المحاولة",
                          ),

                        ),

                      ],

                    ),

                  )


                else ...[



                    // =========================================
                    // Month Selector
                    // =========================================

                    Container(


                      padding:
                      const EdgeInsets
                          .symmetric(

                        horizontal:
                        12,

                        vertical:
                        9,

                      ),



                      decoration:
                      BoxDecoration(


                        color:
                        AppColors.card,


                        borderRadius:
                        BorderRadius.circular(
                          17,
                        ),
  border: Border.all(color: AppColors.border),
  boxShadow: AppStyles.softShadow,
),



                      child:
                      Row(


                        children: [



                          // =========================
                          // الشهر السابق
                          // =========================

                          IconButton(


                            onPressed:
                            controller.previousMonth,


                            icon:
                            Icon(


                              Icons
                                  .arrow_back_ios,


                              size:
                              16,


                              color:
                              AppColors.primary,


                            ),


                          ),



                          const Spacer(),



                          Icon(


                            Icons
                                .calendar_month,


                            size:
                            18,


                            color:
                            AppColors.primary,


                          ),



                          const SizedBox(
                            width: 7,
                          ),



                          Text(


                            "${controller.getMonthName(controller.selectedMonthDate.month)} ${controller.selectedMonthDate.year}",


                            style:
                            TextStyle(


                              fontWeight:
                              FontWeight.bold,


                              color:
                              AppColors.textDark,


                            ),


                          ),



                          const Spacer(),



                          // =========================
                          // الشهر التالي
                          // =========================

                          IconButton(


                            onPressed:
                            controller.nextMonth,


                            icon:
                            Icon(


                              Icons
                                  .arrow_forward_ios,


                              size:
                              16,


                              color:
                              AppColors.primary,


                            ),


                          ),


                        ],


                      ),


                    ),



                    const SizedBox(
                      height: 15,
                    ),



                    // =========================================
                    // Financial Summary
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



                      child:
                      Row(


                        children: [



                          Expanded(


                            child:
                            _summaryItem(


                              title:
                              "إجمالي الدخل",


                              amount:
                              "${AppFormatters.amount(controller.totalIncome)} ₪",


                              icon:
                              Icons
                                  .arrow_downward,


                              color:
                              AppColors.income,


                            ),


                          ),



                          _verticalDivider(),



                          Expanded(


                            child:
                            _summaryItem(


                              title:
                              "إجمالي المصروف",


                              amount:
                              "${AppFormatters.amount(controller.totalExpense)} ₪",


                              icon:
                              Icons
                                  .arrow_upward,


                              color:
                              AppColors.expense,


                            ),


                          ),



                          _verticalDivider(),



                          Expanded(


                            child:
                            _summaryItem(


                              title:
                              "صافي التوفير",


                              amount:
                              "${AppFormatters.amount(controller.netSaving)} ₪",


                              icon:
                              Icons
                                  .account_balance_wallet_outlined,


                              color:
                              AppColors.primary,


                            ),


                          ),


                        ],


                      ),


                    ),



                    const SizedBox(
                      height: 15,
                    ),



                    // =========================================
                    // Expenses Distribution
                    // =========================================

                    Container(


                      padding:
                      const EdgeInsets.all(
                        17,
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


                        crossAxisAlignment:
                        CrossAxisAlignment.start,


                        children: [



                          Row(


                            children: [


                              Icon(


                                Icons
                                    .pie_chart_outline,


                                color:
                                AppColors.primary,


                                size:
                                20,


                              ),



                              SizedBox(
                                width: 7,
                              ),



                              Text(


                                "توزيع المصروفات",


                                style:
                                TextStyle(


                                  fontWeight:
                                  FontWeight.bold,


                                  fontSize:
                                  16,


                                  color:
                                  AppColors.textDark,


                                ),


                              ),


                            ],


                          ),



                          const SizedBox(
                            height: 18,
                          ),



                          Row(


                            crossAxisAlignment:
                            CrossAxisAlignment.center,


                            children: [



                              // =========================
                              // Legend
                              // =========================

                              Expanded(


                                child:
                                categories.isEmpty

                                    ?

                                Text(


                                  "لا توجد مصروفات في هذا الشهر",


                                  style:
                                  TextStyle(


                                    fontSize:
                                    11,


                                    color:
                                    AppColors.textMuted,


                                  ),


                                )

                                    :

                                Column(


                                  children:
                                  categories.map(
                                        (entry) {


                                      double percent =

                                      controller.totalExpense > 0

                                          ?

                                      (
                                          entry.value

                                              /

                                              controller.totalExpense
                                      )

                                          *

                                          100

                                          :

                                      0;



                                      return _legendItem(


                                        entry.key,


                                        "${percent.toStringAsFixed(0)}%",


                                        controller.getCategoryColor(
                                          entry.key,
                                        ),


                                      );


                                    },
                                  ).toList(),


                                ),


                              ),



                              const SizedBox(
                                width: 12,
                              ),



                              // =========================
                              // Pie Chart
                              // =========================

                              SizedBox(


                                width:
                                150,


                                height:
                                150,



                                child:
                                categories.isEmpty

                                    ?

                                Container(


                                  decoration:
                                  BoxDecoration(


                                    color:
                                    AppColors.surfaceSoft,


                                    shape:
                                    BoxShape.circle,


                                  ),


                                  child:
                                  Center(


                                    child:
                                    Text(


                                      "لا توجد\nمصروفات",


                                      textAlign:
                                      TextAlign.center,


                                      style:
                                      TextStyle(


                                        fontSize:
                                        11,


                                        color:
                                        AppColors.textMuted,


                                      ),


                                    ),


                                  ),


                                )

                                    :

                                Stack(


                                  alignment:
                                  Alignment.center,


                                  children: [



                                    PieChart(


                                      PieChartData(


                                        centerSpaceRadius:
                                        43,


                                        sectionsSpace:
                                        2,


                                        sections:
                                        categories.map(
                                              (entry) {


                                            return PieChartSectionData(


                                              value:
                                              entry.value,


                                              color:
                                              controller.getCategoryColor(
                                                entry.key,
                                              ),


                                              showTitle:
                                              false,


                                              radius:
                                              28,


                                            );


                                          },
                                        ).toList(),


                                      ),


                                    ),



                                    Column(


                                      mainAxisSize:
                                      MainAxisSize.min,


                                      children: [



                                        Text(


                                          "${AppFormatters.amount(controller.totalExpense)} ₪",


                                          style:
                                          TextStyle(


                                            fontWeight:
                                            FontWeight.bold,


                                            fontSize:
                                            16,


                                            color:
                                            AppColors.textDark,


                                          ),


                                        ),



                                        Text(


                                          "إجمالي المصروف",


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


                                  ],


                                ),


                              ),


                            ],


                          ),


                        ],


                      ),


                    ),



                    const SizedBox(
                      height: 15,
                    ),



                    // =========================================
                    // Monthly Comparison
                    // =========================================

                    Container(


                      padding:
                      const EdgeInsets.all(
                        17,
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


                        crossAxisAlignment:
                        CrossAxisAlignment.start,


                        children: [



                          Row(


                            children: [


                              Icon(


                                Icons.bar_chart,


                                color:
                                AppColors.primary,


                              ),



                              SizedBox(
                                width: 7,
                              ),



                              Text(


                                "مقارنة الأشهر",


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


                            ],


                          ),



                          const SizedBox(
                            height: 12,
                          ),



                          Row(


                            children: [


                              _ChartKey(


                                color:
                                AppColors.primary,


                                text:
                                "الدخل",


                              ),



                              SizedBox(
                                width: 12,
                              ),



                              _ChartKey(


                                color:
                                Color(
                                  0xffF06292,
                                ),


                                text:
                                "المصروفات",


                              ),


                            ],


                          ),



                          const SizedBox(
                            height: 15,
                          ),



                          SizedBox(


                            height:
                            210,



                            child:
                            BarChart(


                              BarChartData(


                                maxY:
                                controller.chartMaxY,


                                alignment:
                                BarChartAlignment
                                    .spaceAround,



                                gridData:
                                FlGridData(


                                  show:
                                  true,


                                  horizontalInterval:
                                  controller.chartInterval,


                                  drawVerticalLine:
                                  false,


                                ),



                                borderData:
                                FlBorderData(


                                  show:
                                  false,


                                ),



                                titlesData:
                                FlTitlesData(



                                  topTitles:
                                  const AxisTitles(


                                    sideTitles:
                                    SideTitles(


                                      showTitles:
                                      false,


                                    ),


                                  ),



                                  rightTitles:
                                  const AxisTitles(


                                    sideTitles:
                                    SideTitles(


                                      showTitles:
                                      false,


                                    ),


                                  ),



                                  leftTitles:
                                  AxisTitles(


                                    sideTitles:
                                    SideTitles(


                                      showTitles:
                                      true,


                                      interval:
                                      controller.chartInterval,


                                      reservedSize:
                                      40,



                                      getTitlesWidget:
                                          (value, meta) {


                                        return Text(


                                          controller.formatChartNumber(
                                            value,
                                          ),


                                          style:
                                          TextStyle(


                                            fontSize:
                                            8,


                                            color:
                                            AppColors.textMuted,


                                          ),


                                        );


                                      },


                                    ),


                                  ),



                                  bottomTitles:
                                  AxisTitles(


                                    sideTitles:
                                    SideTitles(


                                      showTitles:
                                      true,



                                      getTitlesWidget:
                                          (value, meta) {


                                        int index =
                                        value.toInt();



                                        if (
                                        index < 0

                                            ||

                                            index >=
                                                controller.comparisonMonths.length
                                        ) {


                                          return const SizedBox();


                                        }



                                        return Padding(


                                          padding:
                                          const EdgeInsets.only(
                                            top: 6,
                                          ),


                                          child:
                                          Text(


                                            controller.comparisonMonths[
                                            index
                                            ]["month"],


                                            style:
                                            TextStyle(


                                              fontSize:
                                              9,


                                              color:
                                              AppColors.textMuted,


                                            ),


                                          ),


                                        );


                                      },


                                    ),


                                  ),


                                ),



                                barGroups:
                                List.generate(


                                  controller.comparisonMonths.length,


                                      (index) {


                                    final month =
                                    controller.comparisonMonths[
                                    index
                                    ];



                                    return _barGroup(


                                      x:
                                      index,


                                      income:
                                      month["income"],


                                      expense:
                                      month["expense"],


                                    );


                                  },


                                ),


                              ),


                            ),


                          ),


                        ],


                      ),


                    ),



                    const SizedBox(
                      height: 15,
                    ),



                    // =========================================
                    // Main Indicators
                    // =========================================

                    Container(


                      padding:
                      const EdgeInsets.all(
                        17,
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


                        crossAxisAlignment:
                        CrossAxisAlignment.start,


                        children: [



                          Row(


                            children: [


                              Icon(


                                Icons.insights,


                                color:
                                AppColors.primary,


                              ),



                              SizedBox(
                                width: 7,
                              ),



                              Text(


                                "أهم المؤشرات",


                                style:
                                TextStyle(


                                  fontWeight:
                                  FontWeight.bold,


                                  fontSize:
                                  16,


                                  color:
                                  AppColors.textDark,


                                ),


                              ),


                            ],


                          ),



                          const SizedBox(
                            height: 15,
                          ),



                          Row(


                            children: [



                              // =========================
                              // أكثر تصنيف
                              // =========================

                              Expanded(


                                child:
                                _indicatorCard(


                                  icon:
                                  controller.topCategory ==
                                      "لا يوجد"

                                      ?

                                  Icons
                                      .category_outlined

                                      :

                                  controller.getCategoryIcon(
                                    controller.topCategory,
                                  ),


                                  title:
                                  "أكثر تصنيف",


                                  value:
                                  controller.topCategory,


                                  color:
                                  controller.topCategory ==
                                      "لا يوجد"

                                      ?

                                  AppColors.primary

                                      :

                                  controller.getCategoryColor(
                                    controller.topCategory,
                                  ),


                                ),


                              ),



                              const SizedBox(
                                width: 8,
                              ),



                              // =========================
                              // أعلى يوم
                              // =========================

                              Expanded(


                                child:
                                _indicatorCard(


                                  icon:
                                  Icons
                                      .calendar_month,


                                  title:
                                  "أعلى يوم إنفاق",


                                  value:
                                  controller.highestExpenseDay,


                                  color:
                                  AppColors.primary,


                                ),


                              ),



                              const SizedBox(
                                width: 8,
                              ),



                              // =========================
                              // مقارنة بالشهر السابق
                              // =========================

                              Expanded(


                                child:
                                _indicatorCard(


                                  icon:
                                  Icons.percent,


                                  title:
                                  "مقارنة بالشهر",


                                  value:
                                  controller.comparisonText,


                                  color:
                                  controller.comparisonColor,


                                ),


                              ),


                            ],


                          ),


                        ],


                      ),


                    ),



                    const SizedBox(
                      height: 15,
                    ),



                    // =========================================
                    // Current Budget
                    // =========================================

                    Container(


                      padding:
                      const EdgeInsets.all(
                        17,
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


                        crossAxisAlignment:
                        CrossAxisAlignment.start,


                        children: [



                          Row(


                            children: [


                              Icon(


                                Icons
                                    .account_balance_wallet_outlined,


                                color:
                                AppColors.primary,


                              ),



                              const SizedBox(
                                width: 7,
                              ),



                              Text(


                                controller.hasBudget

                                    ?

                                "الميزانية الحالية - ${controller.budgetPeriod}"

                                    :

                                "الميزانية الحالية",


                                style:
                                const TextStyle(


                                  fontWeight:
                                  FontWeight.bold,


                                  fontSize:
                                  16,


                                ),


                              ),


                            ],


                          ),



                          const SizedBox(
                            height: 12,
                          ),



                          if (!controller.hasBudget)


                            Text(


                              "لم يتم تحديد ميزانية بعد",


                              style:
                              TextStyle(


                                color:
                                AppColors.textMuted,


                                fontSize:
                                12,


                              ),


                            )


                          else ...[



                            Row(


                              mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,


                              children: [



                                Text(


                                  "${AppFormatters.amount(controller.budgetSpent)} ₪ من ${AppFormatters.amount(controller.budgetAmount)} ₪",


                                  style:
                                  TextStyle(


                                    color:
                                    budgetColor,


                                    fontWeight:
                                    FontWeight.bold,


                                  ),


                                ),



                                Text(


                                  "${(controller.budgetProgress * 100).toInt()}%",


                                  style:
                                  TextStyle(


                                    color:
                                    budgetColor,


                                    fontWeight:
                                    FontWeight.bold,


                                  ),


                                ),


                              ],


                            ),



                            const SizedBox(
                              height: 10,
                            ),



                            ClipRRect(


                              borderRadius:
                              BorderRadius.circular(
                                10,
                              ),



                              child:
                              LinearProgressIndicator(


                                value:
                                controller.budgetProgress,


                                minHeight:
                                10,


                                color:
                                budgetColor,


                                backgroundColor:
                                AppColors.primarySoft,


                              ),


                            ),


                          ],


                        ],


                      ),


                    ),


                  ],


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

    required IconData icon,

    required Color color,

  }) {


    return Column(


      children: [


        Icon(


          icon,


          color:
          color,


          size:
          19,


        ),



        const SizedBox(
          height: 5,
        ),



        Text(


          title,


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



        const SizedBox(
          height: 4,
        ),



        Text(


          amount,


          textAlign:
          TextAlign.center,


          style:
          TextStyle(


            fontSize:
            14,


            color:
            color,


            fontWeight:
            FontWeight.bold,


          ),


        ),


      ],


    );

  }

  Widget _verticalDivider() {


    return Container(


      width:
      1,


      height:
      50,


      color:
      AppColors.primarySoft,


    );

  }

  Widget _legendItem(

      String title,

      String percent,

      Color color,

      ) {


    return Padding(


      padding:
      const EdgeInsets.symmetric(
        vertical: 5,
      ),



      child:
      Row(


        children: [



          Container(


            width:
            9,


            height:
            9,


            decoration:
            BoxDecoration(


              color:
              color,


              shape:
              BoxShape.circle,


            ),


          ),



          const SizedBox(
            width: 7,
          ),



          Expanded(


            child:
            Text(


              title,


              style:
              const TextStyle(


                fontSize:
                11,


              ),


            ),


          ),



          Text(


            percent,


            style:
            TextStyle(


              fontSize:
              11,


              fontWeight:
              FontWeight.bold,


              color:
              AppColors.textDark,


            ),


          ),


        ],


      ),


    );

  }

  BarChartGroupData _barGroup({

    required int x,

    required double income,

    required double expense,

  }) {


    return BarChartGroupData(


      x:
      x,


      barsSpace:
      5,



      barRods: [



        BarChartRodData(


          toY:
          income,


          width:
          18,


          color:
          AppColors.primary,


          borderRadius:
          const BorderRadius.vertical(

            top:
            Radius.circular(
              4,
            ),

          ),


        ),



        BarChartRodData(


          toY:
          expense,


          width:
          18,


          color:
          const Color(
            0xffF06292,
          ),


          borderRadius:
          const BorderRadius.vertical(

            top:
            Radius.circular(
              4,
            ),

          ),


        ),


      ],


    );

  }

  Widget _indicatorCard({

    required IconData icon,

    required String title,

    required String value,

    required Color color,

  }) {


    return Container(


      padding:
      const EdgeInsets.symmetric(

        vertical:
        12,

        horizontal:
        6,

      ),



      decoration:
      BoxDecoration(


        color:
        AppColors.surfaceSoft,


        borderRadius:
        BorderRadius.circular(
          14,
        ),


      ),



      child:
      Column(


        children: [



          Icon(


            icon,


            color:
            color,


            size:
            20,


          ),



          const SizedBox(
            height: 5,
          ),



          Text(


            title,


            textAlign:
            TextAlign.center,


            style:
            TextStyle(


              fontSize:
              8,


              color:
              AppColors.textMuted,


            ),


          ),



          const SizedBox(
            height: 4,
          ),



          Text(


            value,


            textAlign:
            TextAlign.center,


            maxLines:
            2,


            overflow:
            TextOverflow.ellipsis,


            style:
            TextStyle(


              fontSize:
              11,


              color:
              color,


              fontWeight:
              FontWeight.bold,


            ),


          ),


        ],


      ),


    );

  }
}

// =========================================

class _ChartKey
    extends StatelessWidget {


  final Color color;

  final String text;



  const _ChartKey({

    required this.color,

    required this.text,

  });



  @override
  Widget build(
      BuildContext context,
      ) {


    return Row(


      children: [



        Container(


          width:
          8,


          height:
          8,


          decoration:
          BoxDecoration(


            color:
            color,


            shape:
            BoxShape.circle,


          ),


        ),



        const SizedBox(
          width: 5,
        ),



        Text(


          text,


          style:
          TextStyle(


            fontSize:
            10,


            color:
            AppColors.textMuted,


          ),


        ),


      ],


    );

  }

}
