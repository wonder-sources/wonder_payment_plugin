enum PaymentMethodType {
  creditCard("credit_card"),
  applePay("apple_pay"),
  googlePay("google_pay"),
  unionPay("unionpay_wallet"),
  wechat("wechat"),
  alipayHK("alipay_hk"),
  alipay("alipay"),
  fps("fps"),
  octopus("octopus"),
  payme("payme");

  final String rawValue;

  const PaymentMethodType(this.rawValue);

  factory PaymentMethodType.from(String rawValue) {
    return PaymentMethodType.values.firstWhere(
      (e) => e.rawValue == rawValue,
      orElse: () => PaymentMethodType.creditCard,
    );
  }
}

class PaymentMethod {
  PaymentMethodType type;
  Map<String, dynamic>? arguments;

  PaymentMethod({required this.type, this.arguments});

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? args;
    if (json['arguments'] is Map) {
      Map map = json['arguments'];
      args = map.cast<String, dynamic>();
    }
    return PaymentMethod(
      type: PaymentMethodType.from(json['type']),
      arguments: args,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.rawValue,
      'arguments': arguments,
    };
  }
}
