import 'package:flutter/material.dart';

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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),

      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),

        child: Row(
          children: [

            // =========================
            // Icon
            // =========================

            Container(
              width: 45,
              height: 45,

              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.10),
                borderRadius: BorderRadius.circular(13),
              ),

              child: Icon(
                icon,
                color: iconColor,
                size: 23,
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

                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff241653),
                    ),
                  ),


                  const SizedBox(height: 4),


                  // التصنيف / طريقة الدفع

                  Text(
                    subtitle,

                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
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

                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 11,
                          color: Colors.grey,
                        ),

                        const SizedBox(width: 5),

                        Text(
                          date!,

                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),

                      ],
                    ),

                  ],

                ],
              ),
            ),


            // =========================
            // Amount
            // =========================

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,

              children: [

                Text(
                  "${isIncome ? '+' : '-'}$amount ₪",

                  style: TextStyle(
                    color: isIncome
                        ? const Color(0xff20B875)
                        : const Color(0xffF45B69),

                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),


                const SizedBox(height: 6),


                // سهم التفاصيل يظهر فقط
                // إذا كانت العملية قابلة للضغط

                if (onTap != null)
                  Icon(
                    Icons.arrow_back_ios_new,
                    size: 12,
                    color: Colors.grey.shade400,
                  ),

              ],
            ),

          ],
        ),
      ),
    );
  }
}