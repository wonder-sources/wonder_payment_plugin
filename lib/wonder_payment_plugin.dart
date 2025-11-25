import 'src/payment_method.dart';
import 'src/filter_options.dart';
import 'src/log_handler.dart';
import 'src/payment_config.dart';
import 'src/payment_intent.dart';
import 'src/payment_result.dart';
import 'src/ui_config.dart';
import 'wonder_payment_plugin_platform_interface.dart';

export 'src/line_item.dart';
export 'src/payment_intent.dart';
export 'src/payment_result.dart';
export 'src/payment_method.dart';
export 'src/payment_environment.dart';
export 'src/payment_config.dart';
export 'src/ui_config.dart';
export 'src/extra.dart';
export 'src/filter_options.dart';
export 'src/payment_mode.dart';
export 'src/log_handler.dart';

class WonderPaymentPlugin {
  static Future<bool> init({
    PaymentConfig? paymentConfig,
    UIConfig? uiConfig,
    LogHandler? logHandler,
  }) {
    return WonderPaymentPluginPlatform.instance.init(
      paymentConfig: paymentConfig,
      uiConfig: uiConfig,
      logHandler: logHandler,
    );
  }

  static Future<PaymentConfig> getPaymentConfig() {
    return WonderPaymentPluginPlatform.instance.getPaymentConfig();
  }

  static Future<UIConfig> getUIConfig() {
    return WonderPaymentPluginPlatform.instance.getUIConfig();
  }

  static Future<bool> setConfig(Function(PaymentConfig, UIConfig) block) async {
    final paymentConfig =
        await WonderPaymentPluginPlatform.instance.getPaymentConfig();
    final uiConfig = await WonderPaymentPluginPlatform.instance.getUIConfig();
    block(paymentConfig, uiConfig);
    return WonderPaymentPluginPlatform.instance
        .setConfig(paymentConfig: paymentConfig, uiConfig: uiConfig);
  }

  static Future<PaymentResult?> present(PaymentIntent intent) async {
    return WonderPaymentPluginPlatform.instance.present(intent);
  }

  static Future<PaymentMethod?> select({FilterOptions? filterOptions}) async {
    return WonderPaymentPluginPlatform.instance
        .select(filterOptions: filterOptions);
  }

  static Future<PaymentResult?> pay(PaymentIntent intent) async {
    return WonderPaymentPluginPlatform.instance.pay(intent);
  }

  static Future preview() {
    return WonderPaymentPluginPlatform.instance.preview();
  }

  static Future<PaymentMethod?> getDefaultPaymentMethod() async {
    return WonderPaymentPluginPlatform.instance.getDefaultPaymentMethod();
  }

  static Future<bool> setDefaultPaymentMethod(
    PaymentMethod paymentMethod,
  ) async {
    return WonderPaymentPluginPlatform.instance
        .setDefaultPaymentMethod(paymentMethod);
  }

  static Future<PaymentResult?> getPaymentResult(String sessionId) {
    return WonderPaymentPluginPlatform.instance.getPaymentResult(sessionId);
  }

  static Future<Map> addCard(Map cardArgs) {
    return WonderPaymentPluginPlatform.instance.addCard(cardArgs);
  }
}
