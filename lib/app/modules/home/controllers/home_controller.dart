import 'package:get/get.dart';
import 'package:mizani_app/app/data/models/transaction_model.dart';
import 'package:mizani_app/app/data/services/finance_service.dart';
import 'package:mizani_app/app/routes/app_routes.dart';

class HomeController extends GetxController {
  final FinanceService _finance = FinanceService.to;

  final isBalanceHidden = false.obs; // إخفاء / إظهار الرصيد

  // =========================
  // البيانات (بتتحدث لحالها من FinanceService)
  // =========================

  bool get isHomeLoading =>
      _finance.isLoading.value || _finance.isUserLoading.value;

  String get userName => _finance.userName;

  double get balance => _finance.balance;

  double get totalIncome => _finance.totalIncome;

  double get totalExpense => _finance.totalExpense;

  bool get hasBudget => _finance.hasBudget;

  double get budgetAmount => _finance.budgetAmount;

  double get budgetSpent => _finance.budgetSpent;

  double get budgetRemaining => _finance.budgetRemaining;

  double get budgetProgress => _finance.budgetProgress;

  String get budgetPeriod => _finance.budgetPeriod;

  List<TransactionModel> get recentTransactions => _finance.recent(3);

  // =========================
  // Actions
  // =========================

  void toggleBalance() => isBalanceHidden.toggle();

  void openAddExpense() => Get.toNamed(Routes.addExpense);

  void openAddIncome() => Get.toNamed(Routes.addIncome);

  void openBudget() => Get.toNamed(Routes.budget);

  void openTransactions() => Get.toNamed(Routes.transactions);

  void openReports() => Get.toNamed(Routes.reports);

  void openProfile() => Get.toNamed(Routes.profile);

  void openDetails(TransactionModel transaction) =>
      Get.toNamed(Routes.transactionDetails, arguments: transaction);
}
