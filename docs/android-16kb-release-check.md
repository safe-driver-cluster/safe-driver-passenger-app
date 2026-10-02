# Android 16 KB release verification

This check covers native-library alignment, App Bundle packaging, and a local
Android 16 emulator smoke test. It does not certify all Google Play policies or
replace testing of authenticated passenger journeys on real devices.

## Build configuration

- Flutter 3.35.1 / Dart 3.9.0.
- Android Gradle Plugin 8.10.1, Gradle 8.12, Kotlin 2.1.0.
- Android compile SDK 36; NDK 28.2.13676358.
- Uncompressed JNI libraries (`useLegacyPackaging = false`).
- `mobile_scanner` 7.1.4 supplies ML Kit barcode scanning 17.3.0 and CameraX
  1.5.1. The scanner's error callback was migrated to the new API.
- Scanner versions are constrained below 7.2.0 to preserve compatibility with
  the existing Firebase web dependencies. The lockfile pins the audited version.

The previous `passener-app-1.0.1+8.aab` failed ELF checks for both 64-bit copies of
`libbarhopper_v3.so` and `libimage_processing_util_jni.so`. Its bundle packaging
already requested `PAGE_ALIGNMENT_16K`; packaging alone did not fix its native
libraries. Changing NDK versions does not rebuild precompiled SDK libraries.

## Upload signing

The existing upload keystore was found at `D:/safedriver.jks`. Its certificate
matches the previous passenger release. `android/key.properties` now contains
the correct path and existing signing credentials. This file is ignored by Git.
Existing signing entries in `android/local.properties` remain a fallback.
For another machine, copy `android/key.properties.example` to
`android/key.properties` and populate it with the **existing Play upload key**.

Normal release builds require the upload keystore. The explicit Gradle property
`allowUnsignedRelease=true` produces unsigned artifacts for local checks only.
Do not upload those artifacts or emulator APKs signed with the debug key.

After configuring the real key, build with a version code greater than the
highest version code already used in your Play Console:

```powershell
flutter pub get
flutter analyze
flutter test
flutter build appbundle --release --build-number YOUR_NEXT_VERSION_CODE
python scripts/check_android_page_sizes.py build/app/outputs/bundle/release/app-release.aab --json-output build/16kb-release.json
```

## Verify packaging and run on a 16 KB device

Download `bundletool` from Google's official release page. Use Java 17 or newer
and Android SDK Build-Tools 35 or newer. Substitute the installed tool paths:

```powershell
java -jar BUNDLETOOL.jar dump config --bundle=build/app/outputs/bundle/release/app-release.aab
java -jar BUNDLETOOL.jar build-apks --bundle=build/app/outputs/bundle/release/app-release.aab --output=build/release-check.apks --mode=universal
```

The bundle config must contain `PAGE_ALIGNMENT_16K`. Extract `universal.apk` from
the `.apks` ZIP archive, then check both ELF layout and APK ZIP offsets:

```powershell
python scripts/check_android_page_sizes.py build/release-check/universal.apk
zipalign -c -P 16 -v 4 build/release-check/universal.apk
adb shell getconf PAGE_SIZE
adb shell setprop bionic.linker.16kb.app_compat.enabled false
adb shell setprop pm.16kb.app_compat.disabled true
adb shell getprop bionic.linker.16kb.app_compat.enabled
adb shell getprop pm.16kb.app_compat.disabled
adb install -r build/release-check/universal.apk
adb shell am start -W -n com.codecrafters.safedriver/.MainActivity
```

The device must report `16384`; the linker compatibility property must report
`false` and the package-manager disable property `true`. Inspect Android logs
for linker errors, native crashes, and app crashes.
Check QR scanning, camera capture, maps/location, video playback, notifications,
biometrics, storage, sign-in/OTP, NFC, and SOS on supported test devices before
rolling out. Testing SOS requires an agreed test recipient.

For repeatable checker validation:

```powershell
python scripts/test_android_page_sizes.py
```

## References

- [Android's 16 KB page-size guidance](https://developer.android.com/guide/practices/page-sizes)
- [Android Gradle Plugin 8.10 compatibility](https://developer.android.com/build/releases/agp-8-10-0-release-notes)
- [Scanner changelog](https://pub.dev/packages/mobile_scanner/changelog)
- [Google bundletool releases](https://github.com/google/bundletool/releases)

## Results from this workspace

Verification date: 2 October 2026 (Asia/Colombo).

- Dependency resolution succeeded with only `mobile_scanner` changing.
- Startup widget test: passed (1 test).
- ELF checker regression tests: passed (6 tests).
- Dart analysis: no errors; 25 warnings and 651 informational notices.
- Android 16 x86_64 emulator: boots with `PAGE_SIZE=16384`; linker compatibility
  fallback disabled.
- Fresh release bundle build: passed, 65.6 MB; version 1.0.1+8. The bundle was
  saved as `build/16kb-check/app-16kb-unsigned.aab` to identify
  it clearly as a compatibility-check artifact.
- Bundle ELF check: all 12 libraries passed (6 each for arm64-v8a and x86_64).
  The native library set is `libapp.so`, `libflutter.so`, `libbarhopper_v3.so`,
  `libdatastore_shared_counter.so`, `libimage_processing_util_jni.so`, and
  `libsurface_util_jni.so`. Checks include LOAD alignment, address/offset
  congruence, and RELRO end alignment or a safe LOAD suffix.
- Bundle configuration: `PAGE_ALIGNMENT_16K` verified with bundletool 1.18.3.
- Universal APK generated from that bundle: all 12 libraries passed; ZIP offsets
  passed the Python checker and Android Build-Tools 36.0.0 `zipalign -P 16`.
- Emulator installation and cold launch: passed. Notification permission,
  language selection, onboarding, and the login screen were exercised. No
  native linker failures, fatal signals, or AndroidRuntime crashes were observed
  in the captured startup logs. Both linker and package-manager compatibility
  fallback were disabled. Runtime testing used the x86_64 emulator; ARM64 was
  checked statically.
- Authenticated flows, QR scanning/camera operation, and hardware-dependent
  features still require device testing; no login credentials were supplied.
- Normal release signing guard: verified to fail with a clear missing-upload-key
  message. Compatibility output is unsigned; the emulator APK is debug-signed.
- Signed release build: passed after restoring the keystore path. The output is
  `build/app/outputs/bundle/release/app-release.aab` (68,865,021 bytes). Its JAR
  signature was verified and its signer matches the previous passenger release.
  All 12 native-library checks pass and its config requests `PAGE_ALIGNMENT_16K`.
  Version remains 1.0.1+8; increment the version code if 8 is already used in Play.
  Play Console upload/acceptance has not been checked.

Bundle SHA-256:
`7d0e4a818191eeb557d6c8927bc2b164ab2b92dbcd010315ef56437ac651682b`.

Signed release bundle SHA-256:
`b70d8aef7d9d7c6845802ce542fca92959ee2f6cd5de5b2c966e47fdf67b633a`.

Detailed evidence is saved under the ignored `build/` directory:
`16kb-before.json`, `16kb-after-bundle.json`, `16kb-after-apk.json`,
`16kb-after-bundle-config.json`, `16kb-zipalign.log`, `16kb-emulator-launch.log`,
`16kb-runtime-check.log`, `16kb-tests.log`, `16kb-analyze.log`, and
`16kb-signing-guard.log`. Startup and login screenshots are in `build/16kb-check/`.
