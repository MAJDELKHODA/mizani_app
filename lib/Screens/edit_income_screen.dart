import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Widgets/page_header.dart';
import '../Widgets/amount_card.dart';
import '../Widgets/selection_grid.dart';
import '../Widgets/date_selector.dart';
import '../Widgets/note_field.dart';
import '../Widgets/primary_button.dart';



// =========================================
// Edit Income Screen
// =========================================

class EditIncomeScreen extends StatefulWidget {


  // =========================================
  // ID العملية الموجودة في Firebase
  // =========================================

  final String transactionId;



  // =========================================
  // البيانات القديمة للعملية
  // =========================================

  final double initialAmount;

  final String initialSource;

  final DateTime initialDate;

  final String initialNote;



  const EditIncomeScreen({

    super.key,

    required this.transactionId,

    required this.initialAmount,

    required this.initialSource,

    required this.initialDate,

    required this.initialNote,

  });



  @override
  State<EditIncomeScreen> createState() =>
      _EditIncomeScreenState();

}



// =========================================
// State
// =========================================

class _EditIncomeScreenState
    extends State<EditIncomeScreen> {


  // =========================================
  // Controllers
  // =========================================

  late TextEditingController
  amountController;


  late TextEditingController
  noteController;



  // =========================================
  // Selected Values
  // =========================================

  late String selectedSource;


  late DateTime selectedDate;



  // =========================================
  // هل يتم الحفظ الآن؟
  // =========================================

  bool isSaving = false;



  // =========================================
  // مصادر الدخل
  // نفس المصادر الموجودة في AddIncomeScreen
  // =========================================

  final List<SelectionItem>
  incomeSources = const [


    SelectionItem(

      name: "راتب",

      icon: Icons.work,

      color:
      Color(0xff2474E5),

    ),



    SelectionItem(

      name: "عمل حر",

      icon:
      Icons.laptop_mac,

      color:
      Color(0xff5266D6),

    ),



    SelectionItem(

      name: "هدية",

      icon:
      Icons.card_giftcard,

      color:
      Color(0xffFF6B7A),

    ),



    SelectionItem(

      name: "مكافأة",

      icon:
      Icons.emoji_events,

      color:
      Color(0xffF5A623),

    ),



    SelectionItem(

      name: "استثمار",

      icon:
      Icons.trending_up,

      color:
      Color(0xff20B875),

    ),



    SelectionItem(

      name: "أخرى",

      icon:
      Icons.more_horiz,

      color:
      Color(0xff514989),

    ),

  ];



  // =========================================
  // initState
  // =========================================

  @override
  void initState() {

    super.initState();



    // =========================
    // حط المبلغ القديم
    // داخل TextField
    // =========================

    amountController =
        TextEditingController(

          text:
          formatAmount(
            widget.initialAmount,
          ),

        );



    // =========================
    // حط الملاحظة القديمة
    // =========================

    noteController =
        TextEditingController(

          text:
          widget.initialNote,

        );



    // =========================
    // المصدر القديم
    // =========================

    selectedSource =
        widget.initialSource;



    // =========================
    // التاريخ القديم
    // =========================

    selectedDate =
        widget.initialDate;

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
  // اختيار التاريخ
  // =========================================

  Future<void> pickDate() async {


    final DateTime? date =
    await showDatePicker(


      context:
      context,


      initialDate:
      selectedDate,


      firstDate:
      DateTime(2020),


      lastDate:
      DateTime(2035),


    );



    // لو المستخدم اختار تاريخ
    if (date != null) {


      setState(() {


        selectedDate =
            date;


      });


    }

  }



  // =========================================
  // حفظ التعديل في Firebase
  // =========================================

  Future<void> saveChanges() async {


    // =========================
    // جيب المبلغ المكتوب
    // =========================

    String amount =
    amountController
        .text
        .trim();



    // =========================
    // تحقق أن المبلغ مش فاضي
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
    // حول String إلى double
    // =========================

    double? value =
    double.tryParse(
      amount,
    );



    // =========================
    // تحقق من صحة الرقم
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



    // =========================
    // منع الضغط أكثر من مرة
    // =========================

    if (isSaving) {

      return;

    }



    setState(() {


      isSaving = true;


    });



    try {


      // =========================
      // UID المستخدم الحالي
      // =========================

      String uid =

          FirebaseAuth
              .instance
              .currentUser!
              .uid;



      // =========================
      // الوصول لنفس Document
      // الموجود مسبقاً
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
          .doc(
        widget.transactionId,
      )
          .update({


        // =========================
        // المبلغ الجديد
        // =========================

        "amount":
        value,



        // =========================
        // مصدر الدخل الجديد
        // =========================

        "source":
        selectedSource,



        // =========================
        // التاريخ الجديد
        // =========================

        "date":
        Timestamp.fromDate(
          selectedDate,
        ),



        // =========================
        // الملاحظة الجديدة
        // =========================

        "note":
        noteController
            .text
            .trim(),



        // =========================
        // وقت آخر تعديل
        // =========================

        "updatedAt":
        FieldValue
            .serverTimestamp(),


      });



      if (!mounted) {

        return;

      }



      // =========================
      // رسالة نجاح
      // =========================

      ScaffoldMessenger
          .of(context)
          .showSnackBar(


        const SnackBar(


          content:
          Text(

            "تم تعديل الدخل بنجاح",

          ),


        ),


      );



      // =========================
      // true معناها:
      // تم التعديل بنجاح
      // =========================

      Navigator.pop(
        context,
        true,
      );


    }


    catch (e) {


      if (!mounted) {

        return;

      }



      // =========================
      // رجع الزر طبيعي
      // =========================

      setState(() {


        isSaving = false;


      });



      // =========================
      // رسالة خطأ
      // =========================

      ScaffoldMessenger
          .of(context)
          .showSnackBar(


        const SnackBar(


          content:
          Text(

            "حدث خطأ أثناء تعديل الدخل",

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



        body:
        SafeArea(


          child:
          SingleChildScrollView(


            padding:
            const EdgeInsets
                .symmetric(


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
                // Widget مشتركة
                // =========================================

                PageHeader(


                  title:
                  "تعديل الدخل",


                  subtitle:
                  "عدّل بيانات عملية الدخل",


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
                // بطاقة معلومات العملية
                // خاصة بواجهة تعديل الدخل
                // =========================================

                _buildIncomeCard(),



                const SizedBox(
                  height: 15,
                ),



                // =========================================
                // Amount
                // Widget مشتركة
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


                    setState(
                          () {},
                    );


                  },


                ),



                const SizedBox(
                  height: 15,
                ),



                // =========================================
                // Income Source
                // Widget مشتركة
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
                // Widget مشتركة
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
                // Widget مشتركة
                // =========================================

                NoteField(


                  controller:
                  noteController,


                ),



                const SizedBox(
                  height: 18,
                ),



                // =========================================
                // ملخص التعديل
                // =========================================

                _buildSummaryCard(),



                const SizedBox(
                  height: 18,
                ),



                // =========================================
                // Save Button
                // Widget مشتركة
                // =========================================

                if (!isSaving)

                  PrimaryButton(


                    title:
                    "حفظ التعديلات",


                    icon:
                    Icons.save_outlined,


                    onPressed:
                    saveChanges,


                  )

                else

                  Container(


                    width:
                    double.infinity,


                    height:
                    55,


                    decoration:
                    BoxDecoration(


                      color:
                      const Color(
                        0xff6D3CE8,
                      ),


                      borderRadius:
                      BorderRadius.circular(
                        17,
                      ),


                    ),


                    child:
                    const Center(


                      child:
                      SizedBox(


                        width:
                        24,


                        height:
                        24,


                        child:
                        CircularProgressIndicator(


                          strokeWidth:
                          2.5,


                          color:
                          Colors.white,


                        ),


                      ),


                    ),


                  ),



                const SizedBox(
                  height: 15,
                ),


              ],


            ),


          ),


        ),


      ),


    );

  }



  // =========================================
  // Income Card
  // =========================================

  Widget _buildIncomeCard() {


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



      child:
      Row(


        children: [



          // =========================
          // Icon
          // =========================

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


              Icons
                  .account_balance_wallet_outlined,


              color:
              Colors.white,


              size:
              28,


            ),


          ),



          const SizedBox(
            width: 15,
          ),



          // =========================
          // معلومات العملية
          // =========================

          Expanded(


            child:
            Column(


              crossAxisAlignment:
              CrossAxisAlignment.start,


              children: [


                const Text(


                  "عملية الدخل",


                  style:
                  TextStyle(


                    color:
                    Colors.white70,


                    fontSize:
                    13,


                  ),


                ),



                const SizedBox(
                  height: 5,
                ),



                Text(


                  selectedSource,


                  style:
                  const TextStyle(


                    color:
                    Colors.white,


                    fontSize:
                    18,


                    fontWeight:
                    FontWeight.bold,


                  ),


                ),



                const SizedBox(
                  height: 3,
                ),



                const Text(


                  "يمكنك تعديل البيانات أدناه",


                  style:
                  TextStyle(


                    color:
                    Colors.white70,


                    fontSize:
                    11,


                  ),


                ),


              ],


            ),


          ),



          // =========================
          // Amount
          // =========================

          Column(


            crossAxisAlignment:
            CrossAxisAlignment.end,


            children: [


              const Text(


                "المبلغ",


                style:
                TextStyle(


                  color:
                  Colors.white70,


                  fontSize:
                  11,


                ),


              ),



              const SizedBox(
                height: 5,
              ),



              Text(


                "${amountController.text.isEmpty ? "0" : amountController.text} ₪",


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


        ],


      ),


    );

  }



  // =========================================
  // Summary Card
  // =========================================

  Widget _buildSummaryCard() {


    return Container(


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



      child:
      Column(


        crossAxisAlignment:
        CrossAxisAlignment.start,


        children: [


          const Row(


            children: [


              Icon(


                Icons
                    .edit_note_outlined,


                color:
                Color(
                  0xff6D3CE8,
                ),


                size:
                21,


              ),



              SizedBox(
                width: 7,
              ),



              Text(


                "ملخص التعديل",


                style:
                TextStyle(


                  color:
                  Color(
                    0xff352080,
                  ),


                  fontWeight:
                  FontWeight.bold,


                  fontSize:
                  15,


                ),


              ),


            ],


          ),



          const SizedBox(
            height: 15,
          ),



          Row(


            mainAxisAlignment:
            MainAxisAlignment
                .spaceAround,


            children: [



              // =========================
              // Amount
              // =========================

              Expanded(


                child:
                _summaryItem(


                  title:
                  "المبلغ",


                  value:
                  "${amountController.text.isEmpty ? "0" : amountController.text} ₪",


                ),


              ),



              // =========================
              // Separator
              // =========================

              Container(


                width:
                1,


                height:
                42,


                color:
                const Color(
                  0xffD8CDF6,
                ),


              ),



              // =========================
              // Source
              // =========================

              Expanded(


                child:
                _summaryItem(


                  title:
                  "المصدر",


                  value:
                  selectedSource,


                ),


              ),



              // =========================
              // Separator
              // =========================

              Container(


                width:
                1,


                height:
                42,


                color:
                const Color(
                  0xffD8CDF6,
                ),


              ),



              // =========================
              // Date
              // =========================

              Expanded(


                child:
                _summaryItem(


                  title:
                  "التاريخ",


                  value:
                  formatDate(
                    selectedDate,
                  ),


                ),


              ),


            ],


          ),


        ],


      ),


    );

  }



  // =========================================
  // Summary Item
  // =========================================

  Widget _summaryItem({


    required String title,


    required String value,


  }) {


    return Column(


      children: [


        Text(


          title,


          style:
          const TextStyle(


            color:
            Colors.grey,


            fontSize:
            10,


          ),


        ),



        const SizedBox(
          height: 5,
        ),



        Text(


          value,


          maxLines:
          1,


          overflow:
          TextOverflow.ellipsis,


          textAlign:
          TextAlign.center,


          style:
          const TextStyle(


            color:
            Color(
              0xff352080,
            ),


            fontWeight:
            FontWeight.bold,


            fontSize:
            12,


          ),


        ),


      ],


    );

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
  // تنسيق التاريخ
  // =========================================

  String formatDate(
      DateTime date,
      ) {


    String day =
    date.day
        .toString()
        .padLeft(
      2,
      '0',
    );



    String month =
    date.month
        .toString()
        .padLeft(
      2,
      '0',
    );



    return "$day/$month/${date.year}";

  }

}