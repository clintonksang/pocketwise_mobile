package com.pocketwise.app
import com.google.firebase.database.FirebaseDatabase
import android.util.Log
import com.google.firebase.firestore.FirebaseFirestore

 //Firebase firestore
 class SaveToFirebase {
     private val db = FirebaseFirestore.getInstance()

     fun saveTransaction(transaction: TransactionModel) {
         // Ensure userId is not empty
         if (transaction.userId.isNotEmpty()) {
             // Set document ID to userId
             val documentRef = db.collection("transactions").document(transaction.userId)

             // Use set() to explicitly set the document ID
             documentRef.set(transaction)
                 .addOnSuccessListener {
                     Log.d("SaveToFirebase", "Transaction saved with document ID: ${transaction.userId}")
                 }
                 .addOnFailureListener { e ->
                     Log.e("SaveToFirebase", "Error saving transaction", e)
                 }
         } else {
             Log.e("SaveToFirebase", "Invalid userId, cannot save transaction")
         }
     }
 }

//Realtime database
//class SaveToFirebase {
//    private val databaseReference = FirebaseDatabase.getInstance().getReference("transactions")
//
//    fun saveTransaction(transaction: TransactionModel) {
//        // Create a new unique ID for the transaction
//        val transactionId = databaseReference.push().key
//
//        transactionId?.let {
//            databaseReference.child(it).setValue(transaction)
//                .addOnSuccessListener {
//                    Log.d("SaveToFirebase", "Transaction saved successfully")
//                }
//                .addOnFailureListener {
//                    Log.d("SaveToFirebase", "Failed to save transaction: ${it.message}")
//                }
//        }
//    }
//}
