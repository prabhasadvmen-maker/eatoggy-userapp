// import 'dart:convert';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import '../constants/api_constants.dart';
// import '../constants/app_keys.dart';
// import '../services/api_service.dart';
// import '../services/storage_service.dart';
// import '../../main.dart';
// import '../../data/models/responses/user_notification_response.dart';

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   debugPrint(' Handling background notification message: ${message.messageId}');
// }

// class NotificationService {
//   static final NotificationService _instance = NotificationService._internal();
//   factory NotificationService() => _instance;
//   NotificationService._internal();

//   final FirebaseMessaging _fcm = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

//   static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
//     'high_importance_channel',
//     'High Importance Notifications',
//     description: 'This channel is used for important notifications.',
//     importance: Importance.max,
//     playSound: true,
//     enableVibration: true,
//   );

//   Future<void> init() async {
//     try {
//       // 1. Request User Permission
//       await _requestPermission();

//       // 2. Initialize Local Notifications for Foreground Display
//       await _initLocalNotifications();

//       // 3. Set Background Message Handler
//       FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//       // 4. Listen to Messages
//       _setupMessageListeners();

//       // 5. Fetch & Upload FCM Token to Server asynchronously without blocking UI initialization
//       getAndRegisterToken();

//       // Token Refresh Listener
//       _fcm.onTokenRefresh.listen((newToken) {
//         _registerTokenToServer(newToken);
//       });
//     } catch (e) {
//       debugPrint('❌ NotificationService initialization error: $e');
//     }
//   }

//   Future<void> _requestPermission() async {
//     NotificationSettings settings = await _fcm.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//       provisional: false,
//     );
//     debugPrint(' Notification permission status: ${settings.authorizationStatus}');

//     await _fcm.setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//   }

//   Future<void> _initLocalNotifications() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );

//     const InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );

//     await _localNotifications.initialize(
//       settings: initializationSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) {
//         if (response.payload != null && response.payload!.isNotEmpty) {
//           try {
//             final Map<String, dynamic> data = jsonDecode(response.payload!);
//             _handleDeepLink(data);
//           } catch (e) {
//             debugPrint('Error decoding notification payload: $e');
//           }
//         }
//       },
//     );

//     await _localNotifications
//         .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(_channel);
//   }

//   void _setupMessageListeners() {
//     // 1. Foreground Notifications
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       debugPrint(' Foreground FCM Message received: ${message.notification?.title}');
//       final notification = message.notification;
//       final android = message.notification?.android;

//       if (notification != null) {
//         _localNotifications.show(
//           id: notification.hashCode,
//           title: notification.title,
//           body: notification.body,
//           notificationDetails: NotificationDetails(
//             android: AndroidNotificationDetails(
//               _channel.id,
//               _channel.name,
//               channelDescription: _channel.description,
//               importance: Importance.max,
//               priority: Priority.high,
//               playSound: true,
//               icon: android?.smallIcon ?? '@mipmap/ic_launcher',
//             ),
//             iOS: const DarwinNotificationDetails(
//               presentAlert: true,
//               presentBadge: true,
//               presentSound: true,
//             ),
//           ),
//           payload: jsonEncode(message.data),
//         );
//       }
//     });

//     // 2. Notification Clicked When App Opened from Background State
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       debugPrint(' App opened from FCM Notification click: ${message.data}');
//       _handleDeepLink(message.data);
//     });

//     // 3. Notification Clicked When App Launched from Terminated State
//     _fcm.getInitialMessage().then((RemoteMessage? message) {
//       if (message != null) {
//         debugPrint(' App launched from terminated state via FCM Notification: ${message.data}');
//         _handleDeepLink(message.data);
//       }
//     });
//   }

//   Future<void> getAndRegisterToken() async {
//     try {
//       final prefs = await SharedPreferencesService.getInstance();
//       final userToken = prefs.getString(AppKeys.accessToken);
      
//       // Only attempt server registration if user is authenticated (token exists)
//       if (userToken == null || userToken.isEmpty) {
//         debugPrint('ℹ️ Skip FCM Token registration: User not logged in yet.');
//         return;
//       }

//       final token = await _fcm.getToken();
//       if (token != null && token.isNotEmpty) {
//         debugPrint('📲 FCM Device Token: $token');
//         await _registerTokenToServer(token);
//       }
//     } catch (e) {
//       debugPrint('❌ Error fetching FCM Token: $e');
//     }
//   }

//   Future<void> _registerTokenToServer(String fcmToken) async {
//     try {
//       final response = await ApiService.dio.post(
//         ApiConstants.subscribeNotificationToken,
//         data: {"token": fcmToken},
//       );
//       if (response.statusCode == 200) {
//         final parsedResponse = UserNotificationSubscribeResponse.fromJson(
//           response.data is Map<String, dynamic> ? response.data : {},
//         );
//         debugPrint('✅ FCM Token registered to backend successfully: ${parsedResponse.message}');
//       }
//     } catch (e) {
//       debugPrint('⚠️ Registering FCM Token to backend failed: $e');
//     }
//   }

//   void _handleDeepLink(Map<String, dynamic> data) {
//     final String? bookingId = data['bookingId']?.toString();
//     if (bookingId != null && bookingId.isNotEmpty) {
//       debugPrint(' Navigating to booking details for ID: $bookingId');
//       navigatorKey.currentState?.pushNamed(
//         '/booking-details',
//         arguments: {'bookingId': bookingId},
//       );
//     }
//   }
// }
