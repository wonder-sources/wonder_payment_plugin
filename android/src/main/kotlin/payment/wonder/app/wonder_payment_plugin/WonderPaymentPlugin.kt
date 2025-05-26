package payment.wonder.app.wonder_payment_plugin

import android.app.Activity
import android.content.Intent
import android.util.Log
import com.wonder.payment.sdk.PaymentController
import com.wonder.payment.sdk.WonderPayment
import com.wonder.payment.sdk.model.PaymentResult
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry

/** WonderPaymentPlugin */
class WonderPaymentPlugin : FlutterPlugin, MethodCallHandler, ActivityAware,
    PluginRegistry.ActivityResultListener {
    private val TAG = "WonderPaymentPlugin"
    private lateinit var channel: MethodChannel
    private lateinit var activity: Activity
    private lateinit var activityBinding: ActivityPluginBinding
    private var payController: PaymentController? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "wonder_payment_plugin")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        Log.d(TAG, "method:${call.method},argument:${call.arguments}")
        if (call.method == "init") {
            try {
                val paymentConfigMap: Map<String, Any?> = call.argument("paymentConfig") ?: mapOf()
                val paymentConfig = DataConvert.toPaymentConfig(paymentConfigMap)

                val uiConfigMap: Map<String, Any?> = call.argument("uiConfig") ?: mapOf()
                val uiConfig = DataConvert.toUIConfig(uiConfigMap)

                WonderPayment.initConfig(paymentConfig, uiConfig)
                result.success(true)
            } catch (e: Exception) {
                Log.e(TAG, e.toString())
                result.success(false)
            }
        } else if (call.method == "getPaymentConfig") {
            val paymentMap = DataConvert.toMap(WonderPayment.paymentConfig)
            result.success(paymentMap)
        } else if (call.method == "getUIConfig") {
            val uiMap = DataConvert.toMap(WonderPayment.uiConfig)
            result.success(uiMap)
        } else if (call.method == "setConfig") {
            try {
                val paymentConfigMap: Map<String, Any?> = call.argument("paymentConfig") ?: mapOf()
                val paymentConfig = DataConvert.toPaymentConfig(paymentConfigMap)

                val uiConfigMap: Map<String, Any?> = call.argument("uiConfig") ?: mapOf()
                val uiConfig = DataConvert.toUIConfig(uiConfigMap)

                WonderPayment.initConfig(paymentConfig, uiConfig)
                result.success(true)
            } catch (e: Exception) {
                Log.e(TAG, e.toString())
                result.success(false)
            }
        } else if (call.method == "present") {
            val paymentIntent = DataConvert.toPaymentIntent(call.arguments as Map<String, Any?>)
            WonderPayment.present(
                activity,
                paymentIntent,
            ) {
                if (it is PaymentResult.Completed) {
                    result.success(mapOf("status" to "completed"))
                } else if (it is PaymentResult.Failed) {
                    result.success(
                        mapOf(
                            "status" to "failed",
                            "code" to it.error.errorCode,
                            "message" to it.error.errorMsg
                        )
                    )
                } else {
                    result.success(mapOf("status" to "canceled"))
                }
            }
        } else if (call.method == "select") {
            WonderPayment.select(activity) {
                if (it != null) {
                    result.success(DataConvert.toMap(it))
                } else {
                    result.success(null)
                }
            }
        } else if (call.method == "pay") {
            if (WonderPayment.isPaying) return
            val paymentIntent = DataConvert.toPaymentIntent(call.arguments as Map<String, Any?>)
            payController = WonderPayment.pay(activity, paymentIntent) {
                if (it is PaymentResult.Completed) {
                    result.success(mapOf("status" to "completed"))
                } else if (it is PaymentResult.Failed) {
                    result.success(
                        mapOf(
                            "status" to "failed",
                            "code" to it.error.errorCode,
                            "message" to it.error.errorMsg
                        )
                    )
                } else {
                    result.success(mapOf("status" to "canceled"))
                }
            }
        } else if (call.method == "preview") {
            WonderPayment.preview(activity)
        } else if (call.method == "getDefaultPaymentMethod") {
            WonderPayment.getDefaultPaymentMethod {
                if (it != null) {
                    result.success(DataConvert.toMap(it))
                } else {
                    result.success(null)
                }
            }
        } else if (call.method == "getPaymentResult") {
            val sessionId = call.argument<String>("sessionId")
            if (sessionId.isNullOrEmpty()) {
                result.error("-1", "sessionId isNullOrEmpty", "sessionId isNullOrEmpty")
            } else {
                WonderPayment.getPaymentResult(activity, sessionId) {
                    if (it is PaymentResult.Completed) {
                        result.success(mapOf("status" to "completed"))
                    } else {
                        result.success(mapOf("status" to "pending"))
                    }
                }
            }
        } else if (call.method == "setDefaultPaymentMethod") {
            val paymentMethod = DataConvert.toPaymentMethod(call.arguments as Map<String, Any?>)
            if (paymentMethod != null) {
                WonderPayment.setDefaultPaymentMethod(paymentMethod) {
                    result.success(it)
                }
            } else {
                result.success(false)
            }
        } else if (call.method == "addCard") {
            val cardInputModel = DataConvert.toCardInputModel(call.arguments as Map<String, Any?>)
            WonderPayment.addCard(
                activity, cardInputModel
            ) { token, error ->
                if (error != null) {
                    result.error(error.errorCode, error.errorMsg, error.errorMsg)
                } else if (token != null) {
                    result.success(DataConvert.toMap(token))
                }
            }
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activityBinding = binding
        activity = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivity() {
        activityBinding.removeActivityResultListener(this)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        payController?.onActivityResult(requestCode, resultCode, data)
        payController = null
        return false
    }
}
