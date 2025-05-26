import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:wonder_payment_plugin/wonder_payment_plugin.dart';

import 'wonder_payment_plugin_method_channel.dart';

abstract class WonderPaymentPluginPlatform extends PlatformInterface {
  /// Constructs a WonderPaymentPluginPlatform.
  WonderPaymentPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static WonderPaymentPluginPlatform _instance =
      MethodChannelWonderPaymentPlugin();

  /// The default instance of [WonderPaymentPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelWonderPaymentPlugin].
  static WonderPaymentPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [WonderPaymentPluginPlatform] when
  /// they register themselves.
  static set instance(WonderPaymentPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> init({PaymentConfig? paymentConfig, UIConfig? uiConfig}) {
    throw UnimplementedError('init() has not been implemented.');
  }

  Future<PaymentConfig> getPaymentConfig() {
    throw UnimplementedError('getPaymentConfig() has not been implemented.');
  }

  Future<UIConfig> getUIConfig() {
    throw UnimplementedError('getUIConfig() has not been implemented.');
  }

  Future<bool> setConfig({PaymentConfig? paymentConfig, UIConfig? uiConfig}) {
    throw UnimplementedError('setConfig() has not been implemented.');
  }

  Future<PaymentResult?> present(PaymentIntent intent) {
    throw UnimplementedError('present() has not been implemented.');
  }

  Future<PaymentMethod?> select() {
    throw UnimplementedError('select() has not been implemented.');
  }

  Future<PaymentResult?> pay(PaymentIntent intent) {
    throw UnimplementedError('pay() has not been implemented.');
  }

  Future preview() {
    throw UnimplementedError('preview() has not been implemented.');
  }

  Future<PaymentMethod?> getDefaultPaymentMethod() {
    throw UnimplementedError(
        'getDefaultPaymentMethod() has not been implemented.');
  }

  Future<bool> setDefaultPaymentMethod(PaymentMethod paymentMethod) {
    throw UnimplementedError(
        'setDefaultPaymentMethod() has not been implemented.');
  }

  Future<PaymentResult?> getPaymentResult(String sessionId) {
    throw UnimplementedError('getPaymentResult() has not been implemented.');
  }

  Future<Map> addCard(Map cardArgs) {
    throw UnimplementedError('addCard() has not been implemented.');
  }
}
