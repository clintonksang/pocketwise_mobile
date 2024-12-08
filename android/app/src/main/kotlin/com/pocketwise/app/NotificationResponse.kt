// package com.pocketwise.app

// import android.os.Bundle
// import androidx.appcompat.app.AppCompatActivity
// import android.util.Log
// import android.content.Intent
// import android.widget.Button
// import android.widget.TextView

// class NotificationResponse : AppCompatActivity() {
//     override fun onCreate(savedInstanceState: Bundle?) {
//         super.onCreate(savedInstanceState)
//         setContentView(R.layout.activity_notification_response)

//         // Setup buttons
//         val buttonNeeds = findViewById<Button>(R.id.button_needs)
//         val buttonWants = findViewById<Button>(R.id.button_wants)
//         val buttonSavings = findViewById<Button>(R.id.button_savings)
//         val buttonDebt = findViewById<Button>(R.id.button_debt)

//         // Setup button click listeners
//         buttonNeeds.setOnClickListener { logSelection("Needs",) }
//         buttonWants.setOnClickListener { logSelection("Wants") }
//         buttonSavings.setOnClickListener { logSelection("Savings / Investments") }
//         buttonDebt.setOnClickListener {
//             Log.d("NotificationResponse", "Debt button clicked")
//             logSelection("Debt")
//         }
        

//         // Extract data from intent
//         intent.extras?.let { bundle ->
//             val action = bundle.getString("action", "No action")
//             val amount = bundle.getString("amount", "No amount")
//             val sender = bundle.getString("sender", "No sender")

//             // Update UI or log the details to Logcat
//             Log.d("NotificationResponse", "Received action: $action, Amount: $amount, Sender: $sender")
//             cancelNotification(notificationId)
//             // Optionally, update a TextView or other UI element to display these details
//             val senderText = sender.split(" ").take(2).joinToString(" ")
//             findViewById<TextView>(R.id.textViewResponse)?.text = "Amount: $amount\nSender: $senderText"
//         }
//     }

//     private fun logSelection(category: String , notificationId: Int) {
//         Log.d("NotificationResponse", "Selected category: $category")
//         // Optionally close the activity if desired
//         finish()
//     }

//     private fun cancelNotification(notificationId: Int) {
//         val notificationManager: NotificationManager =
//             getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
//         notificationManager.cancel(notificationId) // Cancel the notification
//     }
// }
package com.pocketwise.app


import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import android.util.Log
import android.content.Intent
import android.widget.Button
import android.app.NotificationManager
import android.content.Context

class NotificationResponse : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_notification_response)

        val buttonNeeds = findViewById<Button>(R.id.button_needs)
        val buttonWants = findViewById<Button>(R.id.button_wants)
        val buttonSavings = findViewById<Button>(R.id.button_savings)
        val buttonDebt = findViewById<Button>(R.id.button_debt)

        // Here we're assuming a notificationId for the example. This should come from your Intent or be predefined.
        val notificationId = 1 // You might want to dynamically assign this based on the intent or another source.

        buttonNeeds.setOnClickListener { logSelection("Needs", notificationId) }
        buttonWants.setOnClickListener { logSelection("Wants", notificationId) }
        buttonSavings.setOnClickListener { logSelection("Savings / Investments", notificationId) }
        buttonDebt.setOnClickListener { logSelection("Debt", notificationId) }
    }

    private fun logSelection(category: String, notificationId: Int) {
        Log.d("NotificationResponse", "Selected category: $category")
        cancelNotification(notificationId)
        finish() // Close the activity after selection
    }

    private fun cancelNotification(notificationId: Int) {
        val notificationManager: NotificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.cancel(notificationId) // Cancel the notification
    }
}
