package com.pocketwise.app

import android.content.Context
import android.content.SharedPreferences
import android.util.Log

class TransactionHandler(private val context: Context) {
    private val sharedPreferences: SharedPreferences =
            context.getSharedPreferences("TransactionPrefs", Context.MODE_PRIVATE)
    private val notificationHandler = NotificationHandler(context)

    private val incomePattern = Regex("You have received Ksh(\\d+\\.\\d{2}) from ([^\\.]+)\\.")
    private val expensePattern = Regex("Ksh(\\d+\\.\\d{2}) (paid to|sent to) ([^\\.]+)\\.")

    fun handleTransactionMessage(message: String) {
        val incomeMatchResult = incomePattern.find(message)
        val expenseMatchResult = expensePattern.find(message)

        Log.d("TransactionHandler Initialized", "Message: $message")
        when {
            incomeMatchResult != null -> {
                val amount = incomeMatchResult.groupValues[1]
                val sender = incomeMatchResult.groupValues[2].trim()
                Log.d("TransactionHandler", "Income Received: Amount: $amount, From: $sender")
                saveToSharedPreferences("Income: $amount from $sender")
                notificationHandler.showIncomeNotification(
                        amount,
                        sender,
                        "Would you like to add ${amount} to income?"
                )
            }
            expenseMatchResult != null -> {
                val amount = expenseMatchResult.groupValues[1]
                val recipient = expenseMatchResult.groupValues[3].trim()
                Log.d("TransactionHandler", "Expense: Amount: $amount, To: $recipient")
                saveToSharedPreferences("Expense: $amount to $recipient")
                notificationHandler.showExpenseNotification(
                        amount,
                        recipient,
                        "Add KSH $amount expense to which category?"
                )
            }
            else -> Log.d("TransactionHandler", "No transaction detected in message")
        }
    }

    private fun saveToSharedPreferences(transactionDetail: String) {
        sharedPreferences.edit().putString("latest_transaction", transactionDetail).apply()
        Log.d("TransactionHandler", "Transaction saved to SharedPreferences: $transactionDetail")
    }
}
