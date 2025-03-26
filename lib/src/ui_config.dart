import 'dart:ui';

import 'utils.dart';

class UIConfig {
  Color? background;
  Color? secondaryBackground;
  Color? primaryTextColor;
  Color? secondaryTextColor;
  Color? secondaryButtonColor;
  Color? secondaryButtonBackground;
  Color? primaryButtonColor;
  Color? primaryButtonBackground;
  Color? primaryButtonDisableBackground;
  Color? textFieldBackground;
  Color? linkColor;
  Color? errorColor;
  double? borderRadius;
  DisplayStyle? displayStyle;
  bool? showResult;
  bool? paymentRetriesEnabled;

  UIConfig({
    this.background,
    this.secondaryBackground,
    this.primaryTextColor,
    this.secondaryTextColor,
    this.secondaryButtonColor,
    this.secondaryButtonBackground,
    this.primaryButtonColor,
    this.primaryButtonBackground,
    this.primaryButtonDisableBackground,
    this.textFieldBackground,
    this.linkColor,
    this.errorColor,
    this.borderRadius,
    this.displayStyle,
    this.showResult,
    this.paymentRetriesEnabled,
  });

  factory UIConfig.fromJson(Map<String, dynamic> json) {
    final config = UIConfig();
    config.background = parseColor(json["background"]);
    config.secondaryBackground = parseColor(json["secondaryBackground"]);
    config.primaryTextColor = parseColor(json["primaryTextColor"]);
    config.secondaryTextColor = parseColor(json["secondaryTextColor"]);
    config.secondaryButtonColor = parseColor(json["secondaryButtonColor"]);
    config.secondaryButtonBackground =
        parseColor(json["secondaryButtonBackground"]);
    config.primaryButtonColor = parseColor(json["primaryButtonColor"]);
    config.primaryButtonBackground =
        parseColor(json["primaryButtonBackground"]);
    config.primaryButtonDisableBackground =
        parseColor(json["primaryButtonDisableBackground"]);
    config.textFieldBackground = parseColor(json["textFieldBackground"]);
    config.linkColor = parseColor(json["linkColor"]);
    config.errorColor = parseColor(json["errorColor"]);
    config.borderRadius = json["borderRadius"];
    config.displayStyle = DisplayStyle.from(json["displayStyle"]);
    config.showResult = json["showResult"];
    config.paymentRetriesEnabled = json["paymentRetriesEnabled"];
    return config;
  }

  Map<String, dynamic> toJson() {
    return {
      'background': background?.hex,
      'secondaryBackground': secondaryBackground?.hex,
      'primaryTextColor': primaryTextColor?.hex,
      'secondaryTextColor': secondaryTextColor?.hex,
      'secondaryButtonColor': secondaryButtonColor?.hex,
      'secondaryButtonBackground': secondaryButtonBackground?.hex,
      'primaryButtonColor': primaryButtonColor?.hex,
      'primaryButtonBackground': primaryButtonBackground?.hex,
      'primaryButtonDisableBackground': primaryButtonDisableBackground?.hex,
      'textFieldBackground': textFieldBackground?.hex,
      'linkColor': linkColor?.hex,
      'errorColor': errorColor?.hex,
      'borderRadius': borderRadius,
      'displayStyle': displayStyle?.rawValue,
      'showResult': showResult,
      'paymentRetriesEnabled': paymentRetriesEnabled,
    };
  }
}

enum DisplayStyle {
  oneClick("oneClick"),
  confirm("confirm");

  final String rawValue;
  const DisplayStyle(this.rawValue);

  factory DisplayStyle.from(String rawValue) {
    return DisplayStyle.values.firstWhere(
      (e) => e.rawValue == rawValue,
      orElse: () => DisplayStyle.oneClick,
    );
  }
}

extension HexColor on Color {
  String get hex {
    return '#${value.toRadixString(16)}';
  }
}
