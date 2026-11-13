import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mizani_app/app/core/base/finance_aware_controller.dart';
import 'package:mizani_app/app/core/utils/app_formatters.dart';
import 'package:mizani_app/app/core/utils/app_snackbar.dart';
import 'package:mizani_app/app/core/utils/transaction_display.dart';
import 'package:mizani_app/app/data/models/transaction_model.dart';
import 'package:mizani_app/app/data/repositories/transaction_repository.dart';
import 'package:mizani_app/app/routes/app_routes.dart';

class TransactionDetailsController extends FinanceAwareController {
  final TransactionRepository _repo = Get.find();

  // العملية اللي انفتحت (من Get.arguments)
  late final TransactionModel _initial = Get.arguments as TransactionModel;

  /// النسخة الأحدث من العملية (بتتحدث لحالها بعد التعديل)
  TransactionModel get transaction =>
      finance.transactions.firstWhereOrNull((t) => t.id == _initial.id) ??
      _initial;

  // ----- القيم المعروضة -----
  String get transactionId => transaction.id;
  String get type => transaction.type;
  String get source => transaction.source;
  String get title => transaction.title;
  double get amount => transaction.amount;
  String get category => transaction.title;
  DateTime get date => transaction.date;
  String get time => AppFormatters.time(transaction.createdAt);
  String get paymentMethod => transaction.isIncome ? "-" : transaction.payment;
  String get note => transaction.note;
  IconData get icon => transaction.icon;
  Color get iconColor => transaction.color;
  String get formattedDate => AppFormatters.date(transaction.date);

  void edit() {
    Get.toNamed(
      transaction.isIncome ? Routes.editIncome : Routes.editExpense,
      arguments: transaction,
    );
  }

  Future<void> delete() async {
    try {
      await _repo.delete(transaction.id);
      Get.back();
      AppSnackbar.success("تم حذف العملية بنجاح");
    } catch (_) {
      AppSnackbar.error("حدث خطأ أثناء حذف العملية");
    }
  }
}
