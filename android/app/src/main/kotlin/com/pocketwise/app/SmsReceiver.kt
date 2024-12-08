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
        }

        val transactionHandler = TransactionHandler(context!!)

        messages?.forEach { sms ->
            if (sms.originatingAddress == "MPESA" || sms.originatingAddress?.contains("MPESA") == true) {
                transactionHandler.handleTransactionMessage(sms.messageBody)
            } else {
                Log.d("SmsReceiver", "SMS not from MPESA: Ignored")
            }
        }
    }
}


