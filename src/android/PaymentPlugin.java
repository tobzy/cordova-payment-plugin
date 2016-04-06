import org.apache.cordova.CordovaWebView;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaInterface;

import android.util.Log;
import android.provider.Settings;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import com.interswitchng.sdk.auth.Passport;
import com.interswitchng.sdk.model.RequestOptions;
import com.interswitchng.sdk.payment.IswCallback;
import com.interswitchng.sdk.payment.Payment;
import com.interswitchng.sdk.payment.android.PaymentSDK;
import com.interswitchng.sdk.payment.android.WalletSDK;
import com.interswitchng.sdk.payment.android.inapp.Pay;
import com.interswitchng.sdk.payment.android.inapp.PayWithCard;
import com.interswitchng.sdk.payment.android.inapp.PayWithWallet;
import com.interswitchng.sdk.payment.android.util.Util;
import com.interswitchng.sdk.util.StringUtils;
import com.interswitchng.sdk.util.RandomString;
import com.interswitchng.sdk.payment.model.PurchaseResponse;
import com.interswitchng.sdk.payment.model.PurchaseRequest;

import com.interswitchng.sdk.payment.model.WalletResponse;
import com.interswitchng.sdk.payment.model.WalletRequest;
import com.interswitchng.sdk.payment.model.PaymentMethod;
import com.interswitchng.sdk.payment.model.ValidateCardRequest;
import com.interswitchng.sdk.payment.model.ValidateCardResponse;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;
import android.util.Log;

import java.lang.Exception;
import java.lang.Override;
import java.lang.Runnable;
import java.lang.String;
import java.util.Arrays;

public class PaymentPlugin extends CordovaPlugin  {
	public PaymentPlugin() {}
    private Activity activity;
    private Context context;
    private Button payWithCard;

    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
		super.initialize(cordova, webView);
        final RequestOptions options = RequestOptions.builder().setClientId("IKIA14BAEA0842CE16CA7F9FED619D3ED62A54239276").setClientSecret("Z3HnVfCEadBLZ8SYuFvIQG52E472V3BQLh4XDKmgM2A=").build();
	}
	public boolean execute(final String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        if(action.equals("MakePayment")){
            cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    try {
                        makePayment(action, args, callbackContext); //asyncronous call
                    }
                    catch (JSONException jsonException){
                        callbackContext.error(jsonException.toString());
                    }
                    // Call the success function of the .js file
                }
            });
            return true;
        }
        else if(action.equals("LoadWallet")){
            cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    try {
                        loadWallet(action, args, callbackContext); //asyncronous call
                    }
                    catch (JSONException jsonException){
                        callbackContext.error(jsonException.toString());
                    }
                    // Call the success function of the .js file
                }
            });
            return true;
        }
        else if(action.equals("ValidateCard")){
            cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    try {
                        validateCard(action, args, callbackContext); //asyncronous call
                    }
                    catch (JSONException jsonException){
                        callbackContext.error(jsonException.toString());
                    }
                    // Call the success function of the .js file
                }
            });
            return true;
        }
        else if(action.equals("Pay")){
            cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    try {
                        pay(action, args, callbackContext); //asyncronous call
                    }
                    catch (JSONException jsonException){
                        callbackContext.error(jsonException.toString());
                    }
                    // Call the success function of the .js file
                }
            });
            return true;
        }
        else if(action.equals("PayWithCard")){
            cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    try {
                        payWithCard(action, args, callbackContext); //asyncronous call
                    }
                    catch (JSONException jsonException){
                        callbackContext.error(jsonException.toString());
                    }
                    // Call the success function of the .js file
                }
            });
            return true;
        }
        return false;
    }
    public void makePayment(final String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        Payment.overrideApiBase(Payment.QA_API_BASE); // used to override the payment api base url.
        Passport.overrideApiBase(Passport.QA_API_BASE); //used to override the payment api base url.

        context = cordova.getActivity().getApplicationContext();
        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                final RequestOptions options = RequestOptions.builder().setClientId("IKIA14BAEA0842CE16CA7F9FED619D3ED62A54239276").setClientSecret("Z3HnVfCEadBLZ8SYuFvIQG52E472V3BQLh4XDKmgM2A=").build();
                try{
                    PurchaseRequest request = new PurchaseRequest(); // Setup request parameters
                    request.setPan(args.getString(0)); //Card No or Token
                    request.setAmount(args.getString(1)); // Amount in Naira
                    request.setCvv2(args.getString(2));
                    request.setPinData(args.getString(3)); // Optional Card PIN for card payment
                    request.setTransactionRef(RandomString.numeric(12));
                    request.setExpiryDate(args.getString(5));
                    request.setCustomerId("1234567890");
                    request.setCurrency("NGN");
                    new PaymentSDK(context,options).purchase(request, new IswCallback<PurchaseResponse>() {
                        @Override
                        public void onError(Exception error) {
                            callbackContext.error(error.getMessage());
                        }

                        @Override
                        public void onSuccess(PurchaseResponse response) {
                            // Check if OTP is required.
                            if (StringUtils.hasText(response.getOtpTransactionIdentifier())) {
                                callbackContext.success(response.getMessage());
                            } else {
                                callbackContext.success(response.getMessage());
                            }
                        }
                    });
                }
                catch (JSONException jsonException){
                    callbackContext.error(jsonException.toString());
                }
            }
        });
    }
    public void validateCard(final String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        Payment.overrideApiBase(Payment.QA_API_BASE); // used to override the payment api base url.
        Passport.overrideApiBase(Passport.QA_API_BASE); //used to override the payment api base url.

        context = cordova.getActivity().getApplicationContext();
        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                final RequestOptions options = RequestOptions.builder().setClientId("IKIA14BAEA0842CE16CA7F9FED619D3ED62A54239276").setClientSecret("Z3HnVfCEadBLZ8SYuFvIQG52E472V3BQLh4XDKmgM2A=").build();
                try{
                    ValidateCardRequest request = new ValidateCardRequest(); // Setup request parameters
                    request.setPan(args.getString(0)); //Card No or Token
                    request.setPinData(args.getString(1)); // Optional Card PIN for card payment
                    request.setCvv2(args.getString(2));
                    request.setTransactionRef(RandomString.numeric(12));
                    request.setExpiryDate(args.getString(3));
                    request.setCustomerId("1234567890");
                    new PaymentSDK(context,options).validateCard(request, new IswCallback<ValidateCardResponse>() {
                        @Override
                        public void onError(Exception error) {
                            callbackContext.error(error.getMessage());
                            Log.d("Error", "Cordova Test: error");
                        }

                        @Override
                        public void onSuccess(ValidateCardResponse response) {
                            // Check if OTP is required.
                            if (StringUtils.hasText(response.getOtpTransactionIdentifier())) {
                                Log.d("OTP", "Cordova Test: required otp");
                                callbackContext.success(response.getMessage());

                            } else {
                                Log.d("No OTP", "Cordova Test: does not required otp");
                                callbackContext.success(response.getMessage());
                            }
                        }
                    });
                }
                catch (JSONException jsonException){
                    Log.d("Exception was caught","Cordova Test: exeception was caught");
                    callbackContext.error(jsonException.toString());
                }
            }
        });
    }
    public void loadWallet(final String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        Payment.overrideApiBase(Payment.QA_API_BASE); // used to override the payment api base url.
        Passport.overrideApiBase(Passport.QA_API_BASE); //used to override the payment api base url.

        context = cordova.getActivity().getApplicationContext();
        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                final RequestOptions options = RequestOptions.builder().setClientId("IKIA14BAEA0842CE16CA7F9FED619D3ED62A54239276").setClientSecret("Z3HnVfCEadBLZ8SYuFvIQG52E472V3BQLh4XDKmgM2A=").build();
                final WalletRequest request = new WalletRequest();
                try{
                    request.setTransactionRef(args.getString(0));
                    new WalletSDK(context, options).getPaymentMethods(request, new IswCallback<WalletResponse>() {
                        @Override
                        public void onError(Exception error) {
                            callbackContext.error(error.getMessage());
                        }

                        @Override
                        public void onSuccess(WalletResponse response) {
                            PaymentMethod[] paymentMethods = response.getPaymentMethods();
                            String[] paymentResponse = new String[paymentMethods.length];
                            for (int i = 0; i < paymentMethods.length; i++) {
                                paymentResponse[i] = paymentMethods[i].toString();
                            }
                            callbackContext.success(convertToJSONArray(paymentResponse));
                        }
                    });
                }
                catch (JSONException jsonException){
                    callbackContext.error(jsonException.toString());
                }
            }
        });
    }
    public void pay(final String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        Payment.overrideApiBase(Payment.QA_API_BASE); // used to override the payment api base url.
        Passport.overrideApiBase(Passport.QA_API_BASE); //used to override the payment api base url.
        activity = this.cordova.getActivity();
        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                try {
                    final RequestOptions options = RequestOptions.builder().setClientId("IKIA14BAEA0842CE16CA7F9FED619D3ED62A54239276").setClientSecret("Z3HnVfCEadBLZ8SYuFvIQG52E472V3BQLh4XDKmgM2A=").build();
                    Pay pay = new Pay(activity, "1234567890", "Pay for ball", args.getString(0), "NGN", options, new IswCallback<PurchaseResponse>() {
                        @Override
                        public void onError(Exception error) {
                            callbackContext.error(error.getMessage());
                        }

                        @Override
                        public void onSuccess(PurchaseResponse response) {
                            callbackContext.success(response.getTransactionIdentifier());
                        }
                    });
                    pay.start();
                }
                catch (JSONException jsonException){
                    callbackContext.error(jsonException.toString());
                }
            }
        });
    }
    public void payWithCard(final String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        Payment.overrideApiBase(Payment.QA_API_BASE); // used to override the payment api base url.
        Passport.overrideApiBase(Passport.QA_API_BASE); //used to override the payment api base url.
        activity = this.cordova.getActivity();
        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                try {
                    final RequestOptions options = RequestOptions.builder().setClientId("IKIA14BAEA0842CE16CA7F9FED619D3ED62A54239276").setClientSecret("Z3HnVfCEadBLZ8SYuFvIQG52E472V3BQLh4XDKmgM2A=").build();
                    PayWithCard pay = new PayWithCard(activity, "1234567890", "Pay for gown", args.getString(0), "NGN", options, new IswCallback<PurchaseResponse>() {
                        @Override
                        public void onError(Exception error) {
                            callbackContext.error(error.getMessage());
                        }

                        @Override
                        public void onSuccess(PurchaseResponse response) {
                            callbackContext.success(response.getTransactionIdentifier());
                        }
                    });
                    pay.start();
                }
                catch (JSONException jsonException){
                    callbackContext.error(jsonException.toString());
                }
            }
        });
    }
    public void payWithWallet(final String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        Payment.overrideApiBase(Payment.QA_API_BASE); // used to override the payment api base url.
        Passport.overrideApiBase(Passport.QA_API_BASE); //used to override the payment api base url.
        activity = this.cordova.getActivity();
        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                try {
                    final RequestOptions options = RequestOptions.builder().setClientId("IKIA14BAEA0842CE16CA7F9FED619D3ED62A54239276").setClientSecret("Z3HnVfCEadBLZ8SYuFvIQG52E472V3BQLh4XDKmgM2A=").build();
                    PayWithWallet payWithWallet = new PayWithWallet(activity, "1234567890", "Pay for gown", args.getString(0), "NGN", options, new IswCallback<PurchaseResponse>() {
                        @Override
                        public void onError(Exception error) {
                            callbackContext.error(error.getMessage());
                        }

                        @Override
                        public void onSuccess(PurchaseResponse response) {
                            callbackContext.success(response.getTransactionIdentifier());
                        }
                    });
                    payWithWallet.start();
                }
                catch (JSONException jsonException){
                    callbackContext.error(jsonException.toString());
                }
            }
        });
    }

    public JSONArray convertToJSONArray(String[] paymentMethods){
        JSONArray jsonArray = new JSONArray(Arrays.asList(paymentMethods));
        return jsonArray;
    }
}