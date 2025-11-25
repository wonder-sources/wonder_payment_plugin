/// 支付模式枚举
enum PaymentMode {
  preAuth,
  sale,
  autoDebit,
}

/// 支付模式扩展方法
extension PaymentModeExtension on PaymentMode {
  String get rawValue {
    switch (this) {
      case PaymentMode.preAuth:
        return 'preAuth';
      case PaymentMode.sale:
        return 'sale';
      case PaymentMode.autoDebit:
        return 'autoDebit';
    }
  }

  static PaymentMode? fromString(String value) {
    switch (value) {
      case 'preAuth':
        return PaymentMode.preAuth;
      case 'sale':
        return PaymentMode.sale;
      case 'autoDebit':
        return PaymentMode.autoDebit;
      default:
        return null;
    }
  }
}
