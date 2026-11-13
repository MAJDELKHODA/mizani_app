import 'package:cloud_firestore/cloud_firestore.dart';

// =========================
// الميزانية الحالية
// users/{uid}/budget/current
// =========================
class BudgetModel {
  static const String daily = "يومية";
  static const String weekly = "أسبوعية";
  static const String monthly = "شهرية";

  final double amount;
  final String period; // يومية | أسبوعية | شهرية
  final DateTime startDate;
  final bool enableAlert;
  final double alertPercent;

  const BudgetModel({
    required this.amount,
    required this.period,
    required this.startDate,
    this.enableAlert = true,
    this.alertPercent = 80,
  });

  /// بداية الفترة (بدون ساعات)
  DateTime get periodStart =>
      DateTime(startDate.year, startDate.month, startDate.day);

  /// نهاية الفترة (غير شاملة)
  DateTime get periodEnd {
    final start = periodStart;

    if (period == daily) return start.add(const Duration(days: 1));
    if (period == weekly) return start.add(const Duration(days: 7));

    return DateTime(start.year, start.month + 1, start.day);
  }

  bool containsDate(DateTime date) =>
      !date.isBefore(periodStart) && date.isBefore(periodEnd);

  static BudgetModel? fromMap(Map<String, dynamic>? data) {
    if (data == null) return null;

    final amount = (data["amount"] as num?)?.toDouble() ?? 0;
    final start = data["startDate"];

    if (amount <= 0 || start is! Timestamp) return null;

    return BudgetModel(
      amount: amount,
      period: data["period"] ?? monthly,
      startDate: start.toDate(),
      enableAlert: data["enableAlert"] ?? true,
      alertPercent: (data["alertPercent"] as num?)?.toDouble() ?? 80,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "amount": amount,
      "period": period,
      "enableAlert": enableAlert,
      "alertPercent": alertPercent,
      "startDate": Timestamp.fromDate(startDate),
      "updatedAt": FieldValue.serverTimestamp(),
    };
  }
}
