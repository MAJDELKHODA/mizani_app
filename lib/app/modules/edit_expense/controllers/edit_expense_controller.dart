import 'package:get/get.dart';
import 'package:mizani_app/app/core/base/transaction_form_controller.dart';
import 'package:mizani_app/app/core/constants/app_categories.dart';
import 'package:mizani_app/app/data/models/transaction_model.dart';

class EditExpenseController extends TransactionFormController {
  // العملية اللي بنعدّلها (من Get.arguments)
  final TransactionModel original = Get.arguments as TransactionModel;

  @override
  double get initialAmount => original.amount;

  @override
  String get initialNote => original.note;

  @override
  String get amountLabel => "مبلغ المصروف";

  late String selectedCategory = original.category;
  late String selectedPayment = original.payment.isEmpty
      ? AppCategories.paymentCash
      : original.payment;

  List<CategoryItem> get categories => AppCategories.expenseCategories;

  @override
  void onInit() {
    super.onInit();
    selectedDate = original.date;
  }

  Future<void> saveChanges() async {
    final amount = readAmount();
    if (amount == null) return;

    await runSave(
      action: () => repo.update(
        original.copyWith(
          amount: amount,
          category: selectedCategory,
          payment: selectedPayment,
          note: note,
          date: selectedDate,
        ),
      ),
      successMessage: "تم تعديل المصروف بنجاح",
      errorMessage: "حدث خطأ أثناء تعديل المصروف",
    );
  }
}
