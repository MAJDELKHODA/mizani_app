import 'package:flutter/material.dart';
import 'package:mizani_app/app/core/theme/app_colors.dart';

// =========================
// عنصر قابل للاختيار (تصنيف / مصدر دخل)
// =========================
class CategoryItem {
  final String name;
  final IconData icon;
  final Color color;

  const CategoryItem({
    required this.name,
    required this.icon,
    required this.color,
  });
}

// =========================
// كل التصنيفات ومصادر الدخل وطرق الدفع بمكان واحد
// =========================
class AppCategories {
  AppCategories._();

  static const String typeIncome = "income";
  static const String typeExpense = "expense";

  // ----- تصنيفات المصاريف -----
  static List<CategoryItem> get expenseCategories => [
        const CategoryItem(
          name: "طعام",
          icon: Icons.restaurant,
          color: Color(0xffFF9C55),
        ),
        const CategoryItem(
          name: "مواصلات",
          icon: Icons.directions_car,
          color: Color(0xff3B82F6),
        ),
        CategoryItem(
          name: "تسوق",
          icon: Icons.shopping_cart,
          color: AppColors.primaryDark,
        ),
        const CategoryItem(
          name: "منزل",
          icon: Icons.home,
          color: Color(0xffFF9B50),
        ),
        const CategoryItem(
          name: "ملابس",
          icon: Icons.checkroom,
          color: Color(0xff3498DB),
        ),
        CategoryItem(
          name: "صحة",
          icon: Icons.favorite,
          color: AppColors.expense,
        ),
        const CategoryItem(
          name: "تجميل",
          icon: Icons.spa,
          color: Color(0xffE85C9C),
        ),
        const CategoryItem(
          name: "فواتير",
          icon: Icons.receipt_long,
          color: Color(0xff4ABAD5),
        ),
        const CategoryItem(
          name: "تعليم",
          icon: Icons.school,
          color: Color(0xff8E7CC3),
        ),
        const CategoryItem(
          name: "ترفيه",
          icon: Icons.sports_esports,
          color: Color(0xff14B8A6),
        ),
        CategoryItem(
          name: "هدايا",
          icon: Icons.card_giftcard,
          color: AppColors.expenseLight,
        ),
        CategoryItem(
          name: "أخرى",
          icon: Icons.more_horiz,
          color: AppColors.textMuted,
        ),
      ];

  // ----- مصادر الدخل -----
  static List<CategoryItem> get incomeSources => [
        const CategoryItem(
          name: "راتب",
          icon: Icons.work,
          color: Color(0xff2474E5),
        ),
        const CategoryItem(
          name: "عمل حر",
          icon: Icons.laptop_mac,
          color: Color(0xff5266D6),
        ),
        CategoryItem(
          name: "هدية",
          icon: Icons.card_giftcard,
          color: AppColors.expenseLight,
        ),
        const CategoryItem(
          name: "مكافأة",
          icon: Icons.emoji_events,
          color: Color(0xffF5A623),
        ),
        CategoryItem(
          name: "استثمار",
          icon: Icons.trending_up,
          color: AppColors.income,
        ),
        CategoryItem(
          name: "أخرى",
          icon: Icons.more_horiz,
          color: AppColors.textMuted,
        ),
      ];

  // ----- طرق الدفع -----
  static const String paymentCash = "نقدي";
  static const String paymentCard = "بطاقة";

  static CategoryItem _find(List<CategoryItem> list, String name) {
    return list.firstWhere(
      (item) => item.name == name,
      orElse: () => list.last,
    );
  }

  static CategoryItem expense(String name) => _find(expenseCategories, name);

  static CategoryItem income(String name) => _find(incomeSources, name);

  /// أيقونة أي عملية حسب نوعها
  static IconData iconFor({required bool isIncome, required String name}) =>
      isIncome ? income(name).icon : expense(name).icon;

  /// لون أي عملية حسب نوعها
  static Color colorFor({required bool isIncome, required String name}) =>
      isIncome ? income(name).color : expense(name).color;
}
