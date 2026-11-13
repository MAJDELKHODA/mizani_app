import 'package:mizani_app/app/core/base/transaction_form_controller.dart';
import 'package:mizani_app/app/core/constants/app_categories.dart';
import 'package:mizani_app/app/data/models/transaction_model.dart';

class AddExpenseController extends TransactionFormController {
  @override
  double get initialAmount => 50;

  @override
  String get amountLabel => "مبلغ المصروف";

  String selectedCategory = "طعام";
  String selectedPayment = AppCategories.paymentCash;

  List<CategoryItem> get categories => AppCategories.expenseCategories;

  // ----- الميزانية (لحظية من FinanceService) -----
  bool get isBudgetLoading => finance.isLoading.value;
  bool get hasBudget => finance.hasBudget;
  double get budgetAmount => finance.budgetAmount;
  double get budgetSpent => finance.budgetSpent;
  double get budgetRemaining =>
      finance.budgetRemaining < 0 ? 0 : finance.budgetRemaining;
  double get budgetProgress => finance.budgetProgress;
  String get budgetPeriod => finance.budgetPeriod;

  void selectCategory(String name) {
    selectedCategory = name;
    update();
  }

  void selectPayment(String payment) {
    selectedPayment = payment;
    update();
  }

  Future<void> saveExpense() async {
    final amount = readAmount();
    if (amount == null) return;

    await runSave(
      action: () => repo.add(
        TransactionModel(
          amount: amount,
          type: AppCategories.typeExpense,
          category: selectedCategory,
          payment: selectedPayment,
          note: note,
          date: selectedDate,
        ),
      ),
      successMessage: "تم حفظ المصروف بنجاح",
      errorMessage: "حدث خطأ أثناء حفظ المصروف",
    );
  }
}
