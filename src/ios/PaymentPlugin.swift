import UIKit
import PaymentSDK
import SwiftyJSON


@objc(PaymentPlugin) class PaymentPlugin : CDVPlugin {
    private static var clientId : String = ""
    private static var clientSecret : String = ""
    
    
    func Init (command: CDVInvokedUrlCommand) {
        guard (command.arguments != nil) else {
            let errMsg = "Invalid ClientId or Client Secret"
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errMsg)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
            return
        }
        
        do {
            let firstArg = command.arguments[0] as? NSDictionary ?? ""
            
            let theClientId: String? = firstArg?.valueForKey("clientId") as? String
            let theClientSecret: String? = firstArg?.valueForKey("clientSecret") as? String
            let paymentApi: String? = firstArg?.valueForKey("paymentApi") as? String
            let passportApi: String? = firstArg?.valueForKey("passportApi") as? String
            
            if paymentApi?.characters.count > 0 && passportApi?.characters.count > 0 {
                Passport.overrideApiBase(paymentApi!)
                Payment.overrideApiBase(passportApi!)
            }
            if theClientId?.length > 0 && theClientSecret?.length > 0 {
                PayWithUI.clientId = theClientId!
                PayWithUI.clientSecret = theClientSecret!
                PayWithoutUI.clientId = theClientId!
                PayWithoutUI.clientSecret = theClientSecret!
                
                let successMsg = "Initialization was successfull"
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: successMsg)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
            } else {
                let errMsg = "Invalid ClientId or Client Secret"
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errMsg)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
            }
        } catch _ {
            let errMsg = "Invalid ClientId or Client Secret"
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errMsg)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
        }
    }
    
    func PayWithCard(command: CDVInvokedUrlCommand) {
        do {
            let firstArg = command.arguments[0] as? NSDictionary ?? ""
            
            let theCustomerId: String? = firstArg?.valueForKey("customerId") as? String
            let theCurrency: String? = firstArg?.valueForKey("currency") as? String
            let theDescription: String? = firstArg?.valueForKey("description") as? String
            let theAmount: String? = firstArg?.valueForKey("amount") as? String
            
            PayWithUI.payWithCard(self, cdvCommand: command, theCustomerId: theCustomerId!, theCurrency: theCurrency!,
                                  theDescription: theDescription!, theAmount: theAmount!)
        } catch _ {
            let errMsg = "Some arguments passed to 'payWithCard' are invalid"
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errMsg)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
        }
    }
    
    func PayWithWallet(command: CDVInvokedUrlCommand) {
        do {
            let firstArg = command.arguments[0] as? NSDictionary ?? ""
            
            let theCustomerId: String? = firstArg?.valueForKey("customerId") as? String
            let theCurrency: String? = firstArg?.valueForKey("currency") as? String
            let theDescription: String? = firstArg?.valueForKey("description") as? String
            let theAmount: String? = firstArg?.valueForKey("amount") as? String
            
            PayWithUI.payWithWallet(self, cdvCommand: command, theCustomerId: theCustomerId!, theCurrency: theCurrency!,
                                  theDescription: theDescription!, theAmount: theAmount!)
        } catch _ {
            let errMsg = "Some arguments passed to 'payWithWallet' are invalid"
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errMsg)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
        }
    }
    
    func ValidatePaymentCard(command: CDVInvokedUrlCommand) {
        do {
            let firstArg = command.arguments[0] as? NSDictionary ?? ""
            
            let theCustomerId: String? = firstArg?.valueForKey("customerId") as? String
            
            PayWithUI.validatePaymentCard(self, cdvCommand: command, theCustomerId: theCustomerId!)
        } catch _ {
            let errMsg = "Some arguments passed to 'validatePaymentCard' are invalid"
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errMsg)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
        }
    }
    
    func PayWithToken(command: CDVInvokedUrlCommand){
        do {
            let firstArg = command.arguments[0] as? NSDictionary ?? ""
            
            let theCustomerId: String? = firstArg?.valueForKey("customerId") as? String
            let theDescription: String? = firstArg?.valueForKey("description") as? String
            let theToken: String? = firstArg?.valueForKey("pan") as? String
            let theAmount: String? = firstArg?.valueForKey("amount") as? String
            let theCurrency: String? = firstArg?.valueForKey("currency") as? String
            let theExpiryDate: String? = firstArg?.valueForKey("expiryDate") as? String
            let theCardType: String? = firstArg?.valueForKey("cardtype") as? String
            let thePanLast4Digits: String? = firstArg?.valueForKey("panLast4Digits") as? String
            
            PayWithUI.payWithToken(self, cdvCommand: command, theCustomerId: theCustomerId!, paymentDescription: theDescription!,
                                   theToken: theToken!, theAmount: theAmount!, theCurrency:theCurrency!,
                                   theExpiryDate: theExpiryDate!, theCardType: theCardType!, thePanLast4Digits: thePanLast4Digits!)
        } catch _ {
            let errMsg = "Some arguments passed to 'payWithToken' are invalid"
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errMsg)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
        }
    }
}

extension String {
    var length: Int {
        return (self as NSString).length
    }
}
