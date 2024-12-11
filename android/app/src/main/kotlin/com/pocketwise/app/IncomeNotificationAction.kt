package com.pocketwise.app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import android.app.NotificationManager

class NotificationActionReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.getStringExtra("action")
        val amount = intent.getStringExtra("amount")
        val sender = intent.getStringExtra("sender")

        when (action) {
            "yes" -> Log.d("NotificationAction", "Yes clicked: Amount - $amount, Sender - $sender")
            "no" -> Log.d("NotificationAction", "No clicked: Amount - $amount, Sender - $sender")
        }

        // Dismiss the notification after action
        val notificationManager: NotificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.cancel(1)  // Assuming notification ID is 1
    }
}
