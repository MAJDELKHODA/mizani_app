import 'package:flutter/foundation.dart';

// =========================
// بيحفظ توكن الإشعارات (FCM) للجهاز الحالي
// =========================
class FcmTokenStore {
  String? fcmToken;

  void setFcmToken(String token) {
    fcmToken = token;
    debugPrint('FCM Token: $fcmToken');
  }
}
