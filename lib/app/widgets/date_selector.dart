import 'package:flutter/material.dart';
import 'package:mizani_app/app/core/theme/app_colors.dart';
import 'package:mizani_app/app/core/theme/app_styles.dart';

class DateSelector extends StatelessWidget {
  final DateTime date;
  final VoidCallback onTap;
  final String title;

  const DateSelector({
    super.key,
    required this.date,
    required this.onTap,
    this.title = "التاريخ",
  });

  String get formattedDate {
    String day = date.day.toString().padLeft(2, '0');

    String month = date.month.toString().padLeft(2, '0');

    return "$day/$month/${date.year}";
  }

  // "اليوم" / "أمس" / اسم اليوم
  String get dayLabel {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(date.year, date.month, date.day);
    final diff = today.difference(d).inDays;

    if (diff == 0) return "اليوم";
    if (diff == 1) return "أمس";

    const days = [
      "الإثنين",
      "الثلاثاء",
      "الأربعاء",
      "الخميس",
      "الجمعة",
      "السبت",
      "الأحد",
    ];

    return days[date.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppStyles.card(radius: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_month_rounded,
                size: 19,
                color: AppColors.primary,
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: AppStyles.sectionTitle,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Material(
            color: AppColors.surfaceSoft,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.primarySoft),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primarySoft,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.event_rounded,
                        color: AppColors.primary,
                        size: 21,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dayLabel,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        Text(
                          formattedDate,
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
