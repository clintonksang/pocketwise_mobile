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

        if (action == "yes") {
            val transaction = TransactionModel(
                type = "income",
                amount = amount,
                sender = sender,
                category = "Income",
                hasAdded = true,
                userId = "$userId"
            )
            SaveToFirebase().saveTransaction(transaction)
            Log.d("IncomeNotificationAction", "Transaction saved: Action: $action, Amount: $amount, Sender: $sender, User ID: $userId")
        } else {
            Log.d("IncomeNotificationAction", "Transaction not saved: User declined")
        }

        // Dismiss the notification
        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.cancel(1)
    }
}
