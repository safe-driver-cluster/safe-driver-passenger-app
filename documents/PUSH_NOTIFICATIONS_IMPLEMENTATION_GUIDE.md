# SafeDriver Push Notification System - Implementation Guide

## Overview
This Implementation Guide covers the complete Firebase-based push notification system for SafeDriver, including:
- Time-based dashboard greetings
- Firebase Cloud Functions for sending notifications
- Firestore notification storage
- Device token management
- Automatic notification triggers for key user actions

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         Flutter App                             │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ Dashboard (Time-based Greeting with User Name)            │  │
│  │ - Good Morning/Afternoon/Evening/Night + User firstName   │  │
│  └──────────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ Notification Service (FCM + Local Notifications)         │  │
│  │ - Manages device tokens                                  │  │
│  │ - Displays push notifications                            │  │
│  │ - Tracks notification delivery                           │  │
│  └──────────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ Notification Repository & Providers                      │  │
│  │ - Manage Firestore notifications collection              │  │
│  │ - Stream notifications to UI                             │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
                           ↕️ Firebase SDK
┌─────────────────────────────────────────────────────────────────┐
│                      Firebase Backend                           │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ Cloud Functions (Node.js)                               │  │
│  │ - sendRegistrationNotification (Auth trigger)            │  │
│  │ - sendLoginWelcomeNotification (HTTP callable)           │  │
│  │ - sendFeedbackNotification (Firestore trigger)           │  │
│  │ - sendFeedbackStatusNotification (Firestore trigger)     │  │
│  │ - sendProfileUpdateNotification (Firestore trigger)      │  │
│  │ - sendJourneyStartedNotification (HTTP callable)         │  │
│  │ - sendJourneyCompletedNotification (HTTP callable)       │  │
│  │ - sendBulkNotification (Admin callable)                  │  │
│  └──────────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ Firestore Collections                                    │  │
│  │ - /notifications/{notificationId}                         │  │
│  │ - /passenger_details/{userId} (with deviceTokens array)  │  │
│  │ - /feedbacks/{feedbackId}                                │  │
│  │ - /journeys/{journeyId}                                  │  │
│  └──────────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ Firebase Messaging                                       │  │
│  │ - Sends FCM messages to devices                          │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

## Files Created/Modified

### 1. **Dart Files**

#### New Files:
- `lib/data/models/notification_model.dart` - Complete notification model with enums
- `lib/data/repositories/notification_repository.dart` - Firestore operations for notifications
- `lib/core/utils/greeting_util.dart` - Time-based greeting utility
- `lib/providers/notification_provider.dart` - Riverpod providers for notifications

#### Modified Files:
- `lib/presentation/pages/dashboard/safe_driver_dashboard.dart` - Added time-based greeting with user name
- `lib/core/services/notification_service.dart` - Added FCM token management methods

### 2. **Node.js Files**

#### New Files:
- `backend/functions/notifications.js` - All Cloud Functions for notifications

#### Modified Files:
- `backend/functions/index.js` - Import notifications functions

### 3. **Firestore Rules**

#### New Files:
- `documents/FIRESTORE_NOTIFICATION_RULES.md` - Security rules for notification collections

## Step-by-Step Implementation

### Step 1: Update Firestore Security Rules

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project
3. Go to **Firestore Database** → **Rules**
4. Copy the rules from `documents/FIRESTORE_NOTIFICATION_RULES.md`
5. Click **Publish**

### Step 2: Store Device Tokens in Firestore

Update your `passenger_service.dart` to save device tokens:

```dart
import 'package:safedriver_passenger_app/core/services/notification_service.dart';

Future<void> saveDeviceToken() async {
  try {
    final token = await NotificationService.instance.getFCMToken();
    if (token != null && _currentUser != null) {
      final userRef = _firestore.collection('passenger_details').doc(_currentUser!.uid);
      await userRef.update({
        'deviceTokens': FieldValue.arrayUnion([token]),
      });
    }
  } catch (e) {
    print('Error saving device token: $e');
  }
}

// Call this in your authentication service after successful login
```

### Step 3: Deploy Cloud Functions

```bash
cd backend/functions
npm install
firebase deploy --only functions
```

### Step 4: Integrate Notifications in Auth Service

Add this to your `auth_service.dart`:

```dart
Future<UserCredential> signInWithEmailAndPassword({
  required String email,
  required String password,
  bool rememberMe = false,
}) async {
  // ... existing code ...
  
  final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
    email: email,
    password: password,
  );

  // Save device token
  await _saveDeviceToken(userCredential.user!.uid);
  
  // Send login welcome notification
  // This will be triggered by the Cloud Function

  return userCredential;
}

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

### Step 5: Integrate Notifications in Feedback Service

Update your feedback service to trigger notifications:

```dart
Future<String> submitFeedback(FeedbackModel feedback) async {
  try {
    final docRef = await _firestore.collection('feedbacks').add(feedback.toJson());
    
    // Cloud Function will automatically send notification when trigger fires
    // sendFeedbackNotification will be called automatically
    
    return docRef.id;
  } catch (e) {
    print('Error submitting feedback: $e');
    throw _handleException(e);
  }
}

Future<void> updateFeedbackStatus(String feedbackId, String newStatus) async {
  try {
    await _firestore.collection('feedbacks').doc(feedbackId).update({
      'status': newStatus,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    
    // Cloud Function will automatically send notification when status changes
    // sendFeedbackStatusNotification will be called automatically
  } catch (e) {
    print('Error updating feedback status: $e');
    throw _handleException(e);
  }
}
```

### Step 6: Integrate Notifications in Profile Service

Update your profile service:

```dart
Future<void> updateProfile({
  required String userId,
  required Map<String, dynamic> updates,
}) async {
  try {
    await _firestore.collection('passenger_details').doc(userId).update({
      ...updates,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    
    // Cloud Function will automatically send notification when profile changes
    // sendProfileUpdateNotification will be called automatically
  } catch (e) {
    print('Error updating profile: $e');
    throw _handleException(e);
  }
}
```

### Step 7: Integrate Notifications in Journey Service

Update your journey service:

```dart
Future<void> startJourney({
  required String journeyId,
  required String busNumber,
  required String destination,
  required String departureTime,
}) async {
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
    print('Error starting journey notification: $e');
  }
}

Future<void> completeJourney({
  required String journeyId,
  required String busNumber,
  required String destination,
  required String duration,
}) async {
  try {
    final functions = FirebaseFunctions.instance;
    final callable = functions.httpsCallable('sendJourneyCompletedNotification');
    
    await callable.call({
      'journeyId': journeyId,
      'busNumber': busNumber,
      'destination': destination,
      'duration': duration,
    });
  } catch (e) {
    print('Error completing journey notification: $e');
  }
}
```

### Step 8: Update Dashboard with Notifications

Create a notifications indicator on the dashboard:

```dart
// In SafeDriverDashboard or DashboardPage
Consumer(
  builder: (context, ref, child) {
    final unreadCount = ref.watch(unreadNotificationCountProvider);
    
    return unreadCount.when(
      data: (count) {
        return Container(
          child: count > 0
              ? Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Text(
                      '$count',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : SizedBox.shrink(),
        );
      },
      loading: () => SizedBox.shrink(),
      error: (err, stack) => SizedBox.shrink(),
    );
  },
)
```

## Notification Types & Triggers

### 1. **Registration Notification** 🎉
- **Trigger**: User creates account (Firebase Auth onCreate)
- **Title**: "Welcome to SafeDriver!"
- **Body**: "Your account has been created successfully..."
- **Automatic**: Yes

### 2. **Login Welcome Notification** 👋
- **Trigger**: First login (via Cloud Function)
- **Title**: "Welcome Back!"
- **Body**: "Hello [FirstName]! Ready to explore safe routes?..."
- **Automatic**: Yes
- **Call**: Manually call `sendLoginWelcomeNotification` after login

### 3. **Feedback Submission Notification** 💬
- **Trigger**: Feedback submitted to Firestore (onCreate)
- **Title**: "Feedback Received"
- **Body**: "Thank you for your feedback!..."
- **Automatic**: Yes

### 4. **Feedback Status Update Notification** 📝
- **Trigger**: Feedback status changed (onUpdate)
- **Title**: "Feedback Status Update"
- **Body**: Status-specific message
- **Automatic**: Yes

### 5. **Profile Update Notification** 👤
- **Trigger**: Profile updated in Firestore (onUpdate)
- **Title**: "Profile Updated"
- **Body**: "Your profile has been updated..."
- **Automatic**: Yes

### 6. **Journey Notifications** 🚌
- **Journey Started**: User starts a journey
  - **Title**: "Journey Started"
  - **Body**: "Your journey on bus [number] to [destination] has started..."
  - **Manual Call**: `sendJourneyStartedNotification`

- **Journey Completed**: User completes a journey
  - **Title**: "Journey Completed"
  - **Body**: "Your journey completed in [duration]..."
  - **Manual Call**: `sendJourneyCompletedNotification`

## Dashboard Greeting Feature

The dashboard now displays time-based greetings:
- 5 AM - 12 PM: "Good Morning 🌅"
- 12 PM - 5 PM: "Good Afternoon ☀️"
- 5 PM - 9 PM: "Good Evening 🌆"
- 9 PM - 5 AM: "Good Night 🌙"

Followed by the user's first name: "Good Morning, Ahmed 🌅"

## Testing

### Test Device Token Storage:
```dart
// In your app initialization
void testNotifications() async {
  final token = await NotificationService.instance.getFCMToken();
  print('Device Token: $token');
  
  // Save to Firestore
  await FirebaseFirestore.instance
      .collection('passenger_details')
      .doc(userId)
      .update({
    'deviceTokens': FieldValue.arrayUnion([token]),
  });
}
```

### Test Cloud Functions Locally:
```bash
cd backend/functions
firebase emulators:start --only functions
```

### View Notification Logs:
```bash
firebase functions:log
```

## Troubleshooting

### Notifications Not Appearing

1. **Check Device Tokens**:
   - Verify tokens are saved in `passenger_details.deviceTokens`
   - Check if tokens are invalid or expired

2. **Check Firestore Rules**:
   - Ensure security rules allow read/write to notifications collection
   - Verify `userId` field matches authenticated user

3. **Check Cloud Function Logs**:
   ```bash
   firebase functions:log
   ```

4. **Check FCM Registration**:
   - Ensure device is receiving FCM messages
   - Check device has notification permissions enabled

### Device Tokens Disappearing

- FCM tokens can change when:
  - App is reinstalled
  - User clears app data
  - User logs out and logs back in
- Always append tokens with `FieldValue.arrayUnion()` to preserve old tokens

### Notifications Delayed

- FCM is best-effort delivery
- For critical notifications, consider:
  - Combining with SMS via TextLK
  - Using high priority flag (already configured)
  - Storing in Firestore for later retrieval

## Best Practices

1. **Always Save Device Tokens**:
   - Save on app launch
   - Save on token refresh
   - Add to `deviceTokens` array, don't replace

2. **Handle Token Refresh**:
   ```dart
   NotificationService.instance.tokenStream.listen((token) {
     // Save new token to Firestore
   });
   ```

3. **Implement Notification Viewer**:
   - Display stored notifications from `/notifications` collection
   - Mark as read when viewed
   - Allow deletion

4. **Monitor Notification Delivery**:
   - Track delivery status
   - Log failed sends
   - Implement retry logic if needed

5. **Respect User Privacy**:
   - Only send relevant notifications
   - Provide notification preference settings
   - Allow users to opt-out

## Security Considerations

1. **Validate All Inputs**:
   - Phone numbers
   - Email addresses
   - User data in functions

2. **Rate Limiting**:
   - Already implemented in SMS gateway
   - Consider adding for notification functions

3. **Data Privacy**:
   - Don't store sensitive data in notifications
   - Use encrypted transmission
   - Comply with data privacy regulations

4. **Function Permissions**:
   - Only allow authenticated users to call notification functions
   - Use Cloud Function security context

## Monitoring & Analytics

Consider adding analytics:

```dart
// Track notification opens
FirebaseAnalytics.instance.logEvent(
  name: 'notification_opened',
  parameters: {
    'notification_type': notificationType,
    'notification_id': notificationId,
  },
);
```

## Future Enhancements

1. **Notification Scheduling**:
   - Schedule notifications for optimal delivery times
   - User timezone considerations

2. **Smart Notifications**:
   - ML-based notification timing
   - User behavior prediction

3. **Rich Notifications**:
   - Images and videos in notifications
   - Interactive buttons

4. **Integration with Other Services**:
   - Email notifications
   - In-app message center
   - Notification preferences management

5. **Analytics Dashboard**:
   - Track notification delivery rates
   - User engagement metrics
   - A/B testing capabilities

## Support & Maintenance

- **Monitor Cloud Function Executions**: Check Firebase Console for errors
- **Review Firestore Usage**: Monitor reads/writes for notifications
- **Update Security Rules**: Review quarterly for changes
- **Test After Updates**: Always test notification flow after code changes

---

**Last Updated**: March 2026
**Version**: 1.0.0
