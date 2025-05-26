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
  final sessionId = "YOUR_SESSION_ID";

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
        appId: "YOUR_APP_ID",
        fromScheme: "YOUR_APP_SCHEME",
        wechat: WechatConfig(
          appId: "WECHAT_APP_ID",
          universalLink: "YOUR_APP_UNIVERSAL_LINK",
        ),
        applePay: ApplePayConfig(
          merchantIdentifier: 'YOUR_MERCHANT_IDENTIFIER',
          merchantName: 'YOUR_MERCHANT_NAME',
          countryCode: 'HK',
        ),
        googlePay: GooglePayConfig(
          merchantName: 'YOUR_MERCHANT_NAME',
          merchantId: 'YOUR_MERCHANT_IDENTIFIER',
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
