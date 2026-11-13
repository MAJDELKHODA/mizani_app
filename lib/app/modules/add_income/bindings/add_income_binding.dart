import 'package:get/get.dart';
import 'package:mizani_app/app/modules/add_income/controllers/add_income_controller.dart';

class AddIncomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddIncomeController>(() => AddIncomeController());
  }
}
