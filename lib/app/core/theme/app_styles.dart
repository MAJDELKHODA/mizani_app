import 'package:flutter/material.dart';
import 'package:mizani_app/app/core/theme/app_colors.dart';

// =========================
// ستايلات مشتركة (كروت، ظلال، عناوين)
// =========================
class AppStyles {
  AppStyles._();

  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: AppColors.shadow,
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ];

  // كرت موحد لكل التطبيق (أبيض بالفاتح، غامق بالداكن)
  static BoxDecoration card({double radius = 22}) {
    return BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: AppColors.border),
      boxShadow: softShadow,
    );
  }

  static TextStyle get sectionTitle => TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      );
}
