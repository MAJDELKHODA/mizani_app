import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Widgets/page_header.dart';
import '../Widgets/amount_card.dart';
import '../Widgets/selection_grid.dart';
import '../Widgets/date_selector.dart';
import '../Widgets/note_field.dart';
import '../Widgets/primary_button.dart';


class AddIncomeScreen extends StatefulWidget {

  const AddIncomeScreen({
    super.key,
  });


  @override
  State<AddIncomeScreen> createState() =>
      _AddIncomeScreenState();
}



class _AddIncomeScreenState
    extends State<AddIncomeScreen> {


  // =========================================
  // Controllers
  // =========================================

  final TextEditingController amountController =
  TextEditingController(
    text: "500",
  );


  final TextEditingController noteController =
  TextEditingController();



  // =========================================
  // Income Data
  // =========================================

  String selectedSource =
      "راتب";


  DateTime selectedDate =
  DateTime.now();



  // =========================================
  // Financial Data
  // =========================================

  double totalIncome = 0;

  double totalExpense = 0;

  double balance = 0;


  bool isFinancialLoading =
  true;



  // =========================================
  // Income Sources
  // =========================================

  final List<SelectionItem>
  incomeSources = const [


    SelectionItem(

      name:
      "راتب",

      icon:
      Icons.work,

      color:
      Color(
        0xff2474E5,
      ),

    ),


    SelectionItem(

      name:
      "عمل حر",

      icon:
      Icons.laptop_mac,

      color:
      Color(
        0xff5266D6,
      ),

    ),


    SelectionItem(

      name:
      "هدية",

      icon:
      Icons.card_giftcard,

      color:
      Color(
        0xffFF6B7A,
      ),

    ),


    SelectionItem(

      name:
      "مكافأة",

      icon:
      Icons.emoji_events,

      color:
      Color(
        0xffF5A623,
      ),

    ),


    SelectionItem(

      name:
      "استثمار",

      icon:
      Icons.trending_up,

      color:
      Color(
        0xff20B875,
      ),

    ),


    SelectionItem(

      name:
      "أخرى",

      icon:
      Icons.more_horiz,

      color:
      Color(
        0xff514989,
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
    // جيب الدخل والمصروف من Firebase

    getFinancialData();

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
  // Get Financial Data
  // =========================================

  Future<void> getFinancialData() async {

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

          isFinancialLoading =
          false;

        });


        return;

      }



      String uid =
          user.uid;



      // =========================
      // جيب كل العمليات
      // =========================

      final snapshot =
      await FirebaseFirestore
          .instance
          .collection(
        "users",
      )
          .doc(
        uid,
      )
          .collection(
        "transactions",
      )
          .get();



      double income =
      0;


      double expense =
      0;



      // =========================
      // مر على كل العمليات
      // =========================

      for (var doc
      in snapshot.docs) {


        final data =
        doc.data();



        // لازم يوجد مبلغ

        if (
        data["amount"] is! num
        ) {

          continue;

        }



        double amount =
        (data["amount"]
        as num)
            .toDouble();



        String type =
            data["type"] ??
                "";



        // =========================
        // Income
        // =========================

        if (
        type == "income"
        ) {

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

        }

      }



      // =========================
      // Balance
      // =========================

      double currentBalance =
          income - expense;



      if (!mounted) return;



      setState(() {

        totalIncome =
            income;


        totalExpense =
            expense;


        balance =
            currentBalance;


        isFinancialLoading =
        false;

      });

    }

    catch (e) {


      if (!mounted) return;



      setState(() {

        isFinancialLoading =
        false;

      });



      ScaffoldMessenger
          .of(context)
          .showSnackBar(

        const SnackBar(

          content:
          Text(
            "تعذر تحميل البيانات المالية",
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
  // Save Income
  // =========================================

  Future<void> saveIncome() async {


    String amount =
    amountController
        .text
        .trim();



    // =========================
    // Empty Amount
    // =========================

    if (amount.isEmpty) {


      ScaffoldMessenger
          .of(context)
          .showSnackBar(

        const SnackBar(

          content:
          Text(
            "يرجى إدخال مبلغ الدخل",
          ),

        ),

      );


      return;

    }



    // =========================
    // Convert String To Double
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
          .collection(
        "users",
      )
          .doc(
        uid,
      )
          .collection(
        "transactions",
      )
          .add({


        "amount":
        value,


        "type":
        "income",


        "source":
        selectedSource,


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
            "تم حفظ الدخل بنجاح",
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
            "حدث خطأ أثناء حفظ الدخل",
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
                // Header
                // =========================================

                PageHeader(


                  title:
                  "إضافة دخل",


                  subtitle:
                  "سجّل تفاصيل دخلك بكل سهولة",


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
                  amountController,


                  quickAmounts:
                  const [

                    200,

                    500,

                    1000,

                    2000,

                  ],


                  onChanged: () {


                    setState(() {});


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
                  incomeSources,


                  selectedValue:
                  selectedSource,


                  onSelected:
                      (value) {


                    setState(() {


                      selectedSource =
                          value;


                    });


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
                  selectedDate,


                  onTap:
                  pickDate,


                ),



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
                // Save
                // =========================================

                PrimaryButton(


                  title:
                  "حفظ الدخل",


                  onPressed:
                  saveIncome,


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
  // Balance Card
  // =========================================

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
      isFinancialLoading

          ?

      const SizedBox(


        height:
        75,


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


                  "${formatAmount(balance)} ₪",


                  style:
                  TextStyle(


                    color:
                    balance >= 0

                        ?

                    Colors.white

                        :

                    const Color(
                      0xffFFB4B8,
                    ),


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


                  "${formatAmount(totalIncome)} ₪",


                  style:
                  const TextStyle(


                    color:
                    Color(
                      0xff55E39D,
                    ),


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


                  "${formatAmount(totalExpense)} ₪",


                  style:
                  const TextStyle(


                    color:
                    Color(
                      0xffFF6B73,
                    ),


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