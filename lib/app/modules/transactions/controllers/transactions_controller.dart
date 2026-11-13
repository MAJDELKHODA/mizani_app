import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mizani_app/app/core/base/finance_aware_controller.dart';
import 'package:mizani_app/app/data/models/transaction_model.dart';
import 'package:mizani_app/app/routes/app_routes.dart';

class TransactionsController extends FinanceAwareController {
  static const periodToday = "اليوم";
  static const periodWeek = "الأسبوع";
  static const periodMonth = "الشهر";

  static const typeAll = "الكل";
  static const typeExpenses = "المصروفات";
  static const typeIncome = "الدخل";

  String selectedPeriod = periodToday;
  String selectedType = typeAll;

  bool get isLoading => finance.isLoading.value;

  void selectPeriod(String period) {
    selectedPeriod = period;
    update();
  }

  void selectType(String type) {
    selectedType = type;
    update();
  }

  bool matchesPeriod(DateTime date) {
    final now = DateTime.now();

    if (selectedPeriod == periodToday) {
      return DateUtils.isSameDay(date, now);
    }

    if (selectedPeriod == periodWeek) {
      final difference = now.difference(date).inDays;
      return difference >= 0 && difference <= 6;
    }

    return date.year == now.year && date.month == now.month;
  }

  bool _matchesType(TransactionModel transaction) {
    if (selectedType == typeExpenses) return transaction.isExpense;
    if (selectedType == typeIncome) return transaction.isIncome;
    return true;
  }

  List<TransactionModel> get filteredTransactions => finance.transactions
      .where((t) => matchesPeriod(t.date) && _matchesType(t))
      .toList();

  double get totalIncome => filteredTransactions
      .where((t) => t.isIncome)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpense => filteredTransactions
      .where((t) => t.isExpense)
      .fold(0.0, (sum, t) => sum + t.amount);

  void openDetails(TransactionModel transaction) =>
      Get.toNamed(Routes.transactionDetails, arguments: transaction);
}
