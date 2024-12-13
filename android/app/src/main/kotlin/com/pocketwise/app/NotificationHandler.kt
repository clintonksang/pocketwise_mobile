package com.pocketwise.app

import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.util.Log
import android.widget.RemoteViews
import androidx.core.app.NotificationCompat

class NotificationHandler(private val context: Context) {
    private val notificationManager: NotificationManager =
            context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

    fun showIncomeNotification(amount: String, sender: String, question: String) {
        Log.d("NotificationHandler", "Notification initialized")
        Log.d("NotificationHandler", "Amount: $amount, Sender: $sender")

        // Setup the custom layout for the notification
        val notificationLayout = RemoteViews(context.packageName, R.layout.notification_income)
        notificationLayout.setTextViewText(
                R.id.notification_question,
                question
        ) // Set dynamic question text

        // Intent for "Yes" action
        val yesIntent =
                Intent(context, IncomeNotificationAction::class.java).apply {
                    action = "com.pocketwise.app.YES_ACTION"
                    putExtra("action", "yes")
                    putExtra("amount", amount)
                    putExtra("sender", sender)
                }
        val yesPendingIntent =
                PendingIntent.getBroadcast(
                        context,
                        0,
                        yesIntent,
                        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )

        // Intent for "No" action
        val noIntent =
                Intent(context, IncomeNotificationAction::class.java).apply {
                    action = "com.pocketwise.app.NO_ACTION"
                    putExtra("action", "no")
                    putExtra("amount", amount)
                    putExtra("sender", sender)
                }
        val noPendingIntent =
                PendingIntent.getBroadcast(
                        context,
                        1,
                        noIntent,
                        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )

        notificationLayout.setOnClickPendingIntent(R.id.yes_button, yesPendingIntent)
        notificationLayout.setOnClickPendingIntent(R.id.no_button, noPendingIntent)

        // Build the notification
        val notification =
                NotificationCompat.Builder(context, "income_expense_channel")
                        .setSmallIcon(R.drawable.logo) // Ensure this drawable resource exists
                        .setStyle(NotificationCompat.DecoratedCustomViewStyle())
                        .setCustomContentView(notificationLayout)
                        .setPriority(NotificationCompat.PRIORITY_HIGH)
                        .build()

        // Issue the notification
        notificationManager.notify(1, notification)
    }
    fun showExpenseNotification(amount: String, sender: String, question: String) {
        Log.d("NotificationHandler", "Expense Notification initialized for $amount from $sender")

        // Setup the custom layout for the notification
        val notificationLayout = RemoteViews(context.packageName, R.layout.notification_expense)
        notificationLayout.setTextViewText(R.id.notification_question, question)

        // Define actions and their corresponding intents
        val actions = arrayOf("Needs", "Wants", "Savings", "Debt")
        actions.forEachIndexed { index, actionName ->
            val intent =
                    Intent(context, ExpenseNotificationAction::class.java).apply {
                        // Correctly set the action property of the Intent
                        this.action = "com.pocketwise.app.ACTION_$actionName"
                        putExtra(
                                "action",
                                actionName
                        ) // Keep the original action name for logging or processing
                        putExtra("amount", amount)
                        putExtra("sender", sender)
                    }
            val pendingIntent =
                    PendingIntent.getBroadcast(
                            context,
                            index, // Ensure unique request code
                            intent,
                            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                    )
            notificationLayout.setOnClickPendingIntent(
                    context.resources.getIdentifier(
                            "button_${actionName.toLowerCase()}",
                            "id",
                            context.packageName
                    ),
                    pendingIntent
            )
        }

        // Build and issue the notification
        val notification =
                NotificationCompat.Builder(context, "income_expense_channel")
                        .setSmallIcon(R.drawable.logo)
                        .setStyle(NotificationCompat.DecoratedCustomViewStyle())
                        .setCustomContentView(notificationLayout)
                        .setPriority(NotificationCompat.PRIORITY_HIGH)
                        .build()

        notificationManager.notify(2, notification)
    }
}
