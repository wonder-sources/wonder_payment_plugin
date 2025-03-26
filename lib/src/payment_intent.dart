import 'extra.dart';
import 'line_item.dart';
import 'transaction_type.dart';
import 'payment_method.dart';

class PaymentIntent {
  double amount;
  String currency;
  String orderNumber;
  PaymentMethod? paymentMethod;
  TransactionType transactionType = TransactionType.sale;
  List<LineItem>? lineItems;
  Extra? extra;

  PaymentIntent({
    required this.amount,
    required this.currency,
    required this.orderNumber,
    this.paymentMethod,
    this.transactionType = TransactionType.sale,
    this.lineItems,
    this.extra,
  });

  PaymentIntent copy() {
    PaymentMethod? method;
    if (paymentMethod != null) {
      method = PaymentMethod(
        type: paymentMethod!.type,
        arguments: paymentMethod!.arguments,
      );
    }
    return PaymentIntent(
      amount: amount,
      currency: currency,
      orderNumber: orderNumber,
      paymentMethod: method,
      transactionType: transactionType,
      lineItems: lineItems?.map((e) => e).toList(),
      extra: extra?.copy(),
    );
  }

  factory PaymentIntent.fromJson(Map<String, dynamic> json) {
    List<LineItem>? lineItems;
    if (json['lineItems'] != null) {
      List list = json['lineItems'] as List;
      lineItems = list.map((e) => LineItem.fromJson(e)).toList();
    }
    return PaymentIntent(
      amount: json['amount'],
      currency: json['currency'],
      orderNumber: json['orderNumber'],
      paymentMethod: json['paymentMethod'] != null
          ? PaymentMethod.fromJson(json['paymentMethod'])
          : null,
      transactionType: TransactionType.from(json['transactionType']),
      lineItems: lineItems,
      extra: Extra.fromJson(json['extra']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'currency': currency,
      'orderNumber': orderNumber,
      'paymentMethod': paymentMethod?.toJson(),
      'transactionType': transactionType.rawValue,
      'lineItems': lineItems?.map((e) => e.toJson()).toList(),
      'extra': extra?.toJson(),
    };
  }
}
