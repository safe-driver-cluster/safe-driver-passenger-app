# SafeDriver Notifications - Integration Points

This document lists all the places in existing services where notification integration needs to be added.

## 1. Auth Service (`lib/data/services/auth_service.dart`)

### After Successful Registration
```dart
Future<UserCredential> createUserWithEmailAndPassword({
  required String email,
  required String password,
}) async {
  try {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // ✅ ADD: Save device token to passenger_details
    await _saveDeviceToken(userCredential.user!.uid);

    // Cloud Function will send registration notification automatically

    return userCredential;
  } catch (e) {
    throw _handleAuthError(e);
  }
}

// ✅ ADD: Helper method
Future<void> _saveDeviceToken(String userId) async {
  try {
    final token = await NotificationService.instance.getFCMToken();
    if (token != null) {
      await FirebaseFirestore.instance
          .collection('passenger_details')
          .doc(userId)
          .update({
        'deviceTokens': FieldValue.arrayUnion([token]),
      });
    }
  } catch (e) {
    print('Error saving device token: $e');
  }
}
```

### After Successful Login
```dart
Future<UserCredential> signInWithEmailAndPassword({
  required String email,
  required String password,
  bool rememberMe = false,
}) async {
  try {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // ✅ ADD: Save device token
    await _saveDeviceToken(userCredential.user!.uid);

    // ✅ ADD: Send welcome notification for first login
    try {
      final ref = _firebaseAuth.currentUser;
      if (ref != null) {
        final functions = FirebaseFunctions.instance;
        final callable = functions.httpsCallable('sendLoginWelcomeNotification');
        
        // Get first name from passenger_details
        final passengerDoc = await FirebaseFirestore.instance
            .collection('passenger_details')
            .doc(ref.uid)
            .get();
        final firstName = passengerDoc.data()?['firstName'] ?? 'Traveler';
        
        await callable.call({'firstName': firstName});
      }
    } catch (e) {
      print('Error sending welcome notification: $e');
      // Don't fail login if notification fails
    }

    return userCredential;
  } catch (e) {
    throw _handleAuthError(e);
  }
}
```

---

## 2. Feedback Service (`lib/data/services/feedback_service.dart` or similar)

### On Feedback Submission
```dart
Future<String> submitFeedback(FeedbackModel feedback) async {
  try {
    // Add feedback to Firestore
    final docRef = await _firestore
        .collection('feedbacks')
        .add(feedback.toJson());

    // ✅ AUTOMATIC: Cloud Function 'sendFeedbackNotification' will trigger on firestore onCreate

    return docRef.id;
  } catch (e) {
    print('Error submitting feedback: $e');
    throw _handleException(e);
  }
}
```

### On Feedback Status Update
```dart
Future<void> updateFeedbackStatus(
  String feedbackId,
  String newStatus,
) async {
  try {
    await _firestore
        .collection('feedbacks')
        .doc(feedbackId)
        .update({
      'status': newStatus,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // ✅ AUTOMATIC: Cloud Function 'sendFeedbackStatusNotification' will trigger on firestore onUpdate

  } catch (e) {
    print('Error updating feedback status: $e');
    throw _handleException(e);
  }
}
```

---

## 3. Passenger/Profile Service (`lib/data/services/passenger_service.dart`)

### On Profile Update
```dart
Future<void> updateProfile(
  String userId,
  Map<String, dynamic> updates,
) async {
  try {
    await _firestore
        .collection('passenger_details')
        .doc(userId)
        .update({
      ...updates,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // ✅ AUTOMATIC: Cloud Function 'sendProfileUpdateNotification' will trigger on firestore onUpdate
    // It detects changes to: firstName, lastName, phoneNumber, profileImageUrl, address

  } catch (e) {
    print('Error updating profile: $e');
    throw _handleException(e);
  }
}
```

### Save Device Token on Init
```dart
Future<void> initializePassengerProfile(String userId) async {
  try {
    // ✅ ADD: Save device token
    final token = await NotificationService.instance.getFCMToken();
    if (token != null) {
      await _firestore
          .collection('passenger_details')
          .doc(userId)
          .update({
        'deviceTokens': FieldValue.arrayUnion([token]),
      });
    }

    // ... rest of initialization
  } catch (e) {
    print('Error initializing profile: $e');
  }
}
```

### Handle Token Refresh
```dart
void setupTokenRefreshListener(String userId) {
  // ✅ ADD: Listen for FCM token refreshes
  NotificationService.instance.tokenStream.listen((newToken) {
    _firestore
        .collection('passenger_details')
        .doc(userId)
        .update({
      'deviceTokens': FieldValue.arrayUnion([newToken]),
    }).catchError((e) {
      print('Error updating refreshed token: $e');
    });
  });
}
```

---

## 4. Journey/Trip Service (Create if needed)

### On Journey Start
```dart
Future<void> startJourney({
  required String journeyId,
  required String busNumber,
  required String destination,
  required String departureTime,
}) async {
  try {
    // Create journey record in Firestore
    await _firestore
        .collection('journeys')
        .doc(journeyId)
        .set({
      'busNumber': busNumber,
      'destination': destination,
      'departureTime': departureTime,
      'status': 'active',
      'startedAt': FieldValue.serverTimestamp(),
    });

    // ✅ ADD: Send journey started notification
    try {
      final functions = FirebaseFunctions.instance;
      final callable = functions.httpsCallable('sendJourneyStartedNotification');
      
      await callable.call({
        'journeyId': journeyId,
        'busNumber': busNumber,
        'destination': destination,
        'departureTime': departureTime,
      });
    } catch (e) {
      print('Error sending journey notification: $e');
    }

  } catch (e) {
    print('Error starting journey: $e');
    throw _handleException(e);
  }
}
```

### On Journey Complete
```dart
Future<void> completeJourney({
  required String journeyId,
  required String busNumber,
  required String destination,
  required Duration duration,
}) async {
  try {
    // Update journey record
    await _firestore
        .collection('journeys')
        .doc(journeyId)
        .update({
      'status': 'completed',
      'completedAt': FieldValue.serverTimestamp(),
      'duration': duration.inMinutes,
    });

    // ✅ ADD: Send journey completed notification
    try {
      final functions = FirebaseFunctions.instance;
      final callable = functions.httpsCallable('sendJourneyCompletedNotification');
      
      final durationStr = '${duration.inHours}h ${duration.inMinutes % 60}m';
      
      await callable.call({
        'journeyId': journeyId,
        'busNumber': busNumber,
        'destination': destination,
        'duration': durationStr,
      });
    } catch (e) {
      print('Error sending completion notification: $e');
    }

  } catch (e) {
    print('Error completing journey: $e');
    throw _handleException(e);
  }
}
```

---

## 5. Main App Initialization (`lib/main.dart`)

### Initialize Notifications & Save Token
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ... existing initialization code ...

  // ✅ ADD: Initialize notification service
  await NotificationService.instance.initialize();

  // ✅ ADD: Save device token if user is authenticated
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final token = await NotificationService.instance.getFCMToken();
    if (token != null) {
      await FirebaseFirestore.instance
          .collection('passenger_details')
          .doc(user.uid)
          .update({
        'deviceTokens': FieldValue.arrayUnion([token]),
      }).catchError((e) {
        print('Error saving initial token: $e');
      });
    }
  }

  runApp(const MyApp());
}
```

### Listen for Auth State Changes
```dart
// ✅ ADD: In your main app or auth provider
void _setupAuthListeners() {
  FirebaseAuth.instance.authStateChanges().listen((user) {
    if (user != null) {
      // Save device token on login
      NotificationService.instance.getFCMToken().then((token) {
        if (token != null) {
          FirebaseFirestore.instance
              .collection('passenger_details')
              .doc(user.uid)
              .update({
            'deviceTokens': FieldValue.arrayUnion([token]),
          });
        }
      });
    }
  });
}
```

---

## 6. Notification Viewer Page (Create New)

```dart
// lib/presentation/pages/profile/received_notifications_page.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safedriver_passenger_app/providers/notification_provider.dart';

class ReceivedNotificationsPage extends ConsumerWidget {
  const ReceivedNotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsyncValue = ref.watch(userNotificationsProvider);
    final unreadCount = ref.watch(unreadNotificationCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        elevation: 0,
      ),
      body: notificationsAsyncValue.when(
        data: (notifications) {
          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No notifications yet'),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return ListTile(
                leading: Text(notification.typeEmoji, style: TextStyle(fontSize: 24)),
                title: Text(notification.title),
                subtitle: Text(notification.body),
                trailing: notification.isRead ? null : 
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                onTap: () {
                  // Mark as read
                  ref.read(notificationControllerProvider.notifier)
                      .markAsRead(notification.id);
                },
                onLongPress: () {
                  // Delete notification
                  ref.read(notificationControllerProvider.notifier)
                      .deleteNotification(notification.id);
                },
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
```

---

## Summary of Changes Required

### ✅ Automatic (No Code Changes Needed)
- [ ] Registration Notification
- [ ] Feedback Submission Notification
- [ ] Feedback Status Update Notification
- [ ] Profile Update Notification

### ⚠️ Semi-Automatic (Trigger via Cloud Function)
- [ ] Login Welcome Notification (call function after login)
- [ ] Journey Started Notification (call function when journey starts)
- [ ] Journey Completed Notification (call function when journey completes)

### 🔧 Manual Integration Required
- [ ] Save device tokens in auth service
- [ ] Save device tokens in passenger service
- [ ] Listen for token refresh
- [ ] Create notification viewer page
- [ ] Update dashboard with greeting
- [ ] Add notification bell with unread count

## Priority Order

1. **Critical (Must Do)**
   - [ ] Update auth service to save device tokens
   - [ ] Deploy Cloud Functions
   - [ ] Update Firestore security rules

2. **High (Should Do)**
   - [ ] Add token refresh listener
   - [ ] Create notification viewer page
   - [ ] Test all notification triggers

3. **Medium (Nice to Have)**
   - [ ] Add notification preferences UI
   - [ ] Add notification bell with count
   - [ ] Add analytics

4. **Low (Future)**
   - [ ] Rich notifications with images
   - [ ] Notification scheduling
   - [ ] SMS fallback for critical notifications

---

**Version**: 1.0.0  
**Last Updated**: March 2026
