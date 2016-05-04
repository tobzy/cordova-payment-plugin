import UIKit
import PaymentSDK
import SwiftyJSON


public class PayWithoutUI {
    public static var clientId : String = ""
    public static var clientSecret : String = ""




    
    
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