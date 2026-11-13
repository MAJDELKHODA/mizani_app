import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mizani_app/app/core/theme/app_colors.dart';

// =========================
// مظهر التطبيق: فاتح / داكن / تلقائي (حسب الجهاز)
// =========================
class ThemeService extends GetxService with WidgetsBindingObserver {
  static ThemeService get to => Get.find();

  static const _key = "themeMode";

  final mode = ThemeMode.system.obs;

  bool get isDark {
    if (mode.value == ThemeMode.system) {
      return SchedulerBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;
    }
    return mode.value == ThemeMode.dark;
  }

  /// بنقرأ الاختيار المحفوظ قبل ما يفتح التطبيق
  Future<ThemeService> init() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);

    mode.value = ThemeMode.values.firstWhere(
      (m) => m.name == saved,
      orElse: () => ThemeMode.system,
    );

    _applyPalette();
    WidgetsBinding.instance.addObserver(this);

    return this;
  }

  Future<void> setMode(ThemeMode newMode) async {
    if (newMode == mode.value) return;

    mode.value = newMode;
    _applyPalette();
    Get.changeThemeMode(newMode);
    Get.forceAppUpdate(); // إعادة رسم كل الشاشات بالألوان الجديدة

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, newMode.name);
  }

  // الجهاز تحوّل بين فاتح وداكن
  @override
  void didChangePlatformBrightness() {
    if (mode.value != ThemeMode.system) return;
    _applyPalette();
    Get.forceAppUpdate();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  void _applyPalette() {
    AppColors.current = isDark ? AppPalette.dark : AppPalette.light;
  }
}
