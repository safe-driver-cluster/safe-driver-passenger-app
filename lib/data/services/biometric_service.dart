import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  static final BiometricService _instance = BiometricService._internal();
  factory BiometricService() => _instance;
  BiometricService._internal();

  final LocalAuthentication _localAuth = LocalAuthentication();
  List<BiometricType> _availableBiometrics = [];
  bool _biometricSupported = false;

  /// Initialize biometric service and check available biometric types
  Future<void> initialize() async {
    try {
      // First check if the device can check biometrics (has sensors and system support)
      _biometricSupported = await _localAuth.canCheckBiometrics;
      debugPrint('🔐 Biometric Support: $_biometricSupported');

      if (_biometricSupported) {
        // Now get the available biometric types
        _availableBiometrics = await _localAuth.getAvailableBiometrics();
        debugPrint('📱 Available Biometrics: $_availableBiometrics');

        if (_availableBiometrics.isEmpty) {
          debugPrint(
              '⚠️ Biometric supported but no specific types detected. This may be due to:');
          debugPrint('   - Missing runtime permissions');
          debugPrint('   - Hardware not properly configured');
          debugPrint('   - Try enabling biometric to trigger permission request');
        }
      } else {
        debugPrint(
            '❌ Device does not support biometric authentication (no sensors or system support)');
      }
    } catch (e) {
      debugPrint('❌ Error initializing biometric: $e');
      _biometricSupported = false;
      _availableBiometrics = [];
    }
  }

  /// Check if device supports biometric authentication
  bool get isBiometricSupported => _biometricSupported;

  /// Check if device has fingerprint sensor
  bool get hasFingerprint {
    // Check for explicit fingerprint type
    if (_availableBiometrics.contains(BiometricType.fingerprint)) {
      return true;
    }
    // Also accept weak and strong biometrics (device-specific categorization)
    return _availableBiometrics.contains(BiometricType.weak) ||
        _availableBiometrics.contains(BiometricType.strong);
  }

  /// Check if device has face recognition
  bool get hasFaceRecognition {
    // Check for explicit face type
    if (_availableBiometrics.contains(BiometricType.face)) {
      return true;
    }
    // Also accept weak and strong biometrics (device-specific categorization)
    return _availableBiometrics.contains(BiometricType.weak) ||
        _availableBiometrics.contains(BiometricType.strong);
  }

  /// Get list of available biometric types
  List<BiometricType> get availableBiometrics => _availableBiometrics;

  /// Authenticate using biometrics
  Future<bool> authenticate({
    required String reason,
    bool useErrorDialogs = true,
    bool stickyAuth = false,
  }) async {
    try {
      if (!_biometricSupported) {
        debugPrint('⚠️ Biometric not supported on this device');
        return false;
      }

      final isAuthenticated = await _localAuth.authenticate(
        localizedReason: reason,
        options: AuthenticationOptions(
          stickyAuth: stickyAuth,
          useErrorDialogs: useErrorDialogs,
        ),
      );

      if (isAuthenticated) {
        debugPrint('✅ Biometric authentication successful');
      } else {
        debugPrint('❌ Biometric authentication failed');
      }

      return isAuthenticated;
    } catch (e) {
      debugPrint('❌ Error during biometric authentication: $e');
      return false;
    }
  }

  /// Authenticate specifically for fingerprint
  Future<bool> authenticateWithFingerprint({
    String reason = 'Please authenticate with your fingerprint',
  }) async {
    if (!hasFingerprint) {
      debugPrint('⚠️ Fingerprint not available on this device');
      return false;
    }

    return authenticate(reason: reason);
  }

  /// Authenticate specifically for face recognition
  Future<bool> authenticateWithFace({
    String reason = 'Please authenticate with your face',
  }) async {
    if (!hasFaceRecognition) {
      debugPrint('⚠️ Face recognition not available on this device');
      return false;
    }

    return authenticate(reason: reason);
  }

  /// Cancel biometric authentication
  Future<void> stopAuthentication() async {
    try {
      await _localAuth.stopAuthentication();
      debugPrint('🛑 Biometric authentication cancelled');
    } catch (e) {
      debugPrint('❌ Error stopping authentication: $e');
    }
  }

  /// Request biometric permission explicitly
  /// Call this when user tries to enable biometric authentication
  /// On Android, this will trigger the biometric dialog which requests permissions
  Future<bool> requestBiometricPermission() async {
    try {
      debugPrint('📱 Requesting biometric permission by attempting authentication...');

      // Attempt a test authentication which will trigger permission dialogs on Android
      try {
        final isAuthenticated = await _localAuth.authenticate(
          localizedReason:
              'Please authenticate to enable biometric security (you can cancel this)',
          options: const AuthenticationOptions(
            stickyAuth: true,
            useErrorDialogs: false, // Don't show error dialogs for this test
          ),
        );
        debugPrint('✅ Authentication attempt completed');
      } catch (e) {
        // FragmentActivity errors are expected if authentication can't complete
        // Just proceed with checking available biometrics
        if (e.toString().contains('no_fragment_activity') ||
            e.toString().contains('FragmentActivity')) {
          debugPrint(
              'ℹ️ Biometric dialog not available, but permissions may have been requested');
        } else {
          debugPrint('ℹ️ Authentication attempt result: $e');
        }
      }

      // Wait a bit before rechecking to allow permissions to be processed
      await Future.delayed(const Duration(milliseconds: 500));

      // Regardless of authentication result, check available biometrics again
      // because permission dialogs may have been shown
      final newBiometrics = await _localAuth.getAvailableBiometrics();
      debugPrint('✅ Checked available biometrics after permission attempt');
      debugPrint('📱 Available Biometrics: $newBiometrics');

      if (newBiometrics.isNotEmpty && newBiometrics != _availableBiometrics) {
        _availableBiometrics = newBiometrics;
        debugPrint(
            '✅ Biometric methods now available: ${_availableBiometrics.length}');
        return true;
      }

      // If no new biometrics detected, biometric may still not be properly configured
      if (_availableBiometrics.isEmpty && _biometricSupported) {
        debugPrint('⚠️ Biometric supported but still no methods detected.');
        debugPrint('   Verify device settings > Security > Biometric is enabled');
        return false;
      }

      return _availableBiometrics.isNotEmpty;
    } catch (e) {
      debugPrint('ℹ️ Main error handling: $e');
      // Re-check available biometrics anyway
      try {
        _availableBiometrics = await _localAuth.getAvailableBiometrics();
        debugPrint('📱 Re-checked biometrics: $_availableBiometrics');
      } catch (e2) {
        debugPrint('❌ Error re-checking biometrics: $e2');
      }
      return _availableBiometrics.isNotEmpty;
    }
  }

  /// Get biometric type display name
  String getBiometricTypeName(BiometricType type) {
    switch (type) {
      case BiometricType.fingerprint:
        return 'Fingerprint';
      case BiometricType.face:
        return 'Face Recognition';
      case BiometricType.iris:
        return 'Iris';
      case BiometricType.strong:
        return 'Strong Biometric';
      case BiometricType.weak:
        return 'Weak Biometric';
      default:
        return 'Biometric';
    }
  }

  /// Get list of available biometric type names
  List<String> getAvailableBiometricNames() {
    return _availableBiometrics
        .map((type) => getBiometricTypeName(type))
        .toList();
  }

  /// Get primary biometric type (fingerprint if available, else face)
  String? getPrimaryBiometricType() {
    if (hasFingerprint) return 'Fingerprint';
    if (hasFaceRecognition) return 'Face Recognition';
    
    // Fallback: if we have any biometric type available
    if (_availableBiometrics.isNotEmpty) {
      final firstType = _availableBiometrics.first;
      if (firstType == BiometricType.strong) return 'Strong Biometric';
      if (firstType == BiometricType.weak) return 'Weak Biometric';
      return getBiometricTypeName(firstType);
    }
    
    return null;
  }
}
