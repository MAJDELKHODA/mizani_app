import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Widgets/page_header.dart';
import '../Widgets/amount_card.dart';
import '../Widgets/selection_grid.dart';
import '../Widgets/date_selector.dart';
import '../Widgets/note_field.dart';
import '../Widgets/primary_button.dart';


class AddExpenseScreen extends StatefulWidget {

  const AddExpenseScreen({
    super.key,
  });


  @override
  State<AddExpenseScreen> createState() =>
      _AddExpenseScreenState();
}



class _AddExpenseScreenState
    extends State<AddExpenseScreen> {


  // =========================================
  // Controllers
  // =========================================

  final TextEditingController amountController =
  TextEditingController(
    text: "50",
  );


  final TextEditingController noteController =
  TextEditingController();



  // =========================================
  // Expense Data
  // =========================================

  String selectedCategory =
      "طعام";


  String selectedPayment =
      "نقدي";


  DateTime selectedDate =
  DateTime.now();



  // =========================================
  // Budget Data
  // =========================================

  double budgetAmount = 0;

  double budgetSpent = 0;

  double budgetRemaining = 0;

  double budgetProgress = 0;


  String budgetPeriod = "";


  bool hasBudget = false;

  bool isBudgetLoading = true;



  // =========================================
  // Categories
  // =========================================

  final List<SelectionItem> categories =
  const [


    SelectionItem(

      name: "طعام",

      icon:
      Icons.restaurant,

      color:
      Color(
        0xffFF9C55,
      ),

    ),


    SelectionItem(

      name: "مواصلات",

      icon:
      Icons.directions_car,

      color:
      Color(
        0xff3B82F6,
      ),

    ),


    SelectionItem(

      name: "تسوق",

      icon:
      Icons.shopping_cart,

      color:
      Color(
        0xff7047EB,
      ),

    ),


    SelectionItem(

      name: "منزل",

      icon:
      Icons.home,

      color:
      Color(
        0xffFF9B50,
      ),

    ),


    SelectionItem(

      name: "ملابس",

      icon:
      Icons.checkroom,

      color:
      Color(
        0xff3498DB,
      ),

    ),


    SelectionItem(

      name: "صحة",

      icon:
      Icons.favorite,

      color:
      Color(
        0xffF45B69,
      ),

    ),


    SelectionItem(

      name: "تجميل",

      icon:
      Icons.spa,

      color:
      Color(
        0xffE85C9C,
      ),

    ),


    SelectionItem(

      name: "فواتير",

      icon:
      Icons.receipt_long,

      color:
      Color(
        0xff4ABAD5,
      ),

    ),


    SelectionItem(

      name: "تعليم",

      icon:
      Icons.school,

      color:
      Color(
        0xff453089,
      ),

    ),


    SelectionItem(

      name: "ترفيه",

      icon:
      Icons.sports_esports,

      color:
      Color(
        0xff4B3B8F,
      ),

    ),


    SelectionItem(

      name: "هدايا",

      icon:
      Icons.card_giftcard,

      color:
      Color(
        0xffFF6680,
      ),

    ),


    SelectionItem(

      name: "أخرى",

      icon:
      Icons.more_horiz,

      color:
      Color(
        0xff55508C,
      ),

    ),

  ];



  // =========================================
  // Init
  // =========================================

  @override
  void initState() {

    super.initState();


    // أول ما الشاشة تفتح
    // جيب الميزانية من Firebase

    getBudgetData();

  }



  // =========================================
  // Dispose
  // =========================================

  @override
  void dispose() {

    amountController.dispose();

    noteController.dispose();


    super.dispose();

  }



  // =========================================
  // Get Budget Data
  // =========================================

  Future<void> getBudgetData() async {

    try {


      // =========================
      // المستخدم الحالي
      // =========================

      User? user =
          FirebaseAuth
              .instance
              .currentUser;



      if (user == null) {

        if (!mounted) return;


        setState(() {

          hasBudget = false;

          isBudgetLoading = false;

        });


        return;

      }



      String uid =
          user.uid;



      // =========================
      // جيب الميزانية الحالية
      // =========================

      final budgetDoc =
      await FirebaseFirestore
          .instance
          .collection("users")
          .doc(uid)
          .collection("budget")
          .doc("current")
          .get();



      // =========================
      // المستخدم ما حدد ميزانية
      // =========================

      if (!budgetDoc.exists) {

        if (!mounted) return;


        setState(() {

          hasBudget = false;

          budgetAmount = 0;

          budgetSpent = 0;

          budgetRemaining = 0;

          budgetProgress = 0;

          budgetPeriod = "";

          isBudgetLoading = false;

        });


        return;

      }



      final data =
      budgetDoc.data();



      if (data == null) {

        if (!mounted) return;


        setState(() {

          hasBudget = false;

          isBudgetLoading = false;

        });


        return;

      }



      // =========================
      // مبلغ الميزانية
      // =========================

      double amount =
          (data["amount"] as num?)
              ?.toDouble() ??
              0;



      // =========================
      // فترة الميزانية
      // =========================

      String period =
          data["period"] ??
              "";



      // =========================
      // تاريخ بداية الميزانية
      // =========================

      dynamic startValue =
      data["startDate"];



      if (
      amount <= 0 ||
          startValue is! Timestamp
      ) {

        if (!mounted) return;


        setState(() {

          hasBudget = false;

          isBudgetLoading = false;

        });


        return;

      }



      DateTime savedStartDate =
      startValue.toDate();



      // نشيل الساعة والدقائق
      // ونحتفظ باليوم فقط

      DateTime startDate =
      DateTime(

        savedStartDate.year,

        savedStartDate.month,

        savedStartDate.day,

      );



      DateTime endDate;



      // =========================================
      // Daily Budget
      // =========================================

      if (period == "يومية") {

        endDate =
            startDate.add(

              const Duration(
                days: 1,
              ),

            );

      }



      // =========================================
      // Weekly Budget
      // =========================================

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



      // =========================================
      // Monthly Budget
      // =========================================

      else {

        endDate =
            DateTime(

              startDate.year,

              startDate.month + 1,

              startDate.day,

            );

      }



      // =========================================
      // جيب كل العمليات
      // =========================================

      final snapshot =
      await FirebaseFirestore
          .instance
          .collection("users")
          .doc(uid)
          .collection("transactions")
          .get();



      double spent = 0;



      // =========================================
      // احسب المصروف ضمن فترة الميزانية
      // =========================================

      for (var doc in snapshot.docs) {


        final transaction =
        doc.data();



        // بدنا فقط المصروفات

        if (
        transaction["type"] !=
            "expense"
        ) {

          continue;

        }



        // لازم العملية تحتوي تاريخ

        if (
        transaction["date"]
        is! Timestamp
        ) {

          continue;

        }



        // لازم العملية تحتوي مبلغ

        if (
        transaction["amount"]
        is! num
        ) {

          continue;

        }



        DateTime transactionDate =
        (transaction["date"]
        as Timestamp)
            .toDate();



        // =========================================
        // هل العملية داخل فترة الميزانية؟
        // =========================================

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


          double expenseAmount =
          (transaction["amount"]
          as num)
              .toDouble();



          spent +=
              expenseAmount;

        }

      }



      // =========================================
      // Remaining
      // =========================================

      double remaining =
          amount - spent;



      // إذا تجاوز الميزانية
      // نخلي المتبقي صفر

      if (remaining < 0) {

        remaining = 0;

      }



      // =========================================
      // Progress
      // =========================================

      double progress = 0;



      if (amount > 0) {

        progress =
            spent / amount;

      }



      // CircularProgressIndicator
      // يقبل من 0 إلى 1

      progress =
          progress
              .clamp(
            0.0,
            1.0,
          )
              .toDouble();



      // =========================================
      // Update UI
      // =========================================

      if (!mounted) return;


      setState(() {

        hasBudget = true;


        budgetAmount =
            amount;


        budgetSpent =
            spent;


        budgetRemaining =
            remaining;


        budgetProgress =
            progress;


        budgetPeriod =
            period;


        isBudgetLoading =
        false;

      });

    }

    catch (e) {

      if (!mounted) return;


      setState(() {

        isBudgetLoading =
        false;

      });


      ScaffoldMessenger
          .of(context)
          .showSnackBar(

        const SnackBar(

          content:
          Text(
            "تعذر تحميل بيانات الميزانية",
          ),

        ),

      );

    }

  }



  // =========================================
  // Pick Date
  // =========================================

  Future<void> pickDate() async {

    final DateTime? date =
    await showDatePicker(

      context:
      context,


      initialDate:
      selectedDate,


      firstDate:
      DateTime(
        2020,
      ),


      lastDate:
      DateTime(
        2035,
      ),

    );



    if (date != null) {

      setState(() {

        selectedDate =
            date;

      });

    }

  }



  // =========================================
  // Save Expense
  // =========================================

  Future<void> saveExpense() async {


    String amount =
    amountController
        .text
        .trim();



    // =========================
    // Empty
    // =========================

    if (amount.isEmpty) {


      ScaffoldMessenger
          .of(context)
          .showSnackBar(

        const SnackBar(

          content:
          Text(
            "يرجى إدخال مبلغ المصروف",
          ),

        ),

      );


      return;

    }



    // =========================
    // Convert String to Double
    // =========================

    double? value =
    double.tryParse(
      amount,
    );



    // =========================
    // Validation
    // =========================

    if (
    value == null ||
        value <= 0
    ) {


      ScaffoldMessenger
          .of(context)
          .showSnackBar(

        const SnackBar(

          content:
          Text(
            "يرجى إدخال مبلغ صحيح",
          ),

        ),

      );


      return;

    }



    try {


      // =========================
      // Current User
      // =========================

      String uid =
          FirebaseAuth
              .instance
              .currentUser!
              .uid;



      // =========================
      // Save To Firebase
      // =========================

      await FirebaseFirestore
          .instance
          .collection("users")
          .doc(uid)
          .collection("transactions")
          .add({


        "amount":
        value,


        "type":
        "expense",


        "category":
        selectedCategory,


        "payment":
        selectedPayment,


        "note":
        noteController
            .text
            .trim(),


        "date":
        Timestamp.fromDate(
          selectedDate,
        ),


        "createdAt":
        FieldValue
            .serverTimestamp(),

      });



      if (!mounted) return;



      ScaffoldMessenger
          .of(context)
          .showSnackBar(

        const SnackBar(

          content:
          Text(
            "تم حفظ المصروف بنجاح",
          ),

        ),

      );



      Navigator.pop(
        context,
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
            "حدث خطأ أثناء حفظ المصروف",
          ),

        ),

      );

    }

  }



  // =========================================
  // Build
  // =========================================

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


                    Navigator.pop(
                      context,
                    );


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
                  amountController,


                  quickAmounts:
                  const [

                    10,

                    20,

                    50,

                    100,

                    200,

                  ],


                  onChanged: () {


                    setState(() {});


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
                  categories,


                  selectedValue:
                  selectedCategory,


                  onSelected:
                      (value) {


                    setState(() {


                      selectedCategory =
                          value;


                    });


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
                  selectedDate,


                  onTap:
                  pickDate,


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
                  noteController,


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
                  saveExpense,


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



  // =========================================
  // Budget Card
  // =========================================

  Widget _buildBudgetCard() {


    // =========================================
    // اسم الميزانية حسب الفترة
    // =========================================

    String budgetTitle =
        "ميزانيتك";


    if (
    budgetPeriod ==
        "يومية"
    ) {

      budgetTitle =
      "ميزانيتك اليوم";

    }

    else if (
    budgetPeriod ==
        "أسبوعية"
    ) {

      budgetTitle =
      "ميزانيتك الأسبوعية";

    }

    else if (
    budgetPeriod ==
        "شهرية"
    ) {

      budgetTitle =
      "ميزانيتك الشهرية";

    }



    int progressPercent =
    (budgetProgress * 100)
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
        const LinearGradient(


          colors: [


            Color(
              0xff8B5CF6,
            ),


            Color(
              0xff5B34C9,
            ),


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
      isBudgetLoading

          ?

      const SizedBox(


        height:
        72,


        child:
        Center(


          child:
          CircularProgressIndicator(


            color:
            Colors.white,


            strokeWidth:
            3,


          ),


        ),


      )



      // =========================================
      // No Budget
      // =========================================

          :

      !hasBudget

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


                  "${formatAmount(budgetAmount)} ₪",


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


                  "${formatAmount(budgetRemaining)} ₪",


                  style:
                  const TextStyle(


                    color:
                    Color(
                      0xff55E39D,
                    ),


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
                    budgetProgress,


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



  // =========================================
  // Payment Method
  // =========================================

  Widget _buildPaymentMethod() {


    return Container(


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
      Column(


        crossAxisAlignment:
        CrossAxisAlignment.start,


        children: [



          const Row(


            children: [



              Icon(


                Icons.credit_card,


                size:
                18,


                color:
                Color(
                  0xff43318F,
                ),


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
              const Color(
                0xffFAF8FF,
              ),



              borderRadius:
              BorderRadius.circular(
                13,
              ),



              border:
              Border.all(


                color:
                const Color(
                  0xffEEE8FA,
                ),


              ),


            ),



            child:
            DropdownButtonHideUnderline(


              child:
              DropdownButton<String>(


                value:
                selectedPayment,



                isExpanded:
                true,



                icon:
                const Icon(


                  Icons
                      .keyboard_arrow_down,


                  color:
                  Color(
                    0xff6D3CE8,
                  ),


                ),



                items:
                const [



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
                          Color(
                            0xff6D3CE8,
                          ),

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
                          Color(
                            0xff6D3CE8,
                          ),

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
                          Color(
                            0xff6D3CE8,
                          ),

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
                          Color(
                            0xff6D3CE8,
                          ),

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


                    setState(() {


                      selectedPayment =
                          value;


                    });


                  }


                },


              ),


            ),


          ),

        ],

      ),

    );

  }



  // =========================================
  // Format Amount
  // =========================================

  String formatAmount(
      double value,
      ) {


    // 200.0
    // تصير
    // 200

    if (
    value % 1 ==
        0
    ) {


      return value
          .toInt()
          .toString();


    }



    // 200.50
    // تضل 200.50

    return value
        .toStringAsFixed(
      2,
    );

  }

}