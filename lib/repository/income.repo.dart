import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:pocketwise/utils/DOCREFERENCE.DART';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/income.model.dart';

class IncomeRepository {
  IncomeRepository() {
    _initializeRepository();
  }
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String _transactionKey = 'income';
  final StreamController<double> _incomeStreamController =
      StreamController.broadcast();

  // Stream for total income
  Stream<double> get incomeStream => _incomeStreamController.stream;

  // Initialize repository and calculate initial total
  Future<void> _initializeRepository() async {
    await _calculateTotalIncome();
    await getAllTransactions();
  }

  // Save a transaction to Firebase
  Future<void> saveTransaction(IncomeModel transaction) async {
    await saveincometoFirebase(transaction);
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

  // Delete a transaction from Firebase
  Future<void> deleteTransaction(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('phone') ?? '';

    if (userId != null && userId.isNotEmpty) {
      try {
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('incomes')
            .doc(id)
            .delete();
        Logger().i('Income deleted successfully!');
        _calculateTotalIncome(); // Update stream with new total
      } catch (e) {
        Logger().e('Error deleting income: $e');
        rethrow;
      }
    }
  }

  // Get all transactions from Shared Preferences
  Future<List<IncomeModel>> getAllTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('phone') ?? '';
    print('userId from prefs: $userId');
    if (userId != null && userId.isNotEmpty) {
      final QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('incomes')
          .get();

      final List<IncomeModel> transactions = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return IncomeModel(
          id: doc.id,
          amount: double.parse(data['amount'].toString()),
          date: data['date'],
          income_from: data['sender'],
        );
      }).toList();
      print('INCOME transactions: $transactions');
      return transactions;
    } else {
      return [];
    }
  }

  // Clear all transactions from Firebase
  Future<void> clearAllTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('phone') ?? '';

    if (userId != null && userId.isNotEmpty) {
      try {
        final QuerySnapshot snapshot = await _firestore
            .collection('users')
            .doc(userId)
            .collection('incomes')
            .get();

        final batch = _firestore.batch();
        snapshot.docs.forEach((doc) {
          batch.delete(doc.reference);
        });

        await batch.commit();
        Logger().i('All incomes cleared from Firebase');
        _calculateTotalIncome(); // Update the stream to reflect the new state
      } catch (e) {
        Logger().e('Error clearing incomes: $e');
        rethrow;
      }
    }
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
