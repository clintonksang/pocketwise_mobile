//package com.pocketwise.app
//
//import android.content.BroadcastReceiver
//import android.content.Context
//import android.content.Intent
//import android.os.Bundle
//import android.telephony.SmsMessage
//
//class SmsReceiver : BroadcastReceiver() {
//    override fun onReceive(context: Context?, intent: Intent?) {
//        val pdus = intent?.extras?.get("pdus") as Array<*>?
//        val messages = pdus?.mapNotNull { pdu ->
//            SmsMessage.createFromPdu(pdu as ByteArray)
//        }?.map { it.messageBody }?.joinToString(separator = "\n")
//        messages?.let { MainActivity.handleSMS(it) }
//    }
//}
