package com.pocketwise.app

import android.app.NotificationManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class ExpenseNotificationAction : BroadcastReceiver() {
    private val saveToFirebase = SaveToFirebase()

    override fun onReceive(context: Context, intent: Intent) {
        Log.d("ExpenseNotificationAction", "=== Received expense notification action ===")
        Log.d("ExpenseNotificationAction", "Action: ${intent.action}")

        val amount = intent.getStringExtra("amount")
        val merchant = intent.getStringExtra("merchant")
        val message = intent.getStringExtra("message")
        val category = intent.getStringExtra("category")  // Get the AI-suggested category
        val userId = context.getSharedPreferences("AppPreferences", Context.MODE_PRIVATE)
            .getString("userId", null)

        Log.d("ExpenseNotificationAction", "Amount: $amount")
        Log.d("ExpenseNotificationAction", "Merchant: $merchant")
        Log.d("ExpenseNotificationAction", "Category: $category")
        Log.d("ExpenseNotificationAction", "User ID: $userId")

        if (userId != null && category != null) {
            // Create transaction data matching the structure in transactions.dart
            val transaction = mapOf<String, Any>(
                "amount" to (amount ?: ""),
                "category" to category,
                "dateCreated" to SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(Date()),
                "hasAdded" to true,
                "sender" to (merchant ?: ""),
                "type" to "expense",
                "userId" to userId
            )

            // Save to Firebase
            saveToFirebase.saveExpense(transaction)
            Log.d("ExpenseNotificationAction", "Transaction saved to Firebase with category: $category")
        } else {
            Log.e("ExpenseNotificationAction", "Missing required data: userId=${userId != null}, category=${category != null}")
        }

        // Dismiss the notification
        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.cancel(2)
    }
}
