import 'payment_mode.dart';

/// 过滤选项类
class FilterOptions {
  /// 支持的支付模式列表
  final List<PaymentMode> supportedPaymentModes;

  FilterOptions({
    this.supportedPaymentModes = const [],
  });

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'supportedPaymentModes': supportedPaymentModes.map((mode) => mode.rawValue).toList(),
    };
  }

  /// 从JSON创建实例
  factory FilterOptions.fromJson(Map<String, dynamic> json) {
    final paymentModes = (json['supportedPaymentModes'] as List<dynamic>?)
        ?.map((mode) => PaymentModeExtension.fromString(mode as String))
        .where((mode) => mode != null)
        .cast<PaymentMode>()
        .toList() ?? [];
    
    return FilterOptions(
      supportedPaymentModes: paymentModes,
    );
  }
}