package com.pocketwise.app

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.os.Build
import android.util.Log
import android.view.View
import android.widget.RemoteViews
import androidx.core.app.NotificationCompat
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class NotificationReceiver : BroadcastReceiver() {
    private val saveToFirebase = SaveToFirebase()

    override fun onReceive(context: Context, intent: Intent) {
        Log.d("NotificationReceiver", "=== Received notification action ===")
        Log.d("NotificationReceiver", "Action: ${intent.action}")
        
        when (intent.action) {
            "CATEGORY_SELECTED" -> {
                val category = intent.getStringExtra("category")
                val amount = intent.getStringExtra("amount")
                val merchant = intent.getStringExtra("merchant")
                val message = intent.getStringExtra("message")
                val userId = context.getSharedPreferences("AppPreferences", Context.MODE_PRIVATE)
                    .getString("userId", null)
                
                Log.d("NotificationReceiver", "Category selected: $category")
                Log.d("NotificationReceiver", "Amount: $amount")
                Log.d("NotificationReceiver", "Merchant: $merchant")
                Log.d("NotificationReceiver", "User ID: $userId")
                
                if (userId != null) {
                    // Create transaction data matching the structure in transactions.dart
                    val transaction = mapOf<String, Any>(
                        "amount" to (amount ?: ""),
                        "category" to (category ?: ""),
                        "dateCreated" to SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(Date()),
                        "hasAdded" to true,
                        "sender" to (merchant ?: ""),
                        "type" to "expense",
                        "userId" to userId
                    )

                    // Save to Firebase
                    saveToFirebase.saveExpense(transaction)
                    Log.d("NotificationReceiver", "Transaction saved to Firebase with category: $category")

                    // Dismiss the notification
                    val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                    notificationManager.cancelAll()  // This will dismiss all notifications
                    Log.d("NotificationReceiver", "Notification dismissed after saving transaction")
                } else {
                    Log.e("NotificationReceiver", "No user ID found")
                }
            }
        }
    }
}

class NotificationHandler(private val context: Context) {
    private val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
    private val channelId = "income_expense_channel"
    private val notificationId = 1
    private val categorySuggester = CategorySuggester(context)

    init {
        createNotificationChannel()
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                channelId,
                "Income and Expense Notifications",
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = "Notifications for income and expense transactions"
                enableVibration(true)
                enableLights(true)
                lightColor = Color.BLUE
            }
            notificationManager.createNotificationChannel(channel)
        }
    }

    fun showIncomeNotification(amount: String, sender: String, message: String) {
        val notification = NotificationCompat.Builder(context, channelId)
            .setSmallIcon(R.drawable.logo)
            .setContentTitle("Income Received")
            .setContentText("Ksh$amount from $sender")
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setAutoCancel(true)
            .build()

        notificationManager.notify(notificationId, notification)
    }

    fun showExpenseNotification(amount: String, sender: String, message: String, categories: List<String> = listOf()) {
        Log.d("NotificationHandler", "=== Showing expense notification ===")
        Log.d("NotificationHandler", "Amount: $amount")
        Log.d("NotificationHandler", "Sender: $sender")
        Log.d("NotificationHandler", "Categories: $categories")

        val notificationId = System.currentTimeMillis().toInt()
        
        // Create the notification layout
        val remoteViews = RemoteViews(context.packageName, R.layout.notification_expense_dynamic)
        
        // Set the text values
        remoteViews.setTextViewText(R.id.notification_title, "New Expense")
        remoteViews.setTextViewText(R.id.notification_amount, "Ksh$amount")
        remoteViews.setTextViewText(R.id.notification_merchant, sender)

        // Create category buttons
        categories.take(3).forEachIndexed { index, category ->
            val buttonId = when (index) {
                0 -> R.id.category_button_1
                1 -> R.id.category_button_2
                2 -> R.id.category_button_3
                else -> R.id.category_button_1
            }
            
            // Set button text and make it visible
            remoteViews.setTextViewText(buttonId, category)
            remoteViews.setViewVisibility(buttonId, View.VISIBLE)
            
            // Create intent for this category
            val intent = Intent(context, NotificationReceiver::class.java).apply {
                action = "CATEGORY_SELECTED"
                putExtra("amount", amount)
                putExtra("merchant", sender)
                putExtra("message", message)
                putExtra("category", category)
            }

            val pendingIntent = PendingIntent.getBroadcast(
                context,
                index,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            // Set click listener for the button
            remoteViews.setOnClickPendingIntent(buttonId, pendingIntent)
        }

        // Hide unused buttons
        (categories.size..2).forEach { index ->
            val buttonId = when (index) {
                0 -> R.id.category_button_1
                1 -> R.id.category_button_2
                2 -> R.id.category_button_3
                else -> R.id.category_button_1
            }
            remoteViews.setViewVisibility(buttonId, View.GONE)
        }

        val notification = NotificationCompat.Builder(context, channelId)
            .setSmallIcon(R.drawable.logo)
            .setContentTitle("New Expense")
            .setContentText("Ksh$amount to $sender")
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setCustomContentView(remoteViews)
            .setStyle(NotificationCompat.DecoratedCustomViewStyle())
            .setAutoCancel(true)
            .build()

        notificationManager.notify(notificationId, notification)
        Log.d("NotificationHandler", "Notification shown with ID: $notificationId")
    }
}
