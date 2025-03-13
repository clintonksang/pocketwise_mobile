package com.pocketwise.app

import com.google.firebase.firestore.FirebaseFirestore
import android.util.Log

//  //Firebase firestore
//  class SaveToFirebase {
//      private val db = FirebaseFirestore.getInstance()

//      fun saveTransaction(transaction: TransactionModel) {
//          // Ensure userId is not empty
//          if (transaction.userId.isNotEmpty()) {
//              // Set document ID to userId
//              val documentRef = db.collection("transactions").document(transaction.userId)

//              // Use set() to explicitly set the document ID
//              documentRef.set(transaction)
//                  .addOnSuccessListener {
//                      Log.d("SaveToFirebase", "Transaction saved with document ID: ${transaction.userId}")
//                  }
//                  .addOnFailureListener { e ->
//                      Log.e("SaveToFirebase", "Error saving transaction", e)
//                  }
//          } else {
//              Log.e("SaveToFirebase", "Invalid userId, cannot save transaction")
//          }
//      }
//  }

// //Realtime database
// //class SaveToFirebase {
// //    private val databaseReference = FirebaseDatabase.getInstance().getReference("transactions")
// //
// //    fun saveTransaction(transaction: TransactionModel) {
// //        // Create a new unique ID for the transaction
// //        val transactionId = databaseReference.push().key
// //
// //        transactionId?.let {
// //            databaseReference.child(it).setValue(transaction)
// //                .addOnSuccessListener {
// //                    Log.d("SaveToFirebase", "Transaction saved successfully")
// //                }
// //                .addOnFailureListener {
// //                    Log.d("SaveToFirebase", "Failed to save transaction: ${it.message}")
// //                }
// //        }
// //    }
// //}

// Firestore-root
//     |
//     --- users (collection)
//          |
//          --- userId (document)
//               |
//               --- incomes (collection)
//               |    |
//               |    --- incomeId1 (document)
//               |    |    |-- type: "income"
//               |    |    |-- amount: "1000"
//               |    |    |-- sender: "Employer"
//               |    |    |-- category: "Salary"
//               |    |    |-- hasAdded: true
//               |    |
//               |    --- incomeId2 (document)
//               |         |-- type: "income"
//               |         |-- amount: "500"
//               |         |-- sender: "Freelancing"
//               |         |-- category: "Consulting"
//               |         |-- hasAdded: true
//               |
//               --- expenses (collection)
//                    |
//                    --- expenseId1 (document)
//                    |    |-- type: "expense"
//                    |    |-- amount: "200"
//                    |    |-- sender: "Starbucks"
//                    |    |-- category: "Food & Drinks"
//                    |    |-- hasAdded: true
//                    |
//                    --- expenseId2 (document)
//                         |-- type: "expense"
//                         |-- amount: "150"
//                         |-- sender: "Uber"
//                         |-- category: "Transport"
//                         |-- hasAdded: true


class SaveToFirebase {
    private val db = FirebaseFirestore.getInstance()

    fun saveIncome(income: TransactionModel) {
        if (income.userId.isNotEmpty()) {
            // Save to the incomes sub-collection under the specific user
            val documentRef = db.collection("users")
                                 .document(income.userId)
                                 .collection("incomes")
                                 .document()  // This generates a new unique document ID

            documentRef.set(income)
                .addOnSuccessListener {
                    Log.d("SaveToFirebase", "Income successfully saved with ID: ${documentRef.id}")
                }
                .addOnFailureListener { e ->
                    Log.e("SaveToFirebase", "Error saving income", e)
                }
        } else {
            Log.e("SaveToFirebase", "Invalid userId, cannot save income")
        }
    }

    fun saveExpense(transaction: Map<String, Any>) {
        if (transaction["userId"] != null) {
            // Save to the expenses sub-collection under the specific user
            val documentRef = db.collection("users")
                                 .document(transaction["userId"] as String)
                                 .collection("expenses")
                                 .document()  // This generates a new unique document ID

            documentRef.set(transaction)
                .addOnSuccessListener {
                    Log.d("SaveToFirebase", "Expense successfully saved with ID: ${documentRef.id}")
                }
                .addOnFailureListener { e ->
                    Log.e("SaveToFirebase", "Error saving expense", e)
                }
        } else {
            Log.e("SaveToFirebase", "Invalid userId, cannot save expense")
        }
    }
}
