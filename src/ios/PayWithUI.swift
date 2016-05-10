//
//  Created by Efe Ariaroo on 10/05/2016.
//  Copyright © 2016 Interswitch Limited. All rights reserved.

import UIKit
import PaymentSDK


public class PayWithUI {
    private static var cdvPlugin : PaymentPlugin?
    private static var currentVc : UIViewController?
    private static var isSdkVcShownForWallet  = false
    private static var window : UIWindow?
    
    
    class func payWithCard(cdvPlugin: PaymentPlugin, cdvCommand: CDVInvokedUrlCommand,
                           theCustomerId: String, theCurrency:String, theDescription:String, theAmount:String) {
        PayWithUI.cdvPlugin = cdvPlugin
        
        let payWithCard = PayWithCard(clientId: cdvPlugin.clientId, clientSecret: cdvPlugin.clientSecret,
                                      customerId: theCustomerId, description: theDescription,
                                      amount:theAmount, currency:theCurrency)
        
        let vc = payWithCard.start({(purchaseResponse: PurchaseResponse?, error: NSError?) in
            guard error == nil else {
                let errMsg = (error?.localizedDescription)!
                
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errMsg)
                cdvPlugin.commandDelegate!.sendPluginResult(pluginResult, callbackId: cdvCommand.callbackId)
                cdvPlugin.viewController?.dismissViewControllerAnimated(true, completion: nil)
                return
            }
            guard let response = purchaseResponse else {
                let failureMsg = (error?.localizedFailureReason)!
                
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: failureMsg)
                cdvPlugin.commandDelegate!.sendPluginResult(pluginResult, callbackId: cdvCommand.callbackId)
                cdvPlugin.viewController?.dismissViewControllerAnimated(true, completion: nil)
                return
            }
            
            //Handling success
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: response.toJsonString())
            cdvPlugin.commandDelegate!.sendPluginResult(pluginResult, callbackId: cdvCommand.callbackId)
            cdvPlugin.viewController?.dismissViewControllerAnimated(true, completion: nil)
        })
        
        let screenTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        vc.view.addGestureRecognizer(screenTap)
        
        currentVc = vc
        addBackButton(vc)
        isSdkVcShownForWallet = false
        
        cdvPlugin.viewController?.presentViewController(vc, animated: true, completion: nil)
    }
    
    class func payWithWallet(cdvPlugin: PaymentPlugin, cdvCommand: CDVInvokedUrlCommand,
                           theCustomerId: String, theCurrency:String, theDescription:String, theAmount:String) {
        PayWithUI.cdvPlugin = cdvPlugin
        
        let payWithWallet = PayWithWallet(clientId: cdvPlugin.clientId, clientSecret: cdvPlugin.clientSecret,
                                          customerId: theCustomerId, description: theDescription,
                                          amount: theAmount, currency: theCurrency)
        let vc = payWithWallet.start({(purchaseResponse: PurchaseResponse?, error: NSError?) in
            guard error == nil else {
                let errMsg = (error?.localizedDescription)!
                
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errMsg)
                cdvPlugin.commandDelegate!.sendPluginResult(pluginResult, callbackId: cdvCommand.callbackId)
                cdvPlugin.viewController?.dismissViewControllerAnimated(true, completion: nil)
                return
            }
            
            guard let response = purchaseResponse else {
                let failureMsg = (error?.localizedFailureReason)!
                
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: failureMsg)
                cdvPlugin.commandDelegate!.sendPluginResult(pluginResult, callbackId: cdvCommand.callbackId)
                cdvPlugin.viewController?.dismissViewControllerAnimated(true, completion: nil)
                return
            }
            //Handling success
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: response.toJsonString())
            cdvPlugin.commandDelegate!.sendPluginResult(pluginResult, callbackId: cdvCommand.callbackId)
            cdvPlugin.viewController?.dismissViewControllerAnimated(true, completion: nil)
        })
        addBackButton(vc)
        
        if(window == nil) {
            if let app = UIApplication.sharedApplication().delegate as? CDVAppDelegate, let keyWindow = app.window {
                window = keyWindow
            }
        }
        window!.rootViewController = vc
        window!.makeKeyAndVisible()
        
        currentVc = vc
        isSdkVcShownForWallet = true
    }
    
    class func payWithToken(cdvPlugin: PaymentPlugin, cdvCommand: CDVInvokedUrlCommand, theCustomerId: String, paymentDescription:String,
                            theToken:String, theAmount:String, theCurrency:String, theExpiryDate:String, theCardType:String, thePanLast4Digits:String){
        PayWithUI.cdvPlugin = cdvPlugin
        
        let payWithToken = PayWithToken(clientId: cdvPlugin.clientId, clientSecret: cdvPlugin.clientSecret,
                                        customerId: theCustomerId, description: paymentDescription,
                                        amount:theAmount, token: theToken, currency:theCurrency,
                                        expiryDate: theExpiryDate, cardType: theCardType, last4Digits: thePanLast4Digits)
        
        let vc = payWithToken.start({(purchaseResponse: PurchaseResponse?, error: NSError?) in
            guard error == nil else {
                let errMsg = (error?.localizedDescription)!
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errMsg)
                cdvPlugin.commandDelegate!.sendPluginResult(pluginResult, callbackId: cdvCommand.callbackId)
                cdvPlugin.viewController?.dismissViewControllerAnimated(true, completion: nil)
                return
            }
            guard let response = purchaseResponse else {
                let failureMsg = (error?.localizedFailureReason)!
                
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: failureMsg)
                cdvPlugin.commandDelegate!.sendPluginResult(pluginResult, callbackId: cdvCommand.callbackId)
                cdvPlugin.viewController?.dismissViewControllerAnimated(true, completion: nil)
                return
            }
            
            //Handling success
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: response.toJsonString())
            cdvPlugin.commandDelegate!.sendPluginResult(pluginResult, callbackId: cdvCommand.callbackId)
            cdvPlugin.viewController?.dismissViewControllerAnimated(true, completion: nil)
        })
        
        let screenTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        vc.view.addGestureRecognizer(screenTap)
        
        currentVc = vc
        addBackButton(vc)
        isSdkVcShownForWallet = false
        
        cdvPlugin.viewController?.presentViewController(vc, animated: true, completion: nil)
    }
    
    class func validatePaymentCard(cdvPlugin: PaymentPlugin, cdvCommand: CDVInvokedUrlCommand, theCustomerId: String) {
        PayWithUI.cdvPlugin = cdvPlugin
        
        let validateCard = ValidateCard(clientId: cdvPlugin.clientId, clientSecret: cdvPlugin.clientSecret, customerId: theCustomerId)
        
        let vc = validateCard.start({(validateCardResponse: ValidateCardResponse?, error: NSError?) in
            guard error == nil else {
                let errMsg = (error?.localizedDescription)!
                
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errMsg)
                cdvPlugin.commandDelegate!.sendPluginResult(pluginResult, callbackId: cdvCommand.callbackId)
                cdvPlugin.viewController?.dismissViewControllerAnimated(true, completion: nil)
                return
            }
            
            guard let response = validateCardResponse else {
                let failureMsg = (error?.localizedFailureReason)!
                
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: failureMsg)
                cdvPlugin.commandDelegate!.sendPluginResult(pluginResult, callbackId: cdvCommand.callbackId)
                cdvPlugin.viewController?.dismissViewControllerAnimated(true, completion: nil)
                return
            }
            //Handling success
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: response.toJsonString())
            cdvPlugin.commandDelegate!.sendPluginResult(pluginResult, callbackId: cdvCommand.callbackId)
            cdvPlugin.viewController?.dismissViewControllerAnimated(true, completion: nil)
        })
        
        let screenTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        vc.view.addGestureRecognizer(screenTap)
        
        currentVc = vc
        addBackButton(vc)
        isSdkVcShownForWallet = false
        
        cdvPlugin.viewController?.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    @objc class func dismissKeyboard() {
        currentVc!.view.endEditing(true)
    }
    
    class func addBackButton(sdkVc: UIViewController) {
        let view : UIView = sdkVc.view
        let backButton = UIButton(type: .System)
        let buttonWidth = CGFloat(view.bounds.width / 5)
        
        backButton.frame = CGRectMake(5, view.bounds.height - 40, buttonWidth, 40)
        backButton.setTitle("Back", forState: .Normal)
        backButton.addTarget(self, action: #selector(PayWithUI.backAction), forControlEvents: .TouchUpInside)
        view.addSubview(backButton)
    }
    
    @objc class func backAction() {
        if(isSdkVcShownForWallet) {
            window?.rootViewController = cdvPlugin?.viewController!
            window?.makeKeyAndVisible()
        } else {
            currentVc?.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}

extension PurchaseResponse {
    func toJsonString() -> String {
        var selfDataAsDict = [String:AnyObject]()
        
        selfDataAsDict["transactionIdentifier"] = self.transactionIdentifier
        selfDataAsDict["transactionRef"] = self.transactionRef
        
        if let theToken = self.token {
            if theToken.characters.count > 0 {
                selfDataAsDict["token"] = theToken
            }
        }
        if let theTokenExpiry = self.tokenExpiryDate {
            if theTokenExpiry.characters.count > 0 {
                selfDataAsDict["tokenExpiryDate"] = theTokenExpiry
            }
        }
        if let thePanLast4 = self.panLast4Digits {
            if thePanLast4.characters.count > 0 {
                selfDataAsDict["panLast4Digits"] = thePanLast4
            }
        }
        if let theCardType = self.cardType {
            if theCardType.characters.count > 0 {
                selfDataAsDict["cardType"] = theCardType
            }
        }
        if let theBalance = self.balance {
            if theBalance.characters.count > 0 {
                selfDataAsDict["balance"] = theBalance
            }
        }
        do {
            let jsonNSData = try NSJSONSerialization.dataWithJSONObject(selfDataAsDict, options: NSJSONWritingOptions(rawValue: 0))
            return String(data: jsonNSData, encoding: NSUTF8StringEncoding)!
        } catch _ {
        }
        return ""
    }
}
