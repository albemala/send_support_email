library send_support_email;

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<String> generateSupportEmail(String email) async {
  final packageInfo = await PackageInfo.fromPlatform();
  final systemInfo = await _generateSystemInfo();
  final deviceInfo = await _generateDeviceInfo();

  const subject = '';

  final body = '''
----------------------
Please do not remove this information, as it helps us to assist you better.
${packageInfo.appName} ${packageInfo.version}.${packageInfo.buildNumber}
$systemInfo | $deviceInfo
----------------------
''';

  var url = 'mailto:$email';
  url += '?subject=$subject';
  url += '&body=${Uri.encodeComponent(body)}';

  return url;
}

Future<String> _generateSystemInfo() async {
  final deviceInfo = DeviceInfoPlugin();
  if (kIsWeb) {
    final info = await deviceInfo.webBrowserInfo;
    return '${info.userAgent}';
  }
  if (Platform.isAndroid) {
    final info = await deviceInfo.androidInfo;
    return 'Android ${info.version.baseOS} ${info.version.release} (${info.version.sdkInt})';
  }
  if (Platform.isIOS) {
    final info = await deviceInfo.iosInfo;
    return 'iOS ${info.systemVersion}';
  }
  if (Platform.isMacOS) {
    final info = await deviceInfo.macOsInfo;
    return 'macOS ${info.osRelease}';
  }
  if (Platform.isWindows) {
    final info = await deviceInfo.windowsInfo;
    // TODO improve if possible
    return 'Windows';
  }
  if (Platform.isLinux) {
    final info = await deviceInfo.linuxInfo;
    return info.prettyName;
  }
  return '';
}

Future<String> _generateDeviceInfo() async {
  final deviceInfo = DeviceInfoPlugin();
  if (kIsWeb) {
    final info = await deviceInfo.webBrowserInfo;
    return '${info.platform}';
  }
  if (Platform.isAndroid) {
    final info = await deviceInfo.androidInfo;
    return '${info.manufacturer} ${info.model}';
  }
  if (Platform.isIOS) {
    final info = await deviceInfo.iosInfo;
    return '${info.utsname.machine}';
  }
  if (Platform.isMacOS) {
    final info = await deviceInfo.macOsInfo;
    return info.model;
  }
  if (Platform.isWindows) {
    final info = await deviceInfo.windowsInfo;
    // TODO improve if possible
    return '';
  }
  if (Platform.isLinux) {
    final info = await deviceInfo.linuxInfo;
    // TODO improve if possible
    return '';
  }
  return '';
}
