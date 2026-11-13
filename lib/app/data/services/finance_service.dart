import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mizani_app/app/data/models/budget_model.dart';
import 'package:mizani_app/app/data/models/transaction_model.dart';
import 'package:mizani_app/app/data/models/user_model.dart';
import 'package:mizani_app/app/data/repositories/budget_repository.dart';
import 'package:mizani_app/app/data/repositories/transaction_repository.dart';
import 'package:mizani_app/app/data/repositories/user_repository.dart';

// =========================
// مصدر واحد لبيانات المستخدم المالية
// بيسمع لـ Firestore لحظياً، فأي إضافة/تعديل/حذف بتنعكس فوراً
// على الهوم والميزانية والتقارير بدون إعادة تحميل يدوي
// =========================
class FinanceService extends GetxService {
  static FinanceService get to => Get.find();

  final TransactionRepository _transactionRepo;
  final BudgetRepository _budgetRepo;
  final UserRepository _userRepo;

  FinanceService(this._transactionRepo, this._budgetRepo, this._userRepo);

  final transactions = <TransactionModel>[].obs;
  final budget = Rxn<BudgetModel>();
  final user = Rxn<UserModel>();

  final isLoading = true.obs;
  final isUserLoading = true.obs;

  StreamSubscription<User?>? _authSub;
  final List<StreamSubscription> _dataSubs = [];

  @override
  void onInit() {
    super.onInit();
    _authSub = FirebaseAuth.instance.authStateChanges().listen(_onAuthChanged);
  }

  void _onAuthChanged(User? firebaseUser) {
    _cancelDataSubs();
    transactions.clear();
    budget.value = null;
    user.value = null;

    if (firebaseUser == null) {
      isLoading.value = false;
      isUserLoading.value = false;
      return;
    }

    isLoading.value = true;
    isUserLoading.value = true;
    final uid = firebaseUser.uid;

    _dataSubs.addAll([
      _transactionRepo.watchAll(uid).listen(
        (list) {
          transactions.assignAll(list);
          isLoading.value = false;
        },
        onError: (_) => isLoading.value = false,
      ),
      _budgetRepo.watch(uid).listen(
            (value) => budget.value = value,
            onError: (_) {},
          ),
      _userRepo.watch(uid).listen(
        (value) {
          user.value = value;
          isUserLoading.value = false;
        },
        onError: (_) => isUserLoading.value = false,
      ),
    ]);
  }

  void _cancelDataSubs() {
    for (final sub in _dataSubs) {
      sub.cancel();
    }
    _dataSubs.clear();
  }

  @override
  void onClose() {
    _authSub?.cancel();
    _cancelDataSubs();
    super.onClose();
  }

  // =========================
  // الأرقام العامة
  // =========================

  String get userName => user.value?.name ?? "";

  String get userEmail => user.value?.email ?? "";

  double get totalIncome => transactions
      .where((t) => t.isIncome)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpense => transactions
      .where((t) => t.isExpense)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get balance => totalIncome - totalExpense;

  List<TransactionModel> recent([int count = 3]) =>
      transactions.take(count).toList();

  // =========================
  // الميزانية
  // =========================

  bool get hasBudget => budget.value != null;

  double get budgetAmount => budget.value?.amount ?? 0;

  String get budgetPeriod => budget.value?.period ?? "";

  /// المصروف داخل فترة الميزانية الحالية
  double get budgetSpent {
    final current = budget.value;
    if (current == null) return 0;

    return transactions
        .where((t) => t.isExpense && current.containsDate(t.date))
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  /// ممكن يطلع بالسالب لو تجاوز الميزانية
  double get budgetRemaining => budgetAmount - budgetSpent;

  /// من 0 لـ 1
  double get budgetProgress {
    if (budgetAmount <= 0) return 0;
    return (budgetSpent / budgetAmount).clamp(0.0, 1.0).toDouble();
  }
}
