package com.pocketwise.app

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.content.pm.PackageManager
import android.media.AudioAttributes
import android.net.Uri
import android.os.Build
import android.util.Log
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
    // original configureflutter engine
    // override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    //     super.configureFlutterEngine(flutterEngine)
    //     EventChannel(flutterEngine.dartExecutor.binaryMessenger, "sms_stream")
    //             .setStreamHandler(
    //                     object : EventChannel.StreamHandler {
    //                         override fun onListen(arguments: Any?, events:
    // EventChannel.EventSink) {
    //                             eventSink = events
    //                         }

    //                         override fun onCancel(arguments: Any?) {
    //                             eventSink = null
    //                         }
    //                     }
    //             )

    //     }
    // }
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Existing EventChannel setup
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, "sms_stream")
                .setStreamHandler(
                        object : EventChannel.StreamHandler {
                            override fun onListen(
                                    arguments: Any?,
                                    events: EventChannel.EventSink?
                            ) {
                                eventSink = events
                            }
                            override fun onCancel(arguments: Any?) {
                                eventSink = null
                            }
                        }
                )

        // Setup MethodChannel for simulation
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "simulateExpenseSMS" -> {
                    val userId = call.argument<String>("USERID") ?: "Unknown User"
                    Log.d("MainActivity", "Received simulateExpenseSMS call for user: $userId")
                    
                    // Save user ID and simulate SMS
                    saveUserId(userId)
                    simulateExpenseSMS(userId)
                    
                    result.success("Expense simulation triggered for User ID: $userId")
                }
                "clearUserId" -> {
                    Log.d("MainActivity", "Clearing user ID from native storage")
                    clearUserId()
                    result.success("User ID cleared successfully")
                }
                else -> {
                    Log.e("MainActivity", "Unknown method called: ${call.method}")
                    result.notImplemented()
                }
            }
        }
    }

    // ADDITIONAL FUNCTIONS TO PLAY AROUND
    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)
        createNotificationChannel()
        checkAndRequestPermissions()
        requestNotificationPermission()
        // simulateIncomingSMS()
        // simulateExpenseSMS() // exense
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val name = "Income Expense Channel"
            val descriptionText = "Notifications for income and expense management"
            val importance = NotificationManager.IMPORTANCE_HIGH
            val soundUri = Uri.parse("android.resource://${packageName}/raw/notification_tone")
            // Create an AudioAttributes instance.
            val audioAttributes =
                    AudioAttributes.Builder()
                            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                            .setUsage(AudioAttributes.USAGE_NOTIFICATION)
                            .build()
            val channel =
                    NotificationChannel("income_expense_channel", name, importance).apply {
                        description = descriptionText
                        setSound(soundUri, audioAttributes)
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
    private fun simulateIncomingSMS(userId: String) {
        // Simulating an SMS receive
        val simulatedMessage =
                "SL71JZ3A6D Confirmed.You have received Ksh400.00 from Absa Bank Kenya PLC. 303031 on 7/12/24 at 12:01 PM New M-PESA balance is Ksh454.87."
        val transactionHandler = TransactionHandler(this)
        transactionHandler.handleTransactionMessage(simulatedMessage)
        Log.d("MainActivity", "Simulated income SMS for User ID: $userId")
    }
    private fun simulateExpenseSMS(userId: String) {
        Log.d("MainActivity", "Starting to simulate expense SMS for user: $userId")
        try {
            // Simulating an SMS receive
            val simulatedMessage = "TKsh 1200.00 sent to KCB account ZEBAKI INVESTMENT LIMITED 7619486 has been received on 13/03/2025 at 11:18 AM. M-PESA Ref TCD9I8DXPH. Dial *844# to join Vooma."
            Log.d("MainActivity", "Simulated message created: $simulatedMessage")
            
            // Create TransactionHandler and process the message
            val transactionHandler = TransactionHandler(this)
            transactionHandler.handleTransactionMessage(simulatedMessage)
            
            Log.d("MainActivity", "Message processed and notification will be shown after AI response")
        } catch (e: Exception) {
            Log.e("MainActivity", "Error simulating expense SMS: ${e.message}")
            e.printStackTrace()
        }
    }
    fun saveUserId(userId: String) {
        val sharedPreferences = getSharedPreferences("AppPreferences", Context.MODE_PRIVATE)
        sharedPreferences.edit().apply {
            putString("userId", userId)
            apply()
        }
        Log.d("MainActivity", "User ID saved: $userId")
    }

    private fun clearUserId() {
        val sharedPreferences = getSharedPreferences("AppPreferences", Context.MODE_PRIVATE)
        sharedPreferences.edit().apply {
            remove("userId")
            apply()
        }
        Log.d("MainActivity", "User ID cleared from native storage")
    }

    private fun showNotification(userId: String) {
        Log.d("MainActivity", "Starting to show notification for user: $userId")
        try {
            val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            Log.d("MainActivity", "Notification manager obtained successfully")
            
            val notification = android.app.Notification.Builder(this, "income_expense_channel")
                .setContentTitle("New Transaction")
                .setContentText("Transaction processed for user: $userId")
                .setSmallIcon(android.R.drawable.ic_dialog_info)
                .setPriority(android.app.Notification.PRIORITY_HIGH)
                .setAutoCancel(true)
                .build()

            Log.d("MainActivity", "Notification built successfully")
            notificationManager.notify(System.currentTimeMillis().toInt(), notification)
            Log.d("MainActivity", "Notification shown successfully for user: $userId")
        } catch (e: Exception) {
            Log.e("MainActivity", "Error showing notification: ${e.message}")
            e.printStackTrace()
        }
    }

    // private fun simulateTransaction(message: String?, result: MethodChannel.Result) {
    //     if (message != null) {
    //         println("Simulating transaction with message: $message")
    //         result.success("Transaction simulated with message: $message")
    //     } else {
    //         result.error("ERROR", "No message received for simulation.", null)
    //     }
    // }
}
