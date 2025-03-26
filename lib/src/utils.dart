import 'dart:ui';

String get defaultLocale {
  String locale = "zh-HK";
  final localeStr = PlatformDispatcher.instance.locale.toString();
  if (localeStr.startsWith("zh_")) {
    // iOS: zh_Hans_CN, android: zh_CN 简体
    // iOS: zh_Hant_CN, android: zh_TW 繁体
    if (localeStr.startsWith("zh_Hans") || localeStr == "zh_CN") {
      locale = "zh-CN";
    } else {
      locale = "zh-HK";
    }
  } else {
    locale = "en-US";
  }
  return locale;
}

Color? parseColor(dynamic hex) {
  if (hex is String) {
    String hexColor = hex.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse(hexColor, radix: 16));
  }
  return null;
}
