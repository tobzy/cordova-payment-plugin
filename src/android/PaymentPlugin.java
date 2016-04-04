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

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;

import java.lang.Exception;
import java.lang.Override;
import java.lang.Runnable;

public class PaymentPlugin extends CordovaPlugin {
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
        if(action.equals("LoadWallet")){
            cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    try {
                        loadWallet(action, callbackContext); //asyncronous call
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
        payWithCard = new Button (cordova.getActivity());
        Payment.overrideApiBase(Payment.QA_API_BASE); // used to override the payment api base url.
        Passport.overrideApiBase(Passport.QA_API_BASE); //used to override the payment api base url.
        Util.hideProgressDialog();
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
    public void loadWallet(final String action, final CallbackContext callbackContext) throws JSONException{
        context = cordova.getActivity().getApplicationContext();
        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                final RequestOptions options = RequestOptions.builder().setClientId("IKIA14BAEA0842CE16CA7F9FED619D3ED62A54239276").setClientSecret("Z3HnVfCEadBLZ8SYuFvIQG52E472V3BQLh4XDKmgM2A=").build();
                final WalletRequest request = new WalletRequest();
                request.setTransactionRef(RandomString.numeric(12));
                new WalletSDK(context, options).getPaymentMethods(request, new IswCallback<WalletResponse>() {
                    @Override
                    public void onError(Exception error) {
                        callbackContext.error(error.getMessage());
                    }
                    @Override
                    public void onSuccess(WalletResponse response) {
                        PaymentMethod[] paymentMethods = response.getPaymentMethods();
                        callbackContext.success(paymentMethods.length);
                    }
                });
            }
        });
    }
}