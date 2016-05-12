//
//  Created by Efe Ariaroo on 10/05/2016.
//  Copyright © 2016 Interswitch Limited. All rights reserved.

import UIKit
import PaymentSDK
import SwiftyJSON


public class PayWithoutUI {
    
    class func makePayment(cdvPlugin: PaymentPlugin, cdvCommand: CDVInvokedUrlCommand, thePan: String,
                           theAmount:String, theCvv: String, thePin: String, theExpiryDate: String,
                           theCustomerId: String, theCurrency: String) {
        let purchaseSdk : PaymentSDK = PaymentSDK(clientId: cdvPlugin.clientId, clientSecret: cdvPlugin.clientSecret)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let request = PurchaseRequest(customerId: theCustomerId, amount: theAmount, pan: thePan,
                                      pin: thePin, transactionRef: Payment.randomStringWithLength(12),
                                      currency: theCurrency, requestorId: "")
        
        purchaseSdk.purchase(request, completionHandler:{(purchaseResponse: PurchaseResponse?, error: NSError?) in
            guard error == nil else {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                let errMsg = (error?.localizedDescription)!
                
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errMsg)
                cdvPlugin.commandDelegate!.sendPluginResult(pluginResult, callbackId: cdvCommand.callbackId)
                return
            }
            
            guard let response = purchaseResponse else {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                let errMsg = (error?.localizedFailureReason)!
                
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errMsg)
                cdvPlugin.commandDelegate!.sendPluginResult(pluginResult, callbackId: cdvCommand.callbackId)
                return
            }
            //Success or OTP
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: Utils.getJsonOfPurchaseResponse(response))
            cdvPlugin.commandDelegate!.sendPluginResult(pluginResult, callbackId: cdvCommand.callbackId)
        })
    }
    
    class func loadWallet(cdvPlugin: PaymentPlugin, cdvCommand: CDVInvokedUrlCommand) {
        let walletSdk : WalletSDK = WalletSDK(clientId: cdvPlugin.clientId, clientSecret: cdvPlugin.clientSecret)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
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
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            let paymentMethodsJson = Utils.getJsonOfPaymentMethods(walletResponse.paymentMethods)
            
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: paymentMethodsJson)
            cdvPlugin.commandDelegate!.sendPluginResult(pluginResult, callbackId: cdvCommand.callbackId)
        })
    }
    
    
    class func payWithWallet(cdvPlugin: PaymentPlugin, cdvCommand: CDVInvokedUrlCommand, theCustomerId: String,
                             theAmount:String, tokenOfUserSelectedPaymentMethod: String,
                             thePin: String, theCurrency: String, theRequestorId: String) {
        let walletSdk : WalletSDK = WalletSDK(clientId: cdvPlugin.clientId, clientSecret: cdvPlugin.clientSecret)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let request = PurchaseRequest(customerId: theCustomerId, amount: theAmount, pan: tokenOfUserSelectedPaymentMethod,
                                      pin: thePin, transactionRef: Payment.randomStringWithLength(12),
                                      currency: theCurrency, requestorId: theRequestorId)
        
        walletSdk.purchase(request, completionHandler:{(purchaseResponse: PurchaseResponse?, error: NSError?) in
            guard error == nil else {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                let errMsg = (error?.localizedDescription)!
                
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errMsg)
                cdvPlugin.commandDelegate!.sendPluginResult(pluginResult, callbackId: cdvCommand.callbackId)
                return
            }
            
            guard let response = purchaseResponse else {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                let errMsg = (error?.localizedFailureReason)!
                
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errMsg)
                cdvPlugin.commandDelegate!.sendPluginResult(pluginResult, callbackId: cdvCommand.callbackId)
                return
            }
            //Success or OTP
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: Utils.getJsonOfPurchaseResponse(response))
            cdvPlugin.commandDelegate!.sendPluginResult(pluginResult, callbackId: cdvCommand.callbackId)
        })
    }
    
    class func paymentStatus(cdvPlugin: PaymentPlugin, cdvCommand: CDVInvokedUrlCommand,
                             theTransactionRef: String, theAmount:String) {
        let purchaseSdk = PaymentSDK(clientId: cdvPlugin.clientId, clientSecret: cdvPlugin.clientSecret)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        purchaseSdk.getPaymentStatus(theTransactionRef, amount: theAmount, completionHandler:{(paymentStatusResponse: PaymentStatusResponse?, error: NSError?) in
            guard error == nil else {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                let errMsg = (error?.localizedDescription)!
                
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errMsg)
                cdvPlugin.commandDelegate!.sendPluginResult(pluginResult, callbackId: cdvCommand.callbackId)
                return
            }
            
            guard let response = paymentStatusResponse else {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                let errMsg = (error?.localizedFailureReason)!
                
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errMsg)
                cdvPlugin.commandDelegate!.sendPluginResult(pluginResult, callbackId: cdvCommand.callbackId)
                return
            }
            //Success
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: Utils.getJsonOfPaymentStatus(response))
            cdvPlugin.commandDelegate!.sendPluginResult(pluginResult, callbackId: cdvCommand.callbackId)
        })
    }
    
    class func validateCard(cdvPlugin: PaymentPlugin, cdvCommand: CDVInvokedUrlCommand,
                            thePan: String, theCvv:String, thePin: String, theExpiryDate: String, theCustomerId: String) {
        let purchaseSdk = PaymentSDK(clientId: cdvPlugin.clientId, clientSecret: cdvPlugin.clientSecret)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let validateCardRequest = ValidateCardRequest(customerId: theCustomerId, pan: thePan, pin: thePin, expiryDate: theExpiryDate,
                                                      cvv2: theCvv, transactionRef: Payment.randomStringWithLength(12), requestorId: "")
        
        purchaseSdk.validateCard(validateCardRequest, completionHandler:{(validateCardResponse: ValidateCardResponse?, error: NSError?) in 
            guard error == nil else {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                let errMsg = (error?.localizedDescription)!
                
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errMsg)
                cdvPlugin.commandDelegate!.sendPluginResult(pluginResult, callbackId: cdvCommand.callbackId)
                return
            }
            
            guard let response = validateCardResponse else {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                let errMsg = (error?.localizedFailureReason)!
                
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errMsg)
                cdvPlugin.commandDelegate!.sendPluginResult(pluginResult, callbackId: cdvCommand.callbackId)
                return
            }
            //Success
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: Utils.getJsonOfPurchaseResponse(response))
            cdvPlugin.commandDelegate!.sendPluginResult(pluginResult, callbackId: cdvCommand.callbackId)
        })
    }
    
    class func authorizeOtp(cdvPlugin: PaymentPlugin, cdvCommand: CDVInvokedUrlCommand, theOtp: String,
                            theOtpTransactionId:String, theOtpTransactionRef: String) {
        let otpRequest = AuthorizeOtpRequest(otpTransactionIdentifier: theOtpTransactionId,
                                             otp: theOtp, transactionRef: theOtpTransactionRef)

        let purchaseSdk = PaymentSDK(clientId: cdvPlugin.clientId, clientSecret: cdvPlugin.clientSecret)
        purchaseSdk.authorizeOtp(otpRequest, completionHandler: {(authorizeOtpResponse: AuthorizeOtpResponse?, error: NSError?) in
            guard error == nil else {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                let errMsg = (error?.localizedDescription)!
                
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errMsg)
                cdvPlugin.commandDelegate!.sendPluginResult(pluginResult, callbackId: cdvCommand.callbackId)
                return
            }
            
            guard authorizeOtpResponse != nil else {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: "Otp validation was NOT successful")
                cdvPlugin.commandDelegate!.sendPluginResult(pluginResult, callbackId: cdvCommand.callbackId)
                return
            }
            //OTP successful
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: "Success")
            cdvPlugin.commandDelegate!.sendPluginResult(pluginResult, callbackId: cdvCommand.callbackId)
        })
    }
}
