import 'package:flutter/material.dart';

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
    String day =
    date.day.toString().padLeft(2, '0');

    String month =
    date.month.toString().padLeft(2, '0');

    return "$day/$month/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calendar_month,
                size: 18,
                color: Color(0xff43318F),
              ),

              const SizedBox(width: 6),

              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          InkWell(
            onTap: onTap,

            child: Container(
              padding: const EdgeInsets.all(13),

              decoration: BoxDecoration(
                color: const Color(0xffFAF8FF),

                borderRadius:
                BorderRadius.circular(13),

                border: Border.all(
                  color: const Color(0xffEEE8FA),
                ),
              ),

              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_month,
                    color: Color(0xff6D3CE8),
                    size: 21,
                  ),

                  const SizedBox(width: 10),

                  Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [
                      const Text(
                        "اليوم",
                        style: TextStyle(
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      Text(
                        formattedDate,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xff6D3CE8),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}