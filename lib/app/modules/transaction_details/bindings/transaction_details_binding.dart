import 'package:get/get.dart';
import 'package:mizani_app/app/modules/transaction_details/controllers/transaction_details_controller.dart';

class TransactionDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransactionDetailsController>(() => TransactionDetailsController());
  }
}
