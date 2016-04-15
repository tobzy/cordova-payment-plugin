var exec = require('cordova/exec');
function PaymentPlugin() {
 console.log('Payment plugin working');
}
PaymentPlugin.prototype.makePayment = function(action,args){
   return execPromise(action,args);
}

function execPromise(action, args){
    if (!Array.isArray(args)) {
		args = [args];
	}
    var defer = new $.Deferred();
     exec(function success(successMessage){
              defer.resolve(successMessage);
      },
      function error(errorMessage){
          defer.reject(errorMessage);
      },
      "PaymentPlugin",
      action,
      args);
      return defer.promise();
}
PaymentPlugin.prototype.init = function(action, args){
      return execPromise(action,args);
 }
 PaymentPlugin.prototype.authorizeOtp = function(action, args){
       return execPromise(action,args);
  }
PaymentPlugin.prototype.loadWallet  = function(action, args){
    return execPromise(action,args);
}

PaymentPlugin.prototype.payWithWallet  = function(action, args){
    return execPromise(action,args);
}
PaymentPlugin.prototype.payWithWalletSDK  = function(action, args){
    return execPromise(action,args);
}

PaymentPlugin.prototype.paymentStatus  = function(action, args){
    return execPromise(action,args);
}

PaymentPlugin.prototype.payWithToken  = function(action, args){
    return execPromise(action,args);
}

PaymentPlugin.prototype.validatePaymentCard  = function(action, args){
    return execPromise(action,args);
}
PaymentPlugin.prototype.userInformation = function(action, args){
    return execPromise(action,args);
}

PaymentPlugin.prototype.validateCard  = function(action, args){
    return execPromise(action,args);
}

PaymentPlugin.prototype.pay = function(action, args){
    return execPromise(action,args);
}

PaymentPlugin.prototype.payWithCard = function(action, args){
      return execPromise(action,args);
 }
var paymentPlugin = new PaymentPlugin();
module.exports = paymentPlugin;