# 🔥 Firebase Data Structure for SafeDriver Passenger App

## Collections Overview

### 1. **users** Collection
```javascript
{
  // Document ID: userId (auto-generated)
  "firstName": "John",
  "lastName": "Doe",
  "email": "john.doe@example.com",
  "phoneNumber": "+1234567890",
  "profileImageUrl": "https://storage.googleapis.com/...",
  "dateOfBirth": "1990-05-15T00:00:00.000Z",
  "gender": "male", // male, female, other
  "address": {
    "street": "123 Main St",
    "city": "Colombo",
    "postalCode": "00100",
    "country": "Sri Lanka",
    "coordinates": {
      "latitude": 6.9271,
      "longitude": 79.8612
    }
  },
  "emergencyContact": {
    "name": "Jane Doe",
    "phoneNumber": "+1234567891",
    "relationship": "spouse"
  },
  "preferences": {
    "language": "en", // en, si, ta
    "theme": "system", // light, dark, system
    "notifications": {
      "safetyAlerts": true,
      "journeyUpdates": true,
      "emergencyAlerts": true,
      "systemAnnouncements": true
    },
    "privacy": {
      "shareLocation": true,
      "shareJourneyData": true
    }
  },
  "stats": {
    "todayTrips": 0,
    "totalTrips": 0,
    "carbonSaved": 0.0, // kg CO2
    "pointsEarned": 0,
    "safetyScore": 5.0
  },
  "favorites": {
    "routes": ["route1", "route2"],
    "buses": ["bus1", "bus2"]
  },
  "recentSearches": ["Route 1", "Colombo to Kandy"],
  "isVerified": false,
  "isActive": true,
  "createdAt": "2024-01-01T00:00:00.000Z",
  "updatedAt": "2024-01-01T00:00:00.000Z"
}
```

### 2. **buses** Collection
```javascript
{
  // Document ID: busId (auto-generated)
  "busNumber": "NB-1234",
  "routeNumber": "Route 1",
  "registration": "ABC-1234",
  "busType": "standard", // standard, electric, hybrid, articulated, miniVan, coach
  "passengerCapacity": 45,
  "driverId": "driverId123",
  "driverName": "John Smith",
  "imageUrl": "https://storage.googleapis.com/...",
  "status": "online", // online, offline, inTransit, atStop, maintenance, emergency
  "currentLocation": {
    "latitude": 6.9271,
    "longitude": 79.8612,
    "address": "Main Street, Colombo",
    "timestamp": "2024-01-01T12:00:00.000Z"
  },
  "currentSpeed": 45.5, // km/h
  "heading": 90.0, // degrees
  "safetyScore": 4.2,
  "route": {
    "id": "route123",
    "name": "Colombo - Kandy",
    "stops": [
      {
        "id": "stop1",
        "name": "Colombo Fort",
        "coordinates": {
          "latitude": 6.9271,
          "longitude": 79.8612
        },
        "estimatedArrival": "2024-01-01T13:00:00.000Z"
      }
    ]
  },
  "amenities": ["wifi", "ac", "gps", "cctv"],
  "specifications": {
    "manufacturer": "Ashok Leyland",
    "model": "Viking",
    "year": 2022,
    "engineType": "Diesel",
    "fuelCapacity": 200.0,
    "maxSpeed": 80.0,
    "transmissionType": "Manual",
    "dimensions": {
      "length": 12.0,
      "width": 2.5,
      "height": 3.2,
      "weight": 8500.0
    }
  },
  "maintenanceInfo": {
    "lastService": "2024-01-01T00:00:00.000Z",
    "nextService": "2024-04-01T00:00:00.000Z",
    "mileage": 85000.0,
    "status": "good" // good, fair, poor
  },
  "safetyFeatures": [
    {
      "name": "Driver Drowsiness Detection",
      "enabled": true,
      "lastChecked": "2024-01-01T00:00:00.000Z"
    },
    {
      "name": "Speed Governor",
      "enabled": true,
      "maxSpeed": 80.0
    }
  ],
  "isActive": true,
  "lastUpdated": "2024-01-01T12:00:00.000Z"
}
```

### 3. **drivers** Collection
```javascript
{
  // Document ID: driverId (auto-generated)
  "employeeId": "EMP001",
  "firstName": "John",
  "lastName": "Smith",
  "email": "john.smith@safedriver.com",
  "phoneNumber": "+1234567890",
  "profileImageUrl": "https://storage.googleapis.com/...",
  "dateOfBirth": "1985-03-20T00:00:00.000Z",
  "licenseNumber": "LIC123456",
  "licenseExpiry": "2025-03-20T00:00:00.000Z",
  "experience": {
    "years": 8,
    "totalKm": 150000.0
  },
  "certifications": [
    {
      "name": "Defensive Driving",
      "issuedBy": "RTA",
      "issuedDate": "2023-01-01T00:00:00.000Z",
      "expiryDate": "2026-01-01T00:00:00.000Z"
    }
  ],
  "currentStatus": "active", // active, inactive, onBreak, offDuty
  "currentBusId": "busId123",
  "safetyMetrics": {
    "overallScore": 4.5,
    "alertnessLevel": 0.85, // 0.0 to 1.0
    "recentIncidents": 0,
    "monthlyScore": 4.7
  },
  "performance": {
    "punctualityScore": 4.3,
    "fuelEfficiency": 3.8,
    "passengerRatings": 4.6
  },
  "emergencyContact": {
    "name": "Jane Smith",
    "phoneNumber": "+1234567891",
    "relationship": "spouse"
  },
  "isActive": true,
  "hiredDate": "2020-01-01T00:00:00.000Z",
  "createdAt": "2020-01-01T00:00:00.000Z",
  "updatedAt": "2024-01-01T00:00:00.000Z"
}
```

### 4. **routes** Collection
```javascript
{
  // Document ID: routeId (auto-generated)
  "routeNumber": "Route 1",
  "routeName": "Colombo - Kandy Express",
  "description": "Direct service between Colombo and Kandy",
  "startLocation": {
    "name": "Colombo Fort",
    "coordinates": {
      "latitude": 6.9271,
      "longitude": 79.8612
    }
  },
  "endLocation": {
    "name": "Kandy Bus Stand",
    "coordinates": {
      "latitude": 7.2906,
      "longitude": 80.6337
    }
  },
  "stops": [
    {
      "id": "stop1",
      "name": "Colombo Fort",
      "coordinates": {
        "latitude": 6.9271,
        "longitude": 79.8612
      },
      "order": 1,
      "estimatedDuration": 0 // minutes from start
    }
  ],
  "distance": 115.0, // km
  "estimatedDuration": 180, // minutes
  "fare": {
    "adult": 150.0,
    "child": 75.0,
    "senior": 100.0
  },
  "schedule": {
    "weekday": {
      "firstDeparture": "05:00",
      "lastDeparture": "22:00",
      "frequency": 30 // minutes
    },
    "weekend": {
      "firstDeparture": "06:00",
      "lastDeparture": "21:00",
      "frequency": 45 // minutes
    }
  },
  "activeBuses": ["busId1", "busId2"],
  "isActive": true,
  "createdAt": "2024-01-01T00:00:00.000Z",
  "updatedAt": "2024-01-01T00:00:00.000Z"
}
```

### 5. **safety_alerts** Collection
```javascript
{
  // Document ID: alertId (auto-generated)
  "type": "emergency", // emergency, accident, breakdown, hazard, weather, traffic, security
  "severity": 5, // 1-5 (low to emergency)
  "title": "Emergency Brake Applied",
  "description": "Bus NB-1234 applied emergency brakes due to obstacle",
  "busId": "busId123",
  "driverId": "driverId123",
  "routeId": "routeId123",
  "location": {
    "latitude": 6.9271,
    "longitude": 79.8612,
    "address": "Main Street, Colombo"
  },
  "status": "active", // active, acknowledged, inProgress, resolved, dismissed
  "priority": "critical", // low, medium, high, critical, emergency
  "affectedUsers": ["userId1", "userId2"], // passengers in the bus
  "responses": [
    {
      "responderId": "operatorId1",
      "response": "Emergency services notified",
      "timestamp": "2024-01-01T12:05:00.000Z",
      "actionTaken": "contacted_emergency"
    }
  ],
  "metadata": {
    "speed": 45.0,
    "weather": "clear",
    "visibility": "good",
    "trafficCondition": "moderate"
  },
  "resolvedAt": null,
  "createdAt": "2024-01-01T12:00:00.000Z",
  "updatedAt": "2024-01-01T12:00:00.000Z"
}
```

### 6. **journeys** Collection
```javascript
{
  // Document ID: journeyId (auto-generated)
  "userId": "userId123",
  "busId": "busId123",
  "routeId": "routeId123",
  "driverId": "driverId123",
  "boardingStop": {
    "id": "stop1",
    "name": "Colombo Fort",
    "coordinates": {
      "latitude": 6.9271,
      "longitude": 79.8612
    },
    "timestamp": "2024-01-01T12:00:00.000Z"
  },
  "alightingStop": {
    "id": "stop5",
    "name": "Kandy Bus Stand",
    "coordinates": {
      "latitude": 7.2906,
      "longitude": 80.6337
    },
    "timestamp": "2024-01-01T15:00:00.000Z"
  },
  "fare": {
    "amount": 150.0,
    "currency": "LKR",
    "paymentMethod": "cash" // cash, card, digital_wallet
  },
  "status": "completed", // ongoing, completed, cancelled
  "distance": 115.0, // km
  "duration": 180, // minutes
  "safetyScore": 4.5,
  "incidents": [], // array of incident IDs if any
  "feedback": {
    "rating": 5,
    "comment": "Smooth and safe journey",
    "submittedAt": "2024-01-01T15:30:00.000Z"
  },
  "carbonSaved": 12.5, // kg CO2 compared to private vehicle
  "createdAt": "2024-01-01T12:00:00.000Z",
  "updatedAt": "2024-01-01T15:00:00.000Z"
}
```

### 7. **feedback** Collection
```javascript
{
  // Document ID: feedbackId (auto-generated)
  "userId": "userId123",
  "busId": "busId123",
  "driverId": "driverId123",
  "journeyId": "journeyId123",
  "type": "general", // positive, negative, neutral, suggestion, inquiry, urgent, general
  "category": "service", // service, safety, comfort, driver, vehicle, route
  "rating": {
    "overall": 5,
    "safety": 5,
    "comfort": 4,
    "cleanliness": 4,
    "punctuality": 5,
    "driverBehavior": 5,
    "vehicleCondition": 4
  },
  "title": "Excellent Service",
  "description": "The driver was very professional and the journey was comfortable.",
  "attachments": [
    {
      "type": "image", // image, video
      "url": "https://storage.googleapis.com/...",
      "thumbnail": "https://storage.googleapis.com/..."
    }
  ],
  "status": "submitted", // submitted, received, inReview, responded, resolved, closed
  "priority": "medium", // low, medium, high, urgent
  "isAnonymous": false,
  "adminResponse": {
    "message": "Thank you for your feedback!",
    "responderId": "adminId123",
    "respondedAt": "2024-01-01T16:00:00.000Z"
  },
  "createdAt": "2024-01-01T15:30:00.000Z",
  "updatedAt": "2024-01-01T16:00:00.000Z"
}
```

### 8. **hazard_zones** Collection
```javascript
{
  // Document ID: hazardZoneId (auto-generated)
  "name": "Sharp Curve Zone",
  "description": "Dangerous curve with limited visibility",
  "location": {
    "center": {
      "latitude": 6.9271,
      "longitude": 79.8612
    },
    "radius": 500.0, // meters
    "coordinates": [ // polygon points if complex shape
      {
        "latitude": 6.9271,
        "longitude": 79.8612
      }
    ]
  },
  "severity": "high", // low, medium, high, critical
  "type": "road_hazard", // road_hazard, weather, construction, accident_prone, steep_gradient
  "affectedRoutes": ["routeId1", "routeId2"],
  "restrictions": {
    "maxSpeed": 40.0, // km/h
    "timeRestrictions": {
      "nightTime": true, // extra caution needed at night
      "weather": ["rain", "fog"]
    }
  },
  "alerts": {
    "passengerAlert": "Please hold handrails, approaching sharp curve",
    "driverAlert": "Reduce speed, sharp curve ahead"
  },
  "statistics": {
    "totalIncidents": 5,
    "lastIncident": "2024-01-01T00:00:00.000Z"
  },
  "isActive": true,
  "createdAt": "2024-01-01T00:00:00.000Z",
  "updatedAt": "2024-01-01T00:00:00.000Z"
}
```

### 9. **notifications** Collection
```javascript
{
  // Document ID: notificationId (auto-generated)
  "userId": "userId123",
  "type": "safety_alert", // safety_alert, journey_update, emergency, system_announcement, promotion
  "title": "Safety Alert",
  "message": "Emergency brake applied on your bus. Please remain seated.",
  "data": {
    "busId": "busId123",
    "alertId": "alertId123",
    "action": "view_details"
  },
  "priority": "high", // low, medium, high, urgent
  "isRead": false,
  "readAt": null,
  "deliveredAt": "2024-01-01T12:00:00.000Z",
  "fcmToken": "device_fcm_token",
  "createdAt": "2024-01-01T12:00:00.000Z"
}
```

### 10. **app_settings** Collection
```javascript
{
  // Document ID: settings (single document)
  "maintenance": {
    "isEnabled": false,
    "message": "App is under maintenance. Please try again later.",
    "estimatedEndTime": null
  },
  "features": {
    "biometricAuth": true,
    "darkMode": true,
    "locationSharing": true,
    "pushNotifications": true,
    "crashReporting": true,
    "analytics": true
  },
  "emergencyContacts": {
    "police": "119",
    "medical": "1990",
    "fire": "111",
    "support": "+1-800-SAFEDRIVER"
  },
  "safetyThresholds": {
    "maxSafeSpeedKmh": 80.0,
    "harshBrakingThreshold": -3.5,
    "harshAccelerationThreshold": 3.0,
    "drowsinessAlertThreshold": 0.7,
    "distractionAlertThreshold": 0.6
  },
  "apiEndpoints": {
    "baseUrl": "https://api.safedriver.com/v1",
    "socketUrl": "wss://api.safedriver.com/ws"
  },
  "versions": {
    "minSupportedVersion": "1.0.0",
    "latestVersion": "1.0.0",
    "forceUpdate": false
  },
  "updatedAt": "2024-01-01T00:00:00.000Z"
}
```

## Security Rules Example

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Buses - read only for passengers
    match /buses/{busId} {
      allow read: if request.auth != null;
      allow write: if false; // Only admin/drivers can write
    }
    
    // Routes - read only for passengers
    match /routes/{routeId} {
      allow read: if request.auth != null;
    }
    
    // Journeys - users can read their own journeys
    match /journeys/{journeyId} {
      allow read: if request.auth != null && 
        request.auth.uid == resource.data.userId;
      allow write: if request.auth != null && 
        request.auth.uid == resource.data.userId;
    }
    
    // Feedback - users can create and read their own feedback
    match /feedback/{feedbackId} {
      allow read: if request.auth != null && 
        request.auth.uid == resource.data.userId;
      allow create: if request.auth != null;
    }
    
    // Safety alerts - read only for passengers
    match /safety_alerts/{alertId} {
      allow read: if request.auth != null;
    }
    
    // Notifications - users can read their own notifications
    match /notifications/{notificationId} {
      allow read, update: if request.auth != null && 
        request.auth.uid == resource.data.userId;
    }
    
    // App settings - read only
    match /app_settings/settings {
      allow read: if request.auth != null;
    }
  }
}
```

## Indexes Required

```javascript
// Composite indexes for efficient queries
[
  {
    "collectionGroup": "buses",
    "queryScope": "COLLECTION",
    "fields": [
      {"fieldPath": "status", "order": "ASCENDING"},
      {"fieldPath": "isActive", "order": "ASCENDING"},
      {"fieldPath": "lastUpdated", "order": "DESCENDING"}
    ]
  },
  {
    "collectionGroup": "safety_alerts",
    "queryScope": "COLLECTION", 
    "fields": [
      {"fieldPath": "status", "order": "ASCENDING"},
      {"fieldPath": "priority", "order": "DESCENDING"},
      {"fieldPath": "createdAt", "order": "DESCENDING"}
    ]
  },
  {
    "collectionGroup": "journeys",
    "queryScope": "COLLECTION",
    "fields": [
      {"fieldPath": "userId", "order": "ASCENDING"},
      {"fieldPath": "status", "order": "ASCENDING"},
      {"fieldPath": "createdAt", "order": "DESCENDING"}
    ]
  }
]
```

This structure provides:
- ✅ **Scalability** - Proper data modeling for growth
- ✅ **Security** - User-based access control
- ✅ **Real-time Updates** - Supports live tracking and alerts
- ✅ **Analytics** - Rich data for insights and reporting
- ✅ **Offline Support** - Works with Firestore caching
- ✅ **Multi-language** - Supports your app's localization needs