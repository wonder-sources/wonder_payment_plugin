package payment.wonder.app.wonder_payment_plugin

import android.graphics.Color
import com.wonder.payment.sdk.model.CardInputModel
import com.wonder.payment.sdk.model.CreditCard
import com.wonder.payment.sdk.model.DisplayStyle
import com.wonder.payment.sdk.model.Extra
import com.wonder.payment.sdk.model.GoogleConfig
import com.wonder.payment.sdk.model.LineItem
import com.wonder.payment.sdk.model.PayType
import com.wonder.payment.sdk.model.PaymentConfig
import com.wonder.payment.sdk.model.PaymentEnv
import com.wonder.payment.sdk.model.PaymentIntent
import com.wonder.payment.sdk.model.PaymentMethod
import com.wonder.payment.sdk.model.PaymentTokenModel
import com.wonder.payment.sdk.model.UIConfig
import java.util.Locale

object DataConvert {

    fun toMap(paymentConfig: PaymentConfig): Map<String, Any?> {
        return mapOf(
            "appId" to paymentConfig.appId,
            "customerId" to paymentConfig.customerId,
            "environment" to paymentEnvToString(paymentConfig.environment),
            "locale" to paymentConfig.locale?.toLanguageTag(),
            "wechat" to paymentConfig.wechatAppId?.let {
                mapOf(
                    "appId" to paymentConfig.wechatAppId,
                    "universalLink" to "",
                )
            },
            "googlePay" to paymentConfig.googleConfig?.let {
                mapOf(
                    "merchantName" to it.merchantName,
                    "merchantId" to it.merchantId,
                    "countryCode" to it.countryCode,
                    "currencyCode" to it.currencyCode
                )
            },
            "originalBusinessId" to paymentConfig.originalBusinessId,
            "fromScheme" to paymentConfig.fromScheme,
        )
    }

    fun toMap(uiConfig: UIConfig): Map<String, Any?> {
        return mapOf(
            "background" to intToHexColor(uiConfig.background),
            "secondaryBackground" to intToHexColor(uiConfig.secondaryBackground),
            "primaryTextColor" to intToHexColor(uiConfig.primaryTextColor),
            "secondaryTextColor" to intToHexColor(uiConfig.secondaryTextColor),
            "primaryButtonColor" to intToHexColor(uiConfig.primaryButtonColor),
            "primaryButtonBackground" to intToHexColor(uiConfig.primaryButtonBackground),
            "secondaryButtonColor" to intToHexColor(uiConfig.secondaryButtonColor),
            "secondaryButtonBackground" to intToHexColor(uiConfig.secondaryButtonBackground),
            "textFieldBackground" to intToHexColor(uiConfig.textFieldBackground),
            "linkColor" to intToHexColor(uiConfig.linkColor),
            "successColor" to intToHexColor(uiConfig.successColor),
            "errorColor" to intToHexColor(uiConfig.errorColor),
            "borderColor" to intToHexColor(uiConfig.borderColor),
            "dividerColor" to intToHexColor(uiConfig.dividerColor),
            "borderRadius" to uiConfig.borderRadius,
            "showResult" to uiConfig.showResult,
            "paymentRetriesEnabled" to uiConfig.paymentRetriesEnabled,
            "displayStyle" to displayStyleToString(uiConfig.displayStyle),
        )
    }

    fun toMap(paymentMethod: PaymentMethod): Map<String, Any?> {
        val data = paymentMethod.data?.let {
            if (it is PaymentTokenModel) {
                mapOf(
                    "brand" to it.creditCard?.brand,
                    "exp_year" to it.creditCard?.expYear,
                    "exp_month" to it.creditCard?.expMonth,
                    "number" to it.creditCard?.number,
                    "holder_name" to it.creditCard?.holderName,
                    "token" to it.token,
                    "default" to it.isDefault,
                    "state" to it.state,
                    "token_type" to it.tokenType
                )
            } else if (it is Map<*, *>) {
                it
            } else {
                null
            }
        }
        return mapOf(
            "type" to paymentMethod.type.type,
            "arguments" to data,
        )
    }


    fun toMap(tokenModel: PaymentTokenModel): Map<String, Any?> {
        return mapOf(
            "brand" to tokenModel.creditCard?.brand,
            "exp_year" to tokenModel.creditCard?.expYear,
            "exp_month" to tokenModel.creditCard?.expMonth,
            "number" to tokenModel.creditCard?.number,
            "holder_name" to tokenModel.creditCard?.holderName,
            "token" to tokenModel.token,
            "default" to tokenModel.isDefault,
            "state" to tokenModel.state,
            "token_type" to tokenModel.tokenType
        )
    }


    fun toPaymentConfig(map: Map<String, Any?>): PaymentConfig {
        val wechat = map["wechat"] as Map<String, String?>?
        val googlePay = map["googlePay"] as Map<String, String?>?
        val locale = map["locale"] as String?

        return PaymentConfig(
            appId = map["appId"] as String,
            customerId = map["customerId"] as String,
            environment = paymentEnvFromString(map["environment"] as String),
            locale = locale?.let { Locale.forLanguageTag(it) },
            wechatAppId = wechat?.get("appId"),
            googleConfig = googlePay?.let {
                GoogleConfig(
                    countryCode = googlePay["countryCode"]!!,
                    currencyCode = googlePay["currencyCode"]!!,
                    merchantId = googlePay["merchantId"]!!,
                    merchantName = googlePay["merchantName"]!!,
                )
            },
            fromScheme = map["fromScheme"] as String?,
            originalBusinessId = map["originalBusinessId"] as String?
        )
    }


    fun toUIConfig(map: Map<String, Any?>): UIConfig {
        val uiConfig = UIConfig()
        parseColor(map["background"])?.let { uiConfig.background = it }
        parseColor(map["secondaryBackground"])?.let { uiConfig.secondaryBackground = it }
        parseColor(map["primaryTextColor"])?.let { uiConfig.primaryTextColor = it }
        parseColor(map["secondaryTextColor"])?.let { uiConfig.secondaryTextColor = it }
        parseColor(map["primaryButtonColor"])?.let { uiConfig.primaryButtonColor = it }
        parseColor(map["primaryButtonBackground"])?.let { uiConfig.primaryButtonBackground = it }
        parseColor(map["secondaryButtonColor"])?.let { uiConfig.secondaryButtonColor = it }
        parseColor(map["secondaryButtonBackground"])?.let {
            uiConfig.secondaryButtonBackground = it
        }
        parseColor(map["textFieldBackground"])?.let { uiConfig.textFieldBackground = it }
        parseColor(map["linkColor"])?.let { uiConfig.linkColor = it }
        parseColor(map["successColor"])?.let { uiConfig.successColor = it }
        parseColor(map["errorColor"])?.let { uiConfig.errorColor = it }
        parseColor(map["borderColor"])?.let { uiConfig.borderColor = it }
        parseColor(map["dividerColor"])?.let { uiConfig.dividerColor = it }
        map["borderRadius"]?.let { uiConfig.borderRadius = (it as Double).toFloat() }
        map["showResult"]?.let { uiConfig.showResult = it as Boolean }
        map["paymentRetriesEnabled"]?.let { uiConfig.paymentRetriesEnabled = it as Boolean }
        map["displayStyle"]?.let { uiConfig.displayStyle = displayStyleFromString(it as String) }

        return uiConfig
    }

    fun toPaymentIntent(map: Map<String, Any?>): PaymentIntent {
        val paymentMethod = map["paymentMethod"] as Map<String, Any?>?
        val lineItems = map["lineItems"] as List<Map<String, Any?>>?
        val extra = map["extra"] as Map<String, Any?>?

        var lineItemList: List<LineItem>? = null
        if (lineItems != null) {
            lineItemList = lineItems.map {
                LineItem(
                    it["purchasable_type"] as String?,
                    it["purchase_id"] as Int?,
                    it["quantity"] as Int?,
                    it["price"] as Double?,
                    it["total"] as Double?,
                )
            }
        }

        var extraModel: Extra? = null
        if (extra != null) {
            extraModel = Extra(extra["sessionId"] as String?)
        }

        return PaymentIntent(
            amount = map["amount"] as Double,
            currency = map["currency"] as String,
            orderNumber = map["orderNumber"] as String,
            preAuthModeForSales = map["preAuthModeForSales"] as Boolean,
            paymentMethod = paymentMethod?.let {
                toPaymentMethod(it)
            },
            lineItems = lineItemList,
            extra = extraModel
        )
    }

    fun toPaymentMethod(map: Map<String, Any?>): PaymentMethod? {
        val payType = PayType.fromString(map["type"] as String?) ?: return null
        val arguments = map["arguments"] as Map<String, Any?>?

        val data = arguments?.let {
            if (payType == PayType.CREDIT_CARD) {
                PaymentTokenModel(
                    arguments["token_type"] as String,
                    arguments["token"] as String,
                    arguments["state"] as String,
                    null,
                    "",
                    (arguments["default"] ?: false) as Boolean,
                    CreditCard(
                        arguments["number"] as String,
                        arguments["exp_month"] as String,
                        arguments["exp_year"] as String,
                        arguments["holder_name"] as String,
                        arguments["brand"] as String,
                    )
                )
            } else {
                it
            }
        }

        return PaymentMethod(payType, data)
    }

    fun toCardInputModel(map: Map<String, Any?>): CardInputModel {
        val billingAddress = map["billing_address"] as Map<String, Any?>

        val cardInput = CardInputModel(
            number = map["number"] as String,
            expMonth = map["exp_month"] as String,
            expYear = map["exp_year"] as String,
            cvv = map["cvv"] as String,
            holderName = map["holder_name"] as String,
            firstName = billingAddress["first_name"] as String,
            lastName = billingAddress["last_name"] as String,
            phoneNumber = billingAddress["phone_number"] as String,
        )
        return cardInput
    }

    private fun parseColor(value: Any?): Int? {
        if (value is String) {
            return Color.parseColor(value)
        } else if (value is Int) {
            return value
        }
        return null
    }

    private fun intToHexColor(color: Int): String {
        return String.format("#%08X", color)
    }

    private fun paymentEnvFromString(strValue: String): PaymentEnv {
        return when (strValue) {
            "staging" -> PaymentEnv.STAGING
            "alpha" -> PaymentEnv.ALPHA
            "production" -> PaymentEnv.PRODUCTION
            else -> PaymentEnv.PRODUCTION
        }
    }

    private fun paymentEnvToString(enumValue: PaymentEnv): String {
        return when (enumValue) {
            PaymentEnv.STAGING -> "staging"
            PaymentEnv.ALPHA -> "alpha"
            PaymentEnv.PRODUCTION -> "production"
            else -> "production"
        }
    }

    private fun displayStyleFromString(strValue: String): DisplayStyle {
        return when (strValue) {
            "oneClick" -> DisplayStyle.ONE_CLICK
            "confirm" -> DisplayStyle.CONFIRM
            else -> DisplayStyle.ONE_CLICK
        }
    }

    private fun displayStyleToString(enumValue: DisplayStyle): String {
        return when (enumValue) {
            DisplayStyle.ONE_CLICK -> "oneClick"
            DisplayStyle.CONFIRM -> "confirm"
            else -> "oneClick"
        }
    }

}