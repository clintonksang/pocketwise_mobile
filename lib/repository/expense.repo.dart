import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:pocketwise/utils/DOCREFERENCE.DART';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expensecardmodel.dart';
import 'package:intl/intl.dart';

class ExpenseRepository {
  ExpenseRepository() {
    _calculateTotalExpense();
  }
  static const String _transactionKey = 'transactions';
  final StreamController<double> _expenseStreamController =
      StreamController.broadcast();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
    this.saveExpensestoFirebase(transaction);
    _calculateTotalExpense();
  }

  // Get all transactions from Shared Preferences
  Future<List<ExpenseModel>> getAllTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('phone') ?? '';

    if (userId != null && userId.isNotEmpty) {
      final QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('expenses')
          .get();

      final List<ExpenseModel> transactions = snapshot.docs.map((doc) {
        return ExpenseModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      return transactions;
    } else {
      return [];
    }
    // final prefs = await SharedPreferences.getInstance();
    // String? transactionsJson = prefs.getString(_transactionKey);

    // if (transactionsJson != null) {
    //   List<dynamic> decodedList = jsonDecode(transactionsJson);
    //   return decodedList.map((item) => ExpenseModel.fromMap(item)).toList();
    // }

    // return [];
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
      Logger().e('Error saving income to firebase: $e');
    }
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
