# 📱 SMS Gateway Deployment Guide - SafeDriver App

## 🚀 Overview

This guide provides comprehensive instructions for deploying the SMS gateway integration using Firebase Cloud Functions and Text.lk SMS service for Sri Lankan phone number authentication.

## 📋 Prerequisites

### 1. Firebase Project Setup
- [ ] Firebase project created in Google Cloud Console
- [ ] Billing enabled (Blaze plan required for Cloud Functions)
- [ ] Firebase CLI installed (`npm install -g firebase-tools`)
- [ ] Authentication enabled in Firebase Console
- [ ] Firestore database created
- [ ] Firebase project linked to Flutter app

### 2. Text.lk SMS Gateway Account
- [ ] Text.lk account created and verified
- [ ] Business/Brand Sender ID approved
- [ ] API credentials obtained (User ID, API Key)
- [ ] SMS credits purchased
- [ ] Test SMS sent successfully

### 3. Development Environment
- [ ] Node.js 18+ installed
- [ ] Flutter SDK installed
- [ ] Android Studio / VS Code with Flutter extensions
- [ ] Git repository set up

## 🔧 Step 1: Firebase Project Configuration

### 1.1 Enable Required Services

```bash
# Enable required Firebase services
firebase projects:list
firebase use <your-project-id>

# Enable services in Firebase Console:
# - Authentication (Phone, Email)
# - Cloud Firestore
# - Cloud Functions
# - Cloud Storage
# - Firebase Analytics
# - App Check (recommended)
```

### 1.2 Configure Authentication

1. Go to Firebase Console → Authentication → Sign-in method
2. Enable **Phone** authentication
3. Add your domain to authorized domains
4. Configure reCAPTCHA for web (if applicable)

### 1.3 Firestore Database Setup

1. Create Firestore database in `asia-south1` region (closest to Sri Lanka)
2. Start in production mode
3. Deploy security rules (provided in `firestore.rules`)

## 🔧 Step 2: Text.lk SMS Gateway Configuration

### 2.1 Account Setup

1. Visit [Text.lk](https://www.text.lk/) and create an account
2. Complete KYC verification process
3. Purchase SMS credits (minimum 100 SMS recommended for testing)
4. Apply for Sender ID approval:
   - Sender ID: `SafeDriver` or your brand name
   - Purpose: OTP/Verification messages
   - Wait for approval (usually 1-2 business days)

### 2.2 API Credentials

Text.lk provides two API endpoints:
- **OAuth 2.0 API**: `https://app.text.lk/api/v3/` (Recommended)
- **HTTP API**: `https://app.text.lk/api/http/` (Legacy)

For this integration, we use the **OAuth 2.0 API v3** with:
- **API Token**: ``
- **Sender ID**: Approved sender name (e.g., `SafeDriver`)
- **API Endpoint**: `https://app.text.lk/api/v3/sms/send`

## 🔧 Step 3: Cloud Functions Deployment

### 3.1 Install Dependencies

```bash
cd backend/functions
npm install
```

### 3.2 Configure Environment Variables

**New Method (Recommended): Using .env file**

```bash
cd backend/functions

# Create .env file from template
cp .env.example .env

# Edit .env file with your Text.lk credentials
nano .env  # or use your preferred editor
```

Update the `.env` file with your actual Text.lk API credentials:

```env
# Text.lk API Configuration
TEXTLK_API_TOKEN=
TEXTLK_API_URL=https://app.text.lk/api/v3/sms/send
TEXTLK_SENDER_ID=SafeDriver

# Other configurations...
```

**Alternative Method: Firebase Functions Config**

```bash
# Set Text.lk credentials (legacy method)
firebase functions:config:set textlk.apitoken="2171|Hp874DmptWQNEk16DOGaXvvORW7lQwVIz0YAuYhB5ea59f6b"
firebase functions:config:set textlk.senderid="SafeDriver"

# Verify configuration
firebase functions:config:get
```

### 3.3 Deploy Functions

**Quick Deployment (Recommended)**

```bash
# Make deployment script executable
chmod +x deploy.sh

# Run deployment script (includes validation)
./deploy.sh
```

**Manual Deployment**

```bash
# Install dependencies
npm install

# Deploy all functions
firebase deploy --only functions

# Deploy specific function
firebase deploy --only functions:sendOTP
firebase deploy --only functions:verifyOTP
```

**Quick Setup**

```bash
# Run setup script for first-time setup
chmod +x setup.sh
./setup.sh
```

### 3.4 Verify Deployment

```bash
# Check function logs
firebase functions:log

# Test health check
curl https://asia-south1-<project-id>.cloudfunctions.net/healthCheck
```

## 🔧 Step 4: Firestore Security Rules

### 4.1 Deploy Rules

```bash
# Deploy Firestore rules
firebase deploy --only firestore:rules

# Deploy indexes
firebase deploy --only firestore:indexes
```

### 4.2 Test Rules in Firebase Console

1. Go to Firestore → Rules
2. Use the Rules Playground to test:
   - User can read/write their own data
   - OTP collections are protected
   - Anonymous users cannot access data

## 🔧 Step 5: Flutter App Configuration

### 5.1 Update Dependencies

```bash
flutter pub get
```

### 5.2 Configure Firebase Options

Update `lib/config/firebase_config.dart` with your project details:

```dart
class FirebaseConfig {
  static const String projectId = 'your-project-id';
  static const String storageBucket = 'your-project-id.appspot.com';
  static const String messagingSenderId = 'your-sender-id';
  // ... other configurations
}
```

### 5.3 Update Android Configuration

1. Download `google-services.json` from Firebase Console
2. Place in `android/app/` directory
3. Update `android/app/build.gradle` if needed

### 5.4 Update iOS Configuration

1. Download `GoogleService-Info.plist` from Firebase Console
2. Add to iOS project in Xcode
3. Update iOS bundle ID in Firebase Console

## 🔧 Step 6: Testing

### 6.1 Local Testing with Emulator

```bash
# Start Firebase emulators
firebase emulators:start

# Test functions locally
curl -X POST http://localhost:5001/your-project/asia-south1/sendOTP \
  -H "Content-Type: application/json" \
  -d '{"phoneNumber": "+94771234567"}'
```

### 6.2 Integration Testing

1. Test phone number validation
2. Test OTP sending (check Text.lk dashboard)
3. Test OTP verification
4. Test rate limiting
5. Test error handling

### 6.3 Production Testing

1. Test with real Sri Lankan phone numbers
2. Verify SMS delivery across different carriers:
   - Dialog
   - Mobitel
   - Hutch
   - Airtel
3. Test edge cases (invalid numbers, expired OTPs)

## 🔧 Step 7: Monitoring & Logging

### 7.1 Firebase Monitoring

1. Enable Cloud Logging in Google Cloud Console
2. Set up alerting for function errors
3. Monitor function performance and costs

### 7.2 Text.lk Monitoring

1. Monitor SMS delivery rates in Text.lk dashboard
2. Set up low credit alerts
3. Track failed deliveries and reasons

## 🔧 Step 8: Production Deployment

### 8.1 Pre-deployment Checklist

- [ ] All tests passing
- [ ] Sender ID approved by Text.lk
- [ ] Rate limiting configured
- [ ] Error handling implemented
- [ ] Monitoring set up
- [ ] Security rules tested
- [ ] App signed for release

### 8.2 Deploy to Production

```bash
# Build release APK
flutter build apk --release

# Or build App Bundle
flutter build appbundle --release

# Deploy final functions
firebase deploy --only functions --project production
```

## 📊 Configuration Summary

### Environment Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `textlk.userid` | Text.lk User ID | `your_user_id` |
| `textlk.apikey` | Text.lk API Key | `your_api_key` |
| `textlk.senderid` | Approved Sender ID | `SafeDriver` |

### Firebase Services Used

- **Authentication**: Phone number verification
- **Cloud Functions**: SMS gateway integration
- **Firestore**: User data and OTP records
- **Cloud Storage**: User profile images
- **Analytics**: Usage tracking
- **App Check**: Security (optional)

### Estimated Costs (Monthly)

- **Firebase Functions**: $0-25 (based on usage)
- **Firestore**: $1-10 (based on reads/writes)
- **Text.lk SMS**: $0.02-0.05 per SMS
- **Total**: $10-50 for small to medium usage

## 🔒 Security Considerations

### 8.1 API Security

- Never expose Text.lk credentials in client code
- Use Firebase Functions for all SMS operations
- Implement proper rate limiting
- Validate all input parameters

### 8.2 Data Protection

- Hash OTP codes before storing
- Set TTL for OTP records
- Use Firestore security rules
- Enable audit logging

### 8.3 Abuse Prevention

- Rate limit OTP requests per phone number
- Monitor for unusual patterns
- Implement CAPTCHA for web (if applicable)
- Block known spam numbers

## 🐛 Troubleshooting

### Common Issues

1. **OTP not received**
   - Check Text.lk dashboard for delivery status
   - Verify phone number format (+94XXXXXXXXX)
   - Check SMS credits balance

2. **Function deployment fails**
   - Verify billing is enabled
   - Check Node.js version (18+)
   - Review function logs

3. **Authentication errors**
   - Verify Firebase configuration
   - Check security rules
   - Ensure custom token is valid

### Debug Commands

```bash
# Check function logs
firebase functions:log --only sendOTP

# Test function locally
firebase functions:shell

# Check Firestore rules
firebase firestore:rules:list

# Monitor real-time logs
firebase functions:log --follow
```

## 📞 Support Contacts

- **Text.lk Support**: support@text.lk
- **Firebase Support**: Firebase Console → Support
- **Technical Issues**: Create GitHub issue in repository

## 📝 Additional Resources

- [Firebase Cloud Functions Documentation](https://firebase.google.com/docs/functions)
- [Text.lk API Documentation](https://www.text.lk/sms-api/)
- [Firestore Security Rules Guide](https://firebase.google.com/docs/firestore/security/get-started)
- [Flutter Firebase Integration](https://firebase.flutter.dev/)

---

**Last Updated**: November 2024  
**Version**: 1.0.0  
**Author**: SafeDriver Development Team