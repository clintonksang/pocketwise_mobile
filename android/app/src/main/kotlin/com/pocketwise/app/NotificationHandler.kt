package com.pocketwise.app

import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.util.Log
import android.widget.RemoteViews
import androidx.core.app.NotificationCompat

class NotificationHandler(private val context: Context) {
    private val notificationManager: NotificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

    fun showIncomeNotification(amount: String, sender: String, question: String) {
        Log.d("NotificationHandler", "Notification initialized")
        Log.d("NotificationHandler", "Amount: $amount, Sender: $sender")

        // Setup the custom layout for the notification
        val notificationLayout = RemoteViews(context.packageName, R.layout.notification_income)
        notificationLayout.setTextViewText(R.id.notification_question, question)  // Set dynamic question text

        // Intent for "Yes" action
        val yesIntent = Intent(context, NotificationActionReceiver::class.java).apply {
            action = "com.pocketwise.app.YES_ACTION"
            putExtra("action", "yes")
            putExtra("amount", amount)
            putExtra("sender", sender)
        }
        val yesPendingIntent = PendingIntent.getBroadcast(context, 0, yesIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)

        // Intent for "No" action
        val noIntent = Intent(context, NotificationActionReceiver::class.java).apply {
            action = "com.pocketwise.app.NO_ACTION"
            putExtra("action", "no")
            putExtra("amount", amount)
            putExtra("sender", sender)
        }
        val noPendingIntent = PendingIntent.getBroadcast(context, 1, noIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)

        notificationLayout.setOnClickPendingIntent(R.id.yes_button, yesPendingIntent)
        notificationLayout.setOnClickPendingIntent(R.id.no_button, noPendingIntent)

        // Build the notification
        val notification = NotificationCompat.Builder(context, "income_expense_channel")
            .setSmallIcon(R.drawable.logo)  // Ensure this drawable resource exists
            .setStyle(NotificationCompat.DecoratedCustomViewStyle())
            .setCustomContentView(notificationLayout)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .build()

        // Issue the notification
        notificationManager.notify(1, notification)
    }
         fun showExpenseNotification(amount: String, sender: String, question: String) {
        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        // Create a base intent that will be used for all actions
        val baseIntent = Intent(context, NotificationResponse::class.java).apply {
            putExtra("amount", amount)
            putExtra("sender", sender)
        }

        // Each PendingIntent needs a unique requestCode
        val needsIntent = Intent(baseIntent).apply { putExtra("action", "Needs") }
        val wantsIntent = Intent(baseIntent).apply { putExtra("action", "Wants") }
        val savingsIntent = Intent(baseIntent).apply { putExtra("action", "Savings and Investments") }
        val debtIntent = Intent(baseIntent).apply { putExtra("action", "Debt") }

        val needsPendingIntent = PendingIntent.getActivity(context, 0, needsIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
        val wantsPendingIntent = PendingIntent.getActivity(context, 1, wantsIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
        val savingsPendingIntent = PendingIntent.getActivity(context, 2, savingsIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
        val debtPendingIntent = PendingIntent.getActivity(context, 3, debtIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)

        // Build the notification with multiple actions
        val notification = NotificationCompat.Builder(context, "income_expense_channel")
            .setSmallIcon(R.drawable.logo)
            .setContentTitle("Categorize Expense")
            .setContentText(question)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setContentIntent(needsPendingIntent)  // Default intent when the notification is clicked
            .addAction(R.drawable.logo, "Needs", needsPendingIntent)
            .addAction(R.drawable.logo, "Wants", wantsPendingIntent)
            .addAction(R.drawable.logo, "others", savingsPendingIntent)
            .build()

        // Issue the notification
        notificationManager.notify(2, notification)
    }
}



//ORIGINAL
//package com.pocketwise.app
//
//import android.app.NotificationManager
//import android.app.PendingIntent
//import android.content.Context
//import android.content.Intent
//import androidx.core.app.NotificationCompat
//import android.util.Log
//
//class NotificationHandler(private val context: Context) {
//    private val notificationManager: NotificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
//
//    fun showIncomeNotification(amount: String, sender: String, question: String) {
//        val intent = Intent(context, IncomeNotificationResponse::class.java).apply {
//            putExtra("action", "income")
//            putExtra("amount", amount)
//            putExtra("sender", sender)
//        }
//        Log.d("NotificationHandler", "Notification initialized")
//        Log.d("NotificationHandler", "Amount: $amount")
//        Log.d("NotificationHandler", "Sender: $sender")
//
//        val pendingIntent = PendingIntent.getActivity(
//            context,
//            0,
//            intent,
//            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
//        )
//
//        val notification = NotificationCompat.Builder(context, "income_expense_channel")
//            .setSmallIcon(R.drawable.logo)
//            .setContentTitle("Transaction Confirmation")
//            .setContentText(question)
//            .setPriority(NotificationCompat.PRIORITY_HIGH)
//            .setContentIntent(pendingIntent)
//            .addAction(R.drawable.logo, "Yes", pendingIntent)
//            .addAction(R.drawable.logo, "No", pendingIntent)
//            .build()
//
//        notificationManager.notify(1, notification)
//    }
//
//     fun showExpenseNotification(amount: String, sender: String, question: String) {
//        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
//
//        // Create a base intent that will be used for all actions
//        val baseIntent = Intent(context, NotificationResponse::class.java).apply {
//            putExtra("amount", amount)
//            putExtra("sender", sender)
//        }
//
//        // Each PendingIntent needs a unique requestCode
//        val needsIntent = Intent(baseIntent).apply { putExtra("action", "Needs") }
//        val wantsIntent = Intent(baseIntent).apply { putExtra("action", "Wants") }
//        val savingsIntent = Intent(baseIntent).apply { putExtra("action", "Savings and Investments") }
//        val debtIntent = Intent(baseIntent).apply { putExtra("action", "Debt") }
//
//        val needsPendingIntent = PendingIntent.getActivity(context, 0, needsIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
//        val wantsPendingIntent = PendingIntent.getActivity(context, 1, wantsIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
//        val savingsPendingIntent = PendingIntent.getActivity(context, 2, savingsIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
//        val debtPendingIntent = PendingIntent.getActivity(context, 3, debtIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
//
//        // Build the notification with multiple actions
//        val notification = NotificationCompat.Builder(context, "income_expense_channel")
//            .setSmallIcon(R.drawable.logo)
//            .setContentTitle("Categorize Expense")
//            .setContentText(question)
//            .setPriority(NotificationCompat.PRIORITY_HIGH)
//            .setContentIntent(needsPendingIntent)  // Default intent when the notification is clicked
//            .addAction(R.drawable.logo, "Needs", needsPendingIntent)
//            .addAction(R.drawable.logo, "Wants", wantsPendingIntent)
//            .addAction(R.drawable.logo, "others", savingsPendingIntent)
//            .build()
//
//        // Issue the notification
//        notificationManager.notify(2, notification)
//    }
//
//}
