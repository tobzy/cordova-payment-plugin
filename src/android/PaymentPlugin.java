import org.apache.cordova.CordovaWebView;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.PluginResult;

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
import com.interswitchng.sdk.payment.android.PaymentSDK;
import com.interswitchng.sdk.payment.android.PassportSDK;
import com.interswitchng.sdk.payment.android.WalletSDK;
import com.interswitchng.sdk.payment.android.inapp.Pay;
import com.interswitchng.sdk.payment.android.inapp.PayWithCard;
import com.interswitchng.sdk.payment.android.inapp.ValidateCard;
import com.interswitchng.sdk.payment.android.inapp.PayWithWallet;
import com.interswitchng.sdk.payment.android.inapp.PayWithToken;
import com.interswitchng.sdk.payment.android.inapp.LoginCredentials;
import com.interswitchng.sdk.payment.android.util.Util;
import com.interswitchng.sdk.util.StringUtils;
import com.interswitchng.sdk.util.RandomString;
import com.interswitchng.sdk.payment.model.PurchaseResponse;
import com.interswitchng.sdk.payment.model.PurchaseRequest;
import com.interswitchng.sdk.payment.model.PaymentStatusResponse;
import com.interswitchng.sdk.payment.model.WalletResponse;
import com.interswitchng.sdk.payment.model.WalletRequest;
import com.interswitchng.sdk.payment.model.PaymentMethod;
import com.interswitchng.sdk.payment.model.ValidateCardRequest;
import com.interswitchng.sdk.payment.model.ValidateCardResponse;
import com.interswitchng.sdk.payment.model.AuthorizeOtpRequest;
import com.interswitchng.sdk.payment.model.AuthorizeOtpResponse;
import com.interswitchng.sdk.model.User;
import com.interswitchng.sdk.model.UserInfoRequest;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;
import android.util.Log;

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
        Payment.overrideApiBase(Payment.QA_API_BASE); // used to override the payment api base url.
        Passport.overrideApiBase(Passport.QA_API_BASE); //used to override the payment api base url.
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
	}
	public boolean execute(final String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException {

        if(action.equals("Init")){
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
                        authorizeOtp(action, args, callbackContext); //asyncronous call
                    } catch (Exception exception) {
                        callbackContext.error(exception.toString());
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
                        makePayment(action, args, callbackContext); //asyncronous call
                    } catch (JSONException jsonException) {
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
        else if(action.equals("ValidatePaymentCard")){
            cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    try {
                        validatePaymentCard(action, args, callbackContext); //asyncronous call
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
        else if(action.equals("PayWithToken")){
            cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    try {
                        payWithToken(action, args, callbackContext); //asyncronous call
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
        else if(action.equals("PayWithWallet")){
            cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    try {
                        payWithWallet(action, args, callbackContext); //asyncronous call
                    }
                    catch (JSONException jsonException){
                        callbackContext.error(jsonException.toString());
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
                        payWithWalletSDK(action, args, callbackContext); //asyncronous call
                    }
                    catch (JSONException jsonException){
                        callbackContext.error(jsonException.toString());
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
                        paymentStatus(action, args, callbackContext); //asyncronous call
                    }
                    catch (JSONException jsonException){
                        callbackContext.error(jsonException.toString());
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
        context = cordova.getActivity().getApplicationContext();
        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                try {
                    options = RequestOptions.builder().setClientId(clientId).setClientSecret(clientSecret).build();
                    JSONObject params = args.getJSONObject(0);
                    PurchaseRequest request = new PurchaseRequest(); // Setup request parameters
                    request.setPan(params.getString("pan")); //Card No or Token
                    request.setAmount(params.getString("amount")); // Amount in Naira
                    request.setCvv2(params.getString("cvv"));
                    request.setPinData(params.getString("pin")); // Optional Card PIN for card payment
                    request.setTransactionRef(RandomString.numeric(12));
                    request.setExpiryDate(params.getString("expiryDate"));
                    request.setCustomerId(params.getString("customerId"));
                    request.setCurrency("NGN");
                    new PaymentSDK(context, options).purchase(request, new IswCallback<PurchaseResponse>() {
                        @Override
                        public void onError(Exception error) {
                            callbackContext.error(error.getMessage());
                        }

                        @Override
                        public void onSuccess(PurchaseResponse response) {
                            if (StringUtils.hasText(response.getOtpTransactionIdentifier())) {

                                callbackContext.sendPluginResult(PluginUtils.getPluginResult(callbackContext, response));

                            } else {
                                callbackContext.sendPluginResult(PluginUtils.getPluginResult(callbackContext, response));
                            }
                        }
                    });
                } catch (JSONException jsonException) {
                    callbackContext.error(jsonException.toString());
                }
            }
        });
    }
    public void validateCard(final String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        context = cordova.getActivity().getApplicationContext();
        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                try{
                    options = RequestOptions.builder().setClientId(clientId).setClientSecret(clientSecret).build();
                    JSONObject params = args.getJSONObject(0);
                    ValidateCardRequest request = new ValidateCardRequest(); // Setup request parameters
                    request.setPan(params.getString("pan")); //Card No or Token
                    request.setPinData(params.getString("pin")); // Optional Card PIN for card payment
                    request.setCvv2(params.getString("cvv"));
                    request.setTransactionRef(RandomString.numeric(12));
                    request.setExpiryDate(params.getString("expiryDate"));
                    request.setCustomerId(params.getString("customerId"));
                    new PaymentSDK(context, options).validateCard(request, new IswCallback<ValidateCardResponse>() {
                        @Override
                        public void onError(Exception error) {
                            callbackContext.error(error.getMessage());
                        }

                        @Override
                        public void onSuccess(ValidateCardResponse response) {
                            // Check if OTP is required.
                            try {
                                if (StringUtils.hasText(response.getOtpTransactionIdentifier())) {
                                    callbackContext.sendPluginResult(PluginUtils.getPluginResult(callbackContext, response));
                                } else {
                                    callbackContext.sendPluginResult(PluginUtils.getPluginResult(callbackContext, response));
                                }
                            } catch (Exception ex) {
                                callbackContext.error(ex.getMessage());
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

    public void loadWallet(final String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        context = cordova.getActivity().getApplicationContext();
        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                final WalletRequest request = new WalletRequest();
                try {
                    options = RequestOptions.builder().setClientId(clientId).setClientSecret(clientSecret).build();
                    request.setTransactionRef(RandomString.numeric(12));
                    new WalletSDK(context, options).getPaymentMethods(request, new IswCallback<WalletResponse>() {
                        @Override
                        public void onError(Exception error) {
                            callbackContext.error(error.getMessage());
                        }

                        @Override
                        public void onSuccess(WalletResponse response) {
                            callbackContext.sendPluginResult(PluginUtils.getPluginResult(callbackContext, response));
                        }
                    });
                }
                catch (Exception ex){
                    callbackContext.error(ex.toString());
                }
            }
        });
    }
    public void pay(final String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        activity = this.cordova.getActivity();
        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                try {
                   JSONObject params = args.getJSONObject(0);
                   String customerId = params.getString("customerId");
                   String currency  ="NGN";
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
                }
                catch (JSONException jsonException){
                    callbackContext.error(jsonException.toString());
                }
            }
        });
    }
    public void payWithCard(final String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        activity = this.cordova.getActivity();
        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                try {
                    options = RequestOptions.builder().setClientId(clientId).setClientSecret(clientSecret).build();
                    JSONObject params = args.getJSONObject(0);
                    String customerId = params.getString("customerId");
                    String currency  ="NGN";
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
                }
                catch (JSONException jsonException){
                    callbackContext.error(jsonException.toString());
                }
            }
        });
    }
    public void payWithWallet(final String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        activity = this.cordova.getActivity();
        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                try {
                    options = RequestOptions.builder().setClientId(clientId).setClientSecret(clientSecret).build();
                    JSONObject params = args.getJSONObject(0);
                    String customerId = params.getString("customerId");
                    String currency  ="NGN";
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
                }
                catch (JSONException jsonException){
                    callbackContext.error(jsonException.toString());
                }
            }
        });
    }
    public void payWithWalletSDK(final String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        context = cordova.getActivity().getApplicationContext();
        activity = this.cordova.getActivity();
        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                try {
                    options = RequestOptions.builder().setClientId(clientId).setClientSecret(clientSecret).build();
                    final PurchaseRequest request = new PurchaseRequest();
                    JSONObject params = args.getJSONObject(0);
                    request.setCustomerId(params.getString("customerId"));
                    request.setAmount(params.getString("amount"));
                    if (params.getString("pan") == null) {
                        callbackContext.error("Error : No wallet item selected");
                        return;
                    }
                    request.setPan(params.getString("pan"));
                    request.setPinData(params.getString("pin"));
                    request.setRequestorId(params.getString("requestorId"));
                    request.setCurrency("NGN");
                    request.setTransactionRef(RandomString.numeric(12));

                    new WalletSDK(context, options).purchase(request, new IswCallback<PurchaseResponse>() {

                        @Override
                        public void onError(Exception error) {
                            callbackContext.error(error.getMessage());
                        }

                        @Override
                        public void onSuccess(PurchaseResponse response) {
                            String transactionIdentifier = response.getTransactionIdentifier();
                            if (StringUtils.hasText(response.getOtpTransactionIdentifier())) {
                                //String otpTransactionIdentifier = response.getOtpTransactionIdentifier();
                                callbackContext.sendPluginResult(PluginUtils.getPluginResult(callbackContext, response));

                            } else {
                                callbackContext.sendPluginResult(PluginUtils.getPluginResult(callbackContext, response));
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
    public void payWithToken(final String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        activity = this.cordova.getActivity();
        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                try {
                    options = RequestOptions.builder().setClientId(clientId).setClientSecret(clientSecret).build();
                    JSONObject params = args.getJSONObject(0);
                    String currency  ="NGN";
                    String token = params.getString("pan");
                    String amount = params.getString("amount");
                    String cardType = params.getString("cardtype");
                    String panLast4Digits = params.getString("panLast4Digits");
                    String expiryDate = params.getString("expiryDate");
                    String customerId = params.getString("customerId");
                    String description = params.getString("description");
                    PayWithToken payWithToken = new PayWithToken(activity, customerId, amount, token, expiryDate, currency, cardType, panLast4Digits, description, options, new IswCallback<PurchaseResponse>() {
                        @Override
                        public void onError(Exception error) {
                            callbackContext.error(error.getMessage());
                        }

                        @Override
                        public void onSuccess(PurchaseResponse response) {
                            callbackContext.success(response.getTransactionIdentifier());
                        }
                    });
                    payWithToken.start();
                }
                catch (JSONException jsonException){
                    callbackContext.error(jsonException.toString());
                }
            }
        });
    }
    public void validatePaymentCard(final String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        activity = this.cordova.getActivity();
        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                try {
                    JSONObject params = args.getJSONObject(0);
                    String customerId = params.getString("customerId");
                    options = RequestOptions.builder().setClientId(clientId).setClientSecret(clientSecret).build();
                    ValidateCard  validateCard = new ValidateCard (activity, customerId, options, new IswCallback<ValidateCardResponse>() {
                        @Override
                        public void onError(Exception error) {
                            callbackContext.error(error.getMessage());
                        }

                        @Override
                        public void onSuccess(ValidateCardResponse response) {
                            callbackContext.sendPluginResult(PluginUtils.getPluginResult(callbackContext,response));
                        }
                    });
                    validateCard.start();
                }
                catch (Exception error){
                    callbackContext.error(error.toString());
                }
            }
        });
    }
    public void paymentStatus(final String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        activity = this.cordova.getActivity();
        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                try {
                    options = RequestOptions.builder().setClientId(clientId).setClientSecret(clientSecret).build();
                    String transactionRef = args.getString(0);
                    String amount = args.getString(1);
                    callbackContext.success(transactionRef + "<>" + amount);// Update Payment Status
                }
                catch (Exception error){
                    callbackContext.error(error.toString());
                }
            }
        });
    }
    public void userInformation(final String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        activity = this.cordova.getActivity();
        cordova.getActivity().runOnUiThread(new Runnable() {
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
                }
                catch (Exception error){
                    callbackContext.error(error.toString());
                }
            }
        });
    }
    public JSONArray convertToJSONArray(String[] paymentMethods){
        JSONArray jsonArray = new JSONArray(Arrays.asList(paymentMethods));
        return jsonArray;
    }
    private void init(JSONArray args, CallbackContext callbackContext) {
        try{
            if (args != null && args.length() > 0) {
                JSONObject params = args.getJSONObject(0);
                this.clientId=params.getString("clientId");
                this.clientSecret=params.getString("clientSecret");
                Payment.overrideApiBase(Payment.QA_API_BASE); // used to override the payment api base url.
                Passport.overrideApiBase(Passport.QA_API_BASE);
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
    public void authorizeOtp(final String action, final JSONArray args, final CallbackContext callbackContext){
        activity = this.cordova.getActivity();
        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                try {
                    context = cordova.getActivity().getApplicationContext();
                    options = RequestOptions.builder().setClientId(clientId).setClientSecret(clientSecret).build();
                    JSONObject params = args.getJSONObject(0);
                    AuthorizeOtpRequest otpRequest = new AuthorizeOtpRequest();
                    otpRequest.setOtp(params.getString("otp")); // Accept OTP from user
                    otpRequest.setOtpTransactionIdentifier(params.getString("otpTransactionIdentifier")); // Set the OTP identifier for the request
                    otpRequest.setTransactionRef(params.getString("transactionRef")); // Set the unique transaction reference.
                    new PaymentSDK(context,options).authorizeOtp(otpRequest, new IswCallback<AuthorizeOtpResponse>() {
                        @Override
                        public void onError(Exception error) {
                            callbackContext.error(error.getMessage());
                        }
                        @Override
                        public void onSuccess(AuthorizeOtpResponse otpResponse) {
                            callbackContext.sendPluginResult(PluginUtils.getPluginResult(callbackContext, otpResponse));
                        }
                    });
                }
                catch (Exception error){
                    callbackContext.sendPluginResult(PluginUtils.getPluginResult(callbackContext, error.toString()));
                }
            }
        });
    }
}