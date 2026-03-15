# SafeDriver Push Notifications - Quick Start Guide

## What Was Built

✅ **Complete Firebase-based Push Notification System** with automatic triggers for:
- Account creation (Registration)
- First-time login (Welcome)
- Feedback submissions & status updates
- Profile updates
- Active journey events

✅ **Time-based Dashboard Greetings**
- Shows "Good Morning/Afternoon/Evening/Night" + User's First Name + Emoji
- Updates automatically based on device time

✅ **Firestore Notification Storage**
- All notifications stored in `/notifications` collection
- Track delivery status
- Support for read/unread states

## Files Created

### Dart/Flutter Files
```
lib/
├── data/
│   ├── models/
│   │   └── notification_model.dart (NEW) - Complete notification model with enums
│   └── repositories/
│       └── notification_repository.dart (NEW) - Firestore CRUD operations
├── core/
│   ├── utils/
│   │   └── greeting_util.dart (NEW) - Time-based greeting helper
│   └── services/
│       └── notification_service.dart (MODIFIED) - Added FCM token methods
├── providers/
│   └── notification_provider.dart (NEW) - Riverpod providers
└── presentation/
    └── pages/
        └── dashboard/
            └── safe_driver_dashboard.dart (MODIFIED) - Added time-based greeting
```

### Node.js Files
```
backend/functions/
├── notifications.js (NEW) - All Cloud Functions
└── index.js (MODIFIED) - Import notifications
```

### Documentation
```
documents/
├── PUSH_NOTIFICATIONS_IMPLEMENTATION_GUIDE.md (NEW) - Complete implementation guide
├── FIRESTORE_NOTIFICATION_RULES.md (NEW) - Security rules
└── PUSH_NOTIFICATIONS_QUICK_START.md (THIS FILE)
```

## Quick Integration Steps

### 1️⃣ Update Firestore Security Rules (REQUIRED)

Copy rules from `documents/FIRESTORE_NOTIFICATION_RULES.md` to Firebase Console:
- Go to Firestore Database → Rules
- Paste the rules
- Click Publish

**Time: 2 minutes**

### 2️⃣ Deploy Cloud Functions

```bash
cd backend/functions
npm install
firebase deploy --only functions
```

**Time: 5 minutes**

### 3️⃣ Save Device Tokens in Auth Service

Add to your `auth_service.dart` after login:

```dart
// After successful login
final token = await NotificationService.instance.getFCMToken();
if (token != null) {
  await FirebaseFirestore.instance
      .collection('passenger_details')
      .doc(userId)
      .update({
    'deviceTokens': FieldValue.arrayUnion([token]),
  });
}
```

**Time: 5 minutes**

### 4️⃣ Test Dashboard Greeting

Run your app and check the dashboard:
- Should show: "Good Morning, [FirstName] 🌅" (or appropriate time-based greeting)

**Time: 3 minutes**

## Notification Triggers

| Event | Type | When Sent | Manual? |
|-------|------|-----------|---------|
| **Account Created** | registration | User signup (Auth trigger) | No |
| **First Login** | login | After login (Cloud Function) | Call `sendLoginWelcome()` |
| **Feedback Submitted** | feedback | When added to Firestore | No |
| **Feedback Status** | feedbackStatus | When status field changes | No |
| **Profile Updated** | profile | When user updates profile | No |
| **Journey Started** | journey | User starts journey | Call `sendJourneyStarted()` |
| **Journey Completed** | journey | User completes journey | Call `sendJourneyCompleted()` |

## Key Components

### 1. **NotificationModel** (`notification_model.dart`)
```dart
NotificationType enum:
- registration
- login
- feedback
- feedbackStatus
- profile
- journey
- general

NotificationPriority enum:
- low
- normal
- high

NotificationStatus enum:
- sent
- delivered
- read
- failed
```

### 2. **NotificationRepository** (`notification_repository.dart`)
Methods:
- `addNotification()` - Store in Firestore
- `getUserNotifications()` - Get user's notifications
- `markAsRead()` - Mark as read
- `deleteNotification()` - Delete notification

### 3. **GreetingUtil** (`greeting_util.dart`)
Methods:
- `getTimeBasedGreeting()` - Returns greeting text
- `getGreetingEmoji()` - Returns appropriate emoji
- `getFullGreeting(firstName)` - Complete greeting with name

### 4. **Cloud Functions** (`notifications.js`)
Triggers:
- `sendRegistrationNotification` - Auth onCreate
- `sendLoginWelcomeNotification` - HTTP callable
- `sendFeedbackNotification` - Firestore onCreate
- `sendFeedbackStatusNotification` - Firestore onUpdate
- `sendProfileUpdateNotification` - Firestore onUpdate
- `sendJourneyStartedNotification` - HTTP callable
- `sendJourneyCompletedNotification` - HTTP callable

## Testing

### Test 1: Dashboard Greeting
```dart
// Should see time-based greeting in SafeDriverDashboard
// Check at different times to see it change:
// - Morning (5-12): "Good Morning, Ahmed 🌅"
// - Afternoon (12-17): "Good Afternoon, Ahmed ☀️"
// - Evening (17-21): "Good Evening, Ahmed 🌆"
// - Night (21-5): "Good Night, Ahmed 🌙"
```

### Test 2: Device Token Storage
```dart
// In your auth service after login:
final token = await NotificationService.instance.getFCMToken();
print('Device Token: $token');

// Go to Firebase Console → Firestore → passenger_details → [your-user-id]
// Should see 'deviceTokens' array with your token
```

### Test 3: Registration Notification
```dart
// Sign up a new account
// Wait 2 seconds
// Should receive notification: "🎉 Welcome to SafeDriver!"
```

### Test 4: Cloud Function Logs
```bash
firebase functions:log

# Should see messages like:
# "Registration notification triggered for user: abc123"
# "FCM push notification sent to 1 devices"
```

## Providers Usage

### Get User's Notifications
```dart
final notificationsAsyncValue = ref.watch(userNotificationsProvider);

notificationsAsyncValue.when(
  data: (notifications) {
    // Display notifications list
  },
  loading: () => CircularProgressIndicator(),
  error: (err, stack) => Text('Error: $err'),
);
```

### Get Unread Count
```dart
final unreadCount = ref.watch(unreadNotificationCountProvider);

unreadCount.when(
  data: (count) => Text('Unread: $count'),
  loading: () => Text('...'),
  error: (error, _) => Text('Error'),
);
```

### Mark as Read
```dart
ref.read(notificationControllerProvider.notifier)
    .markAsRead(notificationId);
```

## Checklist Before Deploying

- [ ] Firestore Security Rules updated and published
- [ ] Cloud Functions deployed (`firebase deploy --only functions`)
- [ ] Device token saving code added to auth service
- [ ] Dashboard imported `GreetingUtil` and `currentPassengerProvider`
- [ ] Tested dashboard greeting displays correctly
- [ ] Tested device token is saved in Firestore
- [ ] Tested registration notification is sent
- [ ] Cloud Function logs checked for errors

## Common Issues & Fixes

### ❌ Notifications not appearing

**Check 1: Device tokens missing**
- Firebase Console → Firestore
- Go to `passenger_details` → your user ID
- Verify `deviceTokens` array has entries

**Check 2: Security rules incorrect**
- Firestore → Rules
- Verify notifications collection allows read for `resource.data.userId == request.auth.uid`

**Check 3: Cloud Functions not deployed**
```bash
firebase deploy --only functions
firebase functions:log  # Check for errors
```

### ❌ Dashboard greeting not showing

**Check 1: User not loaded**
- Verify `currentPassengerProvider` is working
- Check Passenger model has `firstName` field

**Check 2: Consumer not wrapped**
- Verify `SafeDriverDashboard` wraps greeting in `Consumer`
- Check widget extends `ConsumerWidget`

### ❌ Device token not saved

**Check 1: Auth service not saving token**
- Check you added token saving code after login
- Verify `FirebaseFirestore.instance` is accessible

**Check 2: Firestore rules**
- Check `passenger_details` allow update for authenticated users

## What's Next?

### Phase 2: Advanced Features
- [ ] Notification preferences UI (allow users to opt-out)
- [ ] Rich push notifications (images, buttons)
- [ ] Scheduled notifications
- [ ] Deep linking from notifications to specific screens

### Phase 3: Analytics
- [ ] Track notification opens
- [ ] Track notification dismissals
- [ ] Build notification dashboard

### Phase 4: Integration
- [ ] Email notifications for critical updates
- [ ] SMS notifications for important events
- [ ] In-app message center
- [ ] Notification bell icon with unread badge

## Support

For detailed implementation information, see:
- **Full Guide**: `documents/PUSH_NOTIFICATIONS_IMPLEMENTATION_GUIDE.md`
- **Security Rules**: `documents/FIRESTORE_NOTIFICATION_RULES.md`

## Reference

### Firestore Collections Structure
```json
/notifications/{notificationId}
{
  "userId": "user123",
  "type": "feedback",
  "title": "Feedback Received",
  "body": "Thank you for your feedback!",
  "priority": "normal",
  "status": "sent",
  "sentAt": Timestamp,
  "readAt": null,
  "deliveredAt": Timestamp,
  "data": {
    "feedbackId": "feedback456",
    "category": "safety"
  }
}

/passenger_details/{userId}
{
  // ... other fields
  "deviceTokens": [
    "token123...",
    "token456...",
  ]
}
```

---

**Version**: 1.0.0  
**Last Updated**: March 2026  
**Status**: ✅ Ready for Deployment
