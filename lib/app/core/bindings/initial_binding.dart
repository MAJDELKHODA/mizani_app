import 'package:get/get.dart';
import 'package:mizani_app/app/data/repositories/auth_repository.dart';
import 'package:mizani_app/app/data/repositories/budget_repository.dart';
import 'package:mizani_app/app/data/repositories/transaction_repository.dart';
import 'package:mizani_app/app/data/repositories/user_repository.dart';
import 'package:mizani_app/app/data/services/finance_service.dart';

// =========================
// الحاجات اللي بتعيش طول عمر التطبيق
// =========================
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Repositories
    Get.lazyPut<AuthRepository>(() => AuthRepository(), fenix: true);
    Get.lazyPut<TransactionRepository>(
      () => TransactionRepository(),
      fenix: true,
    );
    Get.lazyPut<BudgetRepository>(() => BudgetRepository(), fenix: true);
    Get.lazyPut<UserRepository>(() => UserRepository(), fenix: true);

    // مصدر البيانات المالية المشترك
    Get.put<FinanceService>(
      FinanceService(Get.find(), Get.find(), Get.find()),
      permanent: true,
    );
  }
}
