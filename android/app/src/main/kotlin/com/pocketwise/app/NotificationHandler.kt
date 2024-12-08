package com.pocketwise.app

import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import androidx.core.app.NotificationCompat
import android.util.Log

class NotificationHandler(private val context: Context) {
    private val notificationManager: NotificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

    fun showIncomeNotification(amount: String, sender: String, question: String) {
        val intent = Intent(context, NotificationResponse::class.java).apply {
            putExtra("action", "income")
            putExtra("amount", amount)
            putExtra("sender", sender)
        }
        Log.d("NotificationHandler", "Notification initialized")
        Log.d("NotificationHandler", "Amount: $amount")
        Log.d("NotificationHandler", "Sender: $sender")

        val pendingIntent = PendingIntent.getActivity(
            context,
            0,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val notification = NotificationCompat.Builder(context, "income_expense_channel")
            .setSmallIcon(R.drawable.logo)
            .setContentTitle("Transaction Confirmation")
            .setContentText(question)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setContentIntent(pendingIntent)
            .addAction(R.drawable.logo, "Yes", pendingIntent)
            .addAction(R.drawable.logo, "No", pendingIntent)
            .build()

        notificationManager.notify(1, notification)
    }

    fun showExpenseNotification(amount: String, sender: String, question: String) {
        val intent = Intent(context, NotificationResponse::class.java).apply {
            putExtra("action", "expense")
            putExtra("amount", amount)
            putExtra("sender", sender)
        }
        // Log details
        Log.d("NotificationHandler", "Expense notification initialized")
        Log.d("NotificationHandler", "Amount: $amount")
        Log.d("NotificationHandler", "Sender: $sender")

        val pendingIntent = PendingIntent.getActivity(
            context,
            1,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val notification = NotificationCompat.Builder(context, "income_expense_channel")
            .setSmallIcon(R.drawable.logo)
            .setContentTitle("Categorize Expense")
            .setContentText(question)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setContentIntent(pendingIntent)
            .addAction(R.drawable.logo, "Needs", pendingIntent)
            .addAction(R.drawable.logo, "Wants", pendingIntent)
            .addAction(R.drawable.logo, "Savings", pendingIntent)
            .build()

        notificationManager.notify(2, notification)
    }
}
