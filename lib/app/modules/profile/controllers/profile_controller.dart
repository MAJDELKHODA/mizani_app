import 'package:get/get.dart';
import 'package:mizani_app/app/core/base/finance_aware_controller.dart';
import 'package:mizani_app/app/core/utils/app_snackbar.dart';
import 'package:mizani_app/app/data/repositories/auth_repository.dart';
import 'package:mizani_app/app/data/repositories/user_repository.dart';
import 'package:mizani_app/app/data/services/auth_service.dart';
import 'package:mizani_app/app/data/services/notification_service.dart';
import 'package:mizani_app/app/routes/app_routes.dart';

class ProfileController extends FinanceAwareController {
  final AuthRepository _authRepo = Get.find();
  final UserRepository _userRepo = Get.find();

  // ----- بيانات المستخدم (لحظية من FinanceService) -----
  bool get isLoadingUser => finance.isUserLoading.value;

  String get userName =>
      finance.userName.isEmpty ? "مستخدم" : finance.userName;

  String get userEmail => finance.userEmail;

  /// الاسم الحالي للتعديل (فاضي لو لسا "مستخدم")
  String get editableName => finance.userName;

  Future<void> updateName(String name) async {
    final value = name.trim();

    if (value.isEmpty) {
      AppSnackbar.error("يرجى إدخال الاسم");
      return;
    }

    try {
      await _userRepo.updateName(value);
      AppSnackbar.success("تم تعديل الاسم بنجاح");
    } catch (_) {
      AppSnackbar.error("حدث خطأ أثناء تعديل الاسم");
    }
  }

  /// بيبعت رابط تغيير كلمة المرور على الإيميل
  Future<void> sendPasswordChangeEmail() async {
    if (userEmail.isEmpty) {
      AppSnackbar.error("لا يوجد بريد إلكتروني للحساب");
      return;
    }

    try {
      await _authRepo.sendPasswordReset(userEmail);
      AppSnackbar.success(
        "تم إرسال رابط تغيير كلمة المرور إلى بريدك الإلكتروني",
      );
    } on AuthFailure catch (e) {
      AppSnackbar.error(e.message);
    }
  }

  Future<void> logout() async {
    try {
      await NotificationService.instance.clearOnLogout();
    } catch (_) {
      // الإشعارات مش ضرورية لتسجيل الخروج
    }

    try {
      await _authRepo.signOut(); // بيطلع من Google كمان
      Get.offAllNamed(Routes.login);
    } catch (_) {
      AppSnackbar.error("تعذر تسجيل الخروج");
    }
  }

  void showComingSoon(String feature) {
    AppSnackbar.show("$feature ستكون متاحة لاحقاً");
  }
}
