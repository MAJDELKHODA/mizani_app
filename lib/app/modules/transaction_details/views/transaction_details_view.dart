import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mizani_app/app/core/theme/app_colors.dart';
import 'package:mizani_app/app/core/theme/app_styles.dart';
import 'package:mizani_app/app/core/utils/app_formatters.dart';
import 'package:mizani_app/app/widgets/page_header.dart';
import 'package:mizani_app/app/modules/transaction_details/controllers/transaction_details_controller.dart';

class TransactionDetailsView extends GetView<TransactionDetailsController> {
  const TransactionDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TransactionDetailsController>(
      builder: (_) => _buildPage(context),
    );
  }

  Widget _buildPage(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,

      child: Scaffold(
        backgroundColor: AppColors.background,

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
                    Get.back();
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
                    color: AppColors.expenseSoft,
                    borderRadius: BorderRadius.circular(22),
                  ),

                  child: Column(
                    children: [

                      Container(
                        width: 65,
                        height: 65,

                        decoration: BoxDecoration(
                          color: controller.iconColor.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),

                        child: Icon(
                          controller.icon,
                          color: controller.iconColor,
                          size: 32,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        controller.title,

                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        controller.note.isEmpty ? controller.category : controller.note,

                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 14),

                      Text(
                        "-${AppFormatters.amount(controller.amount)} ₪",

                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.expense,
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
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(20),
  border: Border.all(color: AppColors.border),
  boxShadow: AppStyles.softShadow,
),

                  child: Column(
                    children: [

                      detailItem(
                        icon: controller.icon,
                        iconColor: controller.iconColor,
                        title: "التصنيف",
                        value: controller.category,
                      ),

                      divider(),

                      detailItem(
                        icon: Icons.monetization_on_outlined,
                        iconColor: AppColors.primary,
                        title: "المبلغ",
                        value: "${AppFormatters.amount(controller.amount)} ₪",
                      ),

                      divider(),

                      detailItem(
                        icon: Icons.calendar_month,
                        iconColor: AppColors.primary,
                        title: "التاريخ",
                        value: controller.formattedDate,
                      ),

                      divider(),

                      detailItem(
                        icon: Icons.access_time,
                        iconColor: AppColors.primary,
                        title: "الوقت",
                        value: controller.time,
                      ),

                      divider(),

                      detailItem(
                        icon: Icons.account_balance_wallet_outlined,
                        iconColor: AppColors.primary,
                        title: "طريقة الدفع",
                        value: controller.paymentMethod,
                      ),

                      divider(),

                      detailItem(
                        icon: Icons.note_alt_outlined,
                        iconColor: AppColors.primary,
                        title: "ملاحظة",
                        value: controller.note.isEmpty
                            ? "لا توجد ملاحظة"
                            : controller.note,
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
                          onPressed: controller.edit,

                          icon: Icon(
                            Icons.edit_outlined,
                            color: AppColors.primary,
                          ),

                          label: Text(
                            "تعديل العملية",

                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor:
                            AppColors.primarySoft,

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

                          icon: Icon(
                            Icons.delete_outline,
                            color: AppColors.expense,
                          ),

                          label: Text(
                            "حذف العملية",

                            style: TextStyle(
                              color: AppColors.expense,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor:
                            AppColors.expenseSoft,

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
              color: iconColor.withValues(alpha: 0.10),
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

                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  value,

                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
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
      color: AppColors.border,
    );
  }

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
                Get.back();
              },

              child: const Text(
                "إلغاء",
              ),
            ),

            TextButton(

              onPressed: () async {

                Get.back();

                await controller.delete();

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
