import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Widgets/page_header.dart';


class ReportsScreen extends StatefulWidget {

  const ReportsScreen({
    super.key,
  });


  @override
  State<ReportsScreen> createState() =>
      _ReportsScreenState();
}


class _ReportsScreenState
    extends State<ReportsScreen> {


  // =========================================
  // الشهر المختار
  // =========================================

  DateTime selectedMonthDate =
  DateTime(
    DateTime.now().year,
    DateTime.now().month,
  );



  // =========================================
  // كل العمليات القادمة من Firebase
  // =========================================

  List<Map<String, dynamic>>
  transactions = [];



  // =========================================
  // Financial Summary
  // =========================================

  double totalIncome = 0;

  double totalExpense = 0;

  double netSaving = 0;



  // =========================================
  // Categories
  // مثال:
  //
  // {
  //   "طعام": 500,
  //   "مواصلات": 200,
  // }
  // =========================================

  Map<String, double>
  categoryTotals = {};



  // =========================================
  // Main Indicators
  // =========================================

  String topCategory =
      "لا يوجد";


  String highestExpenseDay =
      "لا يوجد";


  double monthComparison = 0;


  bool hasPreviousMonthExpense =
  false;



  // =========================================
  // آخر 3 أشهر للرسم البياني
  // =========================================

  List<Map<String, dynamic>>
  comparisonMonths = [];



  // =========================================
  // Budget
  // =========================================

  double budgetAmount = 0;

  double budgetSpent = 0;

  double budgetProgress = 0;

  String budgetPeriod = "";

  bool hasBudget = false;



  // =========================================
  // Loading
  // =========================================

  bool isLoading = true;

  String errorMessage = "";


  @override
  void initState() {

    super.initState();

    loadReportsData();

  }



  // =========================================
  // تحميل بيانات التقرير كاملة
  // =========================================

  Future<void> loadReportsData() async {

    try {

      // =========================
      // 1. جيب العمليات
      // =========================

      await getTransactions();


      // =========================
      // 2. جيب الميزانية
      // =========================

      await getBudgetData();


      // =========================
      // 3. احسب التقرير
      // =========================

      calculateReport();


      if (!mounted) return;


      setState(() {

        isLoading = false;

        errorMessage = "";

      });

    }

    catch (e) {

      if (!mounted) return;


      setState(() {

        isLoading = false;

        errorMessage =
        "تعذر تحميل بيانات التقارير";

      });

    }

  }



  // =========================================
  // جلب العمليات من Firebase
  // =========================================

  Future<void> getTransactions() async {

    String uid =
        FirebaseAuth
            .instance
            .currentUser!
            .uid;



    final snapshot =
    await FirebaseFirestore
        .instance
        .collection("users")
        .doc(uid)
        .collection("transactions")
        .get();



    List<Map<String, dynamic>>
    loadedTransactions = [];



    for (var doc in snapshot.docs) {

      final data =
      doc.data();



      // لازم يكون عند العملية
      // مبلغ وتاريخ

      if (
      data["amount"] == null ||
          data["date"] == null
      ) {

        continue;

      }



      loadedTransactions.add({

        "id":
        doc.id,


        "amount":
        (data["amount"] as num)
            .toDouble(),


        "type":
        data["type"] ?? "",


        "category":
        data["category"] ?? "",


        "source":
        data["source"] ?? "",


        "payment":
        data["payment"] ?? "",


        "note":
        data["note"] ?? "",


        "date":
        (data["date"] as Timestamp)
            .toDate(),

      });

    }



    transactions =
        loadedTransactions;

  }



  // =========================================
  // جلب الميزانية الحالية
  // =========================================

  Future<void> getBudgetData() async {

    String uid =
        FirebaseAuth
            .instance
            .currentUser!
            .uid;



    final budgetDoc =
    await FirebaseFirestore
        .instance
        .collection("users")
        .doc(uid)
        .collection("budget")
        .doc("current")
        .get();



    // =========================
    // ما في ميزانية
    // =========================

    if (!budgetDoc.exists) {

      hasBudget = false;

      budgetAmount = 0;

      budgetSpent = 0;

      budgetProgress = 0;

      budgetPeriod = "";

      return;

    }



    final data =
    budgetDoc.data()!;



    // =========================
    // مبلغ الميزانية
    // =========================

    double amount =
        (data["amount"] as num?)
            ?.toDouble() ??
            0;



    // =========================
    // نوع الميزانية
    // يومية / أسبوعية / شهرية
    // =========================

    String period =
        data["period"] ?? "";



    // =========================
    // تاريخ بداية الميزانية
    // =========================

    Timestamp? startTimestamp =
    data["startDate"]
    as Timestamp?;



    // في حال ما في تاريخ
    if (startTimestamp == null) {

      hasBudget = true;

      budgetAmount = amount;

      budgetPeriod = period;

      budgetSpent = 0;

      budgetProgress = 0;

      return;

    }



    DateTime savedStartDate =
    startTimestamp.toDate();



    DateTime startDate =
    DateTime(

      savedStartDate.year,

      savedStartDate.month,

      savedStartDate.day,

    );



    DateTime endDate;



    // =========================
    // ميزانية يومية
    // =========================

    if (period == "يومية") {

      endDate =
          startDate.add(

            const Duration(
              days: 1,
            ),

          );

    }


    // =========================
    // ميزانية أسبوعية
    // =========================

    else if (
    period == "أسبوعية"
    ) {

      endDate =
          startDate.add(

            const Duration(
              days: 7,
            ),

          );

    }


    // =========================
    // ميزانية شهرية
    // =========================

    else {

      endDate =
          DateTime(

            startDate.year,

            startDate.month + 1,

            startDate.day,

          );

    }



    double spent = 0;



    // =========================
    // حساب المصروف ضمن
    // فترة الميزانية
    // =========================

    for (var transaction
    in transactions) {


      if (
      transaction["type"] !=
          "expense"
      ) {

        continue;

      }



      DateTime transactionDate =
      transaction["date"];



      bool insideBudgetPeriod =

          !transactionDate
              .isBefore(
            startDate,
          )

              &&

              transactionDate
                  .isBefore(
                endDate,
              );



      if (insideBudgetPeriod) {

        spent +=
        transaction["amount"];

      }

    }



    double progress = 0;



    if (amount > 0) {

      progress =
          spent / amount;

    }



    // ProgressIndicator
    // يقبل قيمة بين 0 و 1

    progress =
        progress
            .clamp(
          0.0,
          1.0,
        )
            .toDouble();



    hasBudget = true;

    budgetAmount =
        amount;

    budgetPeriod =
        period;

    budgetSpent =
        spent;

    budgetProgress =
        progress;

  }



  // =========================================
  // حساب التقرير للشهر المختار
  // =========================================

  void calculateReport() {


    double income = 0;

    double expense = 0;



    Map<String, double>
    categories = {};



    Map<DateTime, double>
    dailyExpenses = {};



    // =========================================
    // عمليات الشهر المحدد
    // =========================================

    for (var transaction
    in transactions) {


      DateTime date =
      transaction["date"];



      bool sameMonth =

          date.year ==
              selectedMonthDate.year

              &&

              date.month ==
                  selectedMonthDate.month;



      // إذا العملية مش بنفس الشهر
      if (!sameMonth) {

        continue;

      }



      double amount =
      transaction["amount"];



      String type =
      transaction["type"];



      // =========================
      // Income
      // =========================

      if (type == "income") {

        income +=
            amount;

      }



      // =========================
      // Expense
      // =========================

      else if (
      type == "expense"
      ) {

        expense +=
            amount;



        String category =
        transaction["category"];



        if (category.isEmpty) {

          category =
          "أخرى";

        }



        // =========================
        // مجموع كل تصنيف
        // =========================

        categories[category] =

            (categories[category] ?? 0)

                +

                amount;



        // =========================
        // اليوم فقط
        // بدون الساعة
        // =========================

        DateTime day =
        DateTime(

          date.year,

          date.month,

          date.day,

        );



        // =========================
        // مجموع الصرف في هذا اليوم
        // =========================

        dailyExpenses[day] =

            (dailyExpenses[day] ?? 0)

                +

                amount;

      }

    }



    // =========================================
    // Summary
    // =========================================

    totalIncome =
        income;


    totalExpense =
        expense;


    netSaving =
        income - expense;


    categoryTotals =
        categories;



    // =========================================
    // أكثر تصنيف صرف
    // =========================================

    if (
    categories.isNotEmpty
    ) {


      MapEntry<String, double>
      highest =
          categories.entries.first;



      for (var entry
      in categories.entries) {


        if (
        entry.value >
            highest.value
        ) {

          highest =
              entry;

        }

      }



      topCategory =
          highest.key;

    }

    else {

      topCategory =
      "لا يوجد";

    }



    // =========================================
    // أعلى يوم إنفاق
    // =========================================

    if (
    dailyExpenses.isNotEmpty
    ) {


      MapEntry<DateTime, double>
      highestDay =
          dailyExpenses.entries.first;



      for (var entry
      in dailyExpenses.entries) {


        if (
        entry.value >
            highestDay.value
        ) {

          highestDay =
              entry;

        }

      }



      highestExpenseDay =
          formatDayMonth(
            highestDay.key,
          );

    }

    else {

      highestExpenseDay =
      "لا يوجد";

    }



    // =========================================
    // الشهر السابق
    // =========================================

    DateTime previousMonth =
    DateTime(

      selectedMonthDate.year,

      selectedMonthDate.month - 1,

    );



    double previousExpense = 0;



    // =========================================
    // مصروف الشهر السابق
    // =========================================

    for (var transaction
    in transactions) {


      DateTime date =
      transaction["date"];



      if (
      transaction["type"] ==
          "expense"

          &&

          date.year ==
              previousMonth.year

          &&

          date.month ==
              previousMonth.month
      ) {


        previousExpense +=
        transaction["amount"];

      }

    }



    // =========================================
    // مقارنة المصروف
    // =========================================

    if (previousExpense > 0) {


      hasPreviousMonthExpense =
      true;



      monthComparison =

          (
              (expense - previousExpense)

                  /

                  previousExpense
          )

              *

              100;

    }

    else {


      hasPreviousMonthExpense =
      false;


      monthComparison =
      0;

    }



    // =========================================
    // آخر 3 أشهر
    // =========================================

    comparisonMonths = [];



    for (
    int i = 2;
    i >= 0;
    i--
    ) {


      DateTime month =
      DateTime(

        selectedMonthDate.year,

        selectedMonthDate.month - i,

      );



      double monthIncome =
      0;


      double monthExpense =
      0;



      for (var transaction
      in transactions) {


        DateTime date =
        transaction["date"];



        bool sameMonth =

            date.year ==
                month.year

                &&

                date.month ==
                    month.month;



        if (!sameMonth) {

          continue;

        }



        if (
        transaction["type"] ==
            "income"
        ) {

          monthIncome +=
          transaction["amount"];

        }


        else if (
        transaction["type"] ==
            "expense"
        ) {

          monthExpense +=
          transaction["amount"];

        }

      }



      comparisonMonths.add({

        "month":
        getMonthName(
          month.month,
        ),


        "income":
        monthIncome,


        "expense":
        monthExpense,

      });

    }

  }



  // =========================================
  // الشهر السابق
  // =========================================

  void previousMonth() {

    setState(() {

      selectedMonthDate =
          DateTime(

            selectedMonthDate.year,

            selectedMonthDate.month - 1,

          );


      calculateReport();

    });

  }



  // =========================================
  // الشهر التالي
  // =========================================

  void nextMonth() {

    setState(() {

      selectedMonthDate =
          DateTime(

            selectedMonthDate.year,

            selectedMonthDate.month + 1,

          );


      calculateReport();

    });

  }



  // =========================================
  // Categories مرتبة من الأكبر
  // =========================================

  List<MapEntry<String, double>>
  get sortedCategories {


    List<MapEntry<String, double>>
    list =
    categoryTotals
        .entries
        .toList();



    list.sort(

          (a, b) =>
          b.value.compareTo(
            a.value,
          ),

    );


    return list;

  }



  // =========================================
  // أكبر قيمة في Chart
  // =========================================

  double get chartMaxY {


    double highest = 0;



    for (var month
    in comparisonMonths) {


      double income =
      month["income"];


      double expense =
      month["expense"];



      if (income > highest) {

        highest =
            income;

      }


      if (expense > highest) {

        highest =
            expense;

      }

    }



    // إذا ما في بيانات

    if (highest == 0) {

      return 500;

    }



    // أقل Max يكون 500

    if (highest < 500) {

      return 500;

    }



    // نقرب لأعلى 500

    return (

        (highest / 500)
            .ceil()

            *

            500

    )
        .toDouble();

  }



  // =========================================
  // المسافة بين خطوط Chart
  // =========================================

  double get chartInterval {

    return chartMaxY / 4;

  }



  // =========================================
  // نص المقارنة
  // =========================================

  String get comparisonText {


    if (!hasPreviousMonthExpense) {

      return "لا يوجد";

    }



    String value =
    monthComparison
        .toStringAsFixed(0);



    if (monthComparison > 0) {

      return "+$value%";

    }



    return "$value%";

  }



  // =========================================
  // لون المقارنة
  // =========================================

  Color get comparisonColor {


    if (!hasPreviousMonthExpense) {

      return const Color(
        0xff6D3CE8,
      );

    }



    // زاد الصرف = أحمر

    if (monthComparison > 0) {

      return const Color(
        0xffF45B69,
      );

    }



    // قل الصرف = أخضر

    if (monthComparison < 0) {

      return const Color(
        0xff20B875,
      );

    }



    return const Color(
      0xff6D3CE8,
    );

  }



  // =========================================
  // Build
  // =========================================

  @override
  Widget build(
      BuildContext context,
      ) {


    final categories =
        sortedCategories;



    final Color budgetColor =

    budgetAmount > 0

        &&

        budgetSpent >
            budgetAmount

        ?

    const Color(
      0xffF45B69,
    )

        :

    const Color(
      0xff6D3CE8,
    );



    return Directionality(


      textDirection:
      TextDirection.rtl,



      child: Scaffold(


        backgroundColor:
        const Color(
          0xffF7F2FF,
        ),



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


                    Navigator.pop(
                      context,
                    );


                  },


                ),



                const SizedBox(
                  height: 20,
                ),



                // =========================================
                // Loading
                // =========================================

                if (isLoading)

                  const Padding(

                    padding:
                    EdgeInsets.symmetric(
                      vertical: 100,
                    ),

                    child:
                    Center(

                      child:
                      CircularProgressIndicator(

                        color:
                        Color(
                          0xff6D3CE8,
                        ),

                      ),

                    ),

                  )


                // =========================================
                // Error
                // =========================================

                else if (
                errorMessage.isNotEmpty
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
                      Colors.white,

                      borderRadius:
                      BorderRadius.circular(
                        20,
                      ),

                    ),

                    child:
                    Column(

                      children: [

                        const Icon(

                          Icons
                              .error_outline,

                          color:
                          Color(
                            0xffF45B69,
                          ),

                          size:
                          35,

                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        Text(
                          errorMessage,
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        TextButton(

                          onPressed: () {

                            setState(() {

                              isLoading =
                              true;

                              errorMessage =
                              "";

                            });


                            loadReportsData();

                          },

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
                        Colors.white,


                        borderRadius:
                        BorderRadius.circular(
                          17,
                        ),


                      ),



                      child:
                      Row(


                        children: [



                          // =========================
                          // الشهر السابق
                          // =========================

                          IconButton(


                            onPressed:
                            previousMonth,


                            icon:
                            const Icon(


                              Icons
                                  .arrow_back_ios,


                              size:
                              16,


                              color:
                              Color(
                                0xff6D3CE8,
                              ),


                            ),


                          ),



                          const Spacer(),



                          const Icon(


                            Icons
                                .calendar_month,


                            size:
                            18,


                            color:
                            Color(
                              0xff6D3CE8,
                            ),


                          ),



                          const SizedBox(
                            width: 7,
                          ),



                          Text(


                            "${getMonthName(selectedMonthDate.month)} ${selectedMonthDate.year}",


                            style:
                            const TextStyle(


                              fontWeight:
                              FontWeight.bold,


                              color:
                              Color(
                                0xff352080,
                              ),


                            ),


                          ),



                          const Spacer(),



                          // =========================
                          // الشهر التالي
                          // =========================

                          IconButton(


                            onPressed:
                            nextMonth,


                            icon:
                            const Icon(


                              Icons
                                  .arrow_forward_ios,


                              size:
                              16,


                              color:
                              Color(
                                0xff6D3CE8,
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
                        Colors.white,


                        borderRadius:
                        BorderRadius.circular(
                          20,
                        ),


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
                              "${formatAmount(totalIncome)} ₪",


                              icon:
                              Icons
                                  .arrow_downward,


                              color:
                              const Color(
                                0xff20B875,
                              ),


                            ),


                          ),



                          _verticalDivider(),



                          Expanded(


                            child:
                            _summaryItem(


                              title:
                              "إجمالي المصروف",


                              amount:
                              "${formatAmount(totalExpense)} ₪",


                              icon:
                              Icons
                                  .arrow_upward,


                              color:
                              const Color(
                                0xffF45B69,
                              ),


                            ),


                          ),



                          _verticalDivider(),



                          Expanded(


                            child:
                            _summaryItem(


                              title:
                              "صافي التوفير",


                              amount:
                              "${formatAmount(netSaving)} ₪",


                              icon:
                              Icons
                                  .account_balance_wallet_outlined,


                              color:
                              const Color(
                                0xff6D3CE8,
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
                        Colors.white,


                        borderRadius:
                        BorderRadius.circular(
                          20,
                        ),


                      ),



                      child:
                      Column(


                        crossAxisAlignment:
                        CrossAxisAlignment.start,


                        children: [



                          const Row(


                            children: [


                              Icon(


                                Icons
                                    .pie_chart_outline,


                                color:
                                Color(
                                  0xff6D3CE8,
                                ),


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
                                  Color(
                                    0xff241653,
                                  ),


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

                                const Text(


                                  "لا توجد مصروفات في هذا الشهر",


                                  style:
                                  TextStyle(


                                    fontSize:
                                    11,


                                    color:
                                    Colors.grey,


                                  ),


                                )

                                    :

                                Column(


                                  children:
                                  categories.map(
                                        (entry) {


                                      double percent =

                                      totalExpense > 0

                                          ?

                                      (
                                          entry.value

                                              /

                                              totalExpense
                                      )

                                          *

                                          100

                                          :

                                      0;



                                      return _legendItem(


                                        entry.key,


                                        "${percent.toStringAsFixed(0)}%",


                                        getCategoryColor(
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
                                  const BoxDecoration(


                                    color:
                                    Color(
                                      0xffF5F2FD,
                                    ),


                                    shape:
                                    BoxShape.circle,


                                  ),


                                  child:
                                  const Center(


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
                                        Colors.grey,


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
                                              getCategoryColor(
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


                                          "${formatAmount(totalExpense)} ₪",


                                          style:
                                          const TextStyle(


                                            fontWeight:
                                            FontWeight.bold,


                                            fontSize:
                                            16,


                                            color:
                                            Color(
                                              0xff241653,
                                            ),


                                          ),


                                        ),



                                        const Text(


                                          "إجمالي المصروف",


                                          style:
                                          TextStyle(


                                            fontSize:
                                            9,


                                            color:
                                            Colors.grey,


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
                        Colors.white,


                        borderRadius:
                        BorderRadius.circular(
                          20,
                        ),


                      ),



                      child:
                      Column(


                        crossAxisAlignment:
                        CrossAxisAlignment.start,


                        children: [



                          const Row(


                            children: [


                              Icon(


                                Icons.bar_chart,


                                color:
                                Color(
                                  0xff6D3CE8,
                                ),


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
                                  Color(
                                    0xff241653,
                                  ),


                                ),


                              ),


                            ],


                          ),



                          const SizedBox(
                            height: 12,
                          ),



                          const Row(


                            children: [


                              _ChartKey(


                                color:
                                Color(
                                  0xff6D3CE8,
                                ),


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
                                chartMaxY,


                                alignment:
                                BarChartAlignment
                                    .spaceAround,



                                gridData:
                                FlGridData(


                                  show:
                                  true,


                                  horizontalInterval:
                                  chartInterval,


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
                                      chartInterval,


                                      reservedSize:
                                      40,



                                      getTitlesWidget:
                                          (value, meta) {


                                        return Text(


                                          formatChartNumber(
                                            value,
                                          ),


                                          style:
                                          const TextStyle(


                                            fontSize:
                                            8,


                                            color:
                                            Colors.grey,


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
                                                comparisonMonths.length
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


                                            comparisonMonths[
                                            index
                                            ]["month"],


                                            style:
                                            const TextStyle(


                                              fontSize:
                                              9,


                                              color:
                                              Color(
                                                0xff81779A,
                                              ),


                                            ),


                                          ),


                                        );


                                      },


                                    ),


                                  ),


                                ),



                                barGroups:
                                List.generate(


                                  comparisonMonths.length,


                                      (index) {


                                    final month =
                                    comparisonMonths[
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
                        Colors.white,


                        borderRadius:
                        BorderRadius.circular(
                          20,
                        ),


                      ),



                      child:
                      Column(


                        crossAxisAlignment:
                        CrossAxisAlignment.start,


                        children: [



                          const Row(


                            children: [


                              Icon(


                                Icons.insights,


                                color:
                                Color(
                                  0xff6D3CE8,
                                ),


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
                                  Color(
                                    0xff241653,
                                  ),


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
                                  topCategory ==
                                      "لا يوجد"

                                      ?

                                  Icons
                                      .category_outlined

                                      :

                                  getCategoryIcon(
                                    topCategory,
                                  ),


                                  title:
                                  "أكثر تصنيف",


                                  value:
                                  topCategory,


                                  color:
                                  topCategory ==
                                      "لا يوجد"

                                      ?

                                  const Color(
                                    0xff6D3CE8,
                                  )

                                      :

                                  getCategoryColor(
                                    topCategory,
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
                                  highestExpenseDay,


                                  color:
                                  const Color(
                                    0xff6D3CE8,
                                  ),


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
                                  comparisonText,


                                  color:
                                  comparisonColor,


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
                        Colors.white,


                        borderRadius:
                        BorderRadius.circular(
                          20,
                        ),


                      ),



                      child:
                      Column(


                        crossAxisAlignment:
                        CrossAxisAlignment.start,


                        children: [



                          Row(


                            children: [


                              const Icon(


                                Icons
                                    .account_balance_wallet_outlined,


                                color:
                                Color(
                                  0xff6D3CE8,
                                ),


                              ),



                              const SizedBox(
                                width: 7,
                              ),



                              Text(


                                hasBudget

                                    ?

                                "الميزانية الحالية - $budgetPeriod"

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



                          if (!hasBudget)


                            const Text(


                              "لم يتم تحديد ميزانية بعد",


                              style:
                              TextStyle(


                                color:
                                Colors.grey,


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


                                  "${formatAmount(budgetSpent)} ₪ من ${formatAmount(budgetAmount)} ₪",


                                  style:
                                  TextStyle(


                                    color:
                                    budgetColor,


                                    fontWeight:
                                    FontWeight.bold,


                                  ),


                                ),



                                Text(


                                  "${(budgetProgress * 100).toInt()}%",


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
                                budgetProgress,


                                minHeight:
                                10,


                                color:
                                budgetColor,


                                backgroundColor:
                                const Color(
                                  0xffEDE7FF,
                                ),


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



  // =========================================
  // Summary Item
  // =========================================

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
          const TextStyle(


            fontSize:
            9,


            color:
            Colors.grey,


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



  // =========================================
  // Vertical Divider
  // =========================================

  Widget _verticalDivider() {


    return Container(


      width:
      1,


      height:
      50,


      color:
      const Color(
        0xffEEE8FA,
      ),


    );

  }



  // =========================================
  // Legend Item
  // =========================================

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
            const TextStyle(


              fontSize:
              11,


              fontWeight:
              FontWeight.bold,


              color:
              Color(
                0xff352080,
              ),


            ),


          ),


        ],


      ),


    );

  }



  // =========================================
  // Bar Group
  // =========================================

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
          const Color(
            0xff6D3CE8,
          ),


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



  // =========================================
  // Indicator Card
  // =========================================

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
        const Color(
          0xffFAF8FF,
        ),


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
            const TextStyle(


              fontSize:
              8,


              color:
              Colors.grey,


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



  // =========================================
  // Category Color
  // نفس ألوان AddExpenseScreen
  // =========================================

  Color getCategoryColor(
      String category,
      ) {


    switch (category) {


      case "طعام":

        return const Color(
          0xffFF9C55,
        );


      case "مواصلات":

        return const Color(
          0xff3B82F6,
        );


      case "تسوق":

        return const Color(
          0xff7047EB,
        );


      case "منزل":

        return const Color(
          0xffFF9B50,
        );


      case "ملابس":

        return const Color(
          0xff3498DB,
        );


      case "صحة":

        return const Color(
          0xffF45B69,
        );


      case "تجميل":

        return const Color(
          0xffE85C9C,
        );


      case "فواتير":

        return const Color(
          0xff4ABAD5,
        );


      case "تعليم":

        return const Color(
          0xff453089,
        );


      case "ترفيه":

        return const Color(
          0xff4B3B8F,
        );


      case "هدايا":

        return const Color(
          0xffFF6680,
        );


      default:

        return const Color(
          0xff55508C,
        );

    }

  }



  // =========================================
  // Category Icon
  // =========================================

  IconData getCategoryIcon(
      String category,
      ) {


    switch (category) {


      case "طعام":

        return Icons.restaurant;


      case "مواصلات":

        return Icons.directions_car;


      case "تسوق":

        return Icons.shopping_cart;


      case "منزل":

        return Icons.home;


      case "ملابس":

        return Icons.checkroom;


      case "صحة":

        return Icons.favorite;


      case "تجميل":

        return Icons.spa;


      case "فواتير":

        return Icons.receipt_long;


      case "تعليم":

        return Icons.school;


      case "ترفيه":

        return Icons.sports_esports;


      case "هدايا":

        return Icons.card_giftcard;


      default:

        return Icons.more_horiz;

    }

  }



  // =========================================
  // Month Name
  // =========================================

  String getMonthName(
      int month,
      ) {


    const months = [


      "يناير",

      "فبراير",

      "مارس",

      "أبريل",

      "مايو",

      "يونيو",

      "يوليو",

      "أغسطس",

      "سبتمبر",

      "أكتوبر",

      "نوفمبر",

      "ديسمبر",


    ];



    return months[
    month - 1
    ];

  }



  // =========================================
  // 25 سبتمبر
  // =========================================

  String formatDayMonth(
      DateTime date,
      ) {


    return
      "${date.day} "
          "${getMonthName(date.month)}";

  }



  // =========================================
  // تنسيق المبلغ
  // =========================================

  String formatAmount(
      double value,
      ) {


    if (
    value % 1 == 0
    ) {


      return value
          .toInt()
          .toString();


    }



    return value
        .toStringAsFixed(
      2,
    );

  }



  // =========================================
  // تنسيق أرقام الرسم
  // =========================================

  String formatChartNumber(
      double value,
      ) {


    if (value >= 1000) {


      double thousands =
          value / 1000;



      if (
      thousands % 1 == 0
      ) {


        return
          "${thousands.toInt()}k";


      }



      return
        "${thousands.toStringAsFixed(1)}k";

    }



    return value
        .toInt()
        .toString();

  }

}



// =========================================
// Chart Key
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
          const TextStyle(


            fontSize:
            10,


            color:
            Colors.grey,


          ),


        ),


      ],


    );

  }

}