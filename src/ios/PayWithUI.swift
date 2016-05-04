import UIKit
import PaymentSDK


public class PayWithUI {
    public static var clientId : String = ""
    public static var clientSecret : String = ""

    
    class func payWithCard(cdvPlugin: PaymentPlugin, cdvCommand: CDVInvokedUrlCommand,
                           theCustomerId: String, theCurrency:String, theDescription:String, theAmount:String) {
        let payWithCard = PayWithCard(clientId: clientId, clientSecret: clientSecret,
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
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: response.transactionIdentifier)
            cdvPlugin.commandDelegate!.sendPluginResult(pluginResult, callbackId: cdvCommand.callbackId)
            cdvPlugin.viewController?.dismissViewControllerAnimated(true, completion: nil)
        })
        addBackButton(cdvPlugin, view: vc.view)
        
        cdvPlugin.viewController?.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    class func payWithWallet(cdvPlugin: PaymentPlugin, cdvCommand: CDVInvokedUrlCommand,
                           theCustomerId: String, theCurrency:String, theDescription:String, theAmount:String) {
        let payWithWallet = PayWithWallet(clientId: clientId, clientSecret: clientSecret,
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
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: response.transactionIdentifier)
            cdvPlugin.commandDelegate!.sendPluginResult(pluginResult, callbackId: cdvCommand.callbackId)
            cdvPlugin.viewController?.dismissViewControllerAnimated(true, completion: nil)
        })
        
        //self.navigationController?.pushViewController(vc, animated: true)
        //--
//        let window = UIWindow(frame: UIScreen.mainScreen().bounds)
//        let viewController = cdvPlugin.viewController!
//        let navigationController = UINavigationController(rootViewController: viewController)
//        window.rootViewController = navigationController
//        window.makeKeyAndVisible()
        //--
        cdvPlugin.viewController?.presentViewController(vc, animated: true, completion: nil)
    }

    class func validatePaymentCard(cdvPlugin: PaymentPlugin, cdvCommand: CDVInvokedUrlCommand, theCustomerId: String) {
        let validateCard = ValidateCard(clientId: clientId, clientSecret: clientSecret, customerId: theCustomerId)
        
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
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: response.message)
            cdvPlugin.commandDelegate!.sendPluginResult(pluginResult, callbackId: cdvCommand.callbackId)
            cdvPlugin.viewController?.dismissViewControllerAnimated(true, completion: nil)
        })
        cdvPlugin.viewController?.presentViewController(vc, animated: true, completion: nil)
    }

    class func payWithToken(cdvPlugin: PaymentPlugin, cdvCommand: CDVInvokedUrlCommand, theCustomerId: String, paymentDescription:String,
                      theToken:String, theAmount:String, theCurrency:String, theExpiryDate:String, theCardType:String, thePanLast4Digits:String){
        let payWithToken = PayWithToken(clientId: clientId, clientSecret: clientSecret,
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
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: response.transactionIdentifier)
            cdvPlugin.commandDelegate!.sendPluginResult(pluginResult, callbackId: cdvCommand.callbackId)
            cdvPlugin.viewController?.dismissViewControllerAnimated(true, completion: nil)
        })
        cdvPlugin.viewController?.presentViewController(vc, animated: true, completion: nil)
    }
    
    class func addBackButton(cdvPlugin:PaymentPlugin, view: UIView) {
        let backButton = UIButton(type: .System)
        
        let screenWidth = view.bounds.width
        let buttonWidth = CGFloat(screenWidth / 5)
        
        backButton.frame = CGRectMake(0, 220, buttonWidth, 50)
        backButton.setTitle("Back", forState: .Normal)
        styleButton(backButton)
        
        //backButton.addTarget(self, action: #selector(PayWithUI.backAction), forControlEvents: .TouchUpInside)
        view.addSubview(backButton)
    }
    
    class func styleButton(theButton: UIButton) {
        theButton.layer.cornerRadius = 5.0
        theButton.backgroundColor  = UIColor.blackColor()
        theButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    }
    
    @objc func backAction(cdvPlugin: PaymentPlugin) {
        cdvPlugin.viewController?.dismissViewControllerAnimated(true, completion: nil)
    }

    func showError(cdvPlugin: PaymentPlugin, message: String) {
        let alertVc = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alertVc.addAction(action)
        
        cdvPlugin.viewController?.presentViewController(alertVc, animated: true, completion: nil)
    }

    func showSuccess(cdvPlugin: PaymentPlugin, message: String) {
        let alertVc = UIAlertController(title: "Success", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alertVc.addAction(action)
        
        cdvPlugin.viewController?.presentViewController(alertVc, animated: true, completion: nil)
    }

}