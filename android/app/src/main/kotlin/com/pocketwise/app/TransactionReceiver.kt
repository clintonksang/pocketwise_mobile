package com.pocketwise.app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

class TransactionReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        when (intent.action) {
            "ADD_INCOME" -> {
                val amount = intent.getStringExtra("AMOUNT") ?: "Unknown amount"
                Log.d("TransactionReceiver", "Add to Income: Amount: $amount")
                // Further handling can be done here, e.g., saving to database or updating UI via a local broadcast
            }
            "ADD_EXPENSE" -> {
                val amount = intent.getStringExtra("AMOUNT") ?: "Unknown amount"
                val category = intent.getStringExtra("CATEGORY") ?: "Unspecified category"
                Log.d("TransactionReceiver", "Categorize Expense: Amount: $amount, Category: $category")
                // Further handling can be done here, e.g., saving to database or updating UI via a local broadcast
            }
        }
    }
}
