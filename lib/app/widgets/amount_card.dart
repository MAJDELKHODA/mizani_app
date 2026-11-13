import 'package:flutter/material.dart';
import 'package:mizani_app/app/core/theme/app_colors.dart';
import 'package:mizani_app/app/core/theme/app_styles.dart';

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
      padding: const EdgeInsets.all(16),
      decoration: AppStyles.card(radius: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "المبلغ",
            style: AppStyles.sectionTitle,
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceSoft,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.primarySoft),
            ),
            child: TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textAlign: TextAlign.center,
              cursorColor: AppColors.primary,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
              onChanged: (_) {
                onChanged();
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "0",
                hintStyle: TextStyle(
                  color: AppColors.primaryBorder,
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                ),
                suffixText: " ₪",
                suffixStyle: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: quickAmounts.map((amount) {
              final bool selected = controller.text == amount.toString();

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    controller.text = amount.toString();
                    onChanged();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary
                          : AppColors.surfaceSoft,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: selected
                            ? AppColors.primary
                            : AppColors.border,
                      ),
                    ),
                    child: Text(
                      "$amount",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: selected ? Colors.white : AppColors.textDark,
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
