import 'package:flutter/material.dart';
import 'package:pocketwise/models/expensecardmodel.dart';
import 'package:pocketwise/models/income.model.dart';
import 'package:pocketwise/repository/expense.repo.dart';

import '../repository/income.repo.dart';

class ExpenseProvider with ChangeNotifier {
  final ExpenseRepository _expenseRepository = ExpenseRepository();
  List<ExpenseModel> _expenses = [];

  ExpenseProvider() {
    _expenseRepository.expenseStream.listen((total) {
      notifyListeners();
      initExpenses();
    });
  }

  List<ExpenseModel> get expenses => _expenses;
  Stream<double> get totalIncomeStream => _expenseRepository.expenseStream;

  void initExpenses() async {
    _expenses = await _expenseRepository.getAllTransactions();
    notifyListeners();
  }

  void addExpense(ExpenseModel expense) async {
    await _expenseRepository.saveTransaction(expense);
  }

  void loadExpensesSortedByDate() async {
    _expenses = await _expenseRepository.getAllTransactions();
    notifyListeners();
  }

  // double getTotalIncome() {
  //   double total = 0;
  //   for (ExpenseModel income in _expenses) {
  //     total += income.amount;
  //   }
  //   return total;
  // }
}
