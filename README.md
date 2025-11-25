## Flutter Wonder Payment Plugin
The Wonder Payment Plugin is a powerful and versatile Flutter plugin designed to streamline in-app payment integration for both iOS and Android platforms. With its developer-friendly architecture, it simplifies the implementation of payment systems while offering extensive customization and robust security.

### Key Features:

* Cross-Platform Compatibility: Seamlessly supports iOS and Android, ensuring a unified payment experience across devices.
* Simplified Workflow: The integration process is intuitive and efficient, reducing development time with clear documentation and ready-to-use APIs.
* Customizable UI: Tailor the payment interface to match your app’s branding, with flexible theming options for buttons, layouts, and animations.
* Enterprise-Grade Security: All transactions are protected via advanced encryption protocols (SSL/TLS, AES-256), ensuring secure data transmission and PCI DSS compliance.
* Multi-Payment Channel Support: Integrate a wide range of popular payment methods, including WeChat Pay, Alipay, UnionPay, Credit/Debit Cards, Octopus (Hong Kong), FPS, PayMe, Apple Pay, and Google Pay, catering to diverse regional and global user needs.

## Getting Started

### Add the SDK to the project
#### 1. In your <font color="green">pubspec.yaml</font> add the following lines:

```js
dependencies:
  wonder_payment_plugin: ^1.0.5
```
#### 2. If it is iOS, 
##### In your <font color="green">Info.plist</font>, add the following lines:

```js
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLName</key>
    <string>payment_sdk_demo</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>YOUR_APP_SCHEME</string>
    </array>
  </dict>
</array>
```
###### This is configuration of whitelist 
```js
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>weixin</string>
  <string>weixinULAPI</string>
  <string>weixinURLParamsAPI</string>
  <string>uppaysdk</string>
  <string>uppaywallet</string>
  <string>uppayx1</string>
  <string>uppayx2</string>
  <string>uppayx3</string>
  <string>octopus</string>
  <string>alipayhk</string>
  <string>alipays</string>
</array>
```

##### If you use <font color="orange">Wechat Pay</font>, you must add a dependency


```js
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLName</key>
    <string>wechat_pay</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>YOUR_WECHAT_APP_ID</string>
    </array>
  </dict>
</array>
```
#### 3. If it is Android:
##### 1.In your <font color="green">android/build.gradle</font> add the following lines:

```js
dependencyResolutionManagement {
  repositories {
    mavenCentral()
    maven {
      url 'https://raw.githubusercontent.com/wonder-sources/WonderPayment-Android/master'
    }
  }
}
```

##### 2. Create an empty Activity in the application package name directory and add the following to the manifest file:
```js
<activity-alias
    android:name=".wxapi.WXPayEntryActivity"
    android:exported="true"
    android:targetActivity="com.wonder.payment.sdk.wxapi.WXPayEntryResultActivity" />
```
#### 4. If iOS

##### In your AppDelegate.swift add the following lines:
```js
func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    return WonderPayment.handleOpenURL(url: url)
}

func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    return WonderPayment.handleOpenURL(url: url)
}
```

### Initiate the SDK
To initiate the SDK, customer needs know:

  -Set Up the Payment Configurations. Retrieve `appID` as a first step when initiating the SDK when you onboard on Wonder, in order to get access to our Payment Gateway configurations. For specific methods such as Apple Pay, Google Pay, Wechat Pay, you will be required to apply directly with the schemes in order to obtain the unique identifier, for the activation of those methods.

  -To set up a method for future payments, you must generate a `customerID` for Tokenisation process.

  -Customer can opt to customise the UI of the payment elements, or follow the default UI settings.

#### Set up payment configuration




```js
WonderPaymentPlugin.init(
    paymentConfig: PaymentConfig(
      environment: PaymentEnvironment.staging, // [staging | alpha | production]
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
```

 The attributes of UIConfig are as follows：

 ```js
class UIConfig {
  Color? background;
  Color? secondaryBackground;
  Color? primaryTextColor;
  Color? secondaryTextColor;
  Color? secondaryButtonColor;
  Color? secondaryButtonBackground;
  Color? primaryButtonColor;
  Color? primaryButtonBackground;
  Color? primaryButtonDisableBackground;
  Color? textFieldBackground;
  Color? linkColor;
  Color? errorColor;
  double? borderRadius;
  DisplayStyle? displayStyle;
  bool? showResult;
 }
```

#### PaymentConfig class

|   Variable       | Type     | Required | Description                     |
| :-----------     | :-----   | :------- | :----------------------------   |
| appId           | String   | Y        |The APP ID Generated from New Api credential on Wonder Dashboard |
| customerId            | String   | N        |This field is needed if customer would like to access to tokenisation feature, check out tokenisation feature [here](/payment_scenarios/payment_tokenization/). User can create the customerId by calling the Create Customer API.<br/>Refer to : https://developer-stage.wonder.today/openapi/customer   |
| environment      | enum     | Y        |The environment of the payment SDK. Available options are:.staging, .alpha, .production|
| locale           | String   | N        | Localised language that the app is opened in. Available options:.zh_CN .zh_HK .en_US |
| wechatAppId      | String   | N        | The appId applied on WeChat pay, the merchant need to give it to our side for WeChat Pay configuration.   |
| googleConfig     | GoogleConfig   | N  | Refer to the below configs if customer wants to enable Google Pay payment.|
| -- countryCode   | String   | Y        |ISO 3166-1 alpha-2 country code where the transaction is processed.  |
| -- currencyCode  | String   | Y        |The ISO 4217 alphabetic currency code.  |
| -- merchantId    | String   | Y        |A Google merchant identifier issued after registration with the Google Pay & Wallet Console.  |
| -- merchantName  | String   | Y        |Merchant name encoded as UTF-8. Merchant name is rendered in the payment sheet.  |

#### UIConfig class

|   Variable                  | Type    | Required | Description                     |
| :-------------------------  | :-----  | :------- | :----------------------------   |
| background                  | Color   | N        |Default data: #FFFFFF   |
| primaryTextColor            | Color   | N        |Default data: #000000   |
| secondaryTextColor          | Color   | N        |Default data: #8E8E93     |
| primaryButtonColor          | Color   | N        |Default data: #FFFFFF   |
| primaryButtonBackground     | Color   | N        |Default data: #000000   |
| secondaryButtonColor        | Color   | N        |Default data: #000000   |
| secondaryButtonBackground   | Color   | N        |Default data: #FFFFFF   |
| borderRadius                | float   | N        | Default: 12  |
| displayStyle                | enum | N        | User can choose how the general UX flow of the payment selection process on Wonder pre-built payment page. Options: confirm, oneClick.Default data: oneClick      |
| showResult                  | boolean | N        | This is to set if customer would like to determine that, upon payment result is returned, the flow should be redirecting back to Wonder pre-built payment result page or not.Default data: true |


###  Initialize Payment Intent, and Complete Payment Immediately
Upon successful SDK configuration set up, the customer can initialize and open Wonder pre-built payment session for every payment intent. The app user can select the pre-enabled payment options in the pre-built UI page to complete the payment. This flow is to trigger and complete payment continuously in one flow.

```js
final intent = PaymentIntent(
    amount: 0.1,
    currency: "HKD",
    orderNumber: "202403081229292766405205",
  );

final result = await WonderPaymentPlugin.present(intent);
```

### Present result object [PaymentResult]
This section presents the result of the payment intent.

|   Variable   | Type     | Required | Description                     |
| :----------- | :-----   | :------- | :----------------------------   |
| status  | enum | Y        | Completed, Canceled, Failed,    |
| code  | string| N     | If the payment goes wrong, an error code is returned   |
| message  | string  | N        | If the payment goes wrong, an error message is returned   |

###  Alternative Flow - Initialize Payment Intent, and Pay Later
Alternatively, the customer can choose to initialize the payment intent, and save the payment method option, and then pay later during the checkout process. This is suitable for customer that wishes to let their payer to pre-choose the default payment method first (step 1), and then complete payment later (step 2).
```js
Step 1: Select payment method

final intent = PaymentIntent(
    amount: 0.1,
    currency: "HKD",
    orderNumber: "202403081229292766405205",
  );

final method = await WonderPaymentPlugin.select(intent.transactionType);
intent.paymentMethod = method;

Step 2: Start the payment process

final result = await WonderPaymentPlugin.pay(intent);
```

#### View your current payment method and add a verified credit card
```js
WonderPaymentPlugin.preview()
```

  </TabItem>
</Tabs>
