import UIKit
import PaymentSDK


@objc(PaymentPlugin) class PaymentPlugin : CDVPlugin {
    
  func overrideApiBase() {
    Passport.overrideApiBase("https://qa.interswitchng.com/passport")
    Payment.overrideApiBase("https://qa.interswitchng.com")
  }
    
  func payWithCard(command: CDVInvokedUrlCommand) {
	let theClientId = command.arguments[0] as? String ?? ""
    let theClientSecret = command.arguments[1]  as? String ?? ""
    let theCustomerId = command.arguments[2]  as? String ?? ""
    let paymentDescription = command.arguments[3] as? String ?? ""
    
    let theAmount = command.arguments[4]  as? String ?? ""
    let theCurrency = command.arguments[5] as? String ?? ""
    overrideApiBase();
    //--
    let payWithCard = PayWithCard(clientId: theClientId, clientSecret: theClientSecret,
                                  customerId: theCustomerId, description: paymentDescription,
                                  amount:theAmount, currency:theCurrency)
    
    let vc = payWithCard.start({(purchaseResponse: PurchaseResponse?, error: NSError?) in
        guard error == nil else {
            let errMsg = (error?.localizedDescription)!
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errMsg)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
            self.viewController?.dismissViewControllerAnimated(true, completion: nil)
            return
        }
        guard let response = purchaseResponse else {
            let failureMsg = (error?.localizedFailureReason)!
            
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: failureMsg)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
            self.viewController?.dismissViewControllerAnimated(true, completion: nil)
            return
        }
        
        //Handling success
        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: response.transactionIdentifier)
        self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
        self.viewController?.dismissViewControllerAnimated(true, completion: nil)
    })
    self.viewController?.presentViewController(vc, animated: true, completion: nil)
  }
    
    func payWithWallet(command: CDVInvokedUrlCommand) {
        let theClientId = command.arguments[0] as? String ?? ""
        let theClientSecret = command.arguments[1]  as? String ?? ""
        let theCustomerId = command.arguments[2]  as? String ?? ""
        let paymentDescription = command.arguments[3] as? String ?? ""
        
        let theAmount = command.arguments[4]  as? String ?? ""
        let theCurrency = command.arguments[5] as? String ?? ""
        overrideApiBase();
        //--
//        let vc = UIViewController(nibName: nil, bundle: nil)
//        let window = UIWindow(frame: UIScreen.mainScreen().bounds)
//        let navigationController = UINavigationController(rootViewController: vc)
//        window.rootViewController = navigationController
//        window.makeKeyAndVisible()
        
        let payWithWallet = PayWithWallet(clientId: theClientId, clientSecret: theClientSecret,
                                          customerId: theCustomerId, description: paymentDescription,
                                          amount: theAmount, currency: theCurrency)
        let vc = payWithWallet.start({(purchaseResponse: PurchaseResponse?, error: NSError?) in
            guard error == nil else {
                let errMsg = (error?.localizedDescription)!
                
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errMsg)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
                self.viewController?.dismissViewControllerAnimated(true, completion: nil)
                return
            }
            
            guard let response = purchaseResponse else {
                let failureMsg = (error?.localizedFailureReason)!
                
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: failureMsg)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
                self.viewController?.dismissViewControllerAnimated(true, completion: nil)
                return
            }
            //Handling success
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: response.transactionIdentifier)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
            self.viewController?.dismissViewControllerAnimated(true, completion: nil)
        })
        
        //self.navigationController?.pushViewController(vc, animated: true)
        self.viewController?.presentViewController(vc, animated: true, completion: nil)
    }
    
    func validatePaymentCard(command: CDVInvokedUrlCommand) {
        let theClientId = command.arguments[0] as? String ?? ""
        let theClientSecret = command.arguments[1]  as? String ?? ""
        let theCustomerId = command.arguments[2]  as? String ?? ""
        overrideApiBase();
        
        let validateCard = ValidateCard(clientId: theClientId, clientSecret: theClientSecret,
                                        customerId: theCustomerId)
        let vc = validateCard.start({(validateCardResponse: ValidateCardResponse?, error: NSError?) in
            guard error == nil else {
                let errMsg = (error?.localizedDescription)!
                
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errMsg)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
                self.viewController?.dismissViewControllerAnimated(true, completion: nil)
                return
            }
            
            guard let response = validateCardResponse else {
                let failureMsg = (error?.localizedFailureReason)!
                
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: failureMsg)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
                self.viewController?.dismissViewControllerAnimated(true, completion: nil)
                return
            }
            //Handling success
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: response.message)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
            self.viewController?.dismissViewControllerAnimated(true, completion: nil)
        })
        self.viewController?.presentViewController(vc, animated: true, completion: nil)
    }
    
    func payWithToken(clId theClientId: String, cls theClientSecret: String){
//        let payWithToken = PayWithToken(clientId: theClientId, clientSecret: theClientSecret,
//                                        customerId: theCustomerId, description: paymentDescription,
//                                        amount: theAmount, token: theToken, currency: "NGN",
//                                        expiryDate: "2004", cardType: theCardType, last4Digits: "7499")
//        let vc = payWithToken.start({(purchaseResponse: PurchaseResponse?, error: NSError?) in
//            guard error == nil else {
//                let errMsg = (error?.localizedDescription)!
//                self.showError(errMsg)
//                return
//            }
//            
//            guard let response = purchaseResponse else {
//                let failureMsg = (error?.localizedFailureReason)!
//                self.showError(failureMsg)
//                return
//            }
//            
//            self.showSuccess("Ref: " + response.transactionIdentifier)
//        })
//        self.viewController?.presentViewController(vc, animated: true, completion: nil)
    }
    
    func showError(message: String) {
        let alertVc = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alertVc.addAction(action)
        
        self.viewController?.presentViewController(alertVc, animated: true, completion: nil)
    }
    
    func showSuccess(message: String) {
        let alertVc = UIAlertController(title: "Success", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alertVc.addAction(action)
        
        self.viewController?.presentViewController(alertVc, animated: true, completion: nil)
    }
}

