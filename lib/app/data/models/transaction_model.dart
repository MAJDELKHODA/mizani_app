import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mizani_app/app/core/constants/app_categories.dart';

// =========================
// عملية مالية (دخل أو مصروف)
// users/{uid}/transactions/{id}
// =========================
class TransactionModel {
  final String id;
  final double amount;
  final String type; // income | expense
  final String category; // للمصروف
  final String source; // للدخل
  final String payment; // للمصروف
  final String note;
  final DateTime date;
  final DateTime? createdAt;

  const TransactionModel({
    this.id = "",
    required this.amount,
    required this.type,
    this.category = "",
    this.source = "",
    this.payment = "",
    this.note = "",
    required this.date,
    this.createdAt,
  });

  bool get isIncome => type == AppCategories.typeIncome;

  bool get isExpense => type == AppCategories.typeExpense;

  /// اسم العملية المعروض (المصدر للدخل، التصنيف للمصروف)
  String get title => isIncome ? source : category;

  factory TransactionModel.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};

    return TransactionModel(
      id: doc.id,
      amount: (data["amount"] as num?)?.toDouble() ?? 0,
      type: data["type"] ?? "",
      category: data["category"] ?? "",
      source: data["source"] ?? "",
      payment: data["payment"] ?? "",
      note: data["note"] ?? "",
      date: data["date"] is Timestamp
          ? (data["date"] as Timestamp).toDate()
          : DateTime.now(),
      createdAt: data["createdAt"] is Timestamp
          ? (data["createdAt"] as Timestamp).toDate()
          : null,
    );
  }

  /// للحفظ بـ Firestore (createdAt بيتحط من السيرفر عند الإضافة)
  Map<String, dynamic> toMap() {
    return {
      "amount": amount,
      "type": type,
      if (isExpense) "category": category,
      if (isExpense) "payment": payment,
      if (isIncome) "source": source,
      "note": note,
      "date": Timestamp.fromDate(date),
    };
  }

  TransactionModel copyWith({
    double? amount,
    String? category,
    String? source,
    String? payment,
    String? note,
    DateTime? date,
  }) {
    return TransactionModel(
      id: id,
      amount: amount ?? this.amount,
      type: type,
      category: category ?? this.category,
      source: source ?? this.source,
      payment: payment ?? this.payment,
      note: note ?? this.note,
      date: date ?? this.date,
      createdAt: createdAt,
    );
  }
}
