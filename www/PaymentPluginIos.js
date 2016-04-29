var exec = require('cordova/exec');

function ensureArray(arg) {
	if (!Array.isArray(arg))
		arg = [arg];
	return arg;
}

function paymentAction (action) {
	return function (argsArray, successCallback, failCallback) {
		var argsArray = ensureArray(argsArray);
    	exec(successCallback, failCallback, "PaymentPlugin", action, argsArray);
	}
}

exports.init = paymentAction("Init");

exports.payWithCard = paymentAction("payWithCard");
exports.payWithWallet = paymentAction("payWithWallet");
exports.validatePaymentCard = paymentAction("validatePaymentCard");

// exports.makePayment = paymentAction("makePayment");
// exports.authorizeOtp = paymentAction("AuthorizeOTP");
// exports.loadWallet = paymentAction("LoadWallet");

// exports.payWithWalletSDK = paymentAction("PayWithWalletSDK");
// exports.paymentStatus = paymentAction("PaymentStatus");
// exports.payWithToken = paymentAction("PayWithToken");
// exports.userInformation = paymentAction("UserInformation");


