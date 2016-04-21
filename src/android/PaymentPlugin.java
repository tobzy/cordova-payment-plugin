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
import com.interswitchng.sdk.payment.PurchaseClient;
import com.interswitchng.sdk.payment.android.PassportSDK;
import com.interswitchng.sdk.payment.model.ValidateCardResponse;
import com.interswitchng.sdk.payment.android.inapp.Pay;
import com.interswitchng.sdk.payment.android.inapp.PayWithCard;
import com.interswitchng.sdk.payment.android.inapp.ValidateCard;
import com.interswitchng.sdk.payment.android.inapp.PayWithWallet;
import com.interswitchng.sdk.payment.android.inapp.LoginCredentials;
import com.interswitchng.sdk.payment.android.util.Util;
import com.interswitchng.sdk.util.StringUtils;
import com.interswitchng.sdk.util.RandomString;
import com.interswitchng.sdk.payment.model.PurchaseResponse;
import com.interswitchng.sdk.payment.model.PurchaseRequest;
import com.interswitchng.sdk.payment.model.PaymentMethod;
import com.interswitchng.sdk.model.User;
import com.interswitchng.sdk.model.UserInfoRequest;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;

import java.lang.Double;
import java.lang.Exception;
import java.lang.Override;
import java.lang.Runnable;
import java.lang.String;
import java.util.Arrays;
import java.util.Objects;

import com.google.gson.Gson;

/**
 * @author Babajide.Apata
 * @description Expose the Payment to Cordova JavaScript Applications
 */

public class PaymentPlugin extends CordovaPlugin  {
	public PaymentPlugin() {
    }
    private String clientId;
    private String clientSecret;

    private Activity activity;
    private Context context;
    private Button payWithCard;
    private static RequestOptions options;
    private IswCallback<LoginCredentials> callback;


    //final RequestOptions options = RequestOptions.builder().setClientId(this.clientId).setClientSecret(this.clientSecret).build();

    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
		super.initialize(cordova, webView);
        activity =  cordova.getActivity();
	}
	public boolean execute(final String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        final PayWithOutUI payWithOutUI = new PayWithOutUI(activity,clientId,clientSecret);
        if (action.equals("Init")) {
            cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    try {
                        init(args, callbackContext);
                    } catch (Exception ex) {
                        callbackContext.error(ex.toString());
                    }
                }
            });
            return true;
        }
        else if(action.equals("AuthorizeOTP")){
            cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    try {
                        payWithOutUI.authorizeOtp(action, args, callbackContext); //asyncronous call
                    } catch (Exception error) {
                        callbackContext.error(error.toString());
                    }
                    // Call the success function of the .js file
                }
            });
            return true;
        }
        else if(action.equals("MakePayment")){
            cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    try {
                        payWithOutUI.makePayment(action, args, callbackContext); //asyncronous call
                    } catch (Exception error) {
                        callbackContext.error(error.toString());
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
                        payWithOutUI.loadWallet(action, callbackContext); //asyncronous call
                    }
                    catch (Exception error){
                        callbackContext.error(error.toString());
                    }
                    // Call the success function of the .js file
                }
            });
            return true;
        }
        else if(action.equals("ValidatePaymentCard")){
            cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    try {
                        validatePaymentCard(action, args, callbackContext); //asyncronous call
                    }
                    catch (Exception error){
                        callbackContext.error(error.toString());
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
                        payWithOutUI.validateCard(action, args, callbackContext); //asyncronous call
                    }
                    catch (Exception error){
                        callbackContext.error(error.toString());
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
                    catch (Exception error){
                        callbackContext.error(error.toString());
                    }
                    // Call the success function of the .js file
                }
            });
            return true;
        }
        else if(action.equals("PayWithToken")){
            cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    try {
                        payWithOutUI.payWithToken(action, args, callbackContext); //asyncronous call
                    }
                    catch (Exception error){
                        callbackContext.error(error.toString());
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
                    catch (Exception error){
                        callbackContext.error(error.toString());
                    }
                    // Call the success function of the .js file
                }
            });
            return true;
        }
        else if(action.equals("PayWithWallet")){
            cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    try {
                        payWithWallet(action, args, callbackContext); //asyncronous call
                    }
                    catch (Exception error){
                        callbackContext.error(error.toString());
                    }
                    // Call the success function of the .js file
                }
            });
            return true;
        }
        else if(action.equals("PayWithWalletSDK")){
            cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    try {
                        payWithOutUI.payWithWalletSDK(action, args, callbackContext); //asyncronous call
                    }
                    catch (Exception error){
                        callbackContext.error(error.toString());
                    }
                    // Call the success function of the .js file
                }
            });
            return true;
        }
        else if(action.equals("PaymentStatus")){
            cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    try {
                        payWithOutUI.paymentStatus(action, args, callbackContext); //asyncronous call
                    }
                    catch (Exception error){
                        callbackContext.error(error.toString());
                    }
                    // Call the success function of the .js file
                }
            });
            return true;
        }
        else if(action.equals("UserInformation")){
            cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    try {
                        userInformation(action, args, callbackContext); //asyncronous call
                    }
                    catch (Exception error){
                        callbackContext.error(error.toString());
                    }
                    // Call the success function of the .js file
                }
            });
            return true;
        }
        return false;
    }




    public void pay(final String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        activity = this.cordova.getActivity();
        activity.runOnUiThread(new Runnable() {
            public void run() {
                try {
                    JSONObject params = args.getJSONObject(0);
                    String customerId = params.getString("customerId");
                    String currency = params.getString("currency");
                    String description = params.getString("description");
                    String amount = params.getString("amount");
                    Pay pay = new Pay(activity, customerId, description, amount, currency, options, new IswCallback<PurchaseResponse>() {
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
                } catch (Exception ex) {
                    callbackContext.error(ex.toString());
                }
            }
        });
    }
    public void payWithCard(final String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        activity = this.cordova.getActivity();
        activity.runOnUiThread(new Runnable() {
            public void run() {
                try {
                    options = RequestOptions.builder().setClientId(clientId).setClientSecret(clientSecret).build();
                    JSONObject params = args.getJSONObject(0);
                    String customerId = params.getString("customerId");
                    String currency = params.getString("currency");
                    String description = params.getString("description");
                    String amount = params.getString("amount");
                    PayWithCard pay = new PayWithCard(activity, customerId, description, amount, currency, options, new IswCallback<PurchaseResponse>() {
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
                } catch (Exception ex) {
                    callbackContext.error(ex.toString());
                }
            }
        });
    }
    public void payWithWallet(final String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        activity = this.cordova.getActivity();
        activity.runOnUiThread(new Runnable() {
            public void run() {
                try {
                    options = RequestOptions.builder().setClientId(clientId).setClientSecret(clientSecret).build();
                    JSONObject params = args.getJSONObject(0);
                    String customerId = params.getString("customerId");
                    String currency = params.getString("currency");
                    String description = params.getString("description");
                    String amount = params.getString("amount");
                    PayWithWallet payWithWallet = new PayWithWallet(activity, customerId, description, amount, currency, options, new IswCallback<PurchaseResponse>() {
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
                } catch (Exception ex) {
                    callbackContext.error(ex.toString());
                }
            }
        });
    }

    public void validatePaymentCard(final String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        activity = this.cordova.getActivity();
        activity.runOnUiThread(new Runnable() {
            public void run() {
                try {
                    JSONObject params = args.getJSONObject(0);
                    String customerId = params.getString("customerId");
                    options = RequestOptions.builder().setClientId(clientId).setClientSecret(clientSecret).build();
                    ValidateCard validateCard = new ValidateCard(activity, customerId, options, new IswCallback<ValidateCardResponse>() {
                        @Override
                        public void onError(Exception error) {
                            callbackContext.error(error.getMessage());
                        }

                        @Override
                        public void onSuccess(ValidateCardResponse response) {
                            callbackContext.sendPluginResult(PluginUtils.getPluginResult(callbackContext, response));
                        }
                    });
                    validateCard.start();
                } catch (Exception error) {
                    callbackContext.error(error.toString());
                }
            }
        });
    }

    public void userInformation(final String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        activity = this.cordova.getActivity();
        activity.runOnUiThread(new Runnable() {
            public void run() {
                try {
                    options = RequestOptions.builder().setClientId(clientId).setClientSecret(clientSecret).build();
                    final LoginCredentials loginCredentials = new LoginCredentials();
                    loginCredentials.setUsername(args.getString(0));
                    loginCredentials.setPassword(args.getString(1));
                    UserInfoRequest userInfoRequest = new UserInfoRequest();
                    userInfoRequest.setUsername(loginCredentials.getUsername());
                    new PassportSDK(activity, options).getUserInfo(userInfoRequest, new IswCallback<User>() {

                        @Override
                        public void onError(Exception error) {
                            callbackContext.error(error.getMessage());
                        }

                        @Override
                        public void onSuccess(final User response) {
                            if (response.getVerifiedMobileNo() == null) {
                                //Send OTP
                                new PassportSDK(activity, options).sendMobileOtp(response, new IswCallback<Object>() {
                                    @Override
                                    public void onError(Exception error) {
                                        callbackContext.error(error.getMessage());
                                    }

                                    @Override
                                    public void onSuccess(Object otpResponse) {
                                        callbackContext.sendPluginResult(PluginUtils.getPluginResult(callbackContext, otpResponse));
                                    }
                                });
                            } else {
                                callbackContext.sendPluginResult(PluginUtils.getPluginResult(callbackContext, response));
                            }
                        }
                    });
                } catch (Exception error) {
                    callbackContext.error(error.toString());
                }
            }
        });
    }
    private void init(JSONArray args, CallbackContext callbackContext) {
        try{
            if (args != null && args.length() > 0) {
                JSONObject params = args.getJSONObject(0);
                this.clientId=params.getString("clientId");
                this.clientSecret=params.getString("clientSecret");
                String paymentApi = params.getString("paymentApi");
                String passportApi = params.getString("passportApi");
                if( (paymentApi != null && paymentApi.length()>0) && (passportApi != null && passportApi.length()>0)){
                    Payment.overrideApiBase(params.getString("paymentApi")); // used to override the payment api base url.
                    Passport.overrideApiBase(params.getString("passportApi"));
                }
                options = RequestOptions.builder().setClientId(this.clientId).setClientSecret(this.clientSecret).build();
                callbackContext.success("Initialization was successfull");
            } else {
                callbackContext.error("Invalid ClientId or Client Secret : ");
            }
        }
        catch (JSONException jsonException){
            callbackContext.error(jsonException.toString());
        }
    }

}