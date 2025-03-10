import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:pocketwise/utils/DOCREFERENCE.DART';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expensecardmodel.dart';
import 'package:intl/intl.dart';

class ExpenseRepository {
  static const String CACHE_KEY_EXPENSES = 'cached_expenses';
  static const String CACHE_TIMESTAMP_KEY = 'expenses_cache_timestamp';
  static const Duration CACHE_DURATION = Duration(minutes: 30);

  ExpenseRepository() {
    _calculateTotalExpense();
  }

  final StreamController<double> _expenseStreamController =
      StreamController.broadcast();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<double> get expenseStream => _expenseStreamController.stream;

  Future<void> _saveToCache(List<ExpenseModel> expenses) async {
    final prefs = await SharedPreferences.getInstance();
    final expensesJson = json.encode(expenses.map((e) => e.toMap()).toList());
    await prefs.setString(CACHE_KEY_EXPENSES, expensesJson);
    await prefs.setInt(
        CACHE_TIMESTAMP_KEY, DateTime.now().millisecondsSinceEpoch);
  }

  Future<List<ExpenseModel>?> _getFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(CACHE_TIMESTAMP_KEY);
    final cachedData = prefs.getString(CACHE_KEY_EXPENSES);

    if (timestamp != null && cachedData != null) {
      final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;
      if (cacheAge < CACHE_DURATION.inMilliseconds) {
        try {
          final List<dynamic> decoded = json.decode(cachedData);
          return decoded.map((e) => ExpenseModel.fromMap(e)).toList();
        } catch (e) {
          Logger().e('Error parsing cached expenses: $e');
          return null;
        }
      }
    }
    return null;
  }

  Future<void> saveTransaction(ExpenseModel transaction) async {
    await saveExpensestoFirebase(transaction);

    // Update cache
    final currentExpenses = await getAllTransactions();
    currentExpenses.add(transaction);
    await _saveToCache(currentExpenses);

    _calculateTotalExpense();
  }

  Future<void> saveExpensestoFirebase(ExpenseModel expenseModel) async {
    final prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('phone') ?? '';
    final now = DateTime.now();
    final formattedDate = DateFormat("yyyy-MM-dd HH:mm:ss").format(now);

    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('expenses')
          .doc(generateDocReference())
          .set({
        "type": "expense",
        "amount": expenseModel.amount,
        "category": expenseModel.category,
        "dateCreated": formattedDate,
        "hasAdded": true,
        "sender": expenseModel.sender,
        "userId": userId,
      });
      Logger().i('Expense saved to firebase');
    } catch (e) {
      Logger().e('Error saving expense to firebase: $e');
    }
  }

  Future<List<ExpenseModel>> getAllTransactions() async {
    // Try to get from cache first
    final cachedExpenses = await _getFromCache();
    if (cachedExpenses != null) {
      Logger().i('Returning expenses from cache');
      return cachedExpenses;
    }

    // If cache miss or expired, fetch from Firebase
    Logger().i('Cache miss or expired, fetching from Firebase');
    final prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('phone') ?? '';

    if (userId != null && userId.isNotEmpty) {
      try {
        final QuerySnapshot snapshot = await _firestore
            .collection('users')
            .doc(userId)
            .collection('expenses')
            .get();

        final List<ExpenseModel> transactions = snapshot.docs.map((doc) {
          return ExpenseModel.fromMap(doc.data() as Map<String, dynamic>);
        }).toList();

        // Update cache with new data
        await _saveToCache(transactions);
        return transactions;
      } catch (e) {
        Logger().e('Error fetching expenses from Firebase: $e');
        return [];
      }
    }
    return [];
  }

  Future<void> refreshTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(CACHE_KEY_EXPENSES);
    await prefs.remove(CACHE_TIMESTAMP_KEY);
    await getAllTransactions(); // This will fetch fresh data and update cache
  }

  // Get transactions sorted by date
  Future<List<ExpenseModel>> getTransactionsSortedByDate() async {
    final List<ExpenseModel> transactions = await getAllTransactions();
    transactions.sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
    return transactions;
  }

  Future<double> getTotalByPocket(String pocket) async {
    final List<ExpenseModel> transactions =
        await getTransactionsByPocket(pocket);
    return transactions.fold(
        0.0,
        (sum, transaction) =>
            double.parse(sum.toString()) + double.parse(transaction.amount));
  }

  // Get transactions by pocket
  Future<List<ExpenseModel>> getTransactionsByPocket(String pocket) async {
    final List<ExpenseModel> transactions = await getAllTransactions();
    return transactions
        .where((transaction) => transaction.sender == pocket)
        .toList();
  }

  // Calculate the total expense and add to stream
  Future<void> _calculateTotalExpense() async {
    double totalExpense = await getTotalExpense();
    _expenseStreamController.add(totalExpense);
  }

  // Get total expense
  Future<double> getTotalExpense() async {
    final List<ExpenseModel> transactions = await getAllTransactions();
    return transactions.fold(
        0.0,
        (total, transaction) =>
            double.parse(total.toString()) + double.parse(transaction.amount));
  }

  Future<double> getTotalExpenseByPocket(String pocket) async {
    final List<ExpenseModel> transactions =
        await getTransactionsByPocket(pocket);
    return transactions.fold(
        0.0,
        (sum, transaction) =>
            double.parse(sum.toString()) + double.parse(transaction.amount));
  }

  // Get transactions by month
  Future<List<ExpenseModel>> getTransactionsByMonth(DateTime month) async {
    final List<ExpenseModel> transactions = await getAllTransactions();
    final now = DateTime.now();

    return transactions.where((transaction) {
      DateTime? transactionDate;

      // Handle relative dates
      if (transaction.dateCreated.toLowerCase() == 'today') {
        transactionDate = DateTime(now.year, now.month, now.day);
      } else {
        try {
          transactionDate = DateTime.parse(transaction.dateCreated);
        } catch (e) {
          // If direct parse fails, try specific format
          try {
            final DateFormat format = DateFormat("yyyy-MM-dd HH:mm:ss");
            transactionDate = format.parse(transaction.dateCreated);
          } catch (e) {
            Logger().e('Error parsing date: ${transaction.dateCreated}');
            return false;
          }
        }
      }

      return transactionDate.year == month.year &&
          transactionDate.month == month.month;
    }).toList();
  }

  // Get transactions by date range
  Future<List<ExpenseModel>> getTransactionsByDateRange(
      DateTime startDate, DateTime endDate) async {
    final List<ExpenseModel> transactions = await getAllTransactions();
    final now = DateTime.now();

    return transactions.where((transaction) {
      DateTime? transactionDate;

      // Handle relative dates
      if (transaction.dateCreated.toLowerCase() == 'today') {
        transactionDate = DateTime(now.year, now.month, now.day);
      } else {
        try {
          transactionDate = DateTime.parse(transaction.dateCreated);
        } catch (e) {
          // If direct parse fails, try specific format
          try {
            final DateFormat format = DateFormat("yyyy-MM-dd HH:mm:ss");
            transactionDate = format.parse(transaction.dateCreated);
          } catch (e) {
            Logger().e('Error parsing date: ${transaction.dateCreated}');
            return false;
          }
        }
      }

      // Normalize dates to start of month for comparison
      final normalizedTransactionDate =
          DateTime(transactionDate.year, transactionDate.month, 1);
      final normalizedStartDate = DateTime(startDate.year, startDate.month, 1);
      final normalizedEndDate = DateTime(endDate.year, endDate.month, 1);

      return normalizedTransactionDate.isAtSameMomentAs(normalizedStartDate) ||
          normalizedTransactionDate.isAtSameMomentAs(normalizedEndDate) ||
          (normalizedTransactionDate.isAfter(normalizedStartDate) &&
              normalizedTransactionDate.isBefore(normalizedEndDate));
    }).toList();
  }

  // Get total expense by month
  Future<double> getTotalExpenseByMonth(DateTime month) async {
    final List<ExpenseModel> transactions = await getTransactionsByMonth(month);
    return transactions.fold(
        0.0,
        (total, transaction) =>
            double.parse(total.toString()) + double.parse(transaction.amount));
  }
}
