package com.pocketwise.app

import android.app.NotificationManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

class ExpenseNotificationAction : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.getStringExtra("action") ?: "Unknown action"
        val amount = intent.getStringExtra("amount") ?: "Unknown amount"
        val sender = intent.getStringExtra("sender") ?: "Unknown sender"

        Log.d(
                "ExpenseNotificationAction",
                "Received action: $action, Amount: $amount, Sender: $sender"
        )

        // Dismiss the notification
        val notificationManager =
                context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.cancel(2) // Assuming 2 is the ID for expense notifications
    }
    
}
