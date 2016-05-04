import UIKit
import PaymentSDK
import SwiftyJSON


@objc(PaymentPlugin) class PaymentPlugin : CDVPlugin {
    private static var clientId : String = ""
    private static var clientSecret : String = ""
    
    
    func pluginInit (command: CDVInvokedUrlCommand) {
        guard (command.arguments != nil) else {
            let errMsg = "Invalid ClientId or Client Secret"
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errMsg)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
            return
        }
        
        let firstArg = command.arguments[0] as? String ?? ""
        if let firstArgAsData = firstArg.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            let firstArgAsJson = JSON(data: firstArgAsData)
            
            do {
                let theClientId : String = firstArgAsJson["clientId"].stringValue
                let theClientSecret : String = firstArgAsJson["clientSecret"].stringValue
                let paymentApi : String = firstArgAsJson["paymentApi"].stringValue
                let passportApi : String = firstArgAsJson["passportApi"].stringValue
                
                if paymentApi.characters.count > 0 && passportApi.characters.count > 0 {
                    Passport.overrideApiBase(paymentApi)
                    Payment.overrideApiBase(passportApi)
                }
                if theClientId.length > 0 && theClientSecret.length > 0 {
                    PayWithUI.clientId = theClientId
                    PayWithUI.clientSecret = theClientSecret
                    PayWithoutUI.clientId = theClientId
                    PayWithoutUI.clientSecret = theClientSecret
                    
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
    }
    
    
    func payWithCard(command: CDVInvokedUrlCommand) {
        let firstArg = command.arguments[0] as? String ?? ""
        
        if let firstArgAsData = firstArg.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            let firstArgAsJson = JSON(data: firstArgAsData)
            do {
                let theCustomerId : String = firstArgAsJson["customerId"].stringValue
                let theCurrency : String = firstArgAsJson["currency"].stringValue
                let theDescription : String = firstArgAsJson["description"].stringValue
                let theAmount : String = firstArgAsJson["amount"].stringValue
                
                PayWithUI.payWithCard(self, cdvCommand: command, theCustomerId: theCustomerId, theCurrency: theCurrency,
                                      theDescription: theDescription, theAmount: theAmount)
            } catch _ {
                let errMsg = "Some arguments passed to 'payWithCard' are invalid"
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errMsg)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
            }
        } else {
            let errMsg = "Please check the arguments passed to 'payWithCard'"
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errMsg)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
        }
    }
    
    func payWithWallet(command: CDVInvokedUrlCommand) {
        let firstArg = command.arguments[0] as? String ?? ""
        
        if let firstArgAsData = firstArg.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            let firstArgAsJson = JSON(data: firstArgAsData)
            do {
                let theCustomerId : String = firstArgAsJson["customerId"].stringValue
                let theCurrency : String = firstArgAsJson["currency"].stringValue
                let theDescription : String = firstArgAsJson["description"].stringValue
                let theAmount : String = firstArgAsJson["amount"].stringValue
                
                PayWithUI.payWithWallet(self, cdvCommand: command, theCustomerId: theCustomerId, theCurrency: theCurrency,
                                      theDescription: theDescription, theAmount: theAmount)
            } catch _ {
                let errMsg = "Some arguments passed to 'payWithWallet' are invalid"
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errMsg)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
            }
        } else {
            let errMsg = "Please check the arguments passed to 'payWithWallet'"
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errMsg)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
        }
    }
    
    func validatePaymentCard(command: CDVInvokedUrlCommand) {
        let firstArg = command.arguments[0] as? String ?? ""
        
        if let firstArgAsData = firstArg.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            let firstArgAsJson = JSON(data: firstArgAsData)
            
            do {
                let theCustomerId : String = firstArgAsJson["customerId"].stringValue
                PayWithUI.validatePaymentCard(self, cdvCommand: command, theCustomerId: theCustomerId)
            } catch _ {
                let errMsg = "Some arguments passed to 'validatePaymentCard' are invalid"
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errMsg)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
            }
        } else {
            let errMsg = "Some arguments passed to 'validatePaymentCard' are invalid"
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errMsg)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
        }
    }
    
    func payWithToken(command: CDVInvokedUrlCommand){
        let firstArg = command.arguments[0] as? String ?? ""
        
        if let firstArgAsData = firstArg.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            let firstArgAsJson = JSON(data: firstArgAsData)
            do {
                let theCustomerId : String = firstArgAsJson["customerId"].stringValue
                
                let theDescription : String = firstArgAsJson["description"].stringValue
                let theToken : String = firstArgAsJson["pan"].stringValue
                let theAmount : String = firstArgAsJson["amount"].stringValue
                let theCurrency : String = firstArgAsJson["currency"].stringValue
                let theExpiryDate : String = firstArgAsJson["expiryDate"].stringValue
                let theCardType : String = firstArgAsJson["cardtype"].stringValue
                let thePanLast4Digits : String = firstArgAsJson["panLast4Digits"].stringValue
                
                PayWithUI.payWithToken(self, cdvCommand: command, theCustomerId: theCustomerId, paymentDescription: theDescription,
                                       theToken: theToken, theAmount: theAmount, theCurrency:theCurrency,
                                       theExpiryDate: theExpiryDate, theCardType: theCardType, thePanLast4Digits: thePanLast4Digits)
            } catch _ {
                let errMsg = "Some arguments passed to 'payWithToken' are invalid"
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errMsg)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
            }
        } else {
            let errMsg = "Please check the arguments passed to 'payWithToken'"
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
