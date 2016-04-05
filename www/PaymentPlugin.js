var exec = require('cordova/exec');
function PaymentPlugin() {
 console.log("PaymentPlugin.js: is created");
}
PaymentPlugin.prototype.makePayment = function(action,args){
 exec(function success(successMessage){
          alert(successMessage);
      },
  function error(errorMessage){
      alert(errorMessage);
  },
  "PaymentPlugin",
  action,
  args);
}

PaymentPlugin.prototype.loadWallet  = function(action, args){
 exec(function success(successMessage){
          alert(successMessage);
      },
  function error(errorMessage){
      alert(errorMessage);
  },
  "PaymentPlugin",
  action,
  [args]);
}
PaymentPlugin.prototype.validateCard  = function(action, args){
 exec(function success(successMessage){
          alert(successMessage);
      },
  function error(errorMessage){
      alert(errorMessage);
  },
  "PaymentPlugin",
  action,
  args);
}
PaymentPlugin.prototype.payWithCard  = function(action, args){
 exec(function success(successMessage){
          alert(successMessage);
      },
  function error(errorMessage){
      alert(errorMessage);
  },
  "PaymentPlugin",
  action,
  args);
}
var paymentPlugin = new PaymentPlugin();
module.exports = paymentPlugin;