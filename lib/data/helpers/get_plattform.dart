import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

String getPlatform() {
  if (kIsWeb) return 'web';
  return Platform.operatingSystem;
}

Future<String> getDeviceName() async {
  final deviceInfo = DeviceInfoPlugin();

  try {
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.model;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.utsname.machine;
    } else {
      return 'unknown';
    }
  } catch (e) {
    return 'unknown';
  }
}
