import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safedriver_passenger_app/data/models/notification_model.dart';
import 'package:safedriver_passenger_app/data/repositories/notification_repository.dart';

import 'auth_provider.dart';

/// Notification repository provider
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository();
});

/// Current user's notifications stream
final userNotificationsProvider =
    StreamProvider<List<NotificationModel>>((ref) {
  final authState = ref.watch(authStateProvider);
  final user = authState.user;

  if (user != null) {
    final repository = ref.watch(notificationRepositoryProvider);
    return repository.getUserNotifications(user.uid);
  } else {
    return Stream.value([]);
  }
});

/// Unread notifications count
final unreadNotificationCountProvider = StreamProvider<int>((ref) {
  final authState = ref.watch(authStateProvider);
  final user = authState.user;

  if (user != null) {
    final repository = ref.watch(notificationRepositoryProvider);
    return repository.getUnreadNotificationCount(user.uid);
  } else {
    return Stream.value(0);
  }
});

/// Recent notifications (last 7 days)
final recentNotificationsProvider =
    StreamProvider<List<NotificationModel>>((ref) {
  final authState = ref.watch(authStateProvider);
  final user = authState.user;

  if (user != null) {
    final repository = ref.watch(notificationRepositoryProvider);
    return repository.getRecentNotifications(user.uid);
  } else {
    return Stream.value([]);
  }
});

/// Notifications by type
final notificationsByTypeProvider =
    StreamProvider.family<List<NotificationModel>, NotificationType>(
        (ref, type) {
  final authState = ref.watch(authStateProvider);
  final user = authState.user;

  if (user != null) {
    final repository = ref.watch(notificationRepositoryProvider);
    return repository.getUserNotificationsByType(user.uid, type);
  } else {
    return Stream.value([]);
  }
});

/// Notification controller
final notificationControllerProvider =
    StateNotifierProvider<NotificationController, AsyncValue<void>>((ref) {
  return NotificationController(ref);
});

class NotificationController extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;
  late final NotificationRepository _repository;

  NotificationController(this._ref) : super(const AsyncValue.data(null)) {
    _repository = _ref.read(notificationRepositoryProvider);
  }

  /// Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      state = const AsyncValue.loading();
      await _repository.markAsRead(notificationId);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead(String userId) async {
    try {
      state = const AsyncValue.loading();
      await _repository.markAllAsRead(userId);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Mark all notifications as read for the signed-in user
  Future<void> markAllAsReadForCurrentUser() async {
    final user = _ref.read(authStateProvider).user;
    if (user == null) {
      return;
    }

    await markAllAsRead(user.uid);
  }

  /// Delete notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      state = const AsyncValue.loading();
      await _repository.deleteNotification(notificationId);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Delete all notifications
  Future<void> deleteAllNotifications(String userId) async {
    try {
      state = const AsyncValue.loading();
      await _repository.deleteAllNotifications(userId);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Delete all notifications for the signed-in user
  Future<void> deleteAllNotificationsForCurrentUser() async {
    final user = _ref.read(authStateProvider).user;
    if (user == null) {
      return;
    }

    await deleteAllNotifications(user.uid);
  }

  /// Send login welcome notification
  Future<void> sendLoginWelcome(String firstName) async {
    try {
      state = const AsyncValue.loading();
      final functions = FirebaseFunctions.instance;
      final callable = functions.httpsCallable('sendLoginWelcomeNotification');
      await callable.call({'firstName': firstName});
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Send journey started notification
  Future<void> sendJourneyStarted({
    required String journeyId,
    required String busNumber,
    required String destination,
    required String departureTime,
  }) async {
    try {
      state = const AsyncValue.loading();
      final functions = FirebaseFunctions.instance;
      final callable =
          functions.httpsCallable('sendJourneyStartedNotification');
      await callable.call({
        'journeyId': journeyId,
        'busNumber': busNumber,
        'destination': destination,
        'departureTime': departureTime,
      });
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Send journey completed notification
  Future<void> sendJourneyCompleted({
    required String journeyId,
    required String busNumber,
    required String destination,
    required String duration,
  }) async {
    try {
      state = const AsyncValue.loading();
      final functions = FirebaseFunctions.instance;
      final callable =
          functions.httpsCallable('sendJourneyCompletedNotification');
      await callable.call({
        'journeyId': journeyId,
        'busNumber': busNumber,
        'destination': destination,
        'duration': duration,
      });
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
