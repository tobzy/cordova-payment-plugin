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
          var paymentMethods = [];
          for(var i=0; i<successMessage.length; i++){
            paymentMethods[i]=successMessage[i];
          }
          //return paymentMethods;
          alert(paymentMethods);
      },
  function error(errorMessage){
      alert(errorMessage);
  },
  "PaymentPlugin",
  action,
  [args]);
}

PaymentPlugin.prototype.payWithWallet  = function(action, args){
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

PaymentPlugin.prototype.payWithToken  = function(action, args){
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

PaymentPlugin.prototype.validatePaymentCard  = function(action, args){
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

PaymentPlugin.prototype.pay = function(action, args){
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

PaymentPlugin.prototype.payWithCard = function(action, args){
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