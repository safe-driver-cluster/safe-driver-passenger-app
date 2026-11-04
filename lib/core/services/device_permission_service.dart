import 'package:flutter/services.dart';

class DevicePermissionService {
  static const MethodChannel _channel =
      MethodChannel('com.codecrafters.safedriver/device_permissions');

  Future<bool> revokeLocationPermissionOnAndroid() async {
    try {
      final result =
          await _channel.invokeMethod<bool>('revokeLocationPermission');
      return result ?? false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }
}
