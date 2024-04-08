import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<Uri> generateSupportEmail(
  String email, {
  String subject = '',
  String body = '',
}) async {
  final packageInfo = await generatePackageInfo();
  final systemInfo = await generateSystemInfo();
  final deviceInfo = await generateDeviceInfo();

  final completeBody = '''
$body

----------------------
Please do not remove this information, as it helps us to assist you better.
$packageInfo
$systemInfo
$deviceInfo
----------------------
''';

  return Uri(
    scheme: 'mailto',
    path: email,
    query: _encodeQueryParameters(<String, String>{
      'subject': subject,
      'body': completeBody,
    }),
  );
}

String _encodeQueryParameters(Map<String, String> params) {
  return params.entries.map((entry) {
    final key = Uri.encodeComponent(entry.key);
    final value = Uri.encodeComponent(entry.value);
    return '$key=$value';
  }).join('&');
}

@visibleForTesting
Future<String> generatePackageInfo() async {
  final packageInfo = await PackageInfo.fromPlatform();
  return '''
${packageInfo.appName} ${packageInfo.version}.${packageInfo.buildNumber}''';
}

@visibleForTesting
Future<String> generateSystemInfo() async {
  final deviceInfo = DeviceInfoPlugin();
  if (kIsWeb) {
    final info = await deviceInfo.webBrowserInfo;
    return '${info.browserName.name}';
  }
  if (Platform.isAndroid) {
    final info = await deviceInfo.androidInfo;
    return 'Android ${info.version.release} (${info.version.sdkInt})';
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
    return '${info.productName} ${info.displayVersion}';
  }
  if (Platform.isLinux) {
    final info = await deviceInfo.linuxInfo;
    // print('----------------------');
    // print(info.data.entries.map((e) => '${e.key}: ${e.value}').join('\n'));
    // print('----------------------');
    return info.prettyName;
  }
  return '';
}

@visibleForTesting
Future<String> generateDeviceInfo() async {
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
    return '';
  }
  if (Platform.isLinux) {
    final info = await deviceInfo.linuxInfo;
    return '';
  }
  return '';
}
