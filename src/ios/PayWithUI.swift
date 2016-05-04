import UIKit
import PaymentSDK


public class PayWithUI {
    public static var clientId : String = ""
    public static var clientSecret : String = ""
    private static var cdvPlugin : PaymentPlugin?
    
    
    class func payWithCard(cdvPlugin: PaymentPlugin, cdvCommand: CDVInvokedUrlCommand,
                           theCustomerId: String, theCurrency:String, theDescription:String, theAmount:String) {
        PayWithUI.cdvPlugin = cdvPlugin
        
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
        
        addBackButton(cdvPlugin, view: vc.view, yPos: 220)
        cdvPlugin.viewController?.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    class func payWithWallet(cdvPlugin: PaymentPlugin, cdvCommand: CDVInvokedUrlCommand,
                           theCustomerId: String, theCurrency:String, theDescription:String, theAmount:String) {
        PayWithUI.cdvPlugin = cdvPlugin
        
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
        
        let window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let navigationController = UINavigationController(rootViewController: vc)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        //addBackButton(cdvPlugin, view: vc.view, yPos: 250)
        let backButton = UIButton(type: .System)
        let screenWidth = vc.view.bounds.width
        let buttonWidth = CGFloat(screenWidth / 5)
        backButton.frame = CGRectMake(0, 250, buttonWidth, 40)
        backButton.setTitle("Back", forState: .Normal)
        styleButton(backButton)
        backButton.addTarget(self, action: #selector(PayWithUI.backActionForPayWithWallet), forControlEvents: .TouchUpInside)
        vc.view.addSubview(backButton)
        
        cdvPlugin.viewController?.presentViewController(vc, animated: true, completion: nil)
    }

    class func validatePaymentCard(cdvPlugin: PaymentPlugin, cdvCommand: CDVInvokedUrlCommand, theCustomerId: String) {
        PayWithUI.cdvPlugin = cdvPlugin
        
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
        
        addBackButton(cdvPlugin, view: vc.view, yPos: 220)
        cdvPlugin.viewController?.presentViewController(vc, animated: true, completion: nil)
    }

    class func payWithToken(cdvPlugin: PaymentPlugin, cdvCommand: CDVInvokedUrlCommand, theCustomerId: String, paymentDescription:String,
                      theToken:String, theAmount:String, theCurrency:String, theExpiryDate:String, theCardType:String, thePanLast4Digits:String){
        PayWithUI.cdvPlugin = cdvPlugin
        
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
        
        addBackButton(cdvPlugin, view: vc.view, yPos: 220)
        cdvPlugin.viewController?.presentViewController(vc, animated: true, completion: nil)
    }
    
    class func addBackButton(cdvPlugin:PaymentPlugin, view: UIView, yPos: CGFloat) {
        let backButton = UIButton(type: .System)
        
        let screenWidth = view.bounds.width
        let buttonWidth = CGFloat(screenWidth / 5)
        
        backButton.frame = CGRectMake(0, yPos, buttonWidth, 40)
        backButton.setTitle("Back", forState: .Normal)
        styleButton(backButton)
        
        backButton.addTarget(self, action: #selector(PayWithUI.backAction), forControlEvents: .TouchUpInside)
        view.addSubview(backButton)
    }
    
    class func styleButton(theButton: UIButton) {
        theButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
    }
    
    @objc class func backAction() {
        PayWithUI.cdvPlugin?.viewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc class func backActionForPayWithWallet() {
        PayWithUI.cdvPlugin?.viewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}