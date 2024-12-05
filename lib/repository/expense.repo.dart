import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expensecardmodel.dart';

class ExpenseRepository {
  ExpenseRepository() {
    _calculateTotalExpense(); 
  }
  static const String _transactionKey = 'transactions';
  final StreamController<double> _expenseStreamController = StreamController.broadcast();

  // Stream for total expense
  Stream<double> get expenseStream => _expenseStreamController.stream;

  // Save a transaction to the Shared Preferences list
  Future<void> saveTransaction(ExpenseModel transaction) async {
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
    _calculateTotalExpense();  
  }

  // Get all transactions from Shared Preferences
  Future<List<ExpenseModel>> getAllTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    String? transactionsJson = prefs.getString(_transactionKey);

    if (transactionsJson != null) {
      List<dynamic> decodedList = jsonDecode(transactionsJson);
      return decodedList.map((item) => ExpenseModel.fromMap(item)).toList();
    }

    return [];
  }

  // Get transactions sorted by date
  Future<List<ExpenseModel>> getTransactionsSortedByDate() async {
    final List<ExpenseModel> transactions = await getAllTransactions();
    transactions.sort((a, b) => b.date.compareTo(a.date));
    return transactions;
  }

Future<double> getTotalByPocket(String pocket) async {
  final List<ExpenseModel> transactions = await getTransactionsByPocket(pocket);
  return transactions.fold(0.0, (sum, transaction) => double.parse(sum.toString()) + transaction.amount);
}

  // Get transactions by pocket
  Future<List<ExpenseModel>> getTransactionsByPocket(String pocket) async {
    final List<ExpenseModel> transactions = await getAllTransactions();
    return transactions.where((transaction) => transaction.pocket == pocket).toList();
  }

  // Get a transaction by its id
  Future<ExpenseModel?> getTransactionById(String id) async {
    final List<ExpenseModel> transactions = await getAllTransactions();
    return transactions.firstWhere(
      (transaction) => transaction.id == id,
     
    );
  }

  // Calculate the total expense and add to stream
  Future<void> _calculateTotalExpense() async {
    double totalExpense = await getTotalExpense();
    _expenseStreamController.add(totalExpense);
  }

  // Get total expense
  Future<double> getTotalExpense() async {
    final List<ExpenseModel> transactions = await getAllTransactions();
    return transactions.fold(0.0, (total, transaction) => double.parse(total.toString()) + transaction.amount);
  }


    Future<double> getTotalExpenseByPocket(String pocket) async {
    final List<ExpenseModel> transactions =
        await  getTransactionsByPocket(pocket);
    return transactions.fold(
        0.0,
        (sum, transaction) =>
            double.parse(sum.toString()) + transaction.amount);
  }
}
