import 'package:get/get.dart';
import 'package:mizani_app/app/modules/edit_expense/controllers/edit_expense_controller.dart';

class EditExpenseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditExpenseController>(() => EditExpenseController());
  }
}
