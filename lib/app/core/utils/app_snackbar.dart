import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mizani_app/app/core/theme/app_colors.dart';

// =========================
// رسائل السناك بار الموحدة
// =========================
class AppSnackbar {
  AppSnackbar._();

  static void show(String message, {bool success = false}) {
    final context = Get.context;
    if (context == null) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          backgroundColor: success
              ? const Color(0xFF047857)
              : (AppColors.isDark ? AppColors.surfaceSoft : AppColors.textDark),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: Row(
            children: [
              Icon(
                success
                    ? Icons.check_circle_rounded
                    : Icons.error_outline_rounded,
                color: success ? AppColors.incomeLight : AppColors.expenseLight,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
  }

  static void success(String message) => show(message, success: true);

  static void error(String message) => show(message);
}
