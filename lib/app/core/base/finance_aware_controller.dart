import 'package:get/get.dart';
import 'package:mizani_app/app/data/services/finance_service.dart';

// =========================
// أساس للـ Controllers اللي بتعرض بيانات مالية
// أي تغيير بالعمليات أو الميزانية أو المستخدم ← update() تلقائي
// فالشاشات اللي بتستخدم GetBuilder بتتحدث لحالها
// =========================
abstract class FinanceAwareController extends GetxController {
  final FinanceService finance = FinanceService.to;

  final List<Worker> _workers = [];

  @override
  void onInit() {
    super.onInit();
    _workers.addAll([
      ever(finance.transactions, (_) => update()),
      ever(finance.budget, (_) => update()),
      ever(finance.user, (_) => update()),
      ever(finance.isLoading, (_) => update()),
      ever(finance.isUserLoading, (_) => update()),
    ]);
  }

  @override
  void onClose() {
    for (final worker in _workers) {
      worker.dispose();
    }
    super.onClose();
  }
}
