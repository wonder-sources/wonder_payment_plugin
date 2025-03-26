enum PaymentEnvironment {
  staging("staging"),
  alpha("alpha"),
  production("production");

  final String rawValue;
  const PaymentEnvironment(this.rawValue);

  factory PaymentEnvironment.from(String rawValue) {
    return PaymentEnvironment.values.firstWhere(
      (e) => e.rawValue == rawValue,
      orElse: () => PaymentEnvironment.production,
    );
  }
}
