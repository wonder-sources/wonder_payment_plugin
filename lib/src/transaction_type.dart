enum TransactionType {
  sale("sale"),
  preAuth("pre_auth");

  final String rawValue;
  const TransactionType(this.rawValue);

  factory TransactionType.from(String rawValue) {
    return TransactionType.values.firstWhere(
      (e) => e.rawValue == rawValue,
      orElse: () => TransactionType.sale,
    );
  }
}
