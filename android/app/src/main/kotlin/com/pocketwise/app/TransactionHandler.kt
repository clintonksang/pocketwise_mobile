package com.pocketwise.app

import android.app.NotificationManager
import android.content.Context
import android.content.SharedPreferences
import android.util.Log
import androidx.core.app.NotificationCompat
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class TransactionHandler(private val context: Context) {
    private val sharedPreferences: SharedPreferences =
            context.getSharedPreferences(
                    "AppPreferences",
                    Context.MODE_PRIVATE
            )
    private val notificationHandler = NotificationHandler(context)
    private val categorySuggester = CategorySuggester(context)

    // Define regex patterns to parse messages
    private val incomePattern = Regex("You have received Ksh(\\d+\\.\\d{2}) from ([^\\.]+)\\.")
    private val expensePattern = Regex("Ksh([\\d,]+\\.[\\d]{2}) (paid to|sent to) ([^\\s]+(?:\\s+[^\\s]+)*)")

    // Checks if the user ID exists and returns it or null
    private fun getUserId(): String? {
        val userId = sharedPreferences.getString("userId", null)
        Log.d("TransactionHandler", "Retrieved User ID: $userId")
        return userId
    }

    // Shows notification prompting user registration if the user ID is missing
    private fun showRegistrationNeededNotification() {
        val notification =
                NotificationCompat.Builder(context, "income_expense_channel")
                        .setSmallIcon(R.drawable.logo)
                        .setContentTitle("Join Pocketwise")
                        .setContentText("Track your income and expenses with Pocketwise. Join now!")
                        .setPriority(NotificationCompat.PRIORITY_HIGH)
                        .build()

        val notificationManager: NotificationManager =
                context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.notify(
                3,
                notification
        )
    }

    fun handleTransactionMessage(message: String) {
        val userId = getUserId()
        if (userId.isNullOrEmpty()) {
            Log.d("TransactionHandler", "User ID is null or empty")
            showRegistrationNeededNotification()
            return
        }

        Log.d("TransactionHandler", "=== Processing message ===")
        Log.d("TransactionHandler", "Message: $message")

        // Process the message for transactions
        val incomeMatchResult = incomePattern.find(message)
        val expenseMatchResult = expensePattern.find(message)

        when {
            incomeMatchResult != null -> handleIncome(incomeMatchResult, userId)
            expenseMatchResult != null -> handleExpense(message, userId)
            else -> Log.d("TransactionHandler", "No transaction pattern matched in message")
        }
    }

    private fun handleIncome(result: MatchResult, userId: String) {
        val amount = result.groupValues[1]
        val sender = result.groupValues[2].trim()
        Log.d(
                "TransactionHandler",
                "Income Received: Amount: $amount, From: $sender, User ID: $userId"
        )
        saveToSharedPreferences("Income: $amount from $sender")
        notificationHandler.showIncomeNotification(
                amount,
                sender,
                "Would you like to add ${amount} to income?"
        )
    }

    private fun handleExpense(message: String, userId: String) {
        Log.d("TransactionHandler", "=== Starting handleExpense ===")
        Log.d("TransactionHandler", "Full Message: $message")
        Log.d("TransactionHandler", "User ID: $userId")

        // Launch coroutine for AI processing
        CoroutineScope(Dispatchers.Main).launch {
            try {
                Log.d("TransactionHandler", "=== Starting AI processing ===")
                val (amount, merchant, categories) = categorySuggester.processTransactionMessage(message)
                
                Log.d("TransactionHandler", "=== AI processing complete ===")
                Log.d("TransactionHandler", "Amount: $amount")
                Log.d("TransactionHandler", "Merchant: $merchant")
                Log.d("TransactionHandler", "Categories: $categories")
                
                saveToSharedPreferences("Expense: $amount to $merchant")
                
                Log.d("TransactionHandler", "=== Showing notification ===")
                notificationHandler.showExpenseNotification(
                    amount = amount,
                    sender = merchant,
                    message = message,
                    categories = categories
                )
            } catch (e: Exception) {
                Log.e("TransactionHandler", "=== Error in handleExpense ===")
                Log.e("TransactionHandler", "Error details: ${e.message}")
                Log.e("TransactionHandler", "Stack trace: ${e.stackTraceToString()}")
                // Fallback to showing notification with default categories
                notificationHandler.showExpenseNotification(
                    amount = "0.00",
                    sender = "Unknown Merchant",
                    message = message
                )
            }
        }
    }

    private fun saveToSharedPreferences(transactionDetail: String) {
        sharedPreferences.edit().putString("latest_transaction", transactionDetail).apply()
        Log.d("TransactionHandler", "Transaction saved to SharedPreferences: $transactionDetail")
    }
}
