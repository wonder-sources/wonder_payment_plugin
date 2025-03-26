class PaymentResult {
  final PaymentResultStatus status;
  final String? code;
  final String? message;

  PaymentResult({
    required this.status,
    this.code,
    this.message,
  });

  factory PaymentResult.fromJson(Map<String, dynamic> json) {
    return PaymentResult(
      status: PaymentResultStatus.from(json['status']),
      code: json['code'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status.rawValue,
      'code': code,
      'message': message,
    };
  }
}

enum PaymentResultStatus {
  completed("completed"),
  canceled("canceled"),
  failed("failed"),
  pending("pending");

  final String rawValue;
  const PaymentResultStatus(this.rawValue);

  factory PaymentResultStatus.from(String rawValue) {
    return PaymentResultStatus.values.firstWhere(
      (e) => e.rawValue == rawValue,
      orElse: () => PaymentResultStatus.pending,
    );
  }
}
