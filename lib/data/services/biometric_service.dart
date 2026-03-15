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
      _biometricSupported = await _localAuth.canCheckBiometrics;
      _availableBiometrics = await _localAuth.getAvailableBiometrics();

      debugPrint('🔐 Biometric Support: $_biometricSupported');
      debugPrint('📱 Available Biometrics: $_availableBiometrics');
    } catch (e) {
      debugPrint('❌ Error initializing biometric: $e');
      _biometricSupported = false;
      _availableBiometrics = [];
    }
  }

  /// Check if device supports biometric authentication
  bool get isBiometricSupported => _biometricSupported;

  /// Check if device has fingerprint sensor
  bool get hasFingerprint =>
      _availableBiometrics.contains(BiometricType.fingerprint);

  /// Check if device has face recognition
  bool get hasFaceRecognition =>
      _availableBiometrics.contains(BiometricType.face);

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
    return null;
  }
}
