import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../data/models/notification_model.dart';
import '../../data/models/passenger_model.dart';
import '../../data/repositories/notification_repository.dart';

class NotificationService {
  static NotificationService? _instance;
  static NotificationService get instance =>
      _instance ??= NotificationService._();
  NotificationService._();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final NotificationRepository _notificationRepository =
      NotificationRepository();

  final StreamController<String> _notificationController =
      StreamController<String>.broadcast();
  final StreamController<RemoteMessage> _fcmController =
      StreamController<RemoteMessage>.broadcast();

  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      _passengerSubscription;
  StreamSubscription<String>? _tokenRefreshSubscription;

  PassengerNotificationSettings? _currentSettings;
  String? _activeUserId;
  Set<String> _activeTopics = <String>{};
  bool _initialized = false;

  Stream<String> get notificationStream => _notificationController.stream;
  Stream<RemoteMessage> get fcmStream => _fcmController.stream;

  static const AndroidNotificationChannel _safetyChannel =
      AndroidNotificationChannel(
    'safety_alerts',
    'Safety Alerts',
    description: 'Important safety alerts and emergency updates.',
    importance: Importance.high,
  );

  static const AndroidNotificationChannel _busUpdatesChannel =
      AndroidNotificationChannel(
    'bus_updates',
    'Bus Updates',
    description: 'Bus arrival, delay, and journey notifications.',
    importance: Importance.defaultImportance,
  );

  static const AndroidNotificationChannel _generalChannel =
      AndroidNotificationChannel(
    'general',
    'General Notifications',
    description: 'General app notifications and account updates.',
    importance: Importance.defaultImportance,
  );

  Future<bool> initialize() async {
    if (_initialized) {
      return true;
    }

    try {
      await _requestNotificationPermissions();
      await _initializeLocalNotifications();
      await _createNotificationChannels();
      await _initializeFirebaseMessaging();
      _bindAuthLifecycle();
      _initialized = true;
      return true;
    } catch (e) {
      print('Notification service initialization failed: $e');
      return false;
    }
  }

  Future<void> _requestNotificationPermissions() async {
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

      if (settings.authorizationStatus != AuthorizationStatus.authorized &&
          settings.authorizationStatus != AuthorizationStatus.provisional) {
        throw NotificationPermissionDeniedException();
      }
      return;
    }

    if (Platform.isAndroid) {
      final status = await Permission.notification.request();
      if (status != PermissionStatus.granted &&
          status != PermissionStatus.limited) {
        throw NotificationPermissionDeniedException();
      }
    }
  }

  Future<void> _initializeLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

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
  }

  Future<void> _initializeFirebaseMessaging() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((message) async {
      await handleIncomingMessage(
        message,
        showLocalNotification: true,
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      await handleIncomingMessage(
        message,
        openedFromSystemNotification: true,
      );
    });

    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      await handleIncomingMessage(
        initialMessage,
        openedFromSystemNotification: true,
      );
    }

    _tokenRefreshSubscription?.cancel();
    _tokenRefreshSubscription = _firebaseMessaging.onTokenRefresh.listen(
      (token) async {
        final userId = _activeUserId;
        if (userId == null || token.isEmpty) {
          return;
        }

        await _saveDeviceToken(userId, token: token);
      },
    );
  }

  Future<void> _createNotificationChannels() async {
    if (!Platform.isAndroid) {
      return;
    }

    final androidPlugin =
        _localNotifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(_safetyChannel);
    await androidPlugin?.createNotificationChannel(_busUpdatesChannel);
    await androidPlugin?.createNotificationChannel(_generalChannel);
  }

  void _bindAuthLifecycle() {
    _authSubscription?.cancel();
    _authSubscription = _auth.authStateChanges().listen((user) async {
      if (user == null) {
        await _clearActiveUserState();
        return;
      }

      if (_activeUserId != user.uid) {
        _activeUserId = user.uid;
        await _saveDeviceToken(user.uid);
      }

      await _listenToPassengerPreferences(user.uid);
    });
  }

  Future<void> _listenToPassengerPreferences(String userId) async {
    await _passengerSubscription?.cancel();
    _passengerSubscription = _firestore
        .collection('passenger_details')
        .doc(userId)
        .snapshots()
        .listen((snapshot) async {
      final data = snapshot.data();
      final preferencesData = data?['preferences'] as Map<String, dynamic>?;
      final notificationsData =
          preferencesData?['notifications'] as Map<String, dynamic>? ?? {};

      _currentSettings =
          PassengerNotificationSettings.fromJson(notificationsData);
      await _syncTopicSubscriptions(userId, _currentSettings!);
    });
  }

  Future<void> _clearActiveUserState() async {
    await _passengerSubscription?.cancel();
    _passengerSubscription = null;
    _currentSettings = null;

    final topicsToRemove = _activeTopics.toList();
    _activeTopics = <String>{};
    _activeUserId = null;

    for (final topic in topicsToRemove) {
      try {
        await _firebaseMessaging.unsubscribeFromTopic(topic);
      } catch (e) {
        print('Failed to unsubscribe from topic $topic: $e');
      }
    }
  }

  Future<void> _syncTopicSubscriptions(
    String userId,
    PassengerNotificationSettings settings,
  ) async {
    final desiredTopics = <String>{
      'user_$userId',
      if (settings.safetyAlerts) 'safety_alerts',
      if (settings.journeyUpdates) 'bus_updates',
      if (settings.emergencyAlerts) 'emergency_alerts',
      if (settings.systemAnnouncements) 'general_announcements',
    };

    final topicsToSubscribe = desiredTopics.difference(_activeTopics);
    final topicsToUnsubscribe = _activeTopics.difference(desiredTopics);

    for (final topic in topicsToSubscribe) {
      try {
        await _firebaseMessaging.subscribeToTopic(topic);
      } catch (e) {
        print('Failed to subscribe to topic $topic: $e');
      }
    }

    for (final topic in topicsToUnsubscribe) {
      try {
        await _firebaseMessaging.unsubscribeFromTopic(topic);
      } catch (e) {
        print('Failed to unsubscribe from topic $topic: $e');
      }
    }

    _activeTopics = desiredTopics;
  }

  Future<void> handleIncomingMessage(
    RemoteMessage message, {
    bool showLocalNotification = false,
    bool openedFromSystemNotification = false,
  }) async {
    if (!_isAllowedByPreferences(message)) {
      return;
    }

    _fcmController.add(message);

    final persistedId = await persistRemoteMessage(
      message,
      markAsRead: openedFromSystemNotification,
    );

    if (showLocalNotification && !_isSilentMessage(message)) {
      await _showLocalNotificationFromFCM(message);
    }

    if (openedFromSystemNotification) {
      _notificationController.add(
        _extractActionUrl(message) ?? persistedId ?? '',
      );
    }
  }

  Future<String?> persistRemoteMessage(
    RemoteMessage message, {
    bool markAsRead = false,
    String? fallbackUserId,
  }) async {
    final resolvedUserId = _resolveUserId(message) ??
        fallbackUserId ??
        _activeUserId ??
        _auth.currentUser?.uid;
    if (resolvedUserId == null || resolvedUserId.isEmpty) {
      return null;
    }

    final documentId = message.messageId;
    final now = DateTime.now();

    if (documentId != null && documentId.isNotEmpty) {
      final existing =
          await _notificationRepository.getNotificationById(documentId);

      if (existing != null) {
        if (markAsRead && !existing.isRead) {
          await _notificationRepository.markAsRead(documentId);
        } else if (existing.status == NotificationStatus.sent) {
          await _notificationRepository.markAsDelivered(documentId);
        }
        return documentId;
      }
    }

    final notification = NotificationModel(
      id: documentId ?? '',
      userId: resolvedUserId,
      type: _mapNotificationType(message.data['type'] as String?),
      title: _extractTitle(message),
      body: _extractBody(message),
      imageUrl: _extractImageUrl(message),
      data: {
        ...message.data,
        if (message.messageId != null) 'messageId': message.messageId,
        if (message.collapseKey != null) 'collapseKey': message.collapseKey,
      },
      priority: _mapNotificationPriority(message.data['priority'] as String?),
      status:
          markAsRead ? NotificationStatus.read : NotificationStatus.delivered,
      sentAt: _extractSentAt(message),
      deliveredAt: now,
      readAt: markAsRead ? now : null,
      isSilent: _isSilentMessage(message),
      actionUrl: _extractActionUrl(message),
    );

    return _notificationRepository.addNotification(
      notification,
      documentId: documentId,
    );
  }

  Future<void> _showLocalNotificationFromFCM(RemoteMessage message) async {
    final title = _extractTitle(message);
    final body = _extractBody(message);

    if (title.isEmpty && body.isEmpty) {
      return;
    }

    final channelId = _getChannelIdFromMessageType(
      message.data['type'] as String?,
    );

    await _localNotifications.show(
      _localNotificationId(message),
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          _getChannelNameFromId(channelId),
          channelDescription: _getChannelDescriptionFromId(channelId),
          importance: _getImportanceFromChannelId(channelId),
          priority: channelId == _safetyChannel.id
              ? Priority.high
              : Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: _extractActionUrl(message),
    );
  }

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
          icon: '@mipmap/ic_launcher',
          color: Colors.red,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          interruptionLevel: isEmergency
              ? InterruptionLevel.critical
              : InterruptionLevel.active,
        ),
      ),
      payload: payload,
    );
  }

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

  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return _localNotifications.pendingNotificationRequests();
  }

  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  Future<NotificationSettings> getNotificationSettings() async {
    return _firebaseMessaging.getNotificationSettings();
  }

  Future<String?> getFCMToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      print('FCM Token: $token');
      return token;
    } catch (e) {
      print('Error getting FCM token: $e');
      return null;
    }
  }

  Stream<String> get tokenStream => _firebaseMessaging.onTokenRefresh;

  Future<void> _saveDeviceToken(
    String userId, {
    String? token,
  }) async {
    try {
      final resolvedToken = token ?? await getFCMToken();
      if (resolvedToken == null || resolvedToken.isEmpty) {
        return;
      }

      await _firestore.collection('passenger_details').doc(userId).set(
        {
          'deviceTokens': FieldValue.arrayUnion([resolvedToken]),
          'lastNotificationTokenUpdatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      print('Failed to save device token: $e');
    }
  }

  String? _resolveUserId(RemoteMessage message) {
    return _extractStringFromKeys(
      message.data,
      const ['userId', 'recipientUserId', 'passengerId'],
    );
  }

  String _extractTitle(RemoteMessage message) {
    return message.notification?.title ??
        _extractStringFromKeys(
          message.data,
          const ['title', 'notificationTitle'],
        ) ??
        'SafeDriver update';
  }

  String _extractBody(RemoteMessage message) {
    return message.notification?.body ??
        _extractStringFromKeys(
          message.data,
          const ['body', 'message', 'notificationBody'],
        ) ??
        '';
  }

  String? _extractImageUrl(RemoteMessage message) {
    return _extractStringFromKeys(
      message.data,
      const ['imageUrl', 'image', 'notificationImage'],
    );
  }

  String? _extractActionUrl(RemoteMessage message) {
    return _extractStringFromKeys(
      message.data,
      const ['actionUrl', 'route', 'deeplink', 'payload'],
    );
  }

  DateTime _extractSentAt(RemoteMessage message) {
    final sentAtRaw = _extractStringFromKeys(
      message.data,
      const ['sentAt', 'timestamp', 'createdAt'],
    );

    if (sentAtRaw != null) {
      final parsed = DateTime.tryParse(sentAtRaw);
      if (parsed != null) {
        return parsed;
      }

      final millis = int.tryParse(sentAtRaw);
      if (millis != null) {
        return DateTime.fromMillisecondsSinceEpoch(millis);
      }
    }

    return message.sentTime ?? DateTime.now();
  }

  NotificationType _mapNotificationType(String? rawType) {
    switch ((rawType ?? '').toLowerCase()) {
      case 'registration':
      case 'signup':
        return NotificationType.registration;
      case 'login':
      case 'security':
        return NotificationType.login;
      case 'feedback':
        return NotificationType.feedback;
      case 'feedback_status':
      case 'feedbackstatus':
        return NotificationType.feedbackStatus;
      case 'profile':
      case 'account':
        return NotificationType.profile;
      case 'journey':
      case 'trip':
      case 'bus':
        return NotificationType.journey;
      default:
        return NotificationType.general;
    }
  }

  NotificationPriority _mapNotificationPriority(String? rawPriority) {
    switch ((rawPriority ?? '').toLowerCase()) {
      case 'low':
        return NotificationPriority.low;
      case 'high':
      case 'urgent':
      case 'critical':
        return NotificationPriority.high;
      default:
        return NotificationPriority.normal;
    }
  }

  bool _isAllowedByPreferences(RemoteMessage message) {
    final settings = _currentSettings;
    if (settings == null) {
      return true;
    }

    final type = (message.data['type'] as String? ?? '').toLowerCase();
    if (type == 'safety') {
      return settings.safetyAlerts;
    }
    if (type == 'emergency') {
      return settings.emergencyAlerts;
    }
    if (type == 'bus' || type == 'journey' || type == 'trip') {
      return settings.journeyUpdates;
    }
    if (type == 'system' || type == 'announcement') {
      return settings.systemAnnouncements;
    }

    return true;
  }

  bool _isSilentMessage(RemoteMessage message) {
    final silentValue = _extractStringFromKeys(
      message.data,
      const ['silent', 'isSilent'],
    );
    return silentValue == 'true' || silentValue == '1';
  }

  int _localNotificationId(RemoteMessage message) {
    final messageId = message.messageId;
    if (messageId != null && messageId.isNotEmpty) {
      return messageId.hashCode;
    }

    return DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }

  void _onNotificationTapped(NotificationResponse response) {
    _notificationController.add(response.payload ?? '');
  }

  String _getChannelIdFromMessageType(String? type) {
    switch ((type ?? '').toLowerCase()) {
      case 'safety':
      case 'emergency':
        return _safetyChannel.id;
      case 'bus':
      case 'journey':
      case 'trip':
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
      default:
        return _generalChannel.name;
    }
  }

  String _getChannelDescriptionFromId(String channelId) {
    switch (channelId) {
      case 'safety_alerts':
        return _safetyChannel.description ?? '';
      case 'bus_updates':
        return _busUpdatesChannel.description ?? '';
      case 'general':
      default:
        return _generalChannel.description ?? '';
    }
  }

  Importance _getImportanceFromChannelId(String channelId) {
    switch (channelId) {
      case 'safety_alerts':
        return Importance.high;
      case 'bus_updates':
      case 'general':
      default:
        return Importance.defaultImportance;
    }
  }

  String? _extractStringFromKeys(
    Map<String, dynamic> data,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = data[key];
      if (value is String && value.isNotEmpty) {
        return value;
      }
    }

    return null;
  }

  @pragma('vm:entry-point')
  static Future<void> persistBackgroundMessage(RemoteMessage message) async {
    await NotificationService.instance.persistRemoteMessage(message);
  }

  void dispose() {
    _notificationController.close();
    _fcmController.close();
    _authSubscription?.cancel();
    _passengerSubscription?.cancel();
    _tokenRefreshSubscription?.cancel();
  }
}

class NotificationPermissionDeniedException implements Exception {
  final String message = 'Notification permission denied';
}

class NotificationInitializationException implements Exception {
  final String message;
  NotificationInitializationException(this.message);
}
