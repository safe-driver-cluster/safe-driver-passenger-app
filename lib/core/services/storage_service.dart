import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class StorageService {
  static StorageService? _instance;
  static StorageService get instance => _instance ??= StorageService._();
  StorageService._();

  SharedPreferences? _prefs;
  Box? _secureBox;
  Box? _userBox;
  Box? _cacheBox;

  // Storage keys
  static const String _userTokenKey = 'user_token';
  static const String _userDataKey = 'user_data';
  static const String _settingsKey = 'app_settings';
  static const String _offlineDataKey = 'offline_data';

  /// Initialize storage service
  Future<bool> initialize() async {
    try {
      // Initialize SharedPreferences
      _prefs = await SharedPreferences.getInstance();

      // Initialize Hive
      await _initializeHive();

      return true;
    } catch (e) {
      print('Storage service initialization failed: $e');
      return false;
    }
  }

  /// Initialize Hive boxes
  Future<void> _initializeHive() async {
    try {
      // Get application directory
      final appDocDir = await getApplicationDocumentsDirectory();
      await Hive.initFlutter(appDocDir.path);

      // Open boxes
      _secureBox = await Hive.openBox('secure_data');
      _userBox = await Hive.openBox('user_data');
      _cacheBox = await Hive.openBox('cache_data');
    } catch (e) {
      print('Hive initialization failed: $e');
      throw StorageException('Failed to initialize local storage: $e');
    }
  }

  // SharedPreferences Methods

  /// Save string value
  Future<bool> saveString(String key, String value) async {
    try {
      return await _prefs?.setString(key, value) ?? false;
    } catch (e) {
      print('Failed to save string: $e');
      return false;
    }
  }

  /// Get string value
  String? getString(String key, {String? defaultValue}) {
    try {
      return _prefs?.getString(key) ?? defaultValue;
    } catch (e) {
      print('Failed to get string: $e');
      return defaultValue;
    }
  }

  /// Save integer value
  Future<bool> saveInt(String key, int value) async {
    try {
      return await _prefs?.setInt(key, value) ?? false;
    } catch (e) {
      print('Failed to save int: $e');
      return false;
    }
  }

  /// Get integer value
  int? getInt(String key, {int? defaultValue}) {
    try {
      return _prefs?.getInt(key) ?? defaultValue;
    } catch (e) {
      print('Failed to get int: $e');
      return defaultValue;
    }
  }

  /// Save boolean value
  Future<bool> saveBool(String key, bool value) async {
    try {
      return await _prefs?.setBool(key, value) ?? false;
    } catch (e) {
      print('Failed to save bool: $e');
      return false;
    }
  }

  /// Get boolean value
  bool? getBool(String key, {bool? defaultValue}) {
    try {
      return _prefs?.getBool(key) ?? defaultValue;
    } catch (e) {
      print('Failed to get bool: $e');
      return defaultValue;
    }
  }

  /// Save double value
  Future<bool> saveDouble(String key, double value) async {
    try {
      return await _prefs?.setDouble(key, value) ?? false;
    } catch (e) {
      print('Failed to save double: $e');
      return false;
    }
  }

  /// Get double value
  double? getDouble(String key, {double? defaultValue}) {
    try {
      return _prefs?.getDouble(key) ?? defaultValue;
    } catch (e) {
      print('Failed to get double: $e');
      return defaultValue;
    }
  }

  /// Save string list
  Future<bool> saveStringList(String key, List<String> value) async {
    try {
      return await _prefs?.setStringList(key, value) ?? false;
    } catch (e) {
      print('Failed to save string list: $e');
      return false;
    }
  }

  /// Get string list
  List<String>? getStringList(String key, {List<String>? defaultValue}) {
    try {
      return _prefs?.getStringList(key) ?? defaultValue;
    } catch (e) {
      print('Failed to get string list: $e');
      return defaultValue;
    }
  }

  // Hive Box Methods

  /// Save data to secure box
  Future<void> saveSecureData(String key, dynamic value) async {
    try {
      await _secureBox?.put(key, value);
    } catch (e) {
      print('Failed to save secure data: $e');
      throw StorageException('Failed to save secure data: $e');
    }
  }

  /// Get data from secure box
  T? getSecureData<T>(String key, {T? defaultValue}) {
    try {
      return _secureBox?.get(key, defaultValue: defaultValue);
    } catch (e) {
      print('Failed to get secure data: $e');
      return defaultValue;
    }
  }

  /// Save user data
  Future<void> saveUserData(String key, dynamic value) async {
    try {
      await _userBox?.put(key, value);
    } catch (e) {
      print('Failed to save user data: $e');
      throw StorageException('Failed to save user data: $e');
    }
  }

  /// Get user data
  T? getUserData<T>(String key, {T? defaultValue}) {
    try {
      return _userBox?.get(key, defaultValue: defaultValue);
    } catch (e) {
      print('Failed to get user data: $e');
      return defaultValue;
    }
  }

  /// Cache data with expiration
  Future<void> cacheData(String key, dynamic value,
      {Duration? expiration}) async {
    try {
      final cacheItem = {
        'data': value,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'expiration': expiration?.inMilliseconds,
      };
      await _cacheBox?.put(key, cacheItem);
    } catch (e) {
      print('Failed to cache data: $e');
      throw StorageException('Failed to cache data: $e');
    }
  }

  /// Get cached data
  T? getCachedData<T>(String key, {T? defaultValue}) {
    try {
      final cacheItem = _cacheBox?.get(key);
      if (cacheItem == null) return defaultValue;

      final timestamp = cacheItem['timestamp'] as int?;
      final expiration = cacheItem['expiration'] as int?;

      if (timestamp != null && expiration != null) {
        final now = DateTime.now().millisecondsSinceEpoch;
        if (now - timestamp > expiration) {
          // Data has expired, remove it
          _cacheBox?.delete(key);
          return defaultValue;
        }
      }

      return cacheItem['data'] as T? ?? defaultValue;
    } catch (e) {
      print('Failed to get cached data: $e');
      return defaultValue;
    }
  }

  /// Check if cached data exists and is valid
  bool isCacheValid(String key) {
    try {
      final cacheItem = _cacheBox?.get(key);
      if (cacheItem == null) return false;

      final timestamp = cacheItem['timestamp'] as int?;
      final expiration = cacheItem['expiration'] as int?;

      if (timestamp != null && expiration != null) {
        final now = DateTime.now().millisecondsSinceEpoch;
        return now - timestamp <= expiration;
      }

      return true; // No expiration set
    } catch (e) {
      print('Failed to check cache validity: $e');
      return false;
    }
  }

  // High-level methods

  /// Save user authentication token
  Future<bool> saveUserToken(String token) async {
    return await saveString(_userTokenKey, token);
  }

  /// Get user authentication token
  String? getUserToken() {
    return getString(_userTokenKey);
  }

  /// Clear user authentication token
  Future<bool> clearUserToken() async {
    return await _prefs?.remove(_userTokenKey) ?? false;
  }

  /// Save user profile data
  Future<void> saveUserProfile(Map<String, dynamic> userData) async {
    await saveUserData(_userDataKey, userData);
  }

  /// Get user profile data
  Map<String, dynamic>? getUserProfile() {
    return getUserData<Map<String, dynamic>>(_userDataKey);
  }

  /// Clear user profile data
  Future<void> clearUserProfile() async {
    await _userBox?.delete(_userDataKey);
  }

  /// Save app settings
  Future<bool> saveAppSettings(Map<String, dynamic> settings) async {
    final jsonString = jsonEncode(settings);
    return await saveString(_settingsKey, jsonString);
  }

  /// Get app settings
  Map<String, dynamic>? getAppSettings() {
    final jsonString = getString(_settingsKey);
    if (jsonString == null) return null;

    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      print('Failed to decode app settings: $e');
      return null;
    }
  }

  /// Save offline data
  Future<void> saveOfflineData(String key, dynamic data) async {
    final offlineData =
        getUserData<Map<String, dynamic>>(_offlineDataKey) ?? {};
    offlineData[key] = data;
    await saveUserData(_offlineDataKey, offlineData);
  }

  /// Get offline data
  T? getOfflineData<T>(String key) {
    final offlineData = getUserData<Map<String, dynamic>>(_offlineDataKey);
    return offlineData?[key] as T?;
  }

  /// Get all offline data
  Map<String, dynamic>? getAllOfflineData() {
    return getUserData<Map<String, dynamic>>(_offlineDataKey);
  }

  /// Clear offline data
  Future<void> clearOfflineData({String? key}) async {
    if (key != null) {
      final offlineData = getUserData<Map<String, dynamic>>(_offlineDataKey);
      if (offlineData != null) {
        offlineData.remove(key);
        await saveUserData(_offlineDataKey, offlineData);
      }
    } else {
      await _userBox?.delete(_offlineDataKey);
    }
  }

  // Utility methods

  /// Check if key exists in SharedPreferences
  bool hasKey(String key) {
    return _prefs?.containsKey(key) ?? false;
  }

  /// Remove key from SharedPreferences
  Future<bool> removeKey(String key) async {
    return await _prefs?.remove(key) ?? false;
  }

  /// Get all keys from SharedPreferences
  Set<String> getAllKeys() {
    return _prefs?.getKeys() ?? {};
  }

  /// Clear all SharedPreferences data
  Future<bool> clearAll() async {
    return await _prefs?.clear() ?? false;
  }

  /// Clear all Hive boxes
  Future<void> clearAllBoxes() async {
    try {
      await _secureBox?.clear();
      await _userBox?.clear();
      await _cacheBox?.clear();
    } catch (e) {
      print('Failed to clear boxes: $e');
      throw StorageException('Failed to clear local storage: $e');
    }
  }

  /// Get storage size information
  Map<String, int> getStorageInfo() {
    return {
      'preferences_keys': _prefs?.getKeys().length ?? 0,
      'secure_box_length': _secureBox?.length ?? 0,
      'user_box_length': _userBox?.length ?? 0,
      'cache_box_length': _cacheBox?.length ?? 0,
    };
  }

  /// Compact Hive boxes (optimize storage)
  Future<void> compactStorage() async {
    try {
      await _secureBox?.compact();
      await _userBox?.compact();
      await _cacheBox?.compact();
    } catch (e) {
      print('Failed to compact storage: $e');
    }
  }

  /// Close all storage connections
  Future<void> dispose() async {
    try {
      await _secureBox?.close();
      await _userBox?.close();
      await _cacheBox?.close();
      await Hive.close();
    } catch (e) {
      print('Failed to dispose storage: $e');
    }
  }
}

// Custom exceptions
class StorageException implements Exception {
  final String message;
  StorageException(this.message);

  @override
  String toString() => 'StorageException: $message';
}
