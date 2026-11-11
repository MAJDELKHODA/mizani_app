import 'package:flutter/foundation.dart';

class NotificationController {
  String? fcmToken;

  void setFcmToken(String token) {
    fcmToken = token;

    debugPrint('FCM Token: $fcmToken');
  }
}