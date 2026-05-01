// Firestore Security Rules for Notifications System
// Copy and paste these rules into your Firestore Rules section in Firebase Console

rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow read/write to authenticated users
    allow read, write: if request.auth != null;

    // Notifications collection - users can only read their own notifications
    match /notifications/{notificationId} {
      allow read: if request.auth != null && resource.data.userId == request.auth.uid;
      allow create: if request.auth != null && request.resource.data.userId == request.auth.uid;
      allow update: if request.auth != null && resource.data.userId == request.auth.uid;
      allow delete: if request.auth != null && resource.data.userId == request.auth.uid;
    }

    // Passenger details - additional rules for handling device tokens
    match /passenger_details/{userId} {
      allow read: if request.auth != null && request.auth.uid == userId;
      allow update: if request.auth != null && request.auth.uid == userId;
      allow create: if request.auth != null && request.auth.uid == userId;
    }

    // Feedbacks collection - support notification triggers
    match /feedbacks/{feedbackId} {
      allow read: if request.auth != null && resource.data.userId == request.auth.uid;
      allow create: if request.auth != null && request.resource.data.userId == request.auth.uid;
      allow update: if request.auth != null && resource.data.userId == request.auth.uid;
      allow delete: if request.auth != null && resource.data.userId == request.auth.uid;
    }

    // Journeys collection - support notification triggers
    match /journeys/{journeyId} {
      allow read: if request.auth != null && resource.data.userId == request.auth.uid;
      allow create: if request.auth != null && request.resource.data.userId == request.auth.uid;
      allow update: if request.auth != null && resource.data.userId == request.auth.uid;
    }
  }
}
