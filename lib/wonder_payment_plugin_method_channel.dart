import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:wonder_payment_plugin/wonder_payment_plugin.dart';

import 'wonder_payment_plugin_platform_interface.dart';
import 'src/log_handler.dart';

/// An implementation of [WonderPaymentPluginPlatform] that uses method channels.
class MethodChannelWonderPaymentPlugin extends WonderPaymentPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('wonder_payment_plugin');

  @override
  Future<bool> init({
    PaymentConfig? paymentConfig,
    UIConfig? uiConfig,
    LogHandler? logHandler,
  }) async {
    methodChannel.setMethodCallHandler((call) async {
      if (call.method == 'log') {
        int level = call.arguments['level'] as int;
        String message = call.arguments['message'] as String;
        logHandler?.log(LogLevel.fromValue(level), message);
      }
    });
    return await methodChannel.invokeMethod(
      'init',
      {
        'paymentConfig': paymentConfig?.toJson(),
        'uiConfig': uiConfig?.toJson(),
      },
    );
  }

  @override
  Future<PaymentConfig> getPaymentConfig() async {
    final resultJson = await methodChannel.invokeMethod('getPaymentConfig');
    if (resultJson is Map) {
      return PaymentConfig.fromJson(resultJson.cast<String, dynamic>());
    } else {
      return PaymentConfig();
    }
  }

  @override
  Future<UIConfig> getUIConfig() async {
    final resultJson = await methodChannel.invokeMethod('getUIConfig');
    if (resultJson is Map) {
      return UIConfig.fromJson(resultJson.cast<String, dynamic>());
    } else {
      return UIConfig();
    }
  }

  @override
  Future<bool> setConfig(
      {PaymentConfig? paymentConfig, UIConfig? uiConfig}) async {
    return await methodChannel.invokeMethod(
      'setConfig',
      {
        'paymentConfig': paymentConfig?.toJson(),
        'uiConfig': uiConfig?.toJson(),
      },
    );
  }

  @override
  Future<PaymentResult?> present(PaymentIntent intent) async {
    final resultJson = await methodChannel.invokeMethod(
      'present',
      intent.toJson(),
    );
    if (resultJson is Map) {
      return PaymentResult.fromJson(resultJson.cast<String, dynamic>());
    } else {
      return null;
    }
  }

  @override
  Future<PaymentMethod?> select({FilterOptions? filterOptions}) async {
    final resultJson = await methodChannel.invokeMethod('select', {
      'filterOptions': filterOptions?.toJson(),
    });
    if (resultJson is Map) {
      return PaymentMethod.fromJson(resultJson.cast<String, dynamic>());
    } else {
      return null;
    }
  }

  @override
  Future<PaymentResult?> pay(PaymentIntent intent) async {
    final resultJson = await methodChannel.invokeMethod(
      'pay',
      intent.toJson(),
    );
    if (resultJson is Map) {
      return PaymentResult.fromJson(resultJson.cast<String, dynamic>());
    } else {
      return null;
    }
  }

  @override
  Future preview() async {
    return methodChannel.invokeMethod('preview');
  }

  @override
  Future<PaymentMethod?> getDefaultPaymentMethod() async {
    final resultJson = await methodChannel.invokeMethod(
      'getDefaultPaymentMethod',
    );
    if (resultJson is Map) {
      return PaymentMethod.fromJson(resultJson.cast<String, dynamic>());
    } else {
      return null;
    }
  }

  @override
  Future<bool> setDefaultPaymentMethod(PaymentMethod paymentMethod) async {
    return await methodChannel.invokeMethod(
      'setDefaultPaymentMethod',
      paymentMethod.toJson(),
    );
  }

  @override
  Future<PaymentResult?> getPaymentResult(String sessionId) async {
    final resultJson = await methodChannel.invokeMethod(
      'getPaymentResult',
      {
        'sessionId': sessionId,
      },
    );
    if (resultJson is Map) {
      return PaymentResult.fromJson(resultJson.cast<String, dynamic>());
    } else {
      return null;
    }
  }

  @override
  Future<Map> addCard(Map cardArgs) async {
    return await methodChannel.invokeMethod(
      'addCard',
      cardArgs,
    );
  }
}
