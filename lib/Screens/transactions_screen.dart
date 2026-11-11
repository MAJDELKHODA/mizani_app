import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mizani_app/Screens/transaction_details_screen.dart';

import '../Widgets/page_header.dart';
import '../Widgets/transaction_item.dart';


class TransactionsScreen extends StatefulWidget {

  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() =>
      _TransactionsScreenState();
}



class _TransactionsScreenState
    extends State<TransactionsScreen> {


  String selectedPeriod = "اليوم";

  String selectedType = "الكل";


  // العمليات اللي رح تجي من Firebase
  List<Map<String, dynamic>> transactions = [];


  bool isLoading = true;



  @override
  void initState() {

    super.initState();

    getTransactions();

  }



  // =========================
  // جلب العمليات من Firebase
  // =========================

  Future<void> getTransactions() async {

    String uid =
        FirebaseAuth.instance.currentUser!.uid;


    try {

      final snapshot =
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("transactions")
          .orderBy(
        "date",
        descending: true,
      )
          .get();


      List<Map<String, dynamic>>
      loadedTransactions = [];


      for (var doc in snapshot.docs) {

        final data = doc.data();


        String type =
            data["type"] ?? "";


        // إذا النوع مش دخل ولا مصروف
        // ما نعرض العملية
        if (
        type != "income" &&
            type != "expense"
        ) {

          continue;

        }


        double amount =
        (data["amount"] as num)
            .toDouble();


        Timestamp? dateTimestamp =
        data["date"] as Timestamp?;


        if (dateTimestamp == null) {

          continue;

        }


        DateTime date =
        dateTimestamp.toDate();


        DateTime? createdAt;


        if (data["createdAt"] is Timestamp) {

          createdAt =
              (data["createdAt"] as Timestamp)
                  .toDate();

        }


        String title = "";

        String details = "";

        String category = "";

        String payment = "";

        String source = "";

        String note =
            data["note"] ?? "";


        IconData icon =
            Icons.receipt_long_outlined;

        Color color =
        const Color(0xff6D3CE8);



        // =========================
        // إذا العملية دخل
        // =========================

        if (type == "income") {

          source =
              data["source"] ?? "دخل";


          title = source;

          details = source;


          icon =
              getIncomeIcon(source);


          color =
              getIncomeColor(source);

        }



        // =========================
        // إذا العملية مصروف
        // =========================

        else if (type == "expense") {

          category =
              data["category"] ?? "مصروف";


          payment =
              data["payment"] ?? "";


          title = category;


          if (payment.isEmpty) {

            details = category;

          }

          else {

            details =
            "$category • $payment";

          }


          icon =
              getExpenseIcon(category);


          color =
              getExpenseColor(category);

        }



        loadedTransactions.add({

          "id": doc.id,

          "title": title,

          "amount": amount,

          "type": type,

          "date": date,

          "createdAt": createdAt,

          "details": details,

          "category": category,

          "payment": payment,

          "source": source,

          "note": note,

          "icon": icon,

          "color": color,

        });

      }


      if (!mounted) return;


      setState(() {

        transactions =
            loadedTransactions;

        isLoading = false;

      });

    }

    catch (e) {

      if (!mounted) return;


      setState(() {

        isLoading = false;

      });


      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content: Text(
            "حدث خطأ أثناء تحميل العمليات",
          ),

        ),

      );

    }

  }



  // =========================
  // فلترة الفترة
  // =========================

  bool matchesPeriod(DateTime date) {

    DateTime now =
    DateTime.now();



    // اليوم

    if (selectedPeriod == "اليوم") {

      return DateUtils.isSameDay(
        date,
        now,
      );

    }



    // الأسبوع

    if (selectedPeriod == "الأسبوع") {

      int difference =
          now.difference(date).inDays;


      return difference >= 0 &&
          difference <= 6;

    }



    // الشهر

    return date.year == now.year &&
        date.month == now.month;

  }



  // =========================
  // فلترة العمليات
  // =========================

  List<Map<String, dynamic>>
  get filteredTransactions {


    return transactions.where(
          (transaction) {


        bool periodMatch =
        matchesPeriod(
          transaction["date"],
        );


        bool typeMatch =

            selectedType == "الكل"

                ||

                (
                    selectedType ==
                        "المصروفات"
                        &&
                        transaction["type"] ==
                            "expense"
                )

                ||

                (
                    selectedType ==
                        "الدخل"
                        &&
                        transaction["type"] ==
                            "income"
                );


        return periodMatch &&
            typeMatch;

      },

    ).toList();

  }



  // =========================
  // إجمالي الدخل
  // =========================

  double get totalIncome {

    double total = 0;


    for (
    var transaction
    in filteredTransactions
    ) {

      if (
      transaction["type"] ==
          "income"
      ) {

        total =
            total +
                transaction["amount"];

      }

    }


    return total;

  }



  // =========================
  // إجمالي المصروف
  // =========================

  double get totalExpense {

    double total = 0;


    for (
    var transaction
    in filteredTransactions
    ) {

      if (
      transaction["type"] ==
          "expense"
      ) {

        total =
            total +
                transaction["amount"];

      }

    }


    return total;

  }



  // =========================
  // تنسيق المبلغ
  // =========================

  String formatAmount(
      double value,
      ) {


    if (value % 1 == 0) {

      return value
          .toInt()
          .toString();

    }


    return value
        .toStringAsFixed(2);

  }



  // =========================
  // تنسيق التاريخ
  // =========================

  String formatDate(
      DateTime date,
      ) {


    String day =
    date.day
        .toString()
        .padLeft(2, '0');


    String month =
    date.month
        .toString()
        .padLeft(2, '0');


    return "$day/$month/${date.year}";

  }



  // =========================
  // تنسيق الوقت
  // =========================

  String formatTime(
      DateTime? date,
      ) {


    if (date == null) {

      return "-";

    }


    String hour =
    date.hour
        .toString()
        .padLeft(2, '0');


    String minute =
    date.minute
        .toString()
        .padLeft(2, '0');


    return "$hour:$minute";

  }



  // =========================
  // أيقونة الدخل
  // =========================

  IconData getIncomeIcon(
      String source,
      ) {


    if (source == "راتب") {

      return Icons.work;

    }


    if (source == "عمل حر") {

      return Icons.laptop_mac;

    }


    if (source == "هدية") {

      return Icons.card_giftcard;

    }


    if (source == "مكافأة") {

      return Icons.emoji_events;

    }


    if (source == "استثمار") {

      return Icons.trending_up;

    }


    return Icons.add_circle_outline;

  }



  // =========================
  // لون الدخل
  // =========================

  Color getIncomeColor(
      String source,
      ) {


    if (source == "راتب") {

      return const Color(
        0xff20B875,
      );

    }


    if (source == "عمل حر") {

      return const Color(
        0xff5266D6,
      );

    }


    if (source == "هدية") {

      return const Color(
        0xffFF6B7A,
      );

    }


    if (source == "مكافأة") {

      return const Color(
        0xffF5A623,
      );

    }


    if (source == "استثمار") {

      return const Color(
        0xff20B875,
      );

    }


    return const Color(
      0xff514989,
    );

  }



  // =========================
  // أيقونة المصروف
  // =========================

  IconData getExpenseIcon(
      String category,
      ) {


    if (category == "طعام") {

      return Icons.restaurant;

    }


    if (category == "مواصلات") {

      return Icons.directions_car;

    }


    if (category == "تسوق") {

      return Icons.shopping_cart;

    }


    if (category == "منزل") {

      return Icons.home;

    }


    if (category == "ملابس") {

      return Icons.checkroom;

    }


    if (category == "صحة") {

      return Icons.favorite;

    }


    if (category == "تجميل") {

      return Icons.spa;

    }


    if (category == "فواتير") {

      return Icons.receipt_long;

    }


    if (category == "تعليم") {

      return Icons.school;

    }


    if (category == "ترفيه") {

      return Icons.sports_esports;

    }


    if (category == "هدايا") {

      return Icons.card_giftcard;

    }


    return Icons.more_horiz;

  }



  // =========================
  // لون المصروف
  // =========================

  Color getExpenseColor(
      String category,
      ) {


    if (category == "طعام") {

      return const Color(
        0xffFF9C55,
      );

    }


    if (category == "مواصلات") {

      return const Color(
        0xff3B82F6,
      );

    }


    if (category == "تسوق") {

      return const Color(
        0xff7047EB,
      );

    }


    if (category == "منزل") {

      return const Color(
        0xffFF9B50,
      );

    }


    if (category == "ملابس") {

      return const Color(
        0xff3498DB,
      );

    }


    if (category == "صحة") {

      return const Color(
        0xffF45B69,
      );

    }


    if (category == "تجميل") {

      return const Color(
        0xffE85C9C,
      );

    }


    if (category == "فواتير") {

      return const Color(
        0xff4ABAD5,
      );

    }


    if (category == "تعليم") {

      return const Color(
        0xff453089,
      );

    }


    if (category == "ترفيه") {

      return const Color(
        0xff4B3B8F,
      );

    }


    if (category == "هدايا") {

      return const Color(
        0xffFF6680,
      );

    }


    return const Color(
      0xff55508C,
    );

  }



  @override
  Widget build(BuildContext context) {


    final filtered =
        filteredTransactions;


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

                    Navigator.pop(
                      context,
                    );

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


                  child: Row(

                    children: [


                      Expanded(

                        child:
                        _summaryItem(

                          title:
                          "إجمالي الدخل",

                          amount:
                          "${formatAmount(totalIncome)} ₪",

                          color:
                          const Color(
                            0xff55E39D,
                          ),

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
                          "${formatAmount(totalExpense)} ₪",

                          color:
                          const Color(
                            0xffFF8A91,
                          ),

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

                    const Text(

                      "العمليات",

                      style:
                      TextStyle(

                        fontSize: 18,

                        fontWeight:
                        FontWeight.bold,

                        color:
                        Color(
                          0xff241653,
                        ),

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
                        Colors.white,

                        borderRadius:
                        BorderRadius.circular(
                          12,
                        ),

                      ),


                      child:
                      DropdownButtonHideUnderline(

                        child:
                        DropdownButton<String>(

                          value:
                          selectedType,


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

                              setState(() {

                                selectedType =
                                    value;

                              });

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

                if (isLoading)

                  const Center(

                    child:
                    Padding(

                      padding:
                      EdgeInsets.all(
                        30,
                      ),

                      child:
                      CircularProgressIndicator(),

                    ),

                  )


                else if (
                filtered.isEmpty
                )

                  _emptyState()


                else

                  ...filtered.map(
                        (transaction) {


                      bool isIncome =
                          transaction["type"] ==
                              "income";


                      return TransactionItem(

                        title:
                        transaction["title"],

                        subtitle:
                        transaction["details"],


                        date:
                        formatDate(
                          transaction["date"]
                          as DateTime,
                        ),


                        amount:
                        formatAmount(
                          transaction["amount"],
                        ),


                        icon:
                        transaction["icon"],


                        iconColor:
                        transaction["color"],


                        isIncome:
                        isIncome,


                        onTap: () async {


                          await Navigator.push(

                            context,

                            MaterialPageRoute(

                              builder: (_) =>
                                  TransactionDetailsScreen(

                                    transactionId:
                                    transaction["id"],
                                    type:
                                    transaction["type"],

                                    source:
                                    transaction["source"],

                                    title:
                                    transaction["title"],

                                    amount:
                                    transaction["amount"],

                                    category:
                                    transaction["title"],

                                    date:
                                    transaction["date"],

                                    time:
                                    formatTime(
                                      transaction["createdAt"],
                                    ),

                                    paymentMethod:
                                    transaction["type"] ==
                                        "expense"
                                        ?
                                    transaction["payment"]
                                        :
                                    "-",

                                    note:
                                    transaction["note"],

                                    icon:
                                    transaction["icon"],

                                    iconColor:
                                    transaction["color"],

                                  ),

                            ),

                          );


                          // لما نرجع من التفاصيل
                          // نحدث العمليات
                          await getTransactions();

                        },

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



  // =========================
  // Summary Item
  // =========================

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



  // =========================
  // Period Button
  // =========================

  Widget _periodButton(
      String title,
      ) {


    bool selected =
        selectedPeriod ==
            title;


    return Expanded(

      child:
      GestureDetector(

        onTap: () {

          setState(() {

            selectedPeriod =
                title;

          });

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
            const Color(
              0xff6D3CE8,
            )
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
              const Color(
                0xff81779A,
              ),

              fontWeight:
              FontWeight.bold,

            ),

          ),

        ),

      ),

    );

  }



  // =========================
  // Empty State
  // =========================

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
        Colors.white,

        borderRadius:
        BorderRadius.circular(
          20,
        ),

      ),

      child:
      const Column(

        children: [

          Icon(

            Icons
                .receipt_long_outlined,

            size: 55,

            color:
            Color(
              0xffB7A9DE,
            ),

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
              Color(
                0xff352080,
              ),

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
              Colors.grey,

              fontSize: 12,

            ),

          ),

        ],

      ),

    );

  }

}