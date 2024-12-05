// import 'dart:async';
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../models/income.model.dart';

// class IncomeRepository {
//   static const String _transactionKey = 'income';

//   // Save a transaction to the Shared Preferences list
//   Future<void> saveTransaction(IncomeModel transaction) async {
//     final prefs = await SharedPreferences.getInstance();

//     // Get the existing transactions list (as a JSON string)
//     String? transactionsJson = prefs.getString(_transactionKey);
//     List<Map<String, dynamic>> transactionsList = [];

//     if (transactionsJson != null) {
//       List<dynamic> decodedList = jsonDecode(transactionsJson);
//       transactionsList = decodedList.cast<Map<String, dynamic>>();
//     }

//     // Add the new transaction to the list
//     transactionsList.add(transaction.toMap());

//     // Save the updated list back to Shared Preferences
//     String updatedJson = jsonEncode(transactionsList);
//     await prefs.setString(_transactionKey, updatedJson);

//     print('saved items: $transactionsList');
//   }

//   // Get all transactions from Shared Preferences
//   Future<List<IncomeModel>> getAllTransactions() async {
//     final prefs = await SharedPreferences.getInstance();
//     String? transactionsJson = prefs.getString(_transactionKey);

//     if (transactionsJson != null) {
//       List<dynamic> decodedList = jsonDecode(transactionsJson);
//       return decodedList.map((item) => IncomeModel.fromMap(item)).toList();
//     }

//     return [];
//   }

//   // Get transactions sorted by date
//   Future<List<IncomeModel>> getTransactionsSortedByDate() async {
//     final List<IncomeModel> transactions = await getAllTransactions();
//     transactions.sort((a, b) => b.date.compareTo(a.date));
//     return transactions;
//   }

//   // Get transactions by source
//   Future<List<IncomeModel>> getTransactionsBySource(String source) async {
//     final List<IncomeModel> transactions = await getAllTransactions();
//     return transactions.where((transaction) => transaction.income_from == source).toList();
//   }

//   // Get a transaction by its id
//   Future<IncomeModel?> getTransactionById(String id) async {
//     final List<IncomeModel> transactions = await getAllTransactions();
//     return transactions.firstWhere(
//       (transaction) => transaction.id == id,
//       orElse: () => IncomeModel(
//         id: '',
//         amount: 0.0,
//         date: '',
//         income_from: '',
//       ),
//     );
//   }

//   // Calculate the total income
//   Future<double> getTotalIncome() async {
//     final List<IncomeModel> transactions = await getAllTransactions();
//     return transactions.fold(0.0, (total, transaction) => double.parse(total.toString()) + double.parse(transaction.amount.toString()));
//   }
// }
import 'dart:async';
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/income.model.dart';

class IncomeRepository {
   IncomeRepository() {
    _calculateTotalIncome(); 
    getAllTransactions(); 
  }

   
  static const String _transactionKey = 'income';
  final StreamController<double> _incomeStreamController = StreamController.broadcast();

  // Stream for total income
  Stream<double> get incomeStream => _incomeStreamController.stream;

  // Save a transaction to the Shared Preferences list
  Future<void> saveTransaction(IncomeModel transaction) async {
    final prefs = await SharedPreferences.getInstance();

    // Get the existing transactions list (as a JSON string)
    String? transactionsJson = prefs.getString(_transactionKey);
    List<Map<String, dynamic>> transactionsList = [];

    if (transactionsJson != null) {
      List<dynamic> decodedList = jsonDecode(transactionsJson);
      transactionsList = decodedList.cast<Map<String, dynamic>>();
    }

    // Add the new transaction to the list
    transactionsList.add(transaction.toMap());

    // Save the updated list back to Shared Preferences
    String updatedJson = jsonEncode(transactionsList);
    await prefs.setString(_transactionKey, updatedJson);

    print('saved items: $transactionsList');
    _calculateTotalIncome(); // Update stream with new total
  }

  // Get all transactions from Shared Preferences
  Future<List<IncomeModel>> getAllTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    String? transactionsJson = prefs.getString(_transactionKey);

    if (transactionsJson != null) {
      List<dynamic> decodedList = jsonDecode(transactionsJson);
      return decodedList.map((item) => IncomeModel.fromMap(item)).toList();
    }

    return [];
  }
// Clear all transactions
Future<void> clearAllTransactions() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_transactionKey, jsonEncode([])); // Clear the stored list
  Logger().i('All incomes cleared');
  _calculateTotalIncome(); // Update the stream to reflect the new state
}

  // Get transactions sorted by date
  Future<List<IncomeModel>> getTransactionsSortedByDate() async {
    final List<IncomeModel> transactions = await getAllTransactions();
    transactions.sort((a, b) => b.date.compareTo(a.date));
    return transactions;
  }

  // Get transactions by source
  Future<List<IncomeModel>> getTransactionsBySource(String source) async {
    final List<IncomeModel> transactions = await getAllTransactions();
    return transactions.where((transaction) => transaction.income_from == source).toList();
  }

  // Get a transaction by its id
  Future<IncomeModel?> getTransactionById(String id) async {
    final List<IncomeModel> transactions = await getAllTransactions();
    return transactions.firstWhere(
      (transaction) => transaction.id == id,
      orElse: () => IncomeModel(
        id: '',
        amount: 0.0,
        date: '',
        income_from: '',
      ),
    );
  }

  // Calculate the total income
  Future<double> getTotalIncome() async {
    final List<IncomeModel> transactions = await getAllTransactions();
    double total = transactions.fold(0.0, (total, transaction) => double.parse(total.toString()) + double.parse(transaction.amount.toString()));
    Logger().w('total income: $total');
    return total;
  }

 
  Future<void> _calculateTotalIncome() async {
    double totalIncome = await getTotalIncome();
    _incomeStreamController.add(totalIncome);
  }
}
