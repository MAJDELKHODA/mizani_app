import 'package:flutter/material.dart';

class AmountCard extends StatelessWidget {
  final TextEditingController controller;
  final List<int> quickAmounts;
  final VoidCallback onChanged;
  final String subtitle;

  const AmountCard({
    super.key,
    required this.controller,
    required this.quickAmounts,
    required this.onChanged,
    this.subtitle = "",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "المبلغ",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),

          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xff9A91B1),
              ),
            ),
          ],

          const SizedBox(height: 10),

          Container(
            decoration: BoxDecoration(
              color: const Color(0xffF7F4FF),
              borderRadius: BorderRadius.circular(16),
            ),

            child: TextField(
              controller: controller,

              keyboardType:
              const TextInputType.numberWithOptions(
                decimal: true,
              ),

              textAlign: TextAlign.center,

              style: const TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Color(0xff6D3CE8),
              ),

              onChanged: (_) {
                onChanged();
              },

              decoration: const InputDecoration(
                border: InputBorder.none,
                suffixText: " ₪",
                suffixStyle: TextStyle(
                  color: Color(0xff958BAC),
                  fontSize: 16,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: quickAmounts.map((amount) {
              final bool selected =
                  controller.text == amount.toString();

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    controller.text = amount.toString();
                    onChanged();
                  },

                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 4,
                    ),

                    padding: const EdgeInsets.symmetric(
                      vertical: 9,
                    ),

                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xff6D3CE8)
                          : const Color(0xffF5F2FD),

                      borderRadius:
                      BorderRadius.circular(20),
                    ),

                    child: Text(
                      "$amount",
                      textAlign: TextAlign.center,

                      style: TextStyle(
                        color: selected
                            ? Colors.white
                            : const Color(0xff81779A),

                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}