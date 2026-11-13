import 'package:flutter/material.dart';
import 'package:mizani_app/app/core/base/finance_aware_controller.dart';
import 'package:mizani_app/app/core/constants/app_categories.dart';
import 'package:mizani_app/app/core/theme/app_colors.dart';
import 'package:mizani_app/app/core/utils/app_formatters.dart';
import 'package:mizani_app/app/data/models/transaction_model.dart';

class ReportsController extends FinanceAwareController {
  DateTime selectedMonthDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
  );

  // ----- نتائج الشهر المختار -----
  double totalIncome = 0;
  double totalExpense = 0;
  double netSaving = 0;
  Map<String, double> categoryTotals = {};
  String topCategory = "لا يوجد";
  String highestExpenseDay = "لا يوجد";
  double monthComparison = 0;
  bool hasPreviousMonthExpense = false;

  /// آخر 3 شهور: {"month": "نوفمبر", "income": 0.0, "expense": 0.0}
  List<Map<String, dynamic>> comparisonMonths = [];

  String errorMessage = "";

  // ----- البيانات (لحظية من FinanceService) -----
  bool get isLoading => finance.isLoading.value;
  List<TransactionModel> get transactions => finance.transactions;

  bool get hasBudget => finance.hasBudget;
  double get budgetAmount => finance.budgetAmount;
  double get budgetSpent => finance.budgetSpent;
  double get budgetProgress => finance.budgetProgress;
  String get budgetPeriod => finance.budgetPeriod;

  @override
  void onInit() {
    super.onInit();
    calculateReport();
  }

  // أي تغيير بالبيانات ← نعيد الحساب قبل إعادة الرسم
  @override
  void update([List<Object>? ids, bool condition = true]) {
    calculateReport();
    super.update(ids, condition);
  }

  void loadReportsData() => update();

  void previousMonth() {
    selectedMonthDate = DateTime(
      selectedMonthDate.year,
      selectedMonthDate.month - 1,
    );
    update();
  }

  void nextMonth() {
    selectedMonthDate = DateTime(
      selectedMonthDate.year,
      selectedMonthDate.month + 1,
    );
    update();
  }

  bool _isSameMonth(DateTime date, DateTime month) =>
      date.year == month.year && date.month == month.month;

  void calculateReport() {
    double income = 0;
    double expense = 0;
    final categories = <String, double>{};
    final dailyExpenses = <DateTime, double>{};

    for (final transaction in transactions) {
      if (!_isSameMonth(transaction.date, selectedMonthDate)) continue;

      if (transaction.isIncome) {
        income += transaction.amount;
      } else if (transaction.isExpense) {
        expense += transaction.amount;

        final category =
            transaction.category.isEmpty ? "أخرى" : transaction.category;
        categories[category] = (categories[category] ?? 0) + transaction.amount;

        final day = DateUtils.dateOnly(transaction.date);
        dailyExpenses[day] = (dailyExpenses[day] ?? 0) + transaction.amount;
      }
    }

    totalIncome = income;
    totalExpense = expense;
    netSaving = income - expense;
    categoryTotals = categories;

    topCategory = categories.isEmpty
        ? "لا يوجد"
        : categories.entries.reduce((a, b) => b.value > a.value ? b : a).key;

    highestExpenseDay = dailyExpenses.isEmpty
        ? "لا يوجد"
        : AppFormatters.dayMonth(
            dailyExpenses.entries
                .reduce((a, b) => b.value > a.value ? b : a)
                .key,
          );

    // المقارنة مع الشهر السابق
    final previousMonthDate = DateTime(
      selectedMonthDate.year,
      selectedMonthDate.month - 1,
    );

    final previousExpense = transactions
        .where((t) => t.isExpense && _isSameMonth(t.date, previousMonthDate))
        .fold(0.0, (sum, t) => sum + t.amount);

    hasPreviousMonthExpense = previousExpense > 0;
    monthComparison = hasPreviousMonthExpense
        ? ((expense - previousExpense) / previousExpense) * 100
        : 0;

    // آخر 3 شهور للرسم البياني
    comparisonMonths = [];

    for (int i = 2; i >= 0; i--) {
      final month = DateTime(
        selectedMonthDate.year,
        selectedMonthDate.month - i,
      );

      double monthIncome = 0;
      double monthExpense = 0;

      for (final transaction in transactions) {
        if (!_isSameMonth(transaction.date, month)) continue;

        if (transaction.isIncome) {
          monthIncome += transaction.amount;
        } else if (transaction.isExpense) {
          monthExpense += transaction.amount;
        }
      }

      comparisonMonths.add({
        "month": AppFormatters.monthName(month.month),
        "income": monthIncome,
        "expense": monthExpense,
      });
    }
  }

  // ----- قيم محسوبة للعرض -----

  List<MapEntry<String, double>> get sortedCategories {
    final list = categoryTotals.entries.toList();
    list.sort((a, b) => b.value.compareTo(a.value));
    return list;
  }

  /// أكبر قيمة بالرسم البياني (مقرّبة لأعلى 500)
  double get chartMaxY {
    double highest = 0;

    for (final month in comparisonMonths) {
      final income = month["income"] as double;
      final expense = month["expense"] as double;
      if (income > highest) highest = income;
      if (expense > highest) highest = expense;
    }

    if (highest < 500) return 500;

    return ((highest / 500).ceil() * 500).toDouble();
  }

  /// المسافة بين خطوط الرسم البياني
  double get chartInterval => chartMaxY / 4;

  /// "+12%" / "-5%" / "لا يوجد"
  String get comparisonText {
    if (!hasPreviousMonthExpense) return "لا يوجد";

    final value = monthComparison.toStringAsFixed(0);
    return monthComparison > 0 ? "+$value%" : "$value%";
  }

  /// زاد الصرف = أحمر، قل = أخضر
  Color get comparisonColor {
    if (!hasPreviousMonthExpense) return AppColors.primary;
    if (monthComparison > 0) return AppColors.expense;
    if (monthComparison < 0) return AppColors.income;
    return AppColors.primary;
  }

  // ----- مساعدات العرض -----

  Color getCategoryColor(String category) =>
      AppCategories.expense(category).color;

  IconData getCategoryIcon(String category) =>
      AppCategories.expense(category).icon;

  String getMonthName(int month) => AppFormatters.monthName(month);

  String formatChartNumber(double value) {
    if (value >= 1000) {
      final thousands = value / 1000;
      return thousands % 1 == 0
          ? "${thousands.toInt()}k"
          : "${thousands.toStringAsFixed(1)}k";
    }
    return value.toInt().toString();
  }
}
