package com.pocketwise.app

import android.app.NotificationManager
import android.content.Context
import android.content.SharedPreferences
import android.util.Log
import androidx.core.app.NotificationCompat

class TransactionHandler(private val context: Context) {
    private val sharedPreferences: SharedPreferences =
            context.getSharedPreferences(
                    "AppPreferences",
                    Context.MODE_PRIVATE
            ) // Corrected file name
    private val notificationHandler = NotificationHandler(context)

    // Define regex patterns to parse messages
    private val incomePattern = Regex("You have received Ksh(\\d+\\.\\d{2}) from ([^\\.]+)\\.")
    private val expensePattern = Regex("Ksh(\\d+\\.\\d{2}) (paid to|sent to) ([^\\.]+)\\.")

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
                        .setContentText(
                                "Register with Pocketwise to start tracking your finances effectively!"
                        )
                        .setPriority(NotificationCompat.PRIORITY_HIGH)
                        .build()

        val notificationManager: NotificationManager =
                context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.notify(
                3,
                notification
        ) // Using a different notification ID for this purpose
    }

    fun handleTransactionMessage(message: String) {
        val userId = getUserId()
        if (userId.isNullOrEmpty()) {
            Log.d("TransactionHandler", "User ID is null or empty")
            showRegistrationNeededNotification()
            return // Stop further processing if the user is not registered
        }

        // Process the message for transactions
        val incomeMatchResult = incomePattern.find(message)
        val expenseMatchResult = expensePattern.find(message)

        Log.d("TransactionHandler Initialized", "Message: $message, User ID: $userId")
        when {
            incomeMatchResult != null -> handleIncome(incomeMatchResult, userId)
            expenseMatchResult != null -> handleExpense(expenseMatchResult, userId)
            else -> Log.d("TransactionHandler", "No transaction detected in message")
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

    private fun handleExpense(result: MatchResult, userId: String) {
        val amount = result.groupValues[1]
        val recipient = result.groupValues[3].trim()
        Log.d("TransactionHandler", "Expense: Amount: $amount, To: $recipient, User ID: $userId")
        saveToSharedPreferences("Expense: $amount to $recipient")
        notificationHandler.showExpenseNotification(
                amount,
                recipient,
                "Add KSH $amount expense to which category?"
        )
    }

    private fun saveToSharedPreferences(transactionDetail: String) {
        sharedPreferences.edit().putString("latest_transaction", transactionDetail).apply()
        Log.d("TransactionHandler", "Transaction saved to SharedPreferences: $transactionDetail")
    }
}
