import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceIdProvider {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  /// Attempts to return a stable device identifier without requiring dangerous permissions.
  /// - On Android: ANDROID_ID
  /// - On iOS: identifierForVendor
  /// - Else: returns a placeholder string
  static Future<String> getDeviceId() async {
    try {
      if (Platform.isAndroid) {
        final info = await _deviceInfo.androidInfo;
        // ANDROID_ID is a 64-bit number (as a hex string) that should remain
        // constant for the lifetime of the user's device. It may reset on factory reset.
        final id = info.id; // ANDROID_ID
        if (id != null && id.isNotEmpty) return id;
      } else if (Platform.isIOS) {
        final info = await _deviceInfo.iosInfo;
        final id = info.identifierForVendor;
        if (id != null && id.isNotEmpty) return id;
      }
    } catch (_) {}
    return 'UNKNOWN_DEVICE_ID';
  }
}
