// =========================
// تنسيق المبالغ والتواريخ (مكان واحد لكل التطبيق)
// =========================
class AppFormatters {
  AppFormatters._();

  static const List<String> _months = [
    "يناير",
    "فبراير",
    "مارس",
    "أبريل",
    "مايو",
    "يونيو",
    "يوليو",
    "أغسطس",
    "سبتمبر",
    "أكتوبر",
    "نوفمبر",
    "ديسمبر",
  ];

  static const List<String> _weekDays = [
    "الإثنين",
    "الثلاثاء",
    "الأربعاء",
    "الخميس",
    "الجمعة",
    "السبت",
    "الأحد",
  ];

  /// 1500.0 => 1,500   |   12.5 => 12.50
  static String amount(double value) {
    final isNegative = value < 0;
    final absValue = value.abs();

    final text = absValue == absValue.roundToDouble()
        ? absValue.toInt().toString()
        : absValue.toStringAsFixed(2);

    final parts = text.split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (m) => ',',
    );

    final result = parts.length > 1 ? '$intPart.${parts[1]}' : intPart;

    return isNegative ? '-$result' : result;
  }

  /// 05/11/2026
  static String date(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return "$day/$month/${date.year}";
  }

  /// 14:05
  static String time(DateTime? date) {
    if (date == null) return "-";
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }

  /// "نوفمبر"
  static String monthName(int month) => _months[month - 1];

  /// "5 نوفمبر"
  static String dayMonth(DateTime date) => "${date.day} ${monthName(date.month)}";

  /// "الخميس"
  static String weekDay(DateTime date) => _weekDays[date.weekday - 1];

  /// "اليوم" / "أمس" / اسم اليوم
  static String relativeDay(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(date.year, date.month, date.day);
    final diff = today.difference(d).inDays;

    if (diff == 0) return "اليوم";
    if (diff == 1) return "أمس";
    return weekDay(date);
  }

  /// 1200 => 1.2K  (للرسوم البيانية)
  static String compact(double value) {
    if (value >= 1000000) return "${(value / 1000000).toStringAsFixed(1)}M";
    if (value >= 1000) return "${(value / 1000).toStringAsFixed(1)}K";
    return value.toStringAsFixed(0);
  }
}
