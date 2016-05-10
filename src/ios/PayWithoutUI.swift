import UIKit
import PaymentSDK
//
//  Created by Efe Ariaroo on 10/05/2016.
//  Copyright © 2016 Interswitch Limited. All rights reserved.
import SwiftyJSON


public class PayWithoutUI {
    private static var cdvPlugin : PaymentPlugin?


    class func loadWallet(cdvPlugin: PaymentPlugin, cdvCommand: CDVInvokedUrlCommand) {
        PayWithoutUI.cdvPlugin = cdvPlugin
        
        let walletSdk : WalletSDK = WalletSDK(clientId: cdvPlugin.clientId, clientSecret: cdvPlugin.clientSecret)
        
        walletSdk.getPaymentMethods({ (response: WalletResponse?, error: NSError?) -> Void in
            guard error == nil else {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                let errMsg = (error?.localizedDescription)!
                
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errMsg)
                cdvPlugin.commandDelegate!.sendPluginResult(pluginResult, callbackId: cdvCommand.callbackId)
                return
            }
            
            guard let walletResponse = response else {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                let errMsg = (error?.localizedDescription)!
                
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errMsg)
                cdvPlugin.commandDelegate!.sendPluginResult(pluginResult, callbackId: cdvCommand.callbackId)
                return
            }
            
            //Handling success
            print("Got the payment methods!")
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            let paymentMethodsJson = getJsonOfPaymentMethods(walletResponse.paymentMethods)
            print("Payment methods: \(paymentMethodsJson)")
            
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: paymentMethodsJson)
            cdvPlugin.commandDelegate!.sendPluginResult(pluginResult, callbackId: cdvCommand.callbackId)
            cdvPlugin.viewController?.dismissViewControllerAnimated(true, completion: nil)
        })
    }

    
    class func getJsonOfPaymentMethods(thePaymentMethods: [PaymentMethod]) -> String {
        var result : String = ""
        do {
            let listOfDicts : [Dictionary] = thePaymentMethods.map { return $0.toDict() }
            let jsonNSData = try NSJSONSerialization.dataWithJSONObject(listOfDicts, options: NSJSONWritingOptions(rawValue: 0))
            result = String(data: jsonNSData, encoding: NSUTF8StringEncoding)!
            
            result = "{ \"paymentMethods\": \(result) }"
        } catch _ {
        }
        return result
    }
    
    class func showError(cdvPlugin: PaymentPlugin, message: String) {
        let alertVc = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alertVc.addAction(action)

        cdvPlugin.viewController?.presentViewController(alertVc, animated: true, completion: nil)
    }

    class func showSuccess(cdvPlugin: PaymentPlugin, message: String) {
        let alertVc = UIAlertController(title: "Success", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alertVc.addAction(action)

        cdvPlugin.viewController?.presentViewController(alertVc, animated: true, completion: nil)
    }
}

extension PaymentMethod {
    func toDict() -> Dictionary<String, AnyObject> {
        var selfDataAsDict = [String:AnyObject]()
        
        selfDataAsDict["cardProduct"] = self.cardProduct
        selfDataAsDict["panLast4Digits"] = self.panLast4Digits
        selfDataAsDict["token"] = self.token
        selfDataAsDict["tokenExpiry"] = self.tokenExpiry
        
        return selfDataAsDict
    }
}

