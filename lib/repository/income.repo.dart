import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:pocketwise/utils/DOCREFERENCE.DART';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/income.model.dart';

class IncomeRepository {
  IncomeRepository() {
    _calculateTotalIncome();
    getAllTransactions();
  }
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String _transactionKey = 'income';
  final StreamController<double> _incomeStreamController =
      StreamController.broadcast();

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

    // save  total income to firebase(not asyncronous)
    this.saveincometoFirebase(transaction);

    print('saved items: $transactionsList');
    _calculateTotalIncome(); // Update stream with new total
  }

  Future<void> saveincometoFirebase(IncomeModel incomeModel) async {
    final prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('phone') ?? '';

    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('incomes')
          .doc(generateDocReference())
          .set({
        "type": "income",
        'amount': incomeModel.amount,
        'date': incomeModel.date,
        'sender': incomeModel.income_from,
        'category': "Income",
        'hasAdded': true,
        'userId': userId,
      });

      // .set(incomeModel.toMap());
      Logger().i('Income saved successfully!');
    } catch (e) {
      Logger().i('Error saving income: $e');
      rethrow;
    }
  }

  // Delete a transaction from the Shared Preferences list
  Future<void> deleteTransaction(String id) async {
    final prefs = await SharedPreferences.getInstance();
    String? transactionsJson = prefs.getString(_transactionKey);
    List<Map<String, dynamic>> transactionsList = [];

    if (transactionsJson != null) {
      List<dynamic> decodedList = jsonDecode(transactionsJson);
      transactionsList = decodedList.cast<Map<String, dynamic>>();
    }

    transactionsList.removeWhere((transaction) => transaction['id'] == id);

    String updatedJson = jsonEncode(transactionsList);
    await prefs.setString(_transactionKey, updatedJson);

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

    // Get income from Firebase
  }

// Clear all transactions
  Future<void> clearAllTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _transactionKey, jsonEncode([])); // Clear the stored list
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
    return transactions
        .where((transaction) => transaction.income_from == source)
        .toList();
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
    double total = transactions.fold(
        0.0,
        (total, transaction) =>
            double.parse(total.toString()) +
            double.parse(transaction.amount.toString()));
    Logger().w('total income: $total');
    return total;
  }

  Future<void> _calculateTotalIncome() async {
    double totalIncome = await getTotalIncome();
    _incomeStreamController.add(totalIncome);
  }
}
