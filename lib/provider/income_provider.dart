import 'package:flutter/material.dart';
import 'package:pockets/models/income.model.dart';

import '../repository/income.repo.dart';


class IncomeProvider with ChangeNotifier {
  final IncomeRepository _incomeRepository = IncomeRepository();
  List<IncomeModel> _incomes = [];

  IncomeProvider() {
    _incomeRepository.incomeStream.listen((total) {
      notifyListeners();
      initIncomes();
    });
  }

  List<IncomeModel> get incomes => _incomes;
  Stream<double> get totalIncomeStream => _incomeRepository.incomeStream;

  void initIncomes() async {
    _incomes = await _incomeRepository.getAllTransactions();
    notifyListeners();
  }

  void addIncome(IncomeModel income) async {
    await _incomeRepository.saveTransaction(income);
  }
    void loadIncomesSortedByDate() async {
    _incomes = await _incomeRepository.getTransactionsSortedByDate();
    notifyListeners();
  }
  void clearAllIncomes() async {
    await _incomeRepository.clearAllTransactions();
    initIncomes();  // Reload to update UI
  }
  double getTotalIncome() {
    double total = 0;
    for (IncomeModel income in _incomes) {
      total += income.amount;
    }
    return total;
  }
}

