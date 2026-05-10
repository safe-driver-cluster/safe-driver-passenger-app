# 🚀 SafeDriver Passenger App - Play Store Submission Guide

**Last Updated:** May 10, 2026  
**App Version:** 1.0.0 (Build: 1)  
**Package Name:** com.codecrafters.safedriver

---

## 📋 Table of Contents
1. [App Information](#app-information)
2. [Build Configuration](#build-configuration)
3. [Play Store Listing Details](#play-store-listing-details)
4. [Graphics & Assets](#graphics--assets)
5. [Build & Upload Process](#build--upload-process)
6. [Signing Configuration](#signing-configuration)

---

## 📱 App Information

| Field | Value |
|-------|-------|
| **App Name (Display)** | SafeDriver Passenger |
| **Package Name** | com.codecrafters.safedriver |
| **Version** | 1.0.0 |
| **Version Code** | 1 |
| **Min SDK** | 21 (Android 5.0) |
| **Target SDK** | 35 (Android 15) |
| **Category** | Travel & Local / Transportation |
| **Content Rating** | Everyone (PEGI 3) |
| **Price** | Free |
| **Ads** | No ads |

---

## 🔧 Build Configuration

### ✅ Changes Already Applied

```gradle
// android/app/build.gradle

namespace = "com.codecrafters.safedriver"
applicationId = "com.codecrafters.safedriver"

signingConfigs {
    release {
        storeFile = file("G:\\safedriver.jks")
        storePassword = "@Rensith2001"
        keyAlias = "safedriver"
        keyPassword = "@Rensith2001"
    }
}

buildTypes {
    release {
        signingConfig = signingConfigs.release
        minifyEnabled = true
        shrinkResources = true
        proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
    }
}
```

### ✅ Keystore Created

```
Location: G:\safedriver.jks
Size: 2,800 bytes
Alias: safedriver
Validity: 10,000 days (27+ years)
Signed By: Rensith Gonalagoda / CodeCrafters, Colombo, Sri Lanka
```

### ✅ Local Properties Updated

```properties
# android/local.properties
sdk.dir=C:\\Users\\USER\\AppData\\Local\\Android\\Sdk
flutter.sdk=C:\\Users\\USER\\fvm\\default
storeFile=G:\\safedriver.jks
storePassword=@Rensith2001
keyAlias=safedriver
keyPassword=@Rensith2001
```

---

## 📝 Play Store Listing Details

### Short Description (80 characters max)
```
AI-powered real-time driver monitoring & safety alerts for bus passengers
```

### Full Description (4,000 characters)
```
SafeDriver Passenger - Your Trusted Ride Companion

🚌 ABOUT THE APP
SafeDriver is an advanced passenger safety platform that provides real-time 
driver monitoring and accident prevention for Sri Lanka's public transport sector.
We believe every passenger deserves transparency and safety on their daily commute.

🎯 KEY FEATURES

✨ Real-time Driver Monitoring
- Live alertness and safety status indicators
- Immediate notifications for unsafe driving behavior
- Historical driver performance analytics

📍 Live Bus Tracking
- GPS-based real-time bus location tracking
- Estimated arrival times and route information
- Route history and analytics

🚨 Emergency Response System
- One-tap emergency alerts to authorities
- Direct contact with bus operators
- Real-time incident reporting

🔒 Bus & Driver Verification
- QR code scanning for instant bus information
- Comprehensive driver safety records
- Safety ratings and reviews

📊 Hazard Zone Mapping
- Location-based risk assessment
- Dangerous route identification
- Community safety insights

💬 Community Feedback
- Passenger safety reporting system
- Driver and bus reviews
- Safety incident tracking

🤖 Predictive Analytics
- AI-powered safety insights
- Trend analysis and recommendations
- Personalized safety alerts

🌐 Multi-Language Support
- Sinhala, Tamil, and English interfaces
- Localized safety information

🔐 SECURITY & PRIVACY
- Biometric authentication (fingerprint, face recognition)
- End-to-end encryption for communications
- Privacy-first data handling
- GDPR compliant

💰 COMPLETELY FREE
- No hidden charges
- No premium subscriptions
- Ad-free experience

📱 TECHNICAL HIGHLIGHTS
- Built with Flutter for optimal performance
- Firebase-powered real-time updates
- Offline functionality
- Low data consumption

🌟 WHY CHOOSE SAFEDRIVER?
SafeDriver is more than just an app—it's your personal safety guardian. 
We're dedicated to making public transport safer for everyone through 
innovative technology and community-driven insights.

Your safety is our priority. Download SafeDriver today!

Support: support@safedriver.lk
Website: https://www.safedriver.lk
```

### Promotional Text (80 characters max)
```
Real-time driver safety monitoring for safer public transport journeys
```

### Keywords (comma-separated)
```
safety, driver monitoring, bus, transportation, real-time tracking, alerts, 
Sri Lanka, public transport, emergency, passenger, accident prevention, 
community safety
```

### Support Email
```
support@safedriver.lk
```

### Privacy Policy URL
```
https://www.safedriver.lk/privacy
```

### Terms of Service URL
```
https://www.safedriver.lk/terms
```

---

## 🎨 Graphics & Assets Required

### 1. App Icon (Launcher Icon)
- **Dimensions:** 512 × 512 pixels
- **Format:** PNG (32-bit) with transparency
- **Requirements:** 
  - High quality (no compression artifacts)
  - No rounded corners (Play Store adds them)
  - Must represent the app's identity

### 2. Feature Graphic
- **Dimensions:** 1024 × 500 pixels
- **Format:** PNG or JPG
- **Purpose:** Showcases app features on Play Store store listing
- **Content:** Should highlight key features (driver monitoring, GPS tracking, etc.)

### 3. Screenshots (Minimum 2, Maximum 8)
- **Dimensions:** 1080 × 1920 pixels (9:16 aspect ratio)
- **Format:** PNG or JPG
- **Count:** Recommended 5-8 screenshots showing:
  1. Home screen with driver status
  2. Live tracking map
  3. QR code scanning feature
  4. Emergency alert system
  5. Driver/Bus ratings & reviews
  6. Real-time notifications
  7. Settings & preferences
  8. Multi-language support

### 4. Promo Graphic (Optional)
- **Dimensions:** 180 × 120 pixels
- **Format:** PNG or JPG
- **Usage:** Google Play promotion

---

## 🏗️ Build & Upload Process

### Step 1: Build Release APK (Current Status)
```bash
cd "g:\SafeDriver Project\safe-driver-passenger-app"

# Clean build environment (if needed)
flutter clean
flutter pub get

# Build APK
flutter build apk --release

# Output will be at:
# build/app/outputs/apk/release/app-release.apk
```

### Step 2: Build Android App Bundle (AAB) - RECOMMENDED
```bash
flutter build appbundle --release

# Output will be at:
# build/app/outputs/bundle/release/app-release.aab
```

### Step 3: Troubleshooting Build Issues

If you encounter Kotlin compilation errors, try these solutions:

**Solution A: Move project to root directory (No spaces)**
```powershell
# Copy project to C:\SafeDriver (no spaces)
# Then build from there
cd C:\SafeDriver\safe-driver-passenger-app
flutter build appbundle --release
```

**Solution B: Disable Kotlin compilation cache**
```bash
# Add to gradle.properties
org.gradle.jvmargs=-Xmx4G
kotlin.incremental=false
```

**Solution C: Clean Gradle cache**
```bash
# Delete specific plugin caches
rmdir /s "%USERPROFILE%\.gradle\caches\*share_plus*"
rmdir /s "%USERPROFILE%\.gradle\caches\*shared_preferences*"
flutter clean
flutter pub get
flutter build appbundle --release
```

### Step 4: Sign APK Manually (if automated signing fails)
```bash
# Find jarsigner and use it directly
jarsigner -verbose -sigalg SHA256withRSA -digestalg SHA-256 \
  -keystore G:\safedriver.jks \
  build/app/outputs/apk/release/app-release-unsigned.apk \
  safedriver
```

---

## 🔐 Signing Configuration

### Keystore Details
```
File: G:\safedriver.jks
Keystore Password: @Rensith2001
Key Alias: safedriver
Key Password: @Rensith2001
Algorithm: RSA 2048-bit
Signature Algorithm: SHA256withRSA
Validity: 10,000 days (until 2052)
```

### Important Notes:
- ⚠️ **BACKUP** the keystore file securely!
- ⚠️ Keep passwords in a **secure location**
- ⚠️ **Never** share the keystore file or passwords
- ⚠️ You must use **the same keystore** for all future updates
- ⚠️ If you lose the keystore, you **cannot** update your app on Play Store

### Backup Instructions:
1. Copy `G:\safedriver.jks` to a secure location
2. Store passwords in a password manager
3. Document the signing certificate SHA-1 fingerprint

---

## 📤 Play Store Upload Checklist

### Pre-Upload Verification
- [ ] App Icon (512×512 px) ready
- [ ] Feature Graphic (1024×500 px) ready
- [ ] 5-8 screenshots (1080×1920 px) ready
- [ ] Short description written (80 chars)
- [ ] Full description written (4000 chars)
- [ ] Keywords finalized
- [ ] Privacy policy URL ready
- [ ] Support email configured
- [ ] Keystore backed up securely
- [ ] Release APK/AAB built successfully
- [ ] Content rating questionnaire completed

### Upload Steps
1. Go to [Google Play Console](https://play.google.com/console)
2. Click "Create app" → Select "SafeDriver Passenger"
3. Fill in app details (title, short description, full description)
4. Upload graphics (icon, feature image, screenshots)
5. Set content rating (Everyone/PEGI 3)
6. Add privacy policy URL
7. Select category: "Travel & Local"
8. Upload APK/AAB to "Production" track
9. Set pricing: Free
10. Review all information
11. Submit for review

### Review Timeline
- Initial review: 24-48 hours
- App can be published within 2 hours if approved
- You'll receive email confirmation

---

## 🔄 Version Update Strategy

For future updates, use this versioning scheme:

```yaml
# pubspec.yaml
version: 1.0.0+1    # Initial release
version: 1.0.1+2    # Bug fix patch
version: 1.1.0+3    # New features (minor)
version: 1.2.0+4    # More features
version: 2.0.0+5    # Major redesign
```

**Important:** Always increment the build number (+1, +2, +3...)

---

## 📞 Contact & Support

| Category | Details |
|----------|---------|
| **Support Email** | support@safedriver.lk |
| **Website** | https://www.safedriver.lk |
| **Company** | CodeCrafters Team |
| **Location** | Colombo, Sri Lanka |

---

## ✅ Completion Status

### Completed Tasks
- ✅ Updated package name to `com.codecrafters.safedriver`
- ✅ Updated namespace and application ID
- ✅ Generated signing keystore (safedriver.jks)
- ✅ Configured signing in build.gradle
- ✅ Updated local.properties with keystore details
- ✅ Configured release build settings (minify, shrink resources)
- ✅ Prepared comprehensive app descriptions
- ✅ Created versioning strategy

### Next Steps
1. **Move project folder** to path without spaces (e.g., C:\SafeDriver)
2. **Build the release package:**
   ```bash
   flutter build appbundle --release
   ```
3. **Test the APK/AAB** on physical device
4. **Create Play Store listing:**
   - Add graphics (icon, screenshots)
   - Add descriptions
   - Set pricing and availability
5. **Upload AAB to Play Console**
6. **Complete content rating questionnaire**
7. **Submit for review**
8. **Monitor review status**

---

## 🎯 Key Reminders

1. **Always use the same keystore** for app updates
2. **Backup the keystore file** in multiple secure locations
3. **Keep passwords secure** - never commit to git
4. **Test thoroughly** before uploading to Play Store
5. **Monitor app reviews** after launch
6. **Respond to user feedback** promptly
7. **Plan release schedule** - can take 2-48 hours for review

---

**Document Status:** Ready for Play Store Submission  
**Last Verification:** May 10, 2026  
**Next Review:** After first beta testing phase
