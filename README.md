

Create the cordova project

cd to cordova project

add cordova payment plugin

add ios platform


cd into platforms/ios

Open the .xcodeproj file in xcode


A popup may appear saying:
Convert to latest Swift Syntax?

Click the Cancel button


In Finder, go to the "/platforms/ios/<NameOfApp>/plugins/com.interswitchng.sdk.payment" directory

Drag the ​ PaymentSDK.framework file to the Embedded Binaries section of your app's TARGETS settings(General tab).

In the dialog that appears, make sure ‘Copy items if needed’ is unchecked in the ‘Choose options for adding these files’

Click the project and under the info tab - Configurations section, change the values for Debug and Release to None.


Now, close Xcode

cd into 'platforms/ios'

run: pod init

Open the Podfile and replace the two commented lines with the following
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, "8.0"
use_frameworks!

Add the following to your Podfile, inside the first target block:

pod 'CryptoSwift'
pod 'Alamofire', :git => 'https://github.com/Alamofire/Alamofire.git'
pod 'SwiftyJSON', :git => 'https://github.com/SwiftyJSON/SwiftyJSON.git'
pod 'OpenSSL'

now run pod install

Go to the directory platforms/ios
Now open the .xcworkspace file in xcode

