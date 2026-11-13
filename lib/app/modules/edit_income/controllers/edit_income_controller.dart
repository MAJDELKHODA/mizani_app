import 'package:get/get.dart';
import 'package:mizani_app/app/core/base/transaction_form_controller.dart';
import 'package:mizani_app/app/core/constants/app_categories.dart';
import 'package:mizani_app/app/data/models/transaction_model.dart';

class EditIncomeController extends TransactionFormController {
  // العملية اللي بنعدّلها (من Get.arguments)
  final TransactionModel original = Get.arguments as TransactionModel;

  @override
  double get initialAmount => original.amount;

  @override
  String get initialNote => original.note;

  @override
  String get amountLabel => "مبلغ الدخل";

  late String selectedSource = original.source;

  List<CategoryItem> get incomeSources => AppCategories.incomeSources;

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
          source: selectedSource,
          note: note,
          date: selectedDate,
        ),
      ),
      successMessage: "تم تعديل الدخل بنجاح",
      errorMessage: "حدث خطأ أثناء تعديل الدخل",
    );
  }
}
