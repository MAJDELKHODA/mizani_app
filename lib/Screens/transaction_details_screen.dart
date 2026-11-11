import 'package:flutter/material.dart';

import '../Widgets/page_header.dart';
import 'edit_expense_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_income_screen.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final String transactionId;
  final String type;
  final String source;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final String time;
  final String paymentMethod;
  final String note;

  final IconData icon;
  final Color iconColor;

  const TransactionDetailsScreen({
    super.key,

    required this.transactionId,
    required this.type,
    required this.source,

    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.time,
    required this.paymentMethod,
    required this.note,
    required this.icon,
    required this.iconColor,
  });

  String get formattedDate {
    String day = date.day.toString().padLeft(2, '0');
    String month = date.month.toString().padLeft(2, '0');

    return "$day/$month/${date.year}";
  }

  Future<void> deleteTransaction(
      BuildContext context,
      ) async {

    String uid =
        FirebaseAuth.instance.currentUser!.uid;


    try {

      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("transactions")
          .doc(transactionId)
          .delete();


      if (!context.mounted) return;


      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
            "تم حذف العملية بنجاح",
          ),
        ),

      );


      Navigator.pop(context);

    }

    catch (e) {

      if (!context.mounted) return;


      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
            "حدث خطأ أثناء حذف العملية",
          ),
        ),

      );

    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,

      child: Scaffold(
        backgroundColor: const Color(0xffF7F2FF),

        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 12,
            ),

            child: Column(
              children: [

                // =========================
                // Header
                // =========================

                PageHeader(
                  title: "تفاصيل العملية",
                  subtitle: "راجع تفاصيل العملية المالية",

                  onBack: () {
                    Navigator.pop(context);
                  },
                ),

                const SizedBox(height: 18),

                // =========================
                // Main Transaction Card
                // =========================

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: const Color(0xffFFF1F3),
                    borderRadius: BorderRadius.circular(22),
                  ),

                  child: Column(
                    children: [

                      Container(
                        width: 65,
                        height: 65,

                        decoration: BoxDecoration(
                          color: iconColor.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),

                        child: Icon(
                          icon,
                          color: iconColor,
                          size: 32,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        title,

                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff241653),
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        note.isEmpty ? category : note,

                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 14),

                      Text(
                        "-${formatAmount(amount)} ₪",

                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffF45B69),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                // =========================
                // Details Card
                // =========================

                Container(
                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Column(
                    children: [

                      detailItem(
                        icon: icon,
                        iconColor: iconColor,
                        title: "التصنيف",
                        value: category,
                      ),

                      divider(),

                      detailItem(
                        icon: Icons.monetization_on_outlined,
                        iconColor: const Color(0xff6D3CE8),
                        title: "المبلغ",
                        value: "${formatAmount(amount)} ₪",
                      ),

                      divider(),

                      detailItem(
                        icon: Icons.calendar_month,
                        iconColor: const Color(0xff6D3CE8),
                        title: "التاريخ",
                        value: formattedDate,
                      ),

                      divider(),

                      detailItem(
                        icon: Icons.access_time,
                        iconColor: const Color(0xff6D3CE8),
                        title: "الوقت",
                        value: time,
                      ),

                      divider(),

                      detailItem(
                        icon: Icons.account_balance_wallet_outlined,
                        iconColor: const Color(0xff6D3CE8),
                        title: "طريقة الدفع",
                        value: paymentMethod,
                      ),

                      divider(),

                      detailItem(
                        icon: Icons.note_alt_outlined,
                        iconColor: const Color(0xff6D3CE8),
                        title: "ملاحظة",
                        value: note.isEmpty
                            ? "لا توجد ملاحظة"
                            : note,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // =========================
                // Buttons
                // =========================

                Row(
                  children: [

                    Expanded(
                      child: SizedBox(
                        height: 55,

                        child: ElevatedButton.icon(
                          onPressed: () async {

                            bool? updated;


                            // =========================
                            // تعديل المصروف
                            // =========================

                            if (type == "expense") {

                              updated =
                              await Navigator.push(

                                context,

                                MaterialPageRoute(

                                  builder: (_) =>
                                      EditExpenseScreen(

                                        transactionId:
                                        transactionId,

                                        initialAmount:
                                        amount,

                                        initialCategory:
                                        category,

                                        initialDate:
                                        date,

                                        initialPaymentMethod:
                                        paymentMethod,

                                        initialNote:
                                        note,

                                      ),

                                ),

                              );

                            }


                            // =========================
                            // تعديل الدخل
                            // =========================

                            else if (type == "income") {

                              updated =
                              await Navigator.push(

                                context,

                                MaterialPageRoute(

                                  builder: (_) =>
                                      EditIncomeScreen(

                                        transactionId:
                                        transactionId,

                                        initialAmount:
                                        amount,

                                        initialSource:
                                        source,

                                        initialDate:
                                        date,

                                        initialNote:
                                        note,

                                      ),

                                ),

                              );

                            }


                            // =========================
                            // إذا صار تعديل
                            // ارجع لقائمة العمليات
                            // =========================

                            if (updated == true) {

                              Navigator.pop(context);

                            }

                          },

                          icon: const Icon(
                            Icons.edit_outlined,
                            color: Color(0xff6D3CE8),
                          ),

                          label: const Text(
                            "تعديل العملية",

                            style: TextStyle(
                              color: Color(0xff6D3CE8),
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor:
                            const Color(0xffEEE7FF),

                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(17),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: SizedBox(
                        height: 55,

                        child: ElevatedButton.icon(
                          onPressed: () {
                            showDeleteDialog(context);
                          },

                          icon: const Icon(
                            Icons.delete_outline,
                            color: Color(0xffF45B69),
                          ),

                          label: const Text(
                            "حذف العملية",

                            style: TextStyle(
                              color: Color(0xffF45B69),
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor:
                            const Color(0xffFFF0F2),

                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(17),
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),

                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =========================
  // Detail Item
  // =========================

  Widget detailItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),

      child: Row(
        children: [

          Container(
            width: 42,
            height: 42,

            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(
              icon,
              color: iconColor,
              size: 21,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(
                  title,

                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  value,

                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff241653),
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget divider() {
    return Divider(
      height: 1,
      color: Colors.grey.shade200,
    );
  }

  String formatAmount(double value) {
    if (value % 1 == 0) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(2);
  }

  // =========================
  // Delete Dialog
  // =========================

  void showDeleteDialog(
      BuildContext context,
      ) {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text(
            "حذف العملية",
          ),

          content: const Text(
            "هل أنت متأكد أنك تريد حذف هذه العملية؟",
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text(
                "إلغاء",
              ),
            ),

            TextButton(

              onPressed: () async {

                Navigator.pop(context);

                await deleteTransaction(context);

              },

              child: const Text(

                "حذف",

                style: TextStyle(
                  color: Colors.red,
                ),

              ),

            ),

          ],
        );
      },
    );
  }
}