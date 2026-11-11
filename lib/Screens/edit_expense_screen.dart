import 'package:flutter/material.dart';

import '../Widgets/page_header.dart';
import '../Widgets/amount_card.dart';
import '../Widgets/selection_grid.dart';
import '../Widgets/date_selector.dart';
import '../Widgets/note_field.dart';
import '../Widgets/primary_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class EditExpenseScreen extends StatefulWidget {

  final String transactionId;
  final double initialAmount;
  final String initialCategory;
  final DateTime initialDate;
  final String initialPaymentMethod;
  final String initialNote;


  const EditExpenseScreen({
    super.key,

    required this.transactionId,
    required this.initialAmount,
    required this.initialCategory,
    required this.initialDate,
    required this.initialPaymentMethod,
    required this.initialNote,
  });


  @override
  State<EditExpenseScreen> createState() =>
      _EditExpenseScreenState();
}


class _EditExpenseScreenState
    extends State<EditExpenseScreen> {

  late TextEditingController amountController;

  late TextEditingController noteController;

  late String selectedCategory;

  late String selectedPayment;

  late DateTime selectedDate;


  final List<SelectionItem> categories = const [

    SelectionItem(
      name: "طعام",
      icon: Icons.restaurant,
      color: Color(0xffFF9C55),
    ),

    SelectionItem(
      name: "مواصلات",
      icon: Icons.directions_car,
      color: Color(0xff3B82F6),
    ),

    SelectionItem(
      name: "تسوق",
      icon: Icons.shopping_cart,
      color: Color(0xff7047EB),
    ),

    SelectionItem(
      name: "منزل",
      icon: Icons.home,
      color: Color(0xffFF9B50),
    ),

    SelectionItem(
      name: "ملابس",
      icon: Icons.checkroom,
      color: Color(0xff3498DB),
    ),

    SelectionItem(
      name: "صحة",
      icon: Icons.favorite,
      color: Color(0xffF45B69),
    ),

    SelectionItem(
      name: "تجميل",
      icon: Icons.spa,
      color: Color(0xffE85C9C),
    ),

    SelectionItem(
      name: "فواتير",
      icon: Icons.receipt_long,
      color: Color(0xff4ABAD5),
    ),

    SelectionItem(
      name: "تعليم",
      icon: Icons.school,
      color: Color(0xff453089),
    ),

    SelectionItem(
      name: "ترفيه",
      icon: Icons.sports_esports,
      color: Color(0xff4B3B8F),
    ),

    SelectionItem(
      name: "هدايا",
      icon: Icons.card_giftcard,
      color: Color(0xffFF6680),
    ),

    SelectionItem(
      name: "أخرى",
      icon: Icons.more_horiz,
      color: Color(0xff55508C),
    ),

  ];


  @override
  void initState() {

    super.initState();


    amountController =
        TextEditingController(
          text: formatAmount(
            widget.initialAmount,
          ),
        );


    noteController =
        TextEditingController(
          text: widget.initialNote,
        );


    selectedCategory =
        widget.initialCategory;


    selectedPayment =
        widget.initialPaymentMethod;


    selectedDate =
        widget.initialDate;

  }


  @override
  void dispose() {

    amountController.dispose();

    noteController.dispose();

    super.dispose();
  }


  // =========================
  // Pick Date
  // =========================

  Future<void> pickDate() async {

    final DateTime? date =
    await showDatePicker(

      context: context,

      initialDate:
      selectedDate,

      firstDate:
      DateTime(2020),

      lastDate:
      DateTime(2035),

    );


    if (date != null) {

      setState(() {

        selectedDate =
            date;

      });

    }

  }


  // =========================
  // Save
  // =========================

  Future<void> saveChanges() async {

    String amount =
    amountController.text.trim();


    if (amount.isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
            "يرجى إدخال المبلغ",
          ),
        ),

      );

      return;
    }


    double? value =
    double.tryParse(amount);


    if (value == null || value <= 0) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
            "يرجى إدخال مبلغ صحيح",
          ),
        ),

      );

      return;
    }


    try {

      String uid =
          FirebaseAuth.instance.currentUser!.uid;


      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("transactions")
          .doc(widget.transactionId)
          .update({

        "amount": value,

        "category": selectedCategory,

        "payment": selectedPayment,

        "note":
        noteController.text.trim(),

        "date":
        Timestamp.fromDate(
          selectedDate,
        ),

        "updatedAt":
        FieldValue.serverTimestamp(),

      });


      if (!mounted) return;


      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
            "تم تعديل العملية بنجاح",
          ),
        ),

      );


      Navigator.pop(
        context,
        true,
      );

    }

    catch (e) {

      if (!mounted) return;


      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
            "حدث خطأ أثناء تعديل العملية",
          ),
        ),

      );

    }
  }


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
              horizontal: 18,
              vertical: 12,
            ),


            child: Column(

              children: [


                // =========================
                // Header
                // =========================

                PageHeader(

                  title:
                  "تعديل العملية",

                  subtitle:
                  "عدّل بيانات العملية",

                  onBack: () {

                    Navigator.pop(
                      context,
                    );

                  },

                ),


                const SizedBox(
                  height: 18,
                ),


                // =========================
                // Amount
                // =========================

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

                    setState(
                          () {},
                    );

                  },

                ),


                const SizedBox(
                  height: 15,
                ),


                // =========================
                // Category
                // =========================

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


                // =========================
                // Date
                // =========================

                DateSelector(

                  date:
                  selectedDate,

                  onTap:
                  pickDate,

                ),


                const SizedBox(
                  height: 15,
                ),


                // =========================
                // Payment Method
                // خاص بالمصروف
                // =========================

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
                      18,
                    ),

                  ),


                  child: Column(

                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                    children: [

                      const Row(

                        children: [

                          Icon(
                            Icons
                                .credit_card,
                            color:
                            Color(
                              0xff43318F,
                            ),
                            size: 18,
                          ),

                          SizedBox(
                            width: 6,
                          ),

                          Text(
                            "طريقة الدفع",
                            style:
                            TextStyle(
                              fontWeight:
                              FontWeight
                                  .bold,
                            ),
                          ),

                        ],

                      ),


                      const SizedBox(
                        height: 10,
                      ),


                      Container(

                        padding:
                        const EdgeInsets
                            .symmetric(
                          horizontal: 12,
                        ),

                        decoration:
                        BoxDecoration(

                          color:
                          const Color(
                            0xffFAF8FF,
                          ),

                          borderRadius:
                          BorderRadius
                              .circular(
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
                          DropdownButton<
                              String>(

                            value:
                            selectedPayment,

                            isExpanded:
                            true,

                            items:
                            const [

                              DropdownMenuItem(
                                value:
                                "نقدي",
                                child:
                                Text(
                                  "نقدي",
                                ),
                              ),

                              DropdownMenuItem(
                                value:
                                "بطاقة",
                                child:
                                Text(
                                  "بطاقة",
                                ),
                              ),

                              DropdownMenuItem(
                                value:
                                "محفظة إلكترونية",
                                child:
                                Text(
                                  "محفظة إلكترونية",
                                ),
                              ),

                              DropdownMenuItem(
                                value:
                                "أخرى",
                                child:
                                Text(
                                  "أخرى",
                                ),
                              ),

                            ],

                            onChanged:
                                (value) {

                              if (value !=
                                  null) {

                                setState(
                                      () {

                                    selectedPayment =
                                        value;

                                  },
                                );

                              }

                            },

                          ),

                        ),

                      ),

                    ],

                  ),

                ),


                const SizedBox(
                  height: 15,
                ),


                // =========================
                // Note
                // =========================

                NoteField(

                  controller:
                  noteController,

                ),


                const SizedBox(
                  height: 18,
                ),


                // =========================
                // Save
                // =========================

                PrimaryButton(

                  title:
                  "حفظ التعديلات",

                  icon:
                  Icons.save_outlined,

                  onPressed:
                  saveChanges,

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
}