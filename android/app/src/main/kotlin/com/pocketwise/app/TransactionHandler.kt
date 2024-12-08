package com.pocketwise.app


import android.content.Context
import android.content.SharedPreferences
import android.util.Log
import java.util.regex.Pattern

class TransactionHandler(private val context: Context) {
    private val sharedPreferences: SharedPreferences = context.getSharedPreferences("TransactionPrefs", Context.MODE_PRIVATE)

    // Define the regex patterns within the class
    private val incomePattern = Regex("You have received Ksh(\\d+\\.\\d{2}) from ([^\\.]+)\\.")
    private val expensePattern = Regex("Ksh(\\d+\\.\\d{2}) (paid to|sent to) ([^\\.]+)\\.")

    fun handleTransactionMessage(message: String) {
        val incomeMatchResult = incomePattern.find(message)
        val expenseMatchResult = expensePattern.find(message)

        when {
            incomeMatchResult != null -> {
                val amount = incomeMatchResult.groupValues[1]
                val sender = incomeMatchResult.groupValues[2].trim()
                Log.d("TransactionHandler", "Income Received: Amount: $amount, From: $sender")
                saveToSharedPreferences("Income: $amount from $sender")
            }
            expenseMatchResult != null -> {
                val amount = expenseMatchResult.groupValues[1]
                val recipient = expenseMatchResult.groupValues[3].trim()
                Log.d("TransactionHandler", "Expense: Amount: $amount, To: $recipient")
                saveToSharedPreferences("Expense: $amount to $recipient")
            }
            else -> Log.d("TransactionHandler", "No transaction detected in message")
        }
    }

    private fun saveToSharedPreferences(transactionDetail: String) {
        sharedPreferences.edit().putString("latest_transaction", transactionDetail).apply()
        Log.d("TransactionHandler", "Transaction saved to SharedPreferences: $transactionDetail")
    }
    private fun initializeNotifications(){
        // case  income
//        income, amount, sender  with tw



        // case expense

//      income, amount, sender
    }
}
