import 'package:flutter/material.dart';

// =========================
// لوحة ألوان كاملة (وحدة للفاتح ووحدة للداكن)
// =========================
class AppPalette {
  final Color primary;
  final Color primaryLight;
  final Color primaryLighter;
  final Color primaryDark;
  final Color primarySoft;
  final Color primaryBorder;

  final Color heroStart;
  final Color heroEnd;

  final Color background;
  final Color surfaceSoft;
  final Color card;
  final Color border;

  final Color textDark;
  final Color textMuted;
  final Color textHint;

  final Color income;
  final Color incomeLight;
  final Color incomeSoft;

  final Color expense;
  final Color expenseLight;
  final Color expenseSoft;
  final Color expenseBorder;

  final Color warning;
  final Color shadow;

  final Color skeletonBase;
  final Color skeletonHighlight;

  const AppPalette({
    required this.primary,
    required this.primaryLight,
    required this.primaryLighter,
    required this.primaryDark,
    required this.primarySoft,
    required this.primaryBorder,
    required this.heroStart,
    required this.heroEnd,
    required this.background,
    required this.surfaceSoft,
    required this.card,
    required this.border,
    required this.textDark,
    required this.textMuted,
    required this.textHint,
    required this.income,
    required this.incomeLight,
    required this.incomeSoft,
    required this.expense,
    required this.expenseLight,
    required this.expenseSoft,
    required this.expenseBorder,
    required this.warning,
    required this.shadow,
    required this.skeletonBase,
    required this.skeletonHighlight,
  });

  // ----- الوضع الفاتح -----
  static const light = AppPalette(
    primary: Color(0xFF059669),
    primaryLight: Color(0xFF10B981),
    primaryLighter: Color(0xFF34D399),
    primaryDark: Color(0xFF047857),
    primarySoft: Color(0xFFD1FAE5),
    primaryBorder: Color(0xFFA7F3D0),
    heroStart: Color(0xFF053B2C),
    heroEnd: Color(0xFF0E9F6E),
    background: Color(0xFFF3F7F5),
    surfaceSoft: Color(0xFFF1F8F4),
    card: Colors.white,
    border: Color(0xFFE3ECE7),
    textDark: Color(0xFF0B2A20),
    textMuted: Color(0xFF64748B),
    textHint: Color(0xFF94A3B8),
    income: Color(0xFF16A34A),
    incomeLight: Color(0xFF4ADE80),
    incomeSoft: Color(0xFFDCFCE7),
    expense: Color(0xFFF43F5E),
    expenseLight: Color(0xFFFB7185),
    expenseSoft: Color(0xFFFFE4E8),
    expenseBorder: Color(0xFFFECDD3),
    warning: Color(0xFFF59E0B),
    shadow: Color(0x14053B2C),
    skeletonBase: Color(0xFFE6EEEA),
    skeletonHighlight: Color(0xFFF6FAF8),
  );

  // ----- الوضع الداكن -----
  static const dark = AppPalette(
    primary: Color(0xFF10B981),
    primaryLight: Color(0xFF34D399),
    primaryLighter: Color(0xFF6EE7B7),
    primaryDark: Color(0xFF0E9F6E),
    primarySoft: Color(0xFF113528),
    primaryBorder: Color(0xFF1F5A45),
    heroStart: Color(0xFF03211A),
    heroEnd: Color(0xFF0B7A55),
    background: Color(0xFF0A1411),
    surfaceSoft: Color(0xFF16231E),
    card: Color(0xFF111D19),
    border: Color(0xFF213129),
    textDark: Color(0xFFE7F3ED),
    textMuted: Color(0xFF9AACA5),
    textHint: Color(0xFF64776F),
    income: Color(0xFF22C55E),
    incomeLight: Color(0xFF4ADE80),
    incomeSoft: Color(0xFF11301E),
    expense: Color(0xFFFB7185),
    expenseLight: Color(0xFFFDA4AF),
    expenseSoft: Color(0xFF331A1F),
    expenseBorder: Color(0xFF5B2530),
    warning: Color(0xFFFBBF24),
    shadow: Color(0x40000000),
    skeletonBase: Color(0xFF1A2924),
    skeletonHighlight: Color(0xFF253A33),
  );
}

// =========================
// ألوان تطبيق ميزاني
// أي تغيير بالألوان بيصير من هون بس
// الألوان بتتبدل لحالها حسب الوضع (فاتح / داكن)
// =========================
class AppColors {
  AppColors._();

  // اللوحة الحالية — بيغيرها ThemeController
  static AppPalette current = AppPalette.light;

  static bool get isDark => identical(current, AppPalette.dark);

  // ----- الأساسي (أخضر زمردي) -----
  static Color get primary => current.primary;
  static Color get primaryLight => current.primaryLight;
  static Color get primaryLighter => current.primaryLighter;
  static Color get primaryDark => current.primaryDark;
  static Color get primarySoft => current.primarySoft; // خلفيات الأيقونات والشرائح
  static Color get primaryBorder => current.primaryBorder;

  // ----- التدرج (كرت الرصيد والهيدرات) -----
  static Color get heroStart => current.heroStart;
  static Color get heroEnd => current.heroEnd;
  static LinearGradient get heroGradient => LinearGradient(
        colors: [heroStart, heroEnd],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      );

  // ----- الخلفيات -----
  static Color get background => current.background;
  static Color get surfaceSoft => current.surfaceSoft;
  static Color get card => current.card;
  static Color get border => current.border;

  // ----- النصوص -----
  static Color get textDark => current.textDark;
  static Color get textMuted => current.textMuted;
  static Color get textHint => current.textHint;

  // ----- الدخل -----
  static Color get income => current.income;
  static Color get incomeLight => current.incomeLight;
  static Color get incomeSoft => current.incomeSoft;

  // ----- المصروف -----
  static Color get expense => current.expense;
  static Color get expenseLight => current.expenseLight;
  static Color get expenseSoft => current.expenseSoft;
  static Color get expenseBorder => current.expenseBorder;

  // ----- حالات -----
  static Color get warning => current.warning;

  // ----- ظل -----
  static Color get shadow => current.shadow;

  // ----- Skeleton -----
  static Color get skeletonBase => current.skeletonBase;
  static Color get skeletonHighlight => current.skeletonHighlight;
}
