import Flutter
import UIKit
import WonderPaymentSDK

public class WonderPaymentPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "wonder_payment_plugin", binaryMessenger: registrar.messenger())
        let instance = WonderPaymentPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        FlutterPatch.patch()
    }
    
    var argumentsError: FlutterError {
        return FlutterError(code: "-1", message: "Arguments Error", details: nil)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "init":
            guard let json = call.arguments as? NSDictionary else {
                result(argumentsError)
                return
            }
            let paymentConfigJson = json["paymentConfig"] as? NSDictionary
            let uiConfigJson = json["uiConfig"] as? NSDictionary
            let paymentConfig = PaymentConfig.from(json: paymentConfigJson)
            let uiConfig = UIConfig.from(json: uiConfigJson)
            WonderPayment.initSDK(paymentConfig: paymentConfig, uiConfig: uiConfig)
            result(true)
        case "getPaymentConfig":
            result(WonderPayment.paymentConfig.toJson())
        case "getUIConfig":
            result(WonderPayment.uiConfig.toJson())
        case "setConfig":
            guard let json = call.arguments as? NSDictionary else {
                result(argumentsError)
                return
            }
            if let paymentConfigJson = json["paymentConfig"] as? NSDictionary {
                WonderPayment.paymentConfig = PaymentConfig.from(json: paymentConfigJson)
            }
            if let uiConfigJson = json["uiConfig"] as? NSDictionary {
                WonderPayment.uiConfig = UIConfig.from(json: uiConfigJson)
            }
            result(true)
        case "present":
            guard let json = call.arguments as? NSDictionary else {
                result(argumentsError)
                return
            }
            let intent = PaymentIntent.from(json: json)
            WonderPayment.present(intent: intent) {
                paymentResult in
                result(paymentResult.toJson())
            }
        case "select":
            guard let type = call.arguments as? String else {
                result(argumentsError)
                return
            }
            guard let transactionType = TransactionType(rawValue: type) else {
                result(argumentsError)
                return
            }
            WonderPayment.select(transactionType: transactionType) {
                paymentMethod in
                result(paymentMethod.toJson())
            }
        case "pay":
            guard let json = call.arguments as? NSDictionary else {
                result(argumentsError)
                return
            }
            let intent = PaymentIntent.from(json: json)
            WonderPayment.pay(intent: intent) {
                paymentResult in
                result(paymentResult.toJson())
            }
        case "preview":
            WonderPayment.preview()
            result(nil)
        case "getDefaultPaymentMethod":
            WonderPayment.getDefaultPaymentMethod {
                paymentMethod in
                result(paymentMethod?.toJson())
            }
        case "setDefaultPaymentMethod":
            guard let json = call.arguments as? NSDictionary else {
                result(argumentsError)
                return
            }
            let paymentMethod = PaymentMethod.from(json: json)
            WonderPayment.setDefaultPaymentMethod(paymentMethod) {
                succeed in
                result(succeed)
            }
        case "getPaymentResult":
            guard let json = call.arguments as? NSDictionary else {
                result(argumentsError)
                return
            }
            guard let sessionId = json["sessionId"] as? String else {
                result(argumentsError)
                return
            }
            WonderPayment.getPaymentResult(sessionId: sessionId) {
                paymentResult in
                result(paymentResult.toJson())
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
