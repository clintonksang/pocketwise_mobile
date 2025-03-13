package com.pocketwise.app

import java.text.SimpleDateFormat
import java.util.*
//data class TransactionModel(
//    var type: String = "",
//    var amount: String = "",
//    var sender: String = "",
//    var category: String = "",
//    var hasAdded: Boolean = false,
//    var userId: String = "",
//    var dateCreated: String = Date().time.toString()
//)


data class TransactionModel(
    var type: String = "",
    var amount: String = "",
    var sender: String = "",
    var category: String = "",
    var hasAdded: Boolean = false,
    var userId: String = "",
    var dateCreated: String = getCurrentDateTime(),
    var description: String = "" // Store the full transaction message
) {
    companion object {
        fun getCurrentDateTime(): String {
            val sdf = SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault())
            return sdf.format(Date())
        }
    }
}
