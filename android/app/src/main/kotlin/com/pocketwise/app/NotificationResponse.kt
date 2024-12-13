package com.pocketwise.app

import android.app.NotificationManager
import android.content.Context
import android.os.Bundle
import android.util.Log
import android.widget.Button
import androidx.appcompat.app.AppCompatActivity

class NotificationResponse : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_notification_response)

        val buttonNeeds = findViewById<Button>(R.id.button_needs)
        val buttonWants = findViewById<Button>(R.id.button_wants)
        val buttonSavings = findViewById<Button>(R.id.button_savings)
        val buttonDebt = findViewById<Button>(R.id.button_debt)

        // Here we're assuming a notificationId for the example. This should come from your Intent
        // or be predefined.
        val notificationId =
                1 // You might want to dynamically assign this based on the intent or another
        // source.

        buttonNeeds.setOnClickListener { logSelection("Needs", notificationId) }
        buttonWants.setOnClickListener { logSelection("Wants", notificationId) }
        buttonSavings.setOnClickListener { logSelection("Sav/Inv", notificationId) }
        buttonDebt.setOnClickListener { logSelection("Debt", notificationId) }
    }

    private fun logSelection(category: String, notificationId: Int) {
        Log.d("NotificationResponse", "Selected category: $category")
        cancelNotification(notificationId)
        finish() // Close the activity after selection
    }

    private fun cancelNotification(notificationId: Int) {
        val notificationManager: NotificationManager =
                getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.cancel(notificationId) // Cancel the notification
    }
}
