import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mizani_app/app/core/theme/app_colors.dart';
import 'package:mizani_app/app/core/theme/app_transitions.dart';

// =========================
// بناء الثيم من لوحة الألوان (فاتح / داكن)
// =========================
class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(AppPalette.light, Brightness.light);

  static ThemeData get dark => _build(AppPalette.dark, Brightness.dark);

  static ThemeData _build(AppPalette p, Brightness brightness) {
    return ThemeData(
      brightness: brightness,

      // ألوان التطبيق الافتراضية (الأزرار، المؤشرات، الحقول، التقويم...)
      colorScheme: ColorScheme.fromSeed(
        seedColor: p.primary,
        brightness: brightness,
        primary: p.primary,
        error: p.expense,
        surface: p.card,
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: p.primary,
      ),

      // نوافذ الحوار (Dialogs) بشكل موحد
      dialogTheme: DialogThemeData(
        backgroundColor: p.card,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        titleTextStyle: TextStyle(
          fontFamily: "Cairo",
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: p.textDark,
        ),
        contentTextStyle: TextStyle(
          fontFamily: "Cairo",
          fontSize: 14,
          color: p.textMuted,
        ),
      ),

      // الأزرار الأساسية
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: p.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),

      // رسائل السناك بار عائمة ودائرية
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: brightness == Brightness.dark
            ? p.surfaceSoft
            : p.textDark,
        contentTextStyle: const TextStyle(
          fontFamily: "Cairo",
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),

      // التقويم واختيار التاريخ
      datePickerTheme: DatePickerThemeData(
        backgroundColor: p.card,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),

      // القوائم المنسدلة والـ Bottom sheets
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: p.card,
        surfaceTintColor: Colors.transparent,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: p.card,
        surfaceTintColor: Colors.transparent,
      ),

      dividerColor: p.border,

      // حركة انتقال موحدة بين الشاشات
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeSlidePageTransitionsBuilder(),
          // iOS بيضل على الافتراضي عشان سحبة الرجوع تضل شغالة
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),

      fontFamily: "Cairo",

      scaffoldBackgroundColor: p.background,

      textTheme: TextTheme(
        bodyLarge: TextStyle(
          fontFamily: "Cairo",
          color: p.textDark,
        ),
        bodyMedium: TextStyle(
          fontFamily: "Cairo",
          color: p.textDark,
        ),
      ),
    );
  }
}
