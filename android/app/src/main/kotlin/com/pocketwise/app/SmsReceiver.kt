package com.pocketwise.app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.telephony.SmsMessage

import android.util.Log

class SmsReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        val pdus = intent?.extras?.get("pdus") as Array<*>?
        val messages = pdus?.mapNotNull { pdu ->
            SmsMessage.createFromPdu(pdu as ByteArray)
        }?.map { it.messageBody }?.joinToString(separator = "\n")

        Log.d("SmsReceiver", "Received SMS: $messages")
        if (messages != null) {
            saveToSharedPreferences(context, messages)
            Log.d("SmsReceiver", "Saving to SharedPreferences initiated.")
        }
    }

    private fun saveToSharedPreferences(context: Context?, message: String) {
        val sharedPreferences = context?.getSharedPreferences("SMSStorage", Context.MODE_PRIVATE)
        sharedPreferences?.edit()?.putString("latest_sms", message)?.apply()
        Log.d("SmsReceiver", "Message saved to SharedPreferences: $message")
    }
}
