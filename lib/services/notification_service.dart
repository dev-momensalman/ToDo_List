import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:developer';
import 'dart:io';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  // Initialize notification service
  Future<void> initialize() async {
    log('Initializing Notification Service...');
    
    // Request permission for iOS
    await _requestPermission();
    
    // Initialize local notifications
    await _initializeLocalNotifications();
    
    // Get FCM token
    await _getFCMToken();
    
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    
    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
    
    log('Notification Service initialized successfully');
  }

  // Request notification permission
  Future<void> _requestPermission() async {
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    log('Notification permission status: ${settings.authorizationStatus}');
  }

  // Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    log('Local notifications initialized');
  }

  // Get FCM token
  Future<void> _getFCMToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      log('FCM Token: $token');
      
      // Save token to user document in Firestore
      await _saveTokenToFirestore(token);
    } catch (e) {
      log('Error getting FCM token: $e');
    }
  }

  // Save FCM token to Firestore
  Future<void> _saveTokenToFirestore(String? token) async {
    if (token == null) return;
    
    try {
      // Import here to avoid circular dependency
      import 'package:cloud_firestore/cloud_firestore.dart';
      import 'package:firebase_auth/firebase_auth.dart';
      
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'fcmToken': token,
          'tokenUpdatedAt': FieldValue.serverTimestamp(),
        });
        log('FCM token saved to Firestore');
      }
    } catch (e) {
      log('Error saving FCM token to Firestore: $e');
    }
  }

  // Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    log('Received foreground message: ${message.messageId}');
    log('Title: ${message.notification?.title}');
    log('Body: ${message.notification?.body}');
    
    _showLocalNotification(message);
  }

  // Handle background messages (static method required)
  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    log('Received background message: ${message.messageId}');
    log('Title: ${message.notification?.title}');
    log('Body: ${message.notification?.body}');
  }

  // Show local notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'cloudnote_channel',
      'CloudNote Notifications',
      channelDescription: 'Notifications from CloudNote app',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      message.notification.hashCode,
      message.notification?.title ?? 'CloudNote',
      message.notification?.body ?? 'You have a new notification',
      details,
      payload: message.data.toString(),
    );
  }

  // Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    log('Notification tapped: ${response.payload}');
    // Handle navigation based on payload
  }

  // Send notification to specific user (admin function)
  static Future<void> sendNotificationToUser({
    required String userToken,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    try {
      // This would typically be done from a backend service
      // For demo purposes, showing the structure
      log('Sending notification to user with token: $userToken');
      log('Title: $title');
      log('Body: $body');
      log('Data: $data');
      
      // In a real app, you would use Firebase Admin SDK or a HTTP API call
      // to send notifications from your backend
      
    } catch (e) {
      log('Error sending notification: $e');
    }
  }

  // Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      log('Subscribed to topic: $topic');
    } catch (e) {
      log('Error subscribing to topic: $e');
    }
  }

  // Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      log('Unsubscribed from topic: $topic');
    } catch (e) {
      log('Error unsubscribing from topic: $e');
    }
  }

  // Get notification settings stream
  Stream<NotificationSettings> get notificationSettings => _firebaseMessaging.onTokenRefresh;
}
