import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Widgets/page_header.dart';
import '../Widgets/amount_card.dart';
import '../Widgets/date_selector.dart';
import '../Widgets/primary_button.dart';


class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() =>
      _BudgetScreenState();
}


class _BudgetScreenState
    extends State<BudgetScreen> {

  // =========================================
  // Controller
  // =========================================

  final TextEditingController budgetController =
  TextEditingController(
    text: "200",
  );


  // =========================================
  // New Budget Data
  // =========================================

  String selectedPeriod =
      "يومية";

  bool enableAlert =
  true;

  double alertPercent =
  80;

  DateTime startDate =
  DateTime.now();


  // =========================================
  // Current Budget From Firebase
  // =========================================

  double currentBudgetAmount =
  0;

  String currentBudgetPeriod =
      "";

  bool hasCurrentBudget =
  false;

  bool isCurrentBudgetLoading =
  true;


  // =========================================
  // Budget Types
  // =========================================

  final List<Map<String, dynamic>>
  budgetTypes = [

    {
      "name": "يومية",
      "icon": Icons.today,
      "desc": "لإدارة مصروفك اليومي",
    },

    {
      "name": "أسبوعية",
      "icon": Icons.date_range,
      "desc": "لإدارة مصروفك الأسبوعي",
    },

    {
      "name": "شهرية",
      "icon": Icons.calendar_month,
      "desc": "لإدارة مصروفك الشهري",
    },

  ];


  // =========================================
  // Init
  // =========================================

  @override
  void initState() {

    super.initState();

    // أول ما الشاشة تفتح
    // جيب الميزانية الحالية من Firebase

    getCurrentBudget();

  }


  // =========================================
  // Dispose
  // =========================================

  @override
  void dispose() {

    budgetController.dispose();

    super.dispose();

  }


  // =========================================
  // Get Current Budget
  // =========================================

  Future<void> getCurrentBudget() async {

    try {

      // المستخدم الحالي

      User? user =
          FirebaseAuth
              .instance
              .currentUser;


      if (user == null) {

        if (!mounted) return;

        setState(() {

          hasCurrentBudget =
          false;

          isCurrentBudgetLoading =
          false;

        });

        return;

      }


      String uid =
          user.uid;


      // جيب budget/current

      final budgetDoc =
      await FirebaseFirestore
          .instance
          .collection("users")
          .doc(uid)
          .collection("budget")
          .doc("current")
          .get();


      // لو ما في ميزانية محفوظة

      if (!budgetDoc.exists) {

        if (!mounted) return;

        setState(() {

          currentBudgetAmount =
          0;

          currentBudgetPeriod =
          "";

          hasCurrentBudget =
          false;

          isCurrentBudgetLoading =
          false;

        });

        return;

      }


      final data =
      budgetDoc.data();


      if (data == null) {

        if (!mounted) return;

        setState(() {

          hasCurrentBudget =
          false;

          isCurrentBudgetLoading =
          false;

        });

        return;

      }


      double amount =
          (data["amount"] as num?)
              ?.toDouble() ??
              0;


      String period =
          data["period"] ??
              "";


      if (!mounted) return;


      setState(() {

        currentBudgetAmount =
            amount;

        currentBudgetPeriod =
            period;

        hasCurrentBudget =
        true;

        isCurrentBudgetLoading =
        false;

      });

    }

    catch (e) {

      if (!mounted) return;


      setState(() {

        isCurrentBudgetLoading =
        false;

      });


      ScaffoldMessenger
          .of(context)
          .showSnackBar(

        const SnackBar(

          content:
          Text(
            "تعذر تحميل الميزانية الحالية",
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
      startDate,

      firstDate:
      DateTime(2020),

      lastDate:
      DateTime(2035),

    );


    if (date != null) {

      setState(() {

        startDate =
            date;

      });

    }

  }


  // =========================================
  // Save Budget
  // =========================================

  Future<void> saveBudget() async {

    String budget =
    budgetController
        .text
        .trim();


    // =========================================
    // Empty
    // =========================================

    if (budget.isEmpty) {

      ScaffoldMessenger
          .of(context)
          .showSnackBar(

        const SnackBar(

          content:
          Text(
            "يرجى إدخال مبلغ الميزانية",
          ),

        ),

      );

      return;

    }


    // =========================================
    // Convert To Double
    // =========================================

    double? value =
    double.tryParse(
      budget,
    );


    // =========================================
    // Validation
    // =========================================

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

      // =========================================
      // User
      // =========================================

      String uid =
          FirebaseAuth
              .instance
              .currentUser!
              .uid;


      // =========================================
      // Save In Firebase
      // =========================================

      await FirebaseFirestore
          .instance
          .collection("users")
          .doc(uid)
          .collection("budget")
          .doc("current")
          .set({

        "amount":
        value,

        "period":
        selectedPeriod,

        "enableAlert":
        enableAlert,

        "alertPercent":
        alertPercent,

        "startDate":
        Timestamp.fromDate(
          startDate,
        ),

        "updatedAt":
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
            "تم حفظ الميزانية بنجاح",
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
            "حدث خطأ أثناء حفظ الميزانية",
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


      child: Scaffold(

        backgroundColor:
        const Color(
          0xffF7F2FF,
        ),


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

                    Navigator.pop(
                      context,
                    );

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
                  budgetController,

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

                    setState(() {});

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
                    Colors.white,

                    borderRadius:
                    BorderRadius.circular(
                      20,
                    ),

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


                      const Text(

                        "اختر الفترة المناسبة لك",

                        style:
                        TextStyle(

                          fontSize:
                          12,

                          color:
                          Color(
                            0xff9A91B1,
                          ),

                        ),

                      ),


                      const SizedBox(
                        height: 15,
                      ),


                      Row(

                        children:
                        budgetTypes
                            .map(

                              (type) {

                            bool selected =
                                selectedPeriod ==
                                    type["name"];


                            return Expanded(

                              child:
                              InkWell(

                                onTap: () {

                                  setState(() {

                                    selectedPeriod =
                                    type["name"];

                                  });

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

                                    const Color(
                                      0xffF0E9FF,
                                    )

                                        :

                                    const Color(
                                      0xffFAF9FE,
                                    ),


                                    border:
                                    Border.all(

                                      color:
                                      selected

                                          ?

                                      const Color(
                                        0xff6D3CE8,
                                      )

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

                                        type["icon"],

                                        color:
                                        selected

                                            ?

                                        const Color(
                                          0xff6D3CE8,
                                        )

                                            :

                                        const Color(
                                          0xff8D85A3,
                                        ),

                                      ),


                                      const SizedBox(
                                        height: 7,
                                      ),


                                      Text(

                                        type["name"],

                                        style:
                                        TextStyle(

                                          fontSize:
                                          13,

                                          fontWeight:
                                          FontWeight.bold,

                                          color:
                                          selected

                                              ?

                                          const Color(
                                            0xff6D3CE8,
                                          )

                                              :

                                          const Color(
                                            0xff241653,
                                          ),

                                        ),

                                      ),


                                      const SizedBox(
                                        height: 4,
                                      ),


                                      Text(

                                        type["desc"],

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
                    Colors.white,

                    borderRadius:
                    BorderRadius.circular(
                      20,
                    ),

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
                              const Color(
                                0xffF0E9FF,
                              ),

                              borderRadius:
                              BorderRadius.circular(
                                12,
                              ),

                            ),

                            child:
                            const Icon(

                              Icons
                                  .notifications_none,

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
                                    Colors.grey,

                                  ),

                                ),

                              ],

                            ),

                          ),


                          Switch(

                            value:
                            enableAlert,

                            activeColor:
                            const Color(
                              0xff6D3CE8,
                            ),

                            onChanged:
                                (value) {

                              setState(() {

                                enableAlert =
                                    value;

                              });

                            },

                          ),

                        ],

                      ),


                      if (enableAlert) ...[


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

                              "${alertPercent.toInt()}%",

                              style:
                              const TextStyle(

                                color:
                                Color(
                                  0xff6D3CE8,
                                ),

                                fontWeight:
                                FontWeight.bold,

                              ),

                            ),

                          ],

                        ),


                        Slider(

                          value:
                          alertPercent,

                          min:
                          50,

                          max:
                          100,

                          divisions:
                          10,

                          activeColor:
                          const Color(
                            0xff6D3CE8,
                          ),

                          inactiveColor:
                          const Color(
                            0xffEDE7FF,
                          ),

                          onChanged:
                              (value) {

                            setState(() {

                              alertPercent =
                                  value;

                            });

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
                  startDate,

                  onTap:
                  pickDate,

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
                    const Color(
                      0xffEEE7FF,
                    ),

                    borderRadius:
                    BorderRadius.circular(
                      18,
                    ),

                  ),


                  child: Column(

                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [


                      const Text(

                        "ملخص الميزانية الجديدة",

                        style:
                        TextStyle(

                          fontWeight:
                          FontWeight.bold,

                          color:
                          Color(
                            0xff352080,
                          ),

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


                              const Text(

                                "المبلغ",

                                style:
                                TextStyle(

                                  color:
                                  Colors.grey,

                                  fontSize:
                                  11,

                                ),

                              ),


                              const SizedBox(
                                height: 5,
                              ),


                              Text(

                                "${budgetController.text} ₪",

                                style:
                                const TextStyle(

                                  color:
                                  Color(
                                    0xff352080,
                                  ),

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


                              const Text(

                                "النوع",

                                style:
                                TextStyle(

                                  color:
                                  Colors.grey,

                                  fontSize:
                                  11,

                                ),

                              ),


                              const SizedBox(
                                height: 5,
                              ),


                              Text(

                                selectedPeriod,

                                style:
                                const TextStyle(

                                  color:
                                  Color(
                                    0xff352080,
                                  ),

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


                              const Text(

                                "التنبيه",

                                style:
                                TextStyle(

                                  color:
                                  Colors.grey,

                                  fontSize:
                                  11,

                                ),

                              ),


                              const SizedBox(
                                height: 5,
                              ),


                              Text(

                                enableAlert

                                    ?

                                "${alertPercent.toInt()}%"

                                    :

                                "مغلق",

                                style:
                                const TextStyle(

                                  color:
                                  Color(
                                    0xff352080,
                                  ),

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
                  saveBudget,

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
  // Current Budget Card
  // =========================================

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
      isCurrentBudgetLoading

          ?

      const SizedBox(

        height:
        55,

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

      !hasCurrentBudget

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

                  "${formatAmount(currentBudgetAmount)} ₪",

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
                currentBudgetPeriod
                    .isNotEmpty
                ) ...[


                  const SizedBox(
                    height: 2,
                  ),


                  Text(

                    "ميزانية $currentBudgetPeriod",

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


  // =========================================
  // Format Amount
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

}