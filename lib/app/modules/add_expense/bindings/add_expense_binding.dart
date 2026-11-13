import 'package:get/get.dart';
import 'package:mizani_app/app/modules/add_expense/controllers/add_expense_controller.dart';

class AddExpenseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddExpenseController>(() => AddExpenseController());
  }
}
