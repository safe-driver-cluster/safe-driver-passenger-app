import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safedriver_passenger_app/data/services/biometric_service.dart';

import '../../core/services/storage_service.dart';

// Biometric service provider
final biometricServiceProvider = Provider<BiometricService>((ref) {
  return BiometricService();
});

// Storage service provider
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService.instance;
});

// Biometric settings model
class BiometricSettings {
  final bool isBiometricEnabled;
  final bool isFingerPrintEnabled;
  final bool isFaceIdEnabled;
  final bool requireBiometricOnAppOpen;
  final bool isBiometricSupported;
  final String? primaryBiometricType;
  final bool isLoading;
  final String? error;

  const BiometricSettings({
    this.isBiometricEnabled = false,
    this.isFingerPrintEnabled = false,
    this.isFaceIdEnabled = false,
    this.requireBiometricOnAppOpen = false,
    this.isBiometricSupported = false,
    this.primaryBiometricType,
    this.isLoading = false,
    this.error,
  });

  BiometricSettings copyWith({
    bool? isBiometricEnabled,
    bool? isFingerPrintEnabled,
    bool? isFaceIdEnabled,
    bool? requireBiometricOnAppOpen,
    bool? isBiometricSupported,
    String? primaryBiometricType,
    bool? isLoading,
    String? error,
  }) {
    return BiometricSettings(
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      isFingerPrintEnabled: isFingerPrintEnabled ?? this.isFingerPrintEnabled,
      isFaceIdEnabled: isFaceIdEnabled ?? this.isFaceIdEnabled,
      requireBiometricOnAppOpen:
          requireBiometricOnAppOpen ?? this.requireBiometricOnAppOpen,
      isBiometricSupported: isBiometricSupported ?? this.isBiometricSupported,
      primaryBiometricType: primaryBiometricType ?? this.primaryBiometricType,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Biometric settings notifier
class BiometricSettingsNotifier extends StateNotifier<BiometricSettings> {
  final BiometricService _biometricService;
  final StorageService _storage;

  // Storage keys
  static const String _biometricEnabledKey = 'biometric_enabled';
  static const String _fingerPrintEnabledKey = 'fingerprint_enabled';
  static const String _faceIdEnabledKey = 'faceid_enabled';
  static const String _requireBiometricOnAppOpenKey =
      'require_biometric_on_app_open';

  BiometricSettingsNotifier(
    this._biometricService,
    this._storage,
  ) : super(const BiometricSettings()) {
    _initialize();
  }

  /// Initialize biometric settings
  Future<void> _initialize() async {
    try {
      // Initialize biometric service
      await _biometricService.initialize();

      // Load settings from storage
      bool isBiometricEnabled = _storage.getBool(_biometricEnabledKey) ?? false;
      bool isFingerPrintEnabled =
          _storage.getBool(_fingerPrintEnabledKey) ?? false;
      bool isFaceIdEnabled = _storage.getBool(_faceIdEnabledKey) ?? false;
      bool requireBiometricOnAppOpen =
          _storage.getBool(_requireBiometricOnAppOpenKey) ?? false;

      // If biometric not supported, disable all settings
      if (!_biometricService.isBiometricSupported) {
        isBiometricEnabled = false;
        isFingerPrintEnabled = false;
        isFaceIdEnabled = false;
        requireBiometricOnAppOpen = false;
      }

      state = state.copyWith(
        isBiometricSupported: _biometricService.isBiometricSupported,
        isBiometricEnabled: isBiometricEnabled,
        isFingerPrintEnabled:
            isFingerPrintEnabled && _biometricService.hasFingerprint,
        isFaceIdEnabled:
            isFaceIdEnabled && _biometricService.hasFaceRecognition,
        requireBiometricOnAppOpen: requireBiometricOnAppOpen,
        primaryBiometricType: _biometricService.getPrimaryBiometricType(),
      );

      print('✅ Biometric settings initialized');
    } catch (e) {
      state = state.copyWith(error: 'Failed to initialize biometric settings');
      print('❌ Error initializing biometric settings: $e');
    }
  }

  /// Enable/disable biometric authentication
  Future<void> setBiometricEnabled(bool enabled) async {
    try {
      if (!_biometricService.isBiometricSupported) {
        state = state.copyWith(error: 'Biometric not supported on this device');
        return;
      }

      state = state.copyWith(isLoading: true, error: null);

      await _storage.saveBool(_biometricEnabledKey, enabled);

      // If disabling biometric, also disable app open requirement
      if (!enabled) {
        await _storage.saveBool(_requireBiometricOnAppOpenKey, false);
        state = state.copyWith(requireBiometricOnAppOpen: false);
      }

      state = state.copyWith(
        isBiometricEnabled: enabled,
        isLoading: false,
      );

      print('✅ Biometric enabled: $enabled');
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to update biometric settings',
      );
      print('❌ Error updating biometric settings: $e');
    }
  }

  /// Enable/disable fingerprint
  Future<void> setFingerPrintEnabled(bool enabled) async {
    try {
      if (!_biometricService.hasFingerprint) {
        state =
            state.copyWith(error: 'Fingerprint not available on this device');
        return;
      }

      state = state.copyWith(isLoading: true, error: null);

      await _storage.saveBool(_fingerPrintEnabledKey, enabled);

      // Enable biometric if enabling fingerprint
      if (enabled && !state.isBiometricEnabled) {
        await _storage.saveBool(_biometricEnabledKey, true);
        state = state.copyWith(isBiometricEnabled: true);
      }

      state = state.copyWith(
        isFingerPrintEnabled: enabled,
        isLoading: false,
      );

      print('✅ Fingerprint enabled: $enabled');
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to update fingerprint settings',
      );
      print('❌ Error updating fingerprint settings: $e');
    }
  }

  /// Enable/disable face ID
  Future<void> setFaceIdEnabled(bool enabled) async {
    try {
      if (!_biometricService.hasFaceRecognition) {
        state = state.copyWith(
            error: 'Face recognition not available on this device');
        return;
      }

      state = state.copyWith(isLoading: true, error: null);

      await _storage.saveBool(_faceIdEnabledKey, enabled);

      // Enable biometric if enabling face ID
      if (enabled && !state.isBiometricEnabled) {
        await _storage.saveBool(_biometricEnabledKey, true);
        state = state.copyWith(isBiometricEnabled: true);
      }

      state = state.copyWith(
        isFaceIdEnabled: enabled,
        isLoading: false,
      );

      print('✅ Face ID enabled: $enabled');
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to update face ID settings',
      );
      print('❌ Error updating face ID settings: $e');
    }
  }

  /// Require biometric on app open
  Future<void> setRequireBiometricOnAppOpen(bool required) async {
    try {
      if (!state.isBiometricEnabled) {
        state = state.copyWith(error: 'Please enable biometric first');
        return;
      }

      state = state.copyWith(isLoading: true, error: null);

      await _storage.saveBool(_requireBiometricOnAppOpenKey, required);

      state = state.copyWith(
        requireBiometricOnAppOpen: required,
        isLoading: false,
      );

      print('✅ Require biometric on app open: $required');
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to update app open requirement',
      );
      print('❌ Error updating app open requirement: $e');
    }
  }

  /// Reset biometric settings
  Future<void> resetBiometricSettings() async {
    try {
      await _storage.saveBool(_biometricEnabledKey, false);
      await _storage.saveBool(_fingerPrintEnabledKey, false);
      await _storage.saveBool(_faceIdEnabledKey, false);
      await _storage.saveBool(_requireBiometricOnAppOpenKey, false);

      state = const BiometricSettings(
        isBiometricSupported: true,
      );

      print('✅ Biometric settings reset');
    } catch (e) {
      state = state.copyWith(error: 'Failed to reset biometric settings');
      print('❌ Error resetting biometric settings: $e');
    }
  }
}

// Biometric settings provider
final biometricSettingsProvider =
    StateNotifierProvider<BiometricSettingsNotifier, BiometricSettings>((ref) {
  final biometricService = ref.watch(biometricServiceProvider);
  final storage = ref.watch(storageServiceProvider);
  return BiometricSettingsNotifier(biometricService, storage);
});
