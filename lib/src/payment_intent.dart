import 'extra.dart';
import 'line_item.dart';
import 'payment_method.dart';

class PaymentIntent {
  double amount;
  String currency;
  String orderNumber;
  PaymentMethod? paymentMethod;
  List<LineItem>? lineItems;
  bool preAuthModeForSales;
  Extra? extra;

  PaymentIntent({
    required this.amount,
    required this.currency,
    required this.orderNumber,
    this.paymentMethod,
    this.lineItems,
    this.preAuthModeForSales = false,
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
      lineItems: lineItems?.map((e) => e).toList(),
      preAuthModeForSales: preAuthModeForSales,
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
      lineItems: lineItems,
      preAuthModeForSales: json['preAuthModeForSales'],
      extra: Extra.fromJson(json['extra']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'currency': currency,
      'orderNumber': orderNumber,
      'paymentMethod': paymentMethod?.toJson(),
      'lineItems': lineItems?.map((e) => e.toJson()).toList(),
      'preAuthModeForSales': preAuthModeForSales,
      'extra': extra?.toJson(),
    };
  }
}
