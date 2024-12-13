package com.pocketwise.app

import android.app.NotificationManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

class IncomeNotificationAction : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val sharedPreferences = context.getSharedPreferences("AppPreferences", Context.MODE_PRIVATE)
        val userId = sharedPreferences.getString("userId", "Unknown User")

        val action = intent.getStringExtra("action") ?: "Unknown action"
        val amount = intent.getStringExtra("amount") ?: "Unknown amount"
        val sender = intent.getStringExtra("sender") ?: "Unknown sender"

        Log.d(
                "IncomeNotificationAction",
                "Received action: $action, Amount: $amount, Sender: $sender, User ID: $userId"
        )

        // Dismiss the notification
        val notificationManager =
                context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.cancel(1) // Assuming 1 is the ID for income notifications
    }
}
