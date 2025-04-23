// ignore_for_file: file_names

import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';

class DeviceInfo {
  static var deviceUid = "";
  static var deviceName = "";
  static var deviceVersion = "";
  static var deviceModel = "";
  static var deviceOS = "";
  static var timezone = "";

  static getdeviceInfo() async {
    if (Platform.isAndroid) {
      // Android-specific code
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceUid = androidInfo.device;
      deviceName = androidInfo.brand;
      deviceVersion = androidInfo.version.sdkInt.toString();
      deviceModel = androidInfo.model;
      timezone = DateTime.now().timeZoneName;
      deviceOS = "And";
      //print('Running on ${androidInfo.androidId}');
    } else if (Platform.isIOS) {
      // iOS-specific code
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceUid = iosInfo.identifierForVendor ?? "";
      deviceName = iosInfo.name;
      deviceVersion = iosInfo.systemVersion;
      deviceModel = iosInfo.model;
      timezone = DateTime.now().timeZoneName;
      deviceOS = "iOS";
    }
    try {
      timezone ='';
    } on PlatformException {
      timezone = 'Failed to get the timezone.';
    }
    // print('Running on $timezone');
  }
}