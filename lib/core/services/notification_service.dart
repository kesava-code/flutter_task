// File: lib/core/services/notification_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_task/app_config/router/app_router.dart';

// This must be a top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
  }
}

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
  );

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await _fcm.requestPermission();
    await _initializeLocalNotifications();

    // This handles when a user taps a notification and the app opens from a TERMINATED state.
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        _handleNotificationTap(message.data);
      }
    });

    // This listens for messages when the app is in the FOREGROUND.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null && !kIsWeb) {
        _localNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: '@drawable/ic_stat_notification',
            ),
          ),
          payload: message.data['chatId'], // Pass chatId in the payload
        );
      }
    });

    // This handles when a user taps a notification and the app opens from the BACKGROUND.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationTap(message.data);
    });

    // Token Management
    _fcm.getToken().then((token) {
      if (token != null) {
        saveTokenToDatabase(token);
      }
    });
    _fcm.onTokenRefresh.listen(saveTokenToDatabase);
  }

  // Method to handle navigation
  void _handleNotificationTap(Map<String, dynamic> data) {
    final chatId = data['chatId'];
    if (chatId != null) {
      // Use the global navigator key to navigate by name
      rootNavigatorKey.currentState?.pushNamed('chatDetail', arguments: {'chatId': chatId});
    }
  }

  Future<void> _initializeLocalNotifications() async {
    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _localNotificationsPlugin.initialize(
      initializationSettings,
      // This is called when the app is in the foreground and a notification is tapped
      onDidReceiveNotificationResponse: (details) {
        if(details.payload != null) {
          _handleNotificationTap({'chatId': details.payload});
        }
      },
    );
  }

  Future<void> saveTokenToDatabase(String token) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;
    try {
      await _firestore.collection('users').doc(userId).set(
            {'fcmToken': token},
            SetOptions(merge: true),
          );
    } catch (e) {
      if (kDebugMode) {
        print("Could not update FCM token: $e");
      }
    }
  }
}