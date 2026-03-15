# Biometric Authentication Flow Diagram

## User Authentication Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                    SafeDriver App Opening                        │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
        ┌─────────────────────────────────┐
        │  Check Persistent Login Enabled?│
        └────────┬────────────────────────┘
                 │
         ┌───────┴────────┐
         │ NO             │ YES
         ▼                ▼
    ┌────────────┐   ┌──────────────────────┐
    │ Show      │   │ Check Session Active?│
    │ Login     │   └────┬────────────┬─────┘
    │ Screen    │        │ NO         │ YES
    │           │        ▼            ▼
    │           │   ┌──────────┐  ┌────────────────┐
    │           │   │ Show     │  │ Require        │
    │           │   │ Login    │  │ Biometric      │
    │           │   │ Screen   │  │ on App Open?   │
    │           │   │          │  └────┬────────┬──┘
    │           │   │          │       │ YES    │ NO
    │           │   │ User     │       ▼        ▼
    │           │   │ Logs In  │   ┌────────┐  ┌──────────┐
    │           │   │          │   │ Show   │  │ Go to    │
    │           │   │ Firebase │   │Biometry│  │ Dashboard│
    │           │   │ Auth     │   │ Prompt │  └──────────┘
    │           │   │          │   │        │
    │           │   │          │   │ Local  │
    │           │   │          │   │ Auth   │
    │           │   │          │   │        │
    │ User      │   │          │   │        │
    │ Enters    │   │ Session  │   │ Success?
    │ Email &   │   │ Created  │   │        │
    │ Password  │   │          │   │┌───────┴─────┐
    │           │   │          │   ││ NO          │ YES
    │ Firebase  │   │          │   │▼             ▼
    │ Auth OK?  │   │          │   │Retry or  ┌──────────┐
    │           │   │          │   │Fallback  │ Dashboard│
    │Set        │   │Set       │   │          │ (Logged) │
    │Persistent │   │Persistent   └──────────┘
    │Login ON   │   │Login ON
    ▼           ▼   ▼
    └──────────────────────┐
                           │
                           ▼
                  ┌────────────────┐
                  │  Dashboard     │
                  │  User Logged   │
                  └────────────────┘
```

## Biometric Settings Configuration

```
┌──────────────────────────────────────────┐
│         Settings Page                     │
│         Privacy & Security Section        │
└───────────┬────────────────────────────────┘
            │
            ▼
    ┌─────────────────────┐
    │ Biometric Lock      │  ◄─── Master toggle
    │ [Toggle Switch]     │
    └────────┬────────────┘
             │
      ┌──────┴──────┐
      │ OFF          │ ON
      ▼              ▼
  ┌────────┐   ┌──────────────────────┐
  │ Hidden │   │ Show Biometric Options
  │        │   │ ┌──────────────────┐ │
  │        │   │ │ Fingerprint      │ │
  │        │   │ │ [Toggle Switch]  │ │
  │        │   │ ├──────────────────┤ │
  │        │   │ │ Face Recognition │ │
  │        │   │ │ [Toggle Switch]  │ │
  │        │   │ ├──────────────────┤ │
  │        │   │ │ Require on App   │ │
  │        │   │ │ Open             │ │
  │        │   │ │ [Toggle Switch]  │ │
  │        │   │ └──────────────────┘ │
  │        │   └──────────────────────┘
  └────────┘
```

## Persistent Login Architecture

```
┌────────────────────────────────────┐
│      Firebase Auth                  │
│    (Long-term session)              │
└────────────────┬───────────────────┘
                 │
                 ▼
    ┌────────────────────────┐
    │ AuthService            │
    │ ┌────────────────────┐ │
    │ │checkPersistentSess.│ │
    │ │enablePersistent() │ │
    │ │disablePersistent()│ │
    │ └────────────────────┘ │
    └────────────┬───────────┘
                 │
                 ▼
    ┌────────────────────────────┐
    │ StorageService             │
    │ (shared_preferences)       │
    │                            │
    │ persistent_login = true    │
    └────────────────────────────┘
```

## Component Interactions

```
┌──────────────────────────────────────────────────┐
│           SafeDriver App                          │
│                                                   │
│  ┌─────────────────────────────────────────┐    │
│  │ BiometricService                        │    │
│  ├─────────────────────────────────────────┤    │
│  │ • Initialize()                          │    │
│  │ • authenticate()                        │    │
│  │ • hasFingerprint / hasFaceRecognition   │    │
│  │ • getPrimaryBiometricType()             │    │
│  └──────────────┬──────────────────────────┘    │
│                 │                                │
│  ┌──────────────▼──────────────────────────┐    │
│  │ BiometricSettingsProvider (Riverpod)    │    │
│  ├─────────────────────────────────────────┤    │
│  │ • isBiometricEnabled                    │    │
│  │ • isFingerPrintEnabled                  │    │
│  │ • isFaceIdEnabled                       │    │
│  │ • requireBiometricOnAppOpen             │    │
│  │ • setBiometricEnabled()                 │    │
│  └──────────────┬──────────────────────────┘    │
│                 │                                │
│  ┌──────────────▼──────────────────────────┐    │
│  │ AuthService (Updated)                   │    │
│  ├─────────────────────────────────────────┤    │
│  │ • enablePersistentLogin()               │    │
│  │ • disablePersistentLogin()              │    │
│  │ • checkPersistentSession()              │    │
│  │ • isPersistentLoginEnabled()            │    │
│  └──────────────┬──────────────────────────┘    │
│                 │                                │
│  ┌──────────────▼──────────────────────────┐    │
│  │ AuthProvider (Riverpod)                 │    │
│  ├─────────────────────────────────────────┤    │
│  │ • authenticateWithBiometric()           │    │
│  │ • signIn(), signOut() updated           │    │
│  └──────────────┬──────────────────────────┘    │
│                 │                                │
│  ┌──────────────▼──────────────────────────┐    │
│  │ SettingsPage (UI)                       │    │
│  ├─────────────────────────────────────────┤    │
│  │ • Biometric Lock Toggle                 │    │
│  │ • Fingerprint Toggle                    │    │
│  │ • Face ID Toggle                        │    │
│  │ • Require on App Open Toggle            │    │
│  └─────────────────────────────────────────┘    │
│                                                   │
└──────────────────────────────────────────────────┘
          │
          ▼
    ┌──────────────────┐
    │ os.auth (Local)  │  (OS Level)
    │ • local_auth pkg │
    │ • BiometricPrompt│
    │ • TouchID/FaceID │
    └──────────────────┘
```

## Session State Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                          SESSION STATES                      │
└─────────────────────────────────────────────────────────────┘

                    ┌──────────────┐
                    │   INITIAL    │
                    │   (No User)  │
                    └──────┬───────┘
                           │
              ┌────────────┼────────────┐
              │                         │
              ▼                         ▼
         ┌─────────┐            ┌──────────────────┐
         │ AUTO    │            │ SHOW LOGIN SCREEN│
         │ LOGIN   │            │                  │
         │ SUCCESS │            │ User Login Input │
         └────┬────┘            └────┬─────────────┘
              │                      │
              │                  ┌───┘
              │                  │
              └────────┬─────────┘
                       │
                       ▼
            ┌──────────────────────┐
            │ SESSION ACTIVE       │
            │ User: Authenticated  │
            │ Persistent: ON       │
            └─────────┬────────────┘
                      │
          ┌───────────┼───────────┐
          │ NO        │ YES       │
          │ (Biometric│ (Biometric│
          │ disabled) │ enabled)  │
          ▼           ▼
      ┌────────┐  ┌─────────────┐
      │ Direct │  │ Check       │
      │ to     │  │ Biometric   │
      │ App    │  │ Prompt      │
      └────────┘  │ Required?   │
                  └────┬────────┘
                       │
                  ┌────┴─────┐
                  │ YES       │ NO
                  ▼           ▼
             ┌────────┐   ┌─────┐
             │ Bio    │   │Direct
             │ Prompt │   │ to
             │        │   │ App
             └────┬───┘   └─────┘
                  │
              ┌───┴─────┐
              │ Success? │
              ├────┬─────┤
              │ YES│ NO  │
              ▼    ▼
            ┌─┐  ┌─────────────┐
            │✓│  │ Show Error  │
            │ │  │ & Retry     │
            └─┘  └─────┬───────┘
              │        │
              │        ▼
              │   ┌──────────┐
              │   │ Fallback │
              │   │ to       │
              │   │ Password?│
              │   └─────┬────┘
              │         │
              │         │
              └─────┬───┘
                    │
                    ▼
            ┌───────────────┐
            │ LOGOUT/SIGNOUT│
            └───────┬───────┘
                    │
                    ▼
        ┌────────────────────────┐
        │ SESSION CLEARED        │
        │ Persistent: OFF        │
        │ All Data Cleared       │
        └────────┬───────────────┘
                 │
                 ▼
        ┌────────────────┐
        │ SHOW LOGIN PAGE│
        └────────────────┘
```

## Data Flow

```
┌──────────────────────────────────────────────────────┐
│                APP_START                              │
└────────────┬─────────────────────────────────────────┘
             │
             ▼
    ┌────────────────────────┐
    │ AuthService.initialize │
    └────────────┬───────────┘
                 │
    ┌────────────▼──────────────────┐
    │ BiometricService.initialize   │
    └────────────┬──────────────────┘
                 │
    ┌────────────▼────────────────────────┐
    │ BiometricSettingsProvider.initialize│
    └────────────┬───────────────────────┘
                 │
    ┌────────────▼─────────────────────────────────┐
    │ Check: Persistent Login Enabled?            │
    └────────┬────────────────┬────────────────────┘
             │ NO             │ YES
             │                │
             ▼                ▼
        ┌────────┐      ┌───────────────┐
        │ Show   │      │ Check Session │
        │ Login  │      │ & Biometric   │
        │ Screen │      │ Requirements  │
        └────────┘      └───────────────┘
```

## Storage Schema

```
┌────────────────────────────────────────────────────┐
│              Local Storage (SharedPreferences)     │
│                                                    │
│ ┌──────────────────────────────────────────────┐  │
│ │ KEY                         │ VALUE           │  │
│ ├─────────────────────────────┼─────────────────┤  │
│ │ persistent_login            │ true/false      │  │
│ │ biometric_enabled           │ true/false      │  │
│ │ fingerprint_enabled         │ true/false      │  │
│ │ faceid_enabled              │ true/false      │  │
│ │ require_biometric_on_app_opn│ true/false      │  │
│ │                             │                 │  │
│ │ (Firebase Auth handles      │                 │  │
│ │  session persistence)       │                 │  │
│ └──────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────┘
```

## Error Handling Flow

```
┌──────────────────────────┐
│  Biometric Operation     │
└────────────┬─────────────┘
             │
         ┌───┴────┐
         │         │
         ▼         ▼
    ┌─────── ERROR ──────┐
    │                    │
    ├────┬────┬────┬─────┤
    │    │    │    │     │
    ▼    ▼    ▼    ▼     ▼
  Not   User Timeout Device  Other
  Supp. Cancel  Reject Error Error
  
  │    │    │    │     │
  │    │    │    │     │
  ▼    ▼    ▼    ▼     ▼
┌──────────────────────────┐
│ Handle Error w/ Message  │
│ • Log to console         │
│ • Show user message      │
│ • Offer fallback option  │
└──────────────────────────┘
```

---

**Legend:**
- ◄─── Points to related item
- ├─── Branch point
- ├─┤─── Decision/conditional
- ▼    Flow direction
