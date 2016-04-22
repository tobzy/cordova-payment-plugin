import org.apache.cordova.CordovaWebView;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaInterface;

import com.interswitchng.sdk.payment.model.WalletResponse;
import com.interswitchng.sdk.payment.model.WalletRequest;
import com.interswitchng.sdk.payment.model.PurchaseResponse;
import com.interswitchng.sdk.payment.model.PurchaseRequest;
import com.interswitchng.sdk.util.RandomString;
import com.interswitchng.sdk.model.RequestOptions;
import com.interswitchng.sdk.payment.IswCallback;
import com.interswitchng.sdk.util.StringUtils;
import com.interswitchng.sdk.payment.android.PaymentSDK;
import com.interswitchng.sdk.payment.android.WalletSDK;
import com.interswitchng.sdk.payment.model.AuthorizeOtpRequest;
import com.interswitchng.sdk.payment.model.AuthorizeOtpResponse;
import com.interswitchng.sdk.payment.android.inapp.PayWithToken;

import com.interswitchng.sdk.payment.model.ValidateCardRequest;
import com.interswitchng.sdk.payment.model.ValidateCardResponse;
import com.interswitchng.sdk.payment.model.PaymentStatusResponse;
import com.interswitchng.sdk.payment.model.PaymentStatusRequest;

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

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class PayWithOutUI extends CordovaPlugin{
    private String clientId;
    private String clientSecret;

    private Activity activity;
    private Context context;

    private static RequestOptions options;
    public PayWithOutUI(Activity activity, String clientId, String clientSecret ){
        this.activity = activity;
        this.clientId = clientId;
        this.clientSecret = clientSecret;
    }
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
        activity =  cordova.getActivity();
    }
    public  void makePayment(final String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        context = activity.getApplicationContext();
        activity.runOnUiThread(new Runnable() {
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
                    request.setCurrency(params.getString("currency"));
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
                } catch (Exception ex) {
                    callbackContext.error(ex.toString());
                }
            }
        });
    }
    public  void loadWallet(final String action, final CallbackContext callbackContext) throws JSONException {
        context = activity.getApplicationContext();
        activity.runOnUiThread(new Runnable() {
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
                } catch (Exception ex) {
                    callbackContext.error(ex.toString());
                }
            }
        });
    }
    public void payWithToken(final String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        activity.runOnUiThread(new Runnable() {
            public void run() {
                try {
                    options = RequestOptions.builder().setClientId(clientId).setClientSecret(clientSecret).build();
                    JSONObject params = args.getJSONObject(0);
                    String currency = params.getString("currency");
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
                } catch (Exception ex) {
                    callbackContext.error(ex.toString());
                }
            }
        });
    }
    public void payWithWalletSDK(final String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        context = activity.getApplicationContext();
        activity.runOnUiThread(new Runnable() {
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
                    request.setCurrency(params.getString("currency"));
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
                } catch (Exception ex) {
                    callbackContext.error(ex.toString());
                }
            }
        });
    }
    public void validateCard(final String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        context = activity.getApplicationContext();
        activity.runOnUiThread(new Runnable() {
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
                catch (Exception ex){
                    callbackContext.error(ex.toString());
                }
            }
        });
    }
    public void authorizeOtp(final String action, final JSONArray args, final CallbackContext callbackContext){
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
                    new PaymentSDK(context, options).authorizeOtp(otpRequest, new IswCallback<AuthorizeOtpResponse>() {
                        @Override
                        public void onError(Exception error) {
                            callbackContext.error(error.getMessage());
                        }

                        @Override
                        public void onSuccess(AuthorizeOtpResponse otpResponse) {
                            callbackContext.sendPluginResult(PluginUtils.getPluginResult(callbackContext, otpResponse));
                        }
                    });
                } catch (Exception error) {
                    callbackContext.sendPluginResult(PluginUtils.getPluginResult(callbackContext, error.toString()));
                }
            }
        });
    }
    public void paymentStatus(final String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        context = activity.getApplicationContext();
        activity.runOnUiThread(new Runnable() {
            public void run() {
                try {
                    final PaymentStatusRequest request = new PaymentStatusRequest();
                    JSONObject params = args.getJSONObject(0);
                    String transactionRef = params.getString("transactionRef");
                    String amount = params.getString("amount");
                    request.setTransactionRef(transactionRef);
                    request.setAmount(amount);
                    options = RequestOptions.builder().setClientId(clientId).setClientSecret(clientSecret).build();
                    new PaymentSDK(context, options).paymentStatus(request, new IswCallback<PaymentStatusResponse>() {
                        @Override
                        public void onError(Exception error) {
                            callbackContext.error(error.getMessage()); // Handle and notify user of error
                        }

                        @Override
                        public void onSuccess(PaymentStatusResponse response) {
                            callbackContext.sendPluginResult(PluginUtils.getPluginResult(callbackContext, response));// Update Payment Status
                        }
                    });
                } catch (Exception error) {
                    callbackContext.error(error.toString());
                }
            }
        });
    }
}