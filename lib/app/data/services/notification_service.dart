// ═══════════════════════════════════════════════════════════════════════════
//  notification_service.dart
//  خدمة الإشعارات الكاملة: Firebase Cloud Messaging + Local Notifications
//
//  الحزم (أكتوبر 2026):
//    firebase_core: ^4.14.0
//    firebase_messaging: ^16.6.0
//    flutter_local_notifications: ^22.3.2   ← show() و initialize() بمعاملات مسمّاة
//    get: (نسختك الحالية)
//
//  طريقة الاستخدام في main.dart:
//
//    Future<void> main() async {
//      WidgetsFlutterBinding.ensureInitialized();
//      await Firebase.initializeApp();
//      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
//      runApp(const MyApp());
//      await NotificationService.instance.init();
//    }
// ═══════════════════════════════════════════════════════════════════════════

import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'fcm_token_store.dart';


//import 'package:yops/getx_controller/notification_getx_controller.dart';
//import 'package:yops/screen/home/categories_screen.dart';
//import 'package:yops/screen/home/chat_v_screen.dart';

// ───────────────────────────────────────────────────────────────────────────
// 1) معالج الخلفية (Top-level)
//    يجب أن يكون خارج أي كلاس، ويحمل @pragma('vm:entry-point') حتى لا يحذفه
//    المترجم في نسخة Release. يعمل في Isolate منفصل عندما يكون التطبيق
//    في الخلفية أو مغلقاً تماماً، لذلك نهيّئ Firebase بداخله من جديد.
// ───────────────────────────────────────────────────────────────────────────
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('📩 [Background] ${message.messageId} | data: ${message.data}');
  // ملاحظة: إشعارات "notification" يعرضها النظام تلقائياً هنا،
  // فلا تعرضها يدوياً حتى لا تتكرر. استخدم هذه الدالة لمعالجة data فقط.
}

// يُستدعى عند الضغط على "زر إجراء" (Action) في إشعار محلي والتطبيق مغلق.
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  debugPrint('👆 [Background tap] payload: ${response.payload}');
}

// ───────────────────────────────────────────────────────────────────────────
// 2) الكلاس الرئيسي (Singleton)
// ───────────────────────────────────────────────────────────────────────────
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local =
  FlutterLocalNotificationsPlugin();
  final FcmTokenStore controller = FcmTokenStore();

  /// قناة أندرويد عالية الأهمية (تظهر كـ Popup مع صوت).
  /// نفس الـ ID يجب وضعه في AndroidManifest كقناة افتراضية لـ FCM.
  static const AndroidNotificationChannel _channel =
  AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'الإشعارات المهمة في التطبيق',
    importance: Importance.max,
  );

  static const String _allUsersTopic = 'all';

  bool _initialized = false;
  String? fcmToken;
  StreamSubscription<String>? _tokenRefreshSub;

  bool get _isIOS => !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  // ═════════════════════════════════════════════════════════════════════════
  //  التهيئة الكاملة — استدعِها مرة واحدة بعد runApp
  // ═════════════════════════════════════════════════════════════════════════
  Future<void> init() async {
    if (_initialized) return; // حماية من التهيئة المكررة
    _initialized = true;

    // الخطوة 1: طلب الإذن أولاً (iOS + أندرويد 13 فما فوق)
    final granted = await _requestPermission();

    // الخطوة 2: تهيئة الإشعارات المحلية وإنشاء قناة أندرويد
    await _setupLocalNotifications();

    // الخطوة 3: iOS يعرض الإشعار بنفسه والتطبيق مفتوح (بدون تكرار)
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // الخطوة 4: التوكن + الاشتراك في topic + إرساله للسيرفر
    if (granted) await _setupToken();

    // الخطوة 5: الاستماع للإشعارات (مفتوح / ضغط من الخلفية)
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp
        .listen((message) => _handleNotificationClick(message.data));

    // الخطوة 6: هل فُتح التطبيق من إشعار وهو مغلق تماماً؟
    await _handleLaunchFromNotification();
  }

  // ─────────────────────────────── الإذن ───────────────────────────────────
  Future<bool> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true, // تنبيهات على الشاشة
      badge: true, // رقم على أيقونة التطبيق
      sound: true, // صوت
    );
    final status = settings.authorizationStatus;
    debugPrint('🔔 Notification permission: $status');
    return status == AuthorizationStatus.authorized ||
        status == AuthorizationStatus.provisional;
  }

  // ─────────────────────── الإشعارات المحلية ───────────────────────────────
  Future<void> _setupLocalNotifications() async {
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      // الإذن طلبناه عبر Firebase، فلا نطلبه مرة ثانية هنا
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );

    // منذ النسخة 20: initialize() تأخذ معاملات مسمّاة
    await _local.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: _onLocalNotificationTap,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    await _local
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  // ─────────────────────────────── التوكن ──────────────────────────────────
  Future<void> _setupToken() async {
    // على iOS: لازم APNs token يجهز قبل طلب FCM token
    if (_isIOS) {
      final apnsToken = await _waitForApnsToken();
      if (apnsToken == null) {
        debugPrint('⚠️ APNs token غير متاح — تأكد من Push capability ومفتاح APNs');
        return;
      }
    }

    fcmToken = await _messaging.getToken();

    if (fcmToken != null) {
      controller.setFcmToken(fcmToken!);

      await _messaging.subscribeToTopic(_allUsersTopic);
    }

    if (fcmToken != null) {
      await _messaging.subscribeToTopic(_allUsersTopic);
      await _sendTokenToServer(fcmToken!);
    }

    // التوكن ممكن يتغير (إعادة تثبيت، مسح بيانات...) → نحدّث السيرفر
    _tokenRefreshSub ??= _messaging.onTokenRefresh.listen((newToken) {
      fcmToken = newToken;
      _sendTokenToServer(newToken);
    });
  }

  Future<String?> _waitForApnsToken({int retries = 5}) async {
    for (var i = 0; i < retries; i++) {
      final token = await _messaging.getAPNSToken();
      if (token != null) return token;
      await Future<void>.delayed(const Duration(seconds: 1));
    }
    return null;
  }

  Future<void> _sendTokenToServer(String token) async {
    debugPrint('🔥 FCM Token: $token');
  }

  // ───────────────────── التطبيق مفتوح (Foreground) ────────────────────────
  Future<void> _onForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return; // رسالة data فقط → لا نعرض شيئاً

    // iOS يعرضه النظام تلقائياً بسبب setForegroundNotificationPresentationOptions
    if (_isIOS) return;

    await showLocalNotification(
      title: notification.title ?? '',
      body: notification.body ?? '',
      data: message.data,
    );
  }

  /// عرض إشعار محلي (يمكن استدعاؤها من أي مكان في التطبيق).
  Future<void> showLocalNotification({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channel.id,
        _channel.name,
        channelDescription: _channel.description,
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    // منذ النسخة 20: show() بمعاملات مسمّاة، و notificationDetails بدل details
    await _local.show(
      id: _nextNotificationId(), // ID فريد حتى لا يستبدل إشعارٌ إشعاراً آخر
      title: title,
      body: body,
      notificationDetails: details,
      payload: (data == null || data.isEmpty) ? null : jsonEncode(data),
    );
  }

  int _nextNotificationId() =>
      DateTime.now().millisecondsSinceEpoch.remainder(1 << 31);

  // ─────────────────────── الضغط على الإشعار ───────────────────────────────
  void _onLocalNotificationTap(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) return;
    try {
      final data = Map<String, dynamic>.from(jsonDecode(payload) as Map);
      _handleNotificationClick(data);
    } catch (e) {
      debugPrint('❌ Error decoding payload: $e');
    }
  }

  /// التطبيق كان مغلقاً تماماً وفتحه المستخدم بالضغط على إشعار.
  Future<void> _handleLaunchFromNotification() async {
    final initialMessage = await _messaging.getInitialMessage();
    final launchDetails = await _local.getNotificationAppLaunchDetails();

    // ننتظر أول إطار حتى يكون التطبيق جاهزاً للتنقل
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (initialMessage != null) {
        _handleNotificationClick(initialMessage.data);
      } else if (launchDetails?.didNotificationLaunchApp ?? false) {
        final response = launchDetails!.notificationResponse;
        if (response != null) _onLocalNotificationTap(response);
      }
    });
    WidgetsBinding.instance.scheduleFrame();
  }

  /// التوجيه حسب الحقل screen داخل data القادمة من السيرفر.
  /// ملاحظة: كل قيم data في FCM تصل كنصوص String.
  void _handleNotificationClick(Map<String, dynamic> data) {
    if (data.isEmpty) return;

    debugPrint('🔔 Notification clicked: $data');
  }


  // ─────────────────────── عند تسجيل الدخول ────────────────────────────────
  /// بعد تسجيل دخول مستخدم جديد: نجلب توكن جديد ونربطه بحسابه على السيرفر.
  Future<void> registerTokenAfterLogin() => _setupToken();

  // ─────────────────────── عند تسجيل الخروج ────────────────────────────────
  /// يوقف الإشعارات عن هذا الجهاز (استدعِها مع AuthService.signOut).
  Future<void> clearOnLogout() async {
    try {
      await _messaging.unsubscribeFromTopic(_allUsersTopic);
      await _messaging.deleteToken();
      fcmToken = null;
    } catch (e) {
      debugPrint('❌ clearOnLogout failed: $e');
    }
  }
}
