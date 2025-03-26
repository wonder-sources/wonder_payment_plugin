import 'package:wonder_payment_plugin/src/payment_environment.dart';

import 'utils.dart';

class PaymentConfig {
  String appId;
  String customerId;
  String originalBusinessId;
  String fromScheme;
  PaymentEnvironment environment;
  String locale;
  WechatConfig? wechat;
  ApplePayConfig? applePay;
  GooglePayConfig? googlePay;

  PaymentConfig({
    this.appId = "",
    this.customerId = "",
    this.originalBusinessId = "",
    this.fromScheme = "",
    this.environment = PaymentEnvironment.production,
    String? locale,
    this.wechat,
    this.applePay,
    this.googlePay,
  }) : locale = locale ?? defaultLocale;

  Map<String, dynamic> toJson() {
    return {
      'appId': appId,
      'customerId': customerId,
      'originalBusinessId': originalBusinessId,
      'fromScheme': fromScheme,
      'environment': environment.rawValue,
      'locale': locale,
      'wechat': wechat?.toJson(),
      'applePay': applePay?.toJson(),
      'googlePay': googlePay?.toJson(),
    };
  }

  factory PaymentConfig.fromJson(Map<String, dynamic> json) {
    final wechatJson = json['wechat'];
    WechatConfig? wechat;
    if (wechatJson is Map) {
      wechat = WechatConfig.fromJson(wechatJson.cast<String, dynamic>());
    }

    final applePayJson = json['applePay'];
    ApplePayConfig? applePay;
    if (applePayJson is Map) {
      applePay = ApplePayConfig.fromJson(applePayJson.cast<String, dynamic>());
    }

    final googlePayJson = json['googlePay'];
    GooglePayConfig? googlePay;
    if (googlePayJson is Map) {
      googlePay =
          GooglePayConfig.fromJson(googlePayJson.cast<String, dynamic>());
    }

    return PaymentConfig(
      appId: json['appId'],
      customerId: json['customerId'],
      originalBusinessId: json['originalBusinessId'],
      fromScheme: json['fromScheme'] ?? "",
      environment: PaymentEnvironment.from(json['environment']),
      locale: json['locale'],
      wechat: wechat,
      applePay: applePay,
      googlePay: googlePay,
    );
  }
}

// 相关配置参考 https://developers.weixin.qq.com/doc/oplatform/Mobile_App/Access_Guide/iOS.html
class WechatConfig {
  String appId;
  String universalLink;

  WechatConfig({
    required this.appId,
    required this.universalLink,
  });

  factory WechatConfig.fromJson(Map<String, dynamic> json) {
    return WechatConfig(
      appId: json['appId'],
      universalLink: json['universalLink'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appId': appId,
      'universalLink': universalLink,
    };
  }
}

class ApplePayConfig {
  // Apple Developer 后台申请的商户ID
  String merchantIdentifier;

  // 商户名称
  String merchantName;

  // 两位国家码 CN, HK, US ...
  String countryCode;

  ApplePayConfig({
    required this.merchantIdentifier,
    required this.merchantName,
    required this.countryCode,
  });

  factory ApplePayConfig.fromJson(Map<String, dynamic> json) {
    return ApplePayConfig(
      merchantIdentifier: json['merchantIdentifier'],
      merchantName: json['merchantName'],
      countryCode: json['countryCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'merchantIdentifier': merchantIdentifier,
      'merchantName': merchantName,
      'countryCode': countryCode,
    };
  }
}

class GooglePayConfig {
  String merchantName;
  String merchantId;

  // 两位国家码 CN, HK, US ...
  String countryCode;
  //HKD
  String currencyCode;

  GooglePayConfig({
    required this.merchantName,
    required this.merchantId,
    required this.countryCode,
    required this.currencyCode,
  });

  factory GooglePayConfig.fromJson(Map<String, dynamic> json) {
    return GooglePayConfig(
      merchantName: json['merchantName'],
      merchantId: json['merchantId'],
      countryCode: json['countryCode'],
      currencyCode: json['currencyCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'merchantName': merchantName,
      'merchantId': merchantId,
      'countryCode': countryCode,
      'currencyCode': currencyCode,
    };
  }
}
