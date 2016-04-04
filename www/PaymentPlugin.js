var exec = require('cordova/exec');
function PaymentPlugin() {
 console.log("PaymentPlugin.js: is created");
}
PaymentPlugin.prototype.makePayment = function(aString,args){
 exec(function success(successMessage){
          alert(successMessage);
      },
  function error(errorMessage){
      alert(errorMessage);
  },
  "PaymentPlugin",
  aString,
  args);
}

PaymentPlugin.prototype.loadWallet = function(aString){
 exec(function success(successMessage){
          alert(successMessage);
      },
  function error(errorMessage){
      alert(errorMessage);
  },
  "PaymentPlugin",
  aString,
  null);
}
var paymentPlugin = new PaymentPlugin();
module.exports = paymentPlugin;