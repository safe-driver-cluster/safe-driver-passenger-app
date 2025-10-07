import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static NotificationService? _instance;
  static NotificationService get instance =>
      _instance ??= NotificationService._();
  NotificationService._();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Stream controllers for notifications
  final StreamController<String> _notificationController =
      StreamController<String>.broadcast();
  final StreamController<RemoteMessage> _fcmController =
      StreamController<RemoteMessage>.broadcast();

  // Getters for streams
  Stream<String> get notificationStream => _notificationController.stream;
  Stream<RemoteMessage> get fcmStream => _fcmController.stream;

  // Notification channels
  static const AndroidNotificationChannel _safetyChannel =
      AndroidNotificationChannel(
    'safety_alerts',
    'Safety Alerts',
    description: 'Important safety alerts and notifications',
    importance: Importance.high,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('safety_alert'),
  );

  static const AndroidNotificationChannel _busUpdatesChannel =
      AndroidNotificationChannel(
    'bus_updates',
    'Bus Updates',
    description: 'Bus arrival and departure notifications',
    importance: Importance.defaultImportance,
  );

  static const AndroidNotificationChannel _generalChannel =
      AndroidNotificationChannel(
    'general',
    'General Notifications',
    description: 'General app notifications',
    importance: Importance.defaultImportance,
  );

  /// Initialize notification service
  Future<bool> initialize() async {
    try {
      // Request notification permissions
      await _requestNotificationPermissions();

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Initialize Firebase messaging
      await _initializeFirebaseMessaging();

      // Create notification channels
      await _createNotificationChannels();

      return true;
    } catch (e) {
      print('Notification service initialization failed: $e');
      return false;
    }
  }

  /// Request notification permissions
  Future<void> _requestNotificationPermissions() async {
    // Request notification permission for iOS and newer Android versions
    if (Platform.isIOS) {
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        throw NotificationPermissionDeniedException();
      }
    } else if (Platform.isAndroid) {
      final status = await Permission.notification.request();
      if (status != PermissionStatus.granted) {
        throw NotificationPermissionDeniedException();
      }
    }
  }

  /// Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  /// Initialize Firebase messaging
  Future<void> _initializeFirebaseMessaging() async {
    // Set up foreground message handler
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // Set up background message handler
    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);

    // Set up notification opened handler
    FirebaseMessaging.onMessageOpenedApp.listen(_onNotificationOpenedApp);

    // Check for initial message (when app is opened from notification)
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _onNotificationOpenedApp(initialMessage);
    }
  }

  /// Create notification channels for Android
  Future<void> _createNotificationChannels() async {
    if (Platform.isAndroid) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_safetyChannel);

      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_busUpdatesChannel);

      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_generalChannel);
    }
  }

  /// Handle foreground messages
  void _onForegroundMessage(RemoteMessage message) {
    print('Received foreground message: ${message.messageId}');

    // Add to stream
    _fcmController.add(message);

    // Show local notification for foreground messages
    _showLocalNotificationFromFCM(message);
  }

  /// Handle background messages
  static Future<void> _onBackgroundMessage(RemoteMessage message) async {
    print('Received background message: ${message.messageId}');
  }

  /// Handle notification tapped
  void _onNotificationTapped(NotificationResponse response) {
    print('Notification tapped: ${response.payload}');
    _notificationController.add(response.payload ?? '');
  }

  /// Handle notification opened app
  void _onNotificationOpenedApp(RemoteMessage message) {
    print('Notification opened app: ${message.messageId}');
    _fcmController.add(message);
  }

  /// Show local notification from FCM message
  Future<void> _showLocalNotificationFromFCM(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    final channelId = _getChannelIdFromMessageType(message.data['type']);

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          _getChannelNameFromId(channelId),
          importance: _getImportanceFromChannelId(channelId),
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: message.data['payload'],
    );
  }

  /// Show safety alert notification
  Future<void> showSafetyAlert({
    required String title,
    required String body,
    String? payload,
    bool isEmergency = false,
  }) async {
    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _safetyChannel.id,
          _safetyChannel.name,
          channelDescription: _safetyChannel.description,
          importance: isEmergency ? Importance.max : Importance.high,
          priority: Priority.high,
          icon: '@drawable/ic_safety_alert',
          color: Colors.red,
          ongoing: isEmergency,
          autoCancel: !isEmergency,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          sound: isEmergency ? 'emergency_alert.aiff' : 'safety_alert.aiff',
          interruptionLevel: isEmergency
              ? InterruptionLevel.critical
              : InterruptionLevel.active,
        ),
      ),
      payload: payload,
    );
  }

  /// Show bus update notification
  Future<void> showBusUpdate({
    required String title,
    required String body,
    String? payload,
  }) async {
    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _busUpdatesChannel.id,
          _busUpdatesChannel.name,
          channelDescription: _busUpdatesChannel.description,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@drawable/ic_bus',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload,
    );
  }

  /// Show general notification
  Future<void> showGeneralNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _generalChannel.id,
          _generalChannel.name,
          channelDescription: _generalChannel.description,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload,
    );
  }

  /// Schedule a notification
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
    String channelId = 'general',
  }) async {
    await _localNotifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          _getChannelNameFromId(channelId),
          channelDescription: _getChannelDescriptionFromId(channelId),
          importance: _getImportanceFromChannelId(channelId),
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// Cancel a notification
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  /// Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _localNotifications.pendingNotificationRequests();
  }

  /// Get FCM token
  Future<String?> getFCMToken() async {
    return await _firebaseMessaging.getToken();
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  /// Get notification permission status
  Future<NotificationSettings> getNotificationSettings() async {
    return await _firebaseMessaging.getNotificationSettings();
  }

  /// Helper methods
  String _getChannelIdFromMessageType(String? type) {
    switch (type) {
      case 'safety':
        return _safetyChannel.id;
      case 'bus':
        return _busUpdatesChannel.id;
      default:
        return _generalChannel.id;
    }
  }

  String _getChannelNameFromId(String channelId) {
    switch (channelId) {
      case 'safety_alerts':
        return _safetyChannel.name;
      case 'bus_updates':
        return _busUpdatesChannel.name;
      case 'general':
        return _generalChannel.name;
      default:
        return 'General';
    }
  }

  String _getChannelDescriptionFromId(String channelId) {
    switch (channelId) {
      case 'safety_alerts':
        return _safetyChannel.description ?? '';
      case 'bus_updates':
        return _busUpdatesChannel.description ?? '';
      case 'general':
        return _generalChannel.description ?? '';
      default:
        return 'General notifications';
    }
  }

  Importance _getImportanceFromChannelId(String channelId) {
    switch (channelId) {
      case 'safety_alerts':
        return Importance.high;
      case 'bus_updates':
        return Importance.defaultImportance;
      case 'general':
        return Importance.defaultImportance;
      default:
        return Importance.defaultImportance;
    }
  }

  /// Dispose service
  void dispose() {
    _notificationController.close();
    _fcmController.close();
  }
}

// Custom exceptions
class NotificationPermissionDeniedException implements Exception {
  final String message = 'Notification permission denied';
}

class NotificationInitializationException implements Exception {
  final String message;
  NotificationInitializationException(this.message);
}
