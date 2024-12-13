package com.pocketwise.app

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.pocketwise.app/simulator"
    companion object {
        private var eventSink: EventChannel.EventSink? = null
        private const val SMS_PERMISSION_REQUEST_CODE = 101 // This is the line you're missing

        fun handleSMS(message: String) {
            eventSink?.success(message)
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, "sms_stream")
                .setStreamHandler(
                        object : EventChannel.StreamHandler {
                            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                                eventSink = events
                            }

                            override fun onCancel(arguments: Any?) {
                                eventSink = null
                            }
                        }
                )
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call,
                result ->
            if (call.method == "simulateTransaction") {
                val message = call.argument<String>("message")
                simulateTransaction(message, result)
            } else {
                result.notImplemented()
            }
        }
    }

    // ADDITIONAL FUNCTIONS TO PLAY AROUND
    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)
        createNotificationChannel()
        checkAndRequestPermissions()
        requestNotificationPermission()
        // simulateIncomingSMS()incomce
        simulateExpenseSMS() // exense
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val name = "Income Expense Channel"
            val descriptionText = "Notifications for income and expense management"
            val importance = NotificationManager.IMPORTANCE_HIGH
            val channel =
                    NotificationChannel("income_expense_channel", name, importance).apply {
                        description = descriptionText
                    }
            val notificationManager: NotificationManager =
                    getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }
    

    private fun checkAndRequestPermissions() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (checkSelfPermission(android.Manifest.permission.RECEIVE_SMS) !=
                            PackageManager.PERMISSION_GRANTED ||
                            checkSelfPermission(android.Manifest.permission.READ_SMS) !=
                                    PackageManager.PERMISSION_GRANTED
            ) {

                requestPermissions(
                        arrayOf(
                                android.Manifest.permission.RECEIVE_SMS,
                                android.Manifest.permission.READ_SMS
                        ),
                        SMS_PERMISSION_REQUEST_CODE
                )
            }
        }
    }

    private fun requestNotificationPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val permissionsToRequest = mutableListOf<String>()

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU &&
                            checkSelfPermission(android.Manifest.permission.POST_NOTIFICATIONS) !=
                                    PackageManager.PERMISSION_GRANTED
            ) {
                permissionsToRequest.add(android.Manifest.permission.POST_NOTIFICATIONS)
            }

            if (permissionsToRequest.isNotEmpty()) {
                requestPermissions(permissionsToRequest.toTypedArray(), SMS_PERMISSION_REQUEST_CODE)
            }
        }
    }
    // TODO: DELETE ALL THESE TWO IN PROD
    private fun simulateIncomingSMS() {
        // Simulating an SMS receive
        val simulatedMessage =
                "SL71JZ3A6D Confirmed.You have received Ksh400.00 from Absa Bank Kenya PLC. 303031 on 7/12/24 at 12:01 PM New M-PESA balance is Ksh454.87."
        val transactionHandler = TransactionHandler(this)
        transactionHandler.handleTransactionMessage(simulatedMessage)
    }
    private fun simulateExpenseSMS() {
        // Simulating an SMS receive
        val simulatedMessage =
                "SL72LA7S0G Confirmed. Ksh200.00 paid to GOOGLEMART  MINI  MARKET. on 7/12/24 at 5:05 PM.New M-PESA balance is Ksh0.00. Transaction cost, Ksh0.00. Amount you can transact within the day is 499,300.00. Download new M-PESA app on http://bit.ly/mpesappsm & get 500MB FREE data"
        val transactionHandler = TransactionHandler(this)
        transactionHandler.handleTransactionMessage(simulatedMessage)
    }
    private fun simulateTransaction(message: String?, result: MethodChannel.Result) {
        if (message != null) {
            println("Simulating transaction with message: $message")
            result.success("Transaction simulated with message: $message")
        } else {
            result.error("ERROR", "No message received for simulation.", null)
        }
    }
}
