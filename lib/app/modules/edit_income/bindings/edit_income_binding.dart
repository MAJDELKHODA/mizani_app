import 'package:get/get.dart';
import 'package:mizani_app/app/modules/edit_income/controllers/edit_income_controller.dart';

class EditIncomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditIncomeController>(() => EditIncomeController());
  }
}
