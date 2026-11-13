import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mizani_app/app/core/base/finance_aware_controller.dart';
import 'package:mizani_app/app/core/utils/app_snackbar.dart';
import 'package:mizani_app/app/data/models/budget_model.dart';
import 'package:mizani_app/app/data/repositories/budget_repository.dart';

class BudgetPeriodOption {
  final String name;
  final IconData icon;
  final String desc;

  const BudgetPeriodOption({
    required this.name,
    required this.icon,
    required this.desc,
  });
}

class BudgetController extends FinanceAwareController {
  final BudgetRepository _repo = Get.find();

  final budgetController = TextEditingController(text: "200");

  String selectedPeriod = BudgetModel.daily;
  bool enableAlert = true;
  double alertPercent = 80;
  DateTime startDate = DateTime.now();
  bool isSaving = false;

  final List<BudgetPeriodOption> budgetTypes = const [
    BudgetPeriodOption(
      name: BudgetModel.daily,
      icon: Icons.today,
      desc: "لإدارة مصروفك اليومي",
    ),
    BudgetPeriodOption(
      name: BudgetModel.weekly,
      icon: Icons.date_range,
      desc: "لإدارة مصروفك الأسبوعي",
    ),
    BudgetPeriodOption(
      name: BudgetModel.monthly,
      icon: Icons.calendar_month,
      desc: "لإدارة مصروفك الشهري",
    ),
  ];

  // ----- الميزانية الحالية (لحظية من FinanceService) -----
  bool get isCurrentBudgetLoading => finance.isLoading.value;
  bool get hasCurrentBudget => finance.hasBudget;
  double get currentBudgetAmount => finance.budgetAmount;
  String get currentBudgetPeriod => finance.budgetPeriod;

  @override
  void onInit() {
    super.onInit();

    // لو في ميزانية محفوظة، نعبّي الفورم بقيمها
    final current = finance.budget.value;
    if (current != null) {
      budgetController.text = current.amount
          .toStringAsFixed(current.amount % 1 == 0 ? 0 : 2);
      selectedPeriod = current.period;
      enableAlert = current.enableAlert;
      alertPercent = current.alertPercent;
      startDate = current.startDate;
    }
  }

  Future<void> pickDate() async {
    final context = Get.context;
    if (context == null) return;

    final date = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (date != null) {
      startDate = date;
      update();
    }
  }

  Future<void> saveBudget() async {
    final text = budgetController.text.trim();

    if (text.isEmpty) {
      AppSnackbar.error("يرجى إدخال مبلغ الميزانية");
      return;
    }

    final value = double.tryParse(text);

    if (value == null || value <= 0) {
      AppSnackbar.error("يرجى إدخال مبلغ صحيح");
      return;
    }

    if (isSaving) return;
    isSaving = true;
    update();

    try {
      await _repo.save(
        BudgetModel(
          amount: value,
          period: selectedPeriod,
          startDate: startDate,
          enableAlert: enableAlert,
          alertPercent: alertPercent,
        ),
      );
      Get.back();
      AppSnackbar.success("تم حفظ الميزانية بنجاح");
    } catch (_) {
      AppSnackbar.error("حدث خطأ أثناء حفظ الميزانية");
    } finally {
      if (!isClosed) {
        isSaving = false;
        update();
      }
    }
  }

  @override
  void onClose() {
    budgetController.dispose();
    super.onClose();
  }
}
