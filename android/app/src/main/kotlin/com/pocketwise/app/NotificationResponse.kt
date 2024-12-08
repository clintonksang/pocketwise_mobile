package com.pocketwise.app

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import android.util.Log
import android.content.Intent

class NotificationResponse : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Uncomment and add your layout if you have one
        // setContentView(R.layout.activity_notification_response)

        // Extract data from intent
        intent?.extras?.let { bundle ->
            val action = bundle.getString("action", "No action")
            val amount = bundle.getString("amount", "No amount")
            val sender = bundle.getString("sender", "No sender")

            // Log the details to Logcat
            Log.d("NotificationResponse", "Received action: $action")
            Log.d("NotificationResponse", "Amount: $amount")
            Log.d("NotificationResponse", "Sender: $sender")
        }
    }
}
