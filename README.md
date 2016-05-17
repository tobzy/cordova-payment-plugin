## Cordova iOS Payment Plugin

Interswitch payment SDK allows you to accept payments from customers within your mobile application.

**Please Note: *The current supported currency is naira (NGN). Support for other currencies would be added later***.

The first step to ​using the plugin is to register as a merchant. This is described [here](merchantxuat.interswitchng.com)

* You'll need to have **Xcode 7.3** or later installed.

* **cd** to a directory of your choice. 

* Create the cordova project
```terminal
cordova create testapp com.develop.testapp TestApp
```

* **cd** to the cordova project

* Add cordova payment plugin
```
cordova plugin add https://github.com/../cordova-payment-plugin
```

* Add ```ios``` platform. Make sure to add the platform **after** adding the plugin.
```terminal
cordova platform add ios
```

* In ```Finder```, go to the **platforms/ios** directory. Open the .xcodeproj file in XCode. A dialog may appear asking: Convert to latest Swift Syntax? Click the **Cancel** button.

* In ```Finder```, go to the ```/platforms/ios/<NameOfApp>/Plugins/com.interswitchng.sdk.payment``` directory

* Drag the ​ **PaymentSDK.framework** file from ```Finder``` to XCode's **Embedded Binaries** section for your app's **TARGETS** settings.

* In the dialog that appears, make sure ```Copy items if needed``` is unchecked.

* **Important**: With ```XCode``` still open, click the project to view its settings. Under the **info** tab find the **Configurations** section and change all the values for ```Debug``` and ```Release``` to **None**. You can change it back once our setups are done.

The **PaymentSDK.framework** needs some [Cocoapods](https://cocoapods.org/) dependencies so we'll need to install them.

* Close Xcode. **cd** into ```platforms/ios``` directory

* Run: 
```terminal
pod init
```

* Open the **Podfile** created and replace ```#``` commented parts with the following.

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, "8.0"
use_frameworks!
```

* Add the following to the **Podfile**, inside the first ```target``` block.

```
pod 'CryptoSwift'
pod 'Alamofire', :git => 'https://github.com/Alamofire/Alamofire.git'
pod 'SwiftyJSON', :git => 'https://github.com/SwiftyJSON/SwiftyJSON.git'
pod 'OpenSSL'
```

* Now run:
```terminal
pod install
```

* After the pods are installed successfully you can go to the directory ```platforms/ios``` and open the ```<NameOfApp>.xcworkspace``` file in XCode. 

### <a name='SandBoxMode'></a> Using The Plugin in Sandbox Mode

During development of your app, you should use the Plugin in sandbox mode to enable testing. Different Client Id and Client Secret are provided for Production and Sandbox mode. The procedure to use the Plugin on sandbox mode is just as easy:

* Use Sandbox Client Id and Client Secret gotten from the Sandbox Tab of the Developer Console after signup (usually you have to wait up to 5 minutes after signup for you to see the Sandbox details) everywhere you are required to supply Client Id and Client Secret in the remainder of this documentation

* In your code, before using any payment features, the PaymentPlugin init function must be executed in order to set your clientId, clientSecret and also the paymentApi, passportApi base urls.
```javascript
	var userDetails = {
	    clientId :"IKIAF8F70479A6902D4BFF4E443EBF15D1D6CB19E232",
	    clientSecret : "ugsmiXPXOOvks9MR7+IFHSQSdk8ZzvwQMGvd0GJva30=",
	    paymentApi : "https://sandbox.interswitchng.com",
	    passportApi : "https://sandbox.interswitchng.com/passport"
	}
	var initial = PaymentPlugin.init(userDetails);
```

* Follow the remaining steps in the documentation.
* call the init function inside the onDeviceReady function of your cordova app
* NOTE: When going into Production mode, use the Client Id and the Client Secret gotten from the Production Tab of Developer Console instead.

