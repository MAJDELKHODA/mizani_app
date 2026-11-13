import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mizani_app/app/core/base/finance_aware_controller.dart';
import 'package:mizani_app/app/core/utils/app_formatters.dart';
import 'package:mizani_app/app/core/utils/app_snackbar.dart';
import 'package:mizani_app/app/data/repositories/transaction_repository.dart';

// =========================
// أساس مشترك لشاشات إضافة وتعديل العمليات
// (المبلغ، الملاحظة، التاريخ، التحقق، الحفظ)
// =========================
abstract class TransactionFormController extends FinanceAwareController {
  final TransactionRepository repo = Get.find();

  late final TextEditingController amountController;
  late final TextEditingController noteController;

  DateTime selectedDate = DateTime.now();

  bool isSaving = false;

  /// المبلغ اللي بيطلع أول ما تفتح الشاشة
  double get initialAmount;

  String get initialNote => "";

  /// "مبلغ المصروف" / "مبلغ الدخل" برسالة التحقق
  String get amountLabel;

  @override
  void onInit() {
    super.onInit();
    amountController = TextEditingController(
      text: AppFormatters.amount(initialAmount).replaceAll(',', ''),
    );
    noteController = TextEditingController(text: initialNote);
  }

  String get note => noteController.text.trim();

  Future<void> pickDate() async {
    final context = Get.context;
    if (context == null) return;

    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (date != null) {
      selectedDate = date;
      update();
    }
  }

  /// بيرجع المبلغ لو صحيح، أو null مع رسالة
  double? readAmount() {
    final text = amountController.text.trim().replaceAll(',', '');

    if (text.isEmpty) {
      AppSnackbar.error("يرجى إدخال $amountLabel");
      return null;
    }

    final value = double.tryParse(text);

    if (value == null || value <= 0) {
      AppSnackbar.error("يرجى إدخال مبلغ صحيح");
      return null;
    }

    return value;
  }

  /// بيشغّل الحفظ مع حالة التحميل والرسائل
  Future<void> runSave({
    required Future<void> Function() action,
    required String successMessage,
    required String errorMessage,
  }) async {
    if (isSaving) return;

    isSaving = true;
    update();

    try {
      await action();
      Get.back(result: true);
      AppSnackbar.success(successMessage);
    } catch (_) {
      AppSnackbar.error(errorMessage);
    } finally {
      if (!isClosed) {
        isSaving = false;
        update();
      }
    }
  }

  @override
  void onClose() {
    amountController.dispose();
    noteController.dispose();
    super.onClose();
  }
}
