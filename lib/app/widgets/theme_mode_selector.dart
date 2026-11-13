import 'package:flutter/material.dart';
import 'package:mizani_app/app/core/theme/app_colors.dart';
import 'package:mizani_app/app/core/theme/app_styles.dart';
import 'package:get/get.dart';
import 'package:mizani_app/app/data/services/theme_service.dart';

// =========================
// اختيار مظهر التطبيق: فاتح / داكن / تلقائي
// =========================
class ThemeModeSelector extends StatelessWidget {
  const ThemeModeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
        final mode = ThemeService.to.mode.value;

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: AppStyles.card(radius: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      AppColors.isDark
                          ? Icons.dark_mode_rounded
                          : Icons.light_mode_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "مظهر التطبيق",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        Text(
                          "اختر الوضع الفاتح أو الداكن",
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    _option(
                      label: "فاتح",
                      icon: Icons.light_mode_outlined,
                      value: ThemeMode.light,
                      selected: mode,
                    ),
                    _option(
                      label: "داكن",
                      icon: Icons.dark_mode_outlined,
                      value: ThemeMode.dark,
                      selected: mode,
                    ),
                    _option(
                      label: "تلقائي",
                      icon: Icons.brightness_auto_outlined,
                      value: ThemeMode.system,
                      selected: mode,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
    });
  }

  Widget _option({
    required String label,
    required IconData icon,
    required ThemeMode value,
    required ThemeMode selected,
  }) {
    final isSelected = value == selected;

    return Expanded(
      child: GestureDetector(
        onTap: () => ThemeService.to.setMode(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.card : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
            boxShadow: isSelected ? AppStyles.softShadow : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? AppColors.primary : AppColors.textMuted,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? AppColors.primary : AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
