import 'package:mizani_app/app/core/base/transaction_form_controller.dart';
import 'package:mizani_app/app/core/constants/app_categories.dart';
import 'package:mizani_app/app/data/models/transaction_model.dart';

class AddIncomeController extends TransactionFormController {
  @override
  double get initialAmount => 500;

  @override
  String get amountLabel => "مبلغ الدخل";

  String selectedSource = "راتب";

  List<CategoryItem> get incomeSources => AppCategories.incomeSources;

  // ----- الرصيد (لحظي من FinanceService) -----
  bool get isFinancialLoading => finance.isLoading.value;
  double get totalIncome => finance.totalIncome;
  double get totalExpense => finance.totalExpense;
  double get balance => finance.balance;

  void selectSource(String name) {
    selectedSource = name;
    update();
  }

  Future<void> saveIncome() async {
    final amount = readAmount();
    if (amount == null) return;

    await runSave(
      action: () => repo.add(
        TransactionModel(
          amount: amount,
          type: AppCategories.typeIncome,
          source: selectedSource,
          note: note,
          date: selectedDate,
        ),
      ),
      successMessage: "تم حفظ الدخل بنجاح",
      errorMessage: "حدث خطأ أثناء حفظ الدخل",
    );
  }
}
