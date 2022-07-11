package com.example.zezo


import android.content.Intent
import android.widget.Toast
import androidx.annotation.NonNull
import com.paymob.acceptsdk.*
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
      val CHANNEL = "com.flutter.paymobPayment/nativePayment"

    // Arbitrary number and used only in this activity. Change it as you wish.
    val ACCEPT_PAYMENT_REQUEST = 10
    private var _result: MethodChannel.Result? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        MethodChannel(getFlutterEngine()!!.dartExecutor.binaryMessenger,CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "startPaymentActivity") {
                val paymentKey = call.argument<String>("token")
                _result = result
                val pay_intent = Intent(this@MainActivity, PayActivity::class.java)
                putNormalExtras(pay_intent, paymentKey)
                pay_intent.putExtra(PayActivityIntentKeys.SAVE_CARD_DEFAULT, false)
                pay_intent.putExtra(PayActivityIntentKeys.SHOW_SAVE_CARD, false)
                pay_intent.putExtra(PayActivityIntentKeys.THEME_COLOR, resources.getColor(R.color.colorPrimary))
                pay_intent.putExtra("ActionBar", true)
                pay_intent.putExtra("language", "en")
                startActivityForResult(pay_intent, ACCEPT_PAYMENT_REQUEST)
                val secure_intent = Intent(this@MainActivity, ThreeDSecureWebViewActivty::class.java)
                secure_intent.putExtra("ActionBar", true)
            }
        }
    }
    private fun putNormalExtras(intent: Intent, paymentKey: String?) {
        intent.putExtra(PayActivityIntentKeys.PAYMENT_KEY, paymentKey)
        intent.putExtra(PayActivityIntentKeys.THREE_D_SECURE_ACTIVITY_TITLE, "Verification")
    }
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent) {
        super.onActivityResult(requestCode, resultCode, data)
        val extras = data.extras

        if (requestCode == ACCEPT_PAYMENT_REQUEST) {
            if (resultCode == IntentConstants.USER_CANCELED) {
                // User canceled and did no payment request was fired
                Toast.makeText(this,/*"mo1"+*/"User canceled!!",Toast.LENGTH_LONG).show()
                _result?.success("User canceled!!")
            } else if (resultCode == IntentConstants.MISSING_ARGUMENT) {
                // You forgot to pass an important key-value pair in the intent's extras
                Toast.makeText(this,/*"mo2"+*/"Missing Argument == " + extras!!.getString(IntentConstants.MISSING_ARGUMENT_VALUE),Toast.LENGTH_LONG).show()
                _result?.success("Missing Argument == " + extras!!.getString(IntentConstants.MISSING_ARGUMENT_VALUE))
            } else if (resultCode == IntentConstants.TRANSACTION_ERROR) {
                // An error occurred while handling an API's response
                Toast.makeText(this,/*"mo3"+*/extras!!.getString(IntentConstants.TRANSACTION_ERROR_REASON),Toast.LENGTH_LONG).show()

                _result?.success(extras!!.getString(IntentConstants.TRANSACTION_ERROR_REASON))
            } else if (resultCode == IntentConstants.TRANSACTION_REJECTED) {
                // User attempted to pay but their transaction was rejected
                Toast.makeText(this,/*"mo4"+*/extras!!.getString(PayResponseKeys.DATA_MESSAGE),Toast.LENGTH_LONG).show()
                _result?.success(extras!!.getString(PayResponseKeys.DATA_MESSAGE))
            } else if (resultCode == IntentConstants.TRANSACTION_REJECTED_PARSING_ISSUE) {
                // User attempted to pay but their transaction was rejected. An error occured while reading the returned JSON
               Toast.makeText(this,/*"mo5"+*/extras!!.getString(IntentConstants.RAW_PAY_RESPONSE),Toast.LENGTH_LONG).show()

                _result?.success(extras!!.getString(IntentConstants.RAW_PAY_RESPONSE))
            } else if (resultCode == IntentConstants.TRANSACTION_SUCCESSFUL) {
                // User finished their payment successfully
                Toast.makeText(this,/*"mo6"+*/"SUCCESS",Toast.LENGTH_LONG).show()

                _result?.success("SUCCESS")
            } else if (resultCode == IntentConstants.TRANSACTION_SUCCESSFUL_PARSING_ISSUE) {
                // User finished their payment successfully. An error occured while reading the returned JSON.
                _result?.success("TRANSACTION_SUCCESSFUL - Parsing Issue")
            } else if (resultCode == IntentConstants.TRANSACTION_SUCCESSFUL_CARD_SAVED) {
                // User finished their payment successfully and card was saved.
                _result?.success("SUCCESSFUL Token == " + extras!!.getString(SaveCardResponseKeys.TOKEN))
            } else if (resultCode == IntentConstants.USER_CANCELED_3D_SECURE_VERIFICATION) {
                ToastMaker.displayShortToast(this, "User canceled 3-d scure verification!!")
                _result?.success("User canceled 3-d scure verification!!")
            } else if (resultCode == IntentConstants.USER_CANCELED_3D_SECURE_VERIFICATION_PARSING_ISSUE) {
                ToastMaker.displayShortToast(this, "User canceled 3-d scure verification - Parsing Issue!!")
                _result?.success("User canceled 3-d scure verification - Parsing Issue!!")
            }
        }
    }
}