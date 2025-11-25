import 'package:flutter/material.dart';
import 'dart:async';

import 'package:wonder_payment_plugin/wonder_payment_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final amount = 1.0;
  final currency = "HKD";

  // Environment variables
  static const sessionId =
      String.fromEnvironment('SESSION_ID', defaultValue: 'default_session_id');
  static const appId = String.fromEnvironment('APP_ID');
  static const customerId = String.fromEnvironment('CUSTOMER_ID');
  static const appScheme = String.fromEnvironment('APP_SCHEME');
  static const wechatAppId = String.fromEnvironment('WECHAT_APP_ID');
  static const universalLink = String.fromEnvironment('APP_UNIVERSAL_LINK');
  static const merchantName = String.fromEnvironment('MERCHANT_NAME');
  static const applePayMerchantId =
      String.fromEnvironment('APPLE_PAY_MERCHANT_IDENTIFIER');
  static const googlePayMerchantId =
      String.fromEnvironment('GOOGLE_PAY_MERCHANT_ID');

  late var paymentIntent = PaymentIntent(
    amount: amount,
    currency: currency,
    orderNumber: '',
    extra: Extra(
      sessionId: sessionId,
    ),
  );

  PaymentMethod? selectedPaymentMethod;

  @override
  void initState() {
    super.initState();
    initSDK();
  }

  Future initSDK() async {
    await WonderPaymentPlugin.init(
      paymentConfig: PaymentConfig(
        // [staging | alpha | production]
        environment: PaymentEnvironment.staging,
        appId: appId,
        customerId: customerId,
        fromScheme: appScheme,
        wechat: WechatConfig(
          appId: wechatAppId,
          universalLink: universalLink,
        ),
        applePay: ApplePayConfig(
          merchantIdentifier: applePayMerchantId,
          merchantName: merchantName,
          countryCode: 'HK',
        ),
        googlePay: GooglePayConfig(
          merchantName: merchantName,
          merchantId: googlePayMerchantId,
          countryCode: 'HK',
          currencyCode: 'HKD',
        ),
      ),
      uiConfig: UIConfig(
        displayStyle: DisplayStyle.confirm,
      ),
    );
  }

  Future createOrder() async {
    //create order with your backend
    String orderNumber = "";
    paymentIntent.orderNumber = orderNumber;
  }

  Future presentPay() async {
    if (paymentIntent.orderNumber.isEmpty) {
      print('Create order first');
      return;
    }
    var result = await WonderPaymentPlugin.present(paymentIntent);
    print('PaymentResult: ${result?.status}');
  }

  Future selectMethod() async {
    var result = await WonderPaymentPlugin.select();
    paymentIntent.paymentMethod = result;
    if (result != null) {
      setState(() {
        selectedPaymentMethod = result;
      });
    }
  }

  Future pay() async {
    if (paymentIntent.orderNumber.isEmpty) {
      print('Create order first');
      return;
    }
    if (paymentIntent.paymentMethod == null) {
      print('Select payment method first');
      return;
    }
    var result = await WonderPaymentPlugin.pay(paymentIntent);
    print('PaymentResult: ${result?.status}');
  }

  Future preview() async {
    await WonderPaymentPlugin.preview();
  }

  Future setDefaultPaymentMethod() async {
    final config = await WonderPaymentPlugin.getPaymentConfig();
    if (config.customerId.isEmpty) {
      print('Please set customerId first');
      return;
    }
    if (selectedPaymentMethod == null) {
      print('Select payment method first');
      return;
    }
    final succeed = await WonderPaymentPlugin.setDefaultPaymentMethod(
        selectedPaymentMethod!);
    print('Set default payment method succeed: $succeed');
  }

  Future getDefaultPaymentMethod() async {
    final config = await WonderPaymentPlugin.getPaymentConfig();
    if (config.customerId.isEmpty) {
      print('Please set customerId first');
      return;
    }
    final paymentMethod = await WonderPaymentPlugin.getDefaultPaymentMethod();
    print('Default payment method: $paymentMethod');
  }

  Future checkResult() async {
    final result = await WonderPaymentPlugin.getPaymentResult(sessionId);
    print('Check payment result: ${result?.status}');
  }

  String get payButtonTitle {
    if (selectedPaymentMethod != null) {
      return 'Pay(${selectedPaymentMethod!.type.rawValue})';
    } else {
      return 'Pay';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: [
            ElevatedButton(
              onPressed: createOrder,
              child: Text('Create Order'),
            ),
            SizedBox(height: 16),
            FilledButton(
              onPressed: presentPay,
              child: Text('Present'),
            ),
            SizedBox(
              height: 32,
              child: Center(child: Text('Or')),
            ),
            FilledButton(
              onPressed: selectMethod,
              child: Text('Select Payment Method'),
            ),
            FilledButton(
              onPressed: pay,
              child: Text(payButtonTitle),
            ),
            SizedBox(
              height: 32,
              child: Center(child: Text('Manage Payment Methods')),
            ),
            ElevatedButton(
              onPressed: preview,
              child: Text('Preview'),
            ),
            ElevatedButton(
              onPressed: setDefaultPaymentMethod,
              child: Text('Set Default Payment Method'),
            ),
            ElevatedButton(
              onPressed: getDefaultPaymentMethod,
              child: Text('Get Default Payment Method'),
            ),
            SizedBox(
              height: 32,
              child: Center(child: Text('Query Payment Result')),
            ),
            ElevatedButton(
              onPressed: checkResult,
              child: Text('Check Payment Result'),
            ),
          ],
        ),
      ),
    );
  }
}
