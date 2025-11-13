# 🌍 Environment Setup Guide - SafeDriver SMS Gateway

## 🎯 Overview

This guide covers setting up different environments for the SafeDriver SMS gateway integration.

## 🏗️ Environment Structure

### Development Environment
- **Firebase Project**: `safe-driver-dev`
- **Text.lk Account**: Test account with limited credits
- **Phone Numbers**: Use test numbers or small set of real numbers
- **Logging**: Verbose logging enabled

### Staging Environment
- **Firebase Project**: `safe-driver-staging`
- **Text.lk Account**: Production account with limited credits
- **Phone Numbers**: Real numbers for testing
- **Logging**: Standard logging

### Production Environment
- **Firebase Project**: `safe-driver-prod`
- **Text.lk Account**: Production account with full credits
- **Phone Numbers**: All Sri Lankan numbers
- **Logging**: Error and warning only

## 🔧 Development Setup

### 1. Firebase Development Project

```bash
# Create development project
firebase projects:create safe-driver-dev
firebase use safe-driver-dev

# Initialize project
firebase init
```

### 2. Environment Variables

```bash
# Development configuration
firebase functions:config:set \
  textlk.userid="dev_user_id" \
  textlk.apikey="dev_api_key" \
  textlk.senderid="SafeDriverDev" \
  app.environment="development" \
  app.debug="true"
```

### 3. Firestore Rules (Development)

```javascript
// More permissive rules for development
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow read access for debugging
    match /debug/{document=**} {
      allow read, write: if true;
    }
    
    // Standard rules for other collections
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Allow admin access for development
    match /{document=**} {
      allow read, write: if request.auth != null && 
        request.auth.token.email.matches('.*@safedriver\\.lk$');
    }
  }
}
```

## 🔧 Staging Setup

### 1. Firebase Staging Project

```bash
# Create staging project
firebase projects:create safe-driver-staging
firebase use safe-driver-staging

# Deploy with staging configuration
firebase deploy --project staging
```

### 2. Environment Variables

```bash
# Staging configuration
firebase functions:config:set \
  textlk.userid="staging_user_id" \
  textlk.apikey="staging_api_key" \
  textlk.senderid="SafeDriverTest" \
  app.environment="staging" \
  app.debug="false" \
  --project staging
```

## 🔧 Production Setup

### 1. Firebase Production Project

```bash
# Create production project
firebase projects:create safe-driver-prod
firebase use safe-driver-prod

# Deploy with production configuration
firebase deploy --project production
```

### 2. Environment Variables

```bash
# Production configuration
firebase functions:config:set \
  textlk.userid="prod_user_id" \
  textlk.apikey="prod_api_key" \
  textlk.senderid="SafeDriver" \
  app.environment="production" \
  app.debug="false" \
  app.ratelimit="true" \
  --project production
```

## 📱 Flutter Environment Configuration

### 1. Create Environment Files

```dart
// lib/config/env/development.dart
class DevelopmentConfig {
  static const String firebaseProjectId = 'safe-driver-dev';
  static const String environment = 'development';
  static const bool debugMode = true;
  static const int otpTimeoutMinutes = 10;
  static const int maxOtpAttempts = 5;
}

// lib/config/env/staging.dart
class StagingConfig {
  static const String firebaseProjectId = 'safe-driver-staging';
  static const String environment = 'staging';
  static const bool debugMode = false;
  static const int otpTimeoutMinutes = 10;
  static const int maxOtpAttempts = 3;
}

// lib/config/env/production.dart
class ProductionConfig {
  static const String firebaseProjectId = 'safe-driver-prod';
  static const String environment = 'production';
  static const bool debugMode = false;
  static const int otpTimeoutMinutes = 5;
  static const int maxOtpAttempts = 3;
}
```

### 2. Environment Manager

```dart
// lib/config/environment_manager.dart
import 'env/development.dart';
import 'env/staging.dart';
import 'env/production.dart';

enum Environment { development, staging, production }

class EnvironmentManager {
  static const Environment _environment = Environment.development; // Change based on build
  
  static String get firebaseProjectId {
    switch (_environment) {
      case Environment.development:
        return DevelopmentConfig.firebaseProjectId;
      case Environment.staging:
        return StagingConfig.firebaseProjectId;
      case Environment.production:
        return ProductionConfig.firebaseProjectId;
    }
  }
  
  static bool get isDebug {
    switch (_environment) {
      case Environment.development:
        return DevelopmentConfig.debugMode;
      case Environment.staging:
        return StagingConfig.debugMode;
      case Environment.production:
        return ProductionConfig.debugMode;
    }
  }
  
  // Add other environment-specific configurations
}
```

## 🔄 Deployment Scripts

### 1. Development Deployment

```bash
#!/bin/bash
# deploy-dev.sh

echo "🚀 Deploying to Development Environment"

# Switch to development project
firebase use development

# Deploy functions
firebase deploy --only functions

# Deploy Firestore rules
firebase deploy --only firestore:rules

# Deploy Firestore indexes
firebase deploy --only firestore:indexes

echo "✅ Development deployment complete"
```

### 2. Staging Deployment

```bash
#!/bin/bash
# deploy-staging.sh

echo "🚀 Deploying to Staging Environment"

# Run tests first
echo "Running tests..."
npm test

if [ $? -eq 0 ]; then
    echo "✅ Tests passed"
    
    # Switch to staging project
    firebase use staging
    
    # Deploy functions
    firebase deploy --only functions
    
    # Deploy Firestore rules
    firebase deploy --only firestore:rules
    
    echo "✅ Staging deployment complete"
else
    echo "❌ Tests failed. Deployment cancelled."
    exit 1
fi
```

### 3. Production Deployment

```bash
#!/bin/bash
# deploy-prod.sh

echo "🚀 Deploying to Production Environment"

# Confirmation prompt
read -p "Are you sure you want to deploy to PRODUCTION? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Deployment cancelled"
    exit 1
fi

# Run comprehensive tests
echo "Running comprehensive tests..."
npm test
npm run test:integration

if [ $? -eq 0 ]; then
    echo "✅ All tests passed"
    
    # Switch to production project
    firebase use production
    
    # Deploy with backup
    echo "Creating backup..."
    # Add backup logic here
    
    # Deploy functions
    firebase deploy --only functions
    
    # Deploy Firestore rules
    firebase deploy --only firestore:rules
    
    echo "✅ Production deployment complete"
    echo "🔍 Monitor logs: firebase functions:log --follow"
else
    echo "❌ Tests failed. Production deployment cancelled."
    exit 1
fi
```

## 📊 Environment Monitoring

### 1. Development Monitoring

```bash
# Monitor development logs
firebase functions:log --follow --project development

# Check function performance
firebase functions:log --only sendOTP --project development
```

### 2. Production Monitoring

```bash
# Set up alerts
gcloud alpha monitoring policies create \
  --policy-from-file=monitoring/function-errors.yaml \
  --project=safe-driver-prod

# Monitor costs
gcloud billing budgets list --billing-account=YOUR_BILLING_ACCOUNT
```

## 🔒 Security by Environment

### Development
- Relaxed security rules for debugging
- Test data can be accessed by developers
- Verbose logging enabled

### Staging
- Production-like security rules
- Limited access to test data
- Standard logging

### Production
- Strict security rules
- No debug access
- Minimal logging for performance
- Rate limiting enabled
- DDoS protection

## 📋 Environment Checklist

### Pre-deployment
- [ ] Environment variables set
- [ ] Firebase project configured
- [ ] Text.lk account configured
- [ ] Security rules tested
- [ ] Functions tested locally
- [ ] Integration tests passed

### Post-deployment
- [ ] Health check endpoint responding
- [ ] SMS sending working
- [ ] OTP verification working
- [ ] Rate limiting working
- [ ] Monitoring alerts configured
- [ ] Logs are being generated

---

**Environment Management Best Practices**:
1. Keep environment configurations in version control
2. Use different Text.lk accounts for different environments
3. Test deployments in staging before production
4. Monitor costs across all environments
5. Regularly rotate API keys and secrets
6. Backup production data regularly