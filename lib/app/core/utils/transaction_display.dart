import 'package:flutter/material.dart';
import 'package:mizani_app/app/core/constants/app_categories.dart';
import 'package:mizani_app/app/data/models/transaction_model.dart';

// =========================
// طريقة عرض العملية بالواجهة (أيقونة، لون، تفاصيل)
// =========================
extension TransactionDisplay on TransactionModel {
  IconData get icon => AppCategories.iconFor(isIncome: isIncome, name: title);

  Color get color => AppCategories.colorFor(isIncome: isIncome, name: title);

  /// "طعام • نقدي" للمصروف، المصدر للدخل
  String get details {
    if (isIncome || payment.isEmpty) return title;
    return "$category • $payment";
  }
}
