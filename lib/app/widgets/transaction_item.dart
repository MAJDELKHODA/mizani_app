import 'package:flutter/material.dart';
import 'package:mizani_app/app/core/theme/app_colors.dart';

class TransactionItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;

  final IconData icon;
  final Color iconColor;

  final bool isIncome;

  final String? date;

  final VoidCallback? onTap;

  const TransactionItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.icon,
    required this.iconColor,
    required this.isIncome,
    this.date,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final amountColor = isIncome ? AppColors.income : AppColors.expense;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                // =========================
                // Icon
                // =========================

                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: iconColor.withAlpha(28),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
                ),

                const SizedBox(width: 12),

                // =========================
                // Transaction Information
                // =========================

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // اسم العملية
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),

                      const SizedBox(height: 3),

                      // التصنيف / طريقة الدفع
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),

                      // =========================
                      // Date
                      // يظهر فقط إذا تم إرسال تاريخ
                      // =========================

                      if (date != null && date!.isNotEmpty) ...[
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 11,
                              color: AppColors.textMuted,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              date!,
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // =========================
                // Amount
                // =========================

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: amountColor.withAlpha(22),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "${isIncome ? '+' : '-'}$amount ₪",
                        style: TextStyle(
                          color: amountColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // سهم التفاصيل يظهر فقط
                    // إذا كانت العملية قابلة للضغط
                    if (onTap != null) ...[
                      const SizedBox(height: 6),
                      const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 12,
                        color: Color(0xFFCBD5E1),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
