package payment.wonder.app.wonder_payment_plugin

import android.graphics.Color
import com.wonder.payment.sdk.model.CardModel
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
import com.wonder.payment.sdk.model.TransactionType
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
        )
    }

    fun toMap(uiConfig: UIConfig): Map<String, Any?> {
        return mapOf(
            "background" to intToHexColor(uiConfig.background),
            "primaryTextColor" to intToHexColor(uiConfig.primaryTextColor),
            "secondaryTextColor" to intToHexColor(uiConfig.secondaryTextColor),
            "secondaryButtonColor" to intToHexColor(uiConfig.secondaryButtonColor),
            "secondaryButtonBackground" to intToHexColor(uiConfig.secondaryButtonBackground),
            "primaryButtonColor" to intToHexColor(uiConfig.primaryButtonColor),
            "primaryButtonBackground" to intToHexColor(uiConfig.primaryButtonBackground),
            "lineColor" to intToHexColor(uiConfig.lineColor),
            "borderRadius" to uiConfig.borderRadius,
            "showResult" to uiConfig.showResult,
            "paymentRetriesEnabled" to uiConfig.paymentRetriesEnabled,
            "displayStyle" to displayStyleToString(uiConfig.displayStyle),
        )
    }

    fun toMap(paymentMethod: PaymentMethod): Map<String, Any?> {
        val data = paymentMethod.data?.let {
            if (it is CardModel) {
                mapOf(
                    "brand" to it.creditCard.brand,
                    "exp_year" to it.creditCard.expYear,
                    "exp_month" to it.creditCard.expMonth,
                    "number" to it.creditCard.number,
                    "holder_name" to it.creditCard.holderName,
                    "token" to it.token,
                    "default" to it.isDefault,
                    "state" to it.state,
                    "token_type" to it.tokenType
                )
            } else {
                null
            }
        }
        return mapOf(
            "type" to paymentMethod.type.type,
            "arguments" to data,
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
            originalBusinessId = map["originalBusinessId"] as String?
        )
    }

    fun toUIConfig(map: Map<String, Any?>): UIConfig {
        val uiConfig = UIConfig()
        parseColor(map["background"])?.let { uiConfig.background = it }
        parseColor(map["primaryTextColor"])?.let { uiConfig.primaryTextColor = it }
        parseColor(map["secondaryTextColor"])?.let { uiConfig.secondaryTextColor = it }
        parseColor(map["primaryButtonColor"])?.let { uiConfig.primaryButtonColor = it }
        parseColor(map["primaryButtonBackground"])?.let { uiConfig.primaryButtonBackground = it }
        parseColor(map["secondaryButtonColor"])?.let { uiConfig.secondaryButtonColor = it }
        parseColor(map["secondaryButtonBackground"])?.let {
            uiConfig.secondaryButtonBackground = it
        }
        parseColor(map["lineColor"])?.let { uiConfig.lineColor = it }

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
        if(extra != null){
            extraModel = Extra(extra["sessionId"] as String?)
        }

        return PaymentIntent(
            amount = map["amount"] as Double,
            currency = map["currency"] as String,
            orderNumber = map["orderNumber"] as String,
            paymentMethod = paymentMethod?.let {
                toPaymentMethod(it)
            },
            transactionType = transactionTypeFromString(map["transactionType"] as String),
            lineItems = lineItemList,
            extra = extraModel
        )
    }

    fun toPaymentMethod(map: Map<String, Any?>): PaymentMethod? {
        val payType = PayType.fromString(map["type"] as String?) ?: return null
        val arguments = map["arguments"] as Map<String, Any?>?

        val data = arguments?.let {
            if (payType == PayType.CREDIT_CARD) {
                CardModel(
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

    fun transactionTypeFromString(strValue: String): TransactionType {
        return TransactionType.values().find { it.type == strValue } ?: TransactionType.SALE
    }

}