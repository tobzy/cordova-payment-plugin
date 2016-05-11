//
//  Created by Efe Ariaroo on 10/05/2016.
//  Copyright © 2016 Interswitch Limited. All rights reserved.

import UIKit
import PaymentSDK
import SwiftyJSON


@objc(PaymentPlugin) class PaymentPlugin : CDVPlugin {
    internal var clientId : String = ""
    internal var clientSecret : String = ""
    
    
    func Init (command: CDVInvokedUrlCommand) {
        guard (command.arguments != nil) else {
            let errMsg = "Seems no arguments were passed to 'Init'"
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errMsg)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
            return
        }
        let firstArg = command.arguments[0] as? NSDictionary ?? ""
        
        let theClientId: String? = firstArg?.valueForKey("clientId") as? String
        let theClientSecret: String? = firstArg?.valueForKey("clientSecret") as? String
        let paymentApi: String? = firstArg?.valueForKey("paymentApi") as? String
        let passportApi: String? = firstArg?.valueForKey("passportApi") as? String
        
        if paymentApi?.length > 0 && passportApi?.length > 0 {
            Payment.overrideApiBase(paymentApi!)
            Passport.overrideApiBase(passportApi!)
        }
        if theClientId?.length > 0 && theClientSecret?.length > 0 {
            self.clientId = theClientId!
            self.clientSecret = theClientSecret!
            
            let successMsg = "Initialization was successfull"
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: successMsg)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
        } else {
            let errMsg = "Invalid ClientId or Client Secret"
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errMsg)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
        }
    }
    
    func PayWithCard(command: CDVInvokedUrlCommand) {
        guard clientId.length > 0 && clientSecret.length > 0 else {
            let errMsg = "Payment plugin has not been properly initialized"
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errMsg)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
            return
        }
        let firstArg = command.arguments[0] as? NSDictionary ?? ""
        
        let theCustomerId: String? = firstArg?.valueForKey("customerId") as? String
        let theCurrency: String? = firstArg?.valueForKey("currency") as? String
        let theDescription: String? = firstArg?.valueForKey("description") as? String
        let theAmount: String? = firstArg?.valueForKey("amount") as? String
        
        PayWithUI.payWithCard(self, cdvCommand: command, theCustomerId: theCustomerId!, theCurrency: theCurrency!,
                              theDescription: theDescription!, theAmount: theAmount!)
    }
    
    func PayWithWallet(command: CDVInvokedUrlCommand) {
        guard clientId.length > 0 && clientSecret.length > 0 else {
            let errMsg = "Payment plugin has not been properly initialized"
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errMsg)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
            return
        }
        let firstArg = command.arguments[0] as? NSDictionary ?? ""
        
        let theCustomerId: String? = firstArg?.valueForKey("customerId") as? String
        let theCurrency: String? = firstArg?.valueForKey("currency") as? String
        let theDescription: String? = firstArg?.valueForKey("description") as? String
        let theAmount: String? = firstArg?.valueForKey("amount") as? String
        
        PayWithUI.payWithWallet(self, cdvCommand: command, theCustomerId: theCustomerId!, theCurrency: theCurrency!,
                              theDescription: theDescription!, theAmount: theAmount!)
    }
    
    func PayWithToken(command: CDVInvokedUrlCommand){
        guard self.clientId.length > 0 && self.clientSecret.length > 0 else {
            let errMsg = "Payment plugin has not been properly initialized"
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errMsg)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
            return
        }
        let firstArg = command.arguments[0] as? NSDictionary ?? ""
        
        let theCurrency: String? = firstArg?.valueForKey("currency") as? String
        let theToken: String? = firstArg?.valueForKey("pan") as? String
        let theAmount: String? = firstArg?.valueForKey("amount") as? String
        let theCardType: String? = firstArg?.valueForKey("cardtype") as? String
        let thePanLast4Digits: String? = firstArg?.valueForKey("panLast4Digits") as? String
        let theExpiryDate: String? = firstArg?.valueForKey("expiryDate") as? String
        let theCustomerId: String? = firstArg?.valueForKey("customerId") as? String
        let theDescription: String? = firstArg?.valueForKey("description") as? String
        
        PayWithUI.payWithToken(self, cdvCommand: command, theCustomerId: theCustomerId!, paymentDescription: theDescription!,
                               theToken: theToken!, theAmount: theAmount!, theCurrency:theCurrency!,
                               theExpiryDate: theExpiryDate!, theCardType: theCardType!, thePanLast4Digits: thePanLast4Digits!)
    }
    
    func ValidatePaymentCard(command: CDVInvokedUrlCommand) {
        guard self.clientId.length > 0 && self.clientSecret.length > 0 else {
            let errMsg = "Payment plugin has not been properly initialized"
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errMsg)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
            return
        }
        let firstArg = command.arguments[0] as? NSDictionary ?? ""
        
        let theCustomerId: String? = firstArg?.valueForKey("customerId") as? String
        
        PayWithUI.validatePaymentCard(self, cdvCommand: command, theCustomerId: theCustomerId!)
    }
    
    
    //---------- Without SDK UI
    
    func MakePayment(command: CDVInvokedUrlCommand) {
        guard clientId.length > 0 && clientSecret.length > 0 else {
            let errMsg = "Payment plugin has not been properly initialized"
            
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errMsg)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
            return
        }
        
        let firstArg = command.arguments[0] as? NSDictionary ?? ""
        
        let pan: String? = firstArg?.valueForKey("pan") as? String
        let amount: String? = firstArg?.valueForKey("amount") as? String
        let cvv: String? = firstArg?.valueForKey("cvv") as? String
        let pin: String? = firstArg?.valueForKey("pin") as? String
        let expiryDate: String? = firstArg?.valueForKey("expiryDate") as? String
        let customerId: String? = firstArg?.valueForKey("customerId") as? String
        let currency: String? = firstArg?.valueForKey("currency") as? String
        
        PayWithoutUI.makePayment(self, cdvCommand: command, thePan: pan!, theAmount: amount!, theCvv: cvv!,
                                 thePin: pin!, theExpiryDate: expiryDate!, theCustomerId: customerId!, theCurrency: currency!)
    }
    
    func LoadWallet(command: CDVInvokedUrlCommand) {
        guard clientId.length > 0 && clientSecret.length > 0 else {
            let errMsg = "Payment plugin has not been properly initialized"
            
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errMsg)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
            return
        }
        PayWithoutUI.loadWallet(self, cdvCommand: command)
    }
    
    func PayWithWalletSDK(command: CDVInvokedUrlCommand) {
        guard clientId.length > 0 && clientSecret.length > 0 else {
            let errMsg = "Payment plugin has not been properly initialized"
            
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errMsg)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
            return
        }
        
        let firstArg = command.arguments[0] as? NSDictionary ?? ""
        
        let customerId: String? = firstArg?.valueForKey("customerId") as? String
        let amount: String? = firstArg?.valueForKey("amount") as? String
        let theTokenOfPaymentMethod: String? = firstArg?.valueForKey("pan") as? String
        let pin: String? = firstArg?.valueForKey("pin") as? String
        let requestorId: String? = firstArg?.valueForKey("requestorId") as? String
        let currency: String? = firstArg?.valueForKey("currency") as? String
        
        PayWithoutUI.payWithWallet(self, cdvCommand: command, theCustomerId: customerId!, theAmount: amount!,
                                   tokenOfUserSelectedPaymentMethod: theTokenOfPaymentMethod!, thePin: pin!,
                                   theCurrency: currency!, theRequestorId: requestorId!)
    }
    
    func PaymentStatus(command: CDVInvokedUrlCommand) {
        guard clientId.length > 0 && clientSecret.length > 0 else {
            let errMsg = "Payment plugin has not been properly initialized"
            
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errMsg)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
            return
        }
        
        let firstArg = command.arguments[0] as? NSDictionary ?? ""
        
        let transactionRef: String? = firstArg?.valueForKey("transactionRef") as? String
        let amount: String? = firstArg?.valueForKey("amount") as? String

        PayWithoutUI.paymentStatus(self, cdvCommand: command, theTransactionRef: transactionRef!, theAmount: amount!)
        //PayWithoutUI.paymentStatus(self, cdvCommand: command, theTransactionRef: "32323232", theAmount: "3000")
    }
    
}

extension String {
    var length: Int {
        return (self as NSString).length
    }
}
