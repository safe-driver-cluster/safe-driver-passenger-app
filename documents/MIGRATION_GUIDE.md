# 🔧 Migration Guide: Removing Hardcoded Data

This guide helps you migrate from hardcoded data to Firebase integration in your SafeDriver Passenger App.

## 📋 Steps to Remove Hardcoded Data

### 1. **Update App Constants**

Replace hardcoded API keys and configuration with environment variables:

```dart
// ❌ Before: Hardcoded values
class AppConstants {
  static const String firebaseApiKey = 'your-firebase-api-key';
  static const String googleMapsApiKey = 'your-google-maps-api-key';
}

// ✅ After: Environment-based configuration
class AppConstants {
  static const String firebaseApiKey = String.fromEnvironment(
    'FIREBASE_API_KEY', 
    defaultValue: ''
  );
  static const String googleMapsApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY', 
    defaultValue: ''
  );
}
```

### 2. **Update Controller Dependencies**

Replace mock repositories with Firebase-connected ones:

```dart
// ❌ Before: Mock data in controllers
Future<void> _loadRecentActivity() async {
  final activities = [
    'Boarded Bus #123 on Route A',
    'Submitted feedback for Trip #456',
  ];
  state = state.copyWith(recentActivity: activities);
}

// ✅ After: Firebase integration
Future<void> _loadRecentActivity() async {
  try {
    final userId = _authService.currentUser?.uid;
    if (userId != null) {
      final activities = await _firebaseDataService
          .getUserRecentActivity(userId);
      state = state.copyWith(recentActivity: activities);
    }
  } catch (e) {
    _handleError('Failed to load activity: $e');
  }
}
```

### 3. **Update Repository Implementations**

```dart
// ❌ Before: Hardcoded bus data
Future<List<BusModel>> getNearbyBuses() async {
  return [
    BusModel(id: '1', busNumber: 'NB-123', /* ... */),
    BusModel(id: '2', busNumber: 'NB-456', /* ... */),
  ];
}

// ✅ After: Firebase queries
Future<List<BusModel>> getNearbyBuses(double lat, double lng) async {
  try {
    final query = await _firestore
        .collection('buses')
        .where('isActive', isEqualTo: true)
        .where('status', whereIn: ['online', 'inTransit'])
        .get();
    
    return query.docs.map((doc) => 
      BusModel.fromJson({...doc.data(), 'id': doc.id})
    ).toList();
  } catch (e) {
    throw BusRepositoryException('Failed to get buses: $e');
  }
}
```

## 🏗️ Implementation Checklist

### Phase 1: Core Infrastructure
- [ ] Set up Firebase project and configuration
- [ ] Configure Firestore security rules
- [ ] Create required collections and indexes
- [ ] Set up environment variables for API keys

### Phase 2: Data Models
- [ ] Update models to include Firebase document references
- [ ] Add proper fromJson/toJson methods
- [ ] Include validation and error handling
- [ ] Add caching mechanisms where needed

### Phase 3: Repository Layer
- [ ] Replace hardcoded data with Firebase queries
- [ ] Implement real-time listeners where appropriate
- [ ] Add offline support and caching
- [ ] Handle errors gracefully

### Phase 4: Controller Updates
- [ ] Update state management to use Firebase data
- [ ] Implement proper loading states
- [ ] Add error handling and retry logic
- [ ] Remove all hardcoded mock data

### Phase 5: UI Integration
- [ ] Update widgets to handle loading/error states
- [ ] Remove any remaining hardcoded values
- [ ] Test real-time updates
- [ ] Implement offline fallbacks

### Phase 6: Testing & Validation
- [ ] Test with real Firebase data
- [ ] Validate security rules
- [ ] Performance testing with large datasets
- [ ] Test offline scenarios

## 🔧 Configuration Files to Update

### firebase_options.dart
```dart
// Update with your actual Firebase configuration
static const FirebaseOptions android = FirebaseOptions(
  apiKey: String.fromEnvironment('FIREBASE_API_KEY_ANDROID'),
  appId: String.fromEnvironment('FIREBASE_APP_ID_ANDROID'),
  messagingSenderId: String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID'),
  projectId: String.fromEnvironment('FIREBASE_PROJECT_ID'),
  storageBucket: String.fromEnvironment('FIREBASE_STORAGE_BUCKET'),
);
```

### pubspec.yaml
```yaml
# Ensure all Firebase dependencies are added
dependencies:
  cloud_firestore: ^4.13.6
  firebase_auth: ^4.15.3
  firebase_storage: ^11.5.6
  firebase_messaging: ^14.7.10
  firebase_analytics: ^10.8.0
```

## 🚀 Environment Setup

### Development Environment
```bash
# Set development environment variables
export FIREBASE_PROJECT_ID="safedriver-dev"
export FIREBASE_API_KEY="development-api-key"
export GOOGLE_MAPS_API_KEY="development-maps-key"
```

### Production Environment
```bash
# Set production environment variables
export FIREBASE_PROJECT_ID="safedriver-prod"
export FIREBASE_API_KEY="production-api-key"
export GOOGLE_MAPS_API_KEY="production-maps-key"
```

## 📊 Data Migration Scripts

Use these Firestore batch operations to populate initial data:

```dart
// Sample script to populate buses collection
Future<void> migrateBusData() async {
  final batch = FirebaseFirestore.instance.batch();
  
  for (var busData in initialBusData) {
    final docRef = FirebaseFirestore.instance.collection('buses').doc();
    batch.set(docRef, busData.toJson());
  }
  
  await batch.commit();
}
```

## ⚠️ Important Notes

1. **Security**: Never commit real API keys to version control
2. **Performance**: Use Firebase indexes for complex queries
3. **Offline**: Implement proper offline caching strategies
4. **Error Handling**: Always handle Firebase exceptions gracefully
5. **Testing**: Test with both real and emulated Firebase instances

## 🔍 Verification Steps

After migration, verify:
- [ ] No hardcoded data remains in controllers
- [ ] All Firebase queries work correctly
- [ ] Security rules prevent unauthorized access
- [ ] App works offline with cached data
- [ ] Real-time updates function properly
- [ ] Error handling works as expected