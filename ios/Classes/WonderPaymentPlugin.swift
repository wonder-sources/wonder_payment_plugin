import Flutter
import UIKit
import WonderPaymentSDK

public class WonderPaymentPlugin: NSObject, FlutterPlugin {
    
    var flutterMethodChannel: FlutterMethodChannel?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "wonder_payment_plugin", binaryMessenger: registrar.messenger())
        let instance = WonderPaymentPlugin()
        instance.flutterMethodChannel = channel
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
            WonderPayment.initSDK(paymentConfig: paymentConfig, uiConfig: uiConfig) {
                [weak self] level, message in
                self?.flutterMethodChannel?.invokeMethod("log", arguments: [
                    "level": level.rawValue,
                    "message": message
                ])
            }
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
            guard let json = call.arguments as? NSDictionary else {
                result(argumentsError)
                return
            }
            let filterOptionsJson = json["filterOptions"] as? NSDictionary
            let filterOptions = FilterOptions.from(json: filterOptionsJson)
            WonderPayment.select(filterOptions: filterOptions) {
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
        case "addCard":
            guard let args = call.arguments as? NSDictionary else {
                result(argumentsError)
                return
            }
            WonderPayment.addCard(args) { card, error in
                if let card {
                    result(card)
                } else if let error {
                    let code = error["code"] as? String ?? ""
                    let message = error["message"] as? String ?? ""
                    result(FlutterError(code: code, message: message, details: nil))
                }
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
