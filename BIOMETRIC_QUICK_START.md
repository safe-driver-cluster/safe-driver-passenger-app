# Biometric Authentication - Quick Start Guide

## For Users

### Enable Biometric Authentication

1. **Go to Settings**
   - Tap the Profile icon
   - Select "Settings" option

2. **Find Privacy & Security Section**
   - Scroll down to find "Privacy & Security" section
   - Look for "🔐 Biometric Lock" option

3. **Enable Biometric Lock**
   - Toggle the "Biometric Lock" switch ON
   - You should see Fingerprint and Face Recognition options

4. **Choose Your Preferred Biometric**
   - ✅ Toggle "👆 Fingerprint" - for fingerprint authentication
   - ✅ Toggle "😊 Face Recognition" - for face ID
   - You can enable both for maximum flexibility

5. **Optional: Require on App Open**
   - Toggle "📱 Require on App Open" to ON
   - This will ask for biometric when you open the app
   - Provides extra security for your account

6. **Save Settings**
   - Settings auto-save, no save button needed
   - You're all set!

### Using Biometric Authentication

**When "Require on App Open" is enabled:**
1. Close and reopen the app
2. You'll see a biometric prompt
3. Use your fingerprint or face to authenticate
4. You'll be logged in and taken to dashboard

**When "Require on App Open" is disabled:**
1. Close and reopen the app
2. You'll be automatically logged in (if you had persistent login enabled)
3. Skip the login screen, go directly to dashboard

### Disable Biometric Authentication

1. Go to Settings → Privacy & Security
2. Toggle "🔐 Biometric Lock" OFF
3. All biometric options will be disabled
4. You'll use regular password login from next session

### Logout

Even with biometric enabled, you can always logout:
1. Go to Profile/Settings
2. Look for "Logout" or "Sign Out" button
3. Your session will be cleared
4. Next time you open the app, login screen will appear

## For Developers

### Integration Points

#### 1. Biometric Service Usage
```dart
import 'package:safedriver_passenger_app/data/services/biometric_service.dart';

final biometricService = BiometricService();
await biometricService.initialize();

// Check if supported
if (biometricService.isBiometricSupported) {
  final authenticated = await biometricService.authenticate(
    reason: 'Authenticate to access SafeDriver',
  );
}
```

#### 2. Biometric Settings in UI
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safedriver_passenger_app/providers/biometric_settings_provider.dart';

// In ConsumerWidget
Widget build(BuildContext context, WidgetRef ref) {
  final biometricSettings = ref.watch(biometricSettingsProvider);
  
  return Switch(
    value: biometricSettings.isBiometricEnabled,
    onChanged: (value) async {
      final notifier = ref.read(biometricSettingsProvider.notifier);
      await notifier.setBiometricEnabled(value);
    },
  );
}
```

#### 3. Persistent Login Usage
```dart
import 'package:safedriver_passenger_app/data/services/auth_service.dart';

final authService = AuthService();

// Check for persistent session
final hasPersistentSession = await authService.checkPersistentSession();

// Enable persistent login
await authService.enablePersistentLogin();

// Disable persistent login
await authService.disablePersistentLogin();
```

#### 4. Biometric Authentication in Provider
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safedriver_passenger_app/providers/auth_provider.dart';

// In AuthStateNotifier
final isAuthenticated = await authenticateWithBiometric(
  reason: 'Verify your identity',
);
```

### Architecture Overview

```
├── Services
│   ├── BiometricService          (Biometric operations)
│   └── AuthService               (Updated with persistent login)
│
├── Providers
│   ├── biometric_settings_provider.dart    (State management for settings)
│   └── auth_provider.dart                  (Updated with biometric auth)
│
└── Presentation
    └── Settings Page             (UI for biometric settings)
```

### Storage Keys

All settings stored with these keys in local storage:
- `persistent_login` - Boolean
- `biometric_enabled` - Boolean
- `fingerprint_enabled` - Boolean
- `faceid_enabled` - Boolean
- `require_biometric_on_app_open` - Boolean

### Error Handling

Common error scenarios:
1. **Device doesn't support biometric**
   - UI shows "Not supported on this device"
   - Settings disabled for that option

2. **Biometric authentication fails**
   - User can retry
   - Graceful error message shown
   - Can fallback to password

3. **Permission denied**
   - Local_auth handles OS permission prompt
   - User must grant permission in device settings

## Testing Scenarios

### Scenario 1: First Time Setup
```
1. User logs in with email/password
2. Persistent login automatically enabled
3. User navigates to Settings
4. Enables biometric lock
5. Selects fingerprint
6. Enables "require on app open"
7. Closes app
8. Reopens app
9. Biometric prompt appears
10. User authenticates with fingerprint
11. Dashboard shown (login skipped)
```

### Scenario 2: App Close Without Biometric Requirement
```
1. User logs in
2. Closes app
3. Reopens app
4. Dashboard shown directly (no login screen)
5. Persistent login worked
```

### Scenario 3: Logout and Re-login
```
1. User in app
2. Selects logout
3. Persistent login cleared
4. Closes app
5. Reopens app
6. Login screen appears
7. User logs in again
```

### Scenario 4: Disable Biometric
```
1. User in settings
2. Disables biometric lock
3. Close App
4. Reopen app
5. Password login used (no biometric prompt)
```

## Troubleshooting

### Issue: Biometric option not appearing in settings
**Solution:**
- Your device may not have fingerprint/face ID
- Or biometric is not enrolled in device settings
- Go to device settings and enroll biometric

### Issue: Persistent login not working
**Solution:**
- Make sure you logged in and didn't manually logout
- Close app completely (not just minimize)
- Reopen app

### Issue: Settings not saving
**Solution:**
- Check device storage is available
- Try toggling again
- Restart the app
- Check app permissions

### Issue: Doesn't ask for biometric on app open
**Solution:**
- Make sure "Require on App Open" is toggled ON in settings
- Close app completely
- Reopen the app
- You should see the prompt

## FAQ

**Q: Is biometric safe?**
A: Yes, biometric data never leaves your device. The local_auth package uses OS-level APIs that handle all processing securely.

**Q: What if I forget my password?**
A: You can use the "Forgot Password" option on login screen. Biometric is additional security, not a replacement.

**Q: Can I use both fingerprint and face ID?**
A: Yes, you can enable both. The device will use whichever biometric is available/enrolled.

**Q: What happens if my device is stolen?**
A: Logout from your SafeDriver account immediately from another device. Then change your password to invalidate all sessions.

**Q: Does this work offline?**
A: No, biometric works but you need internet for Firebase authentication. Biometric is only the unlock mechanism.

**Q: Can I have persistent login without biometric?**
A: Yes, persistent login is enabled by default. Biometric is optional security on top.

---

For more detailed information, see `BIOMETRIC_AUTHENTICATION_GUIDE.md`
