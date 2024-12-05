import 'dart:math';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:pockets/utils/constants/colors.dart';
import 'package:pockets/utils/constants/limits.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/budget.model.dart';
import '../provider/income_provider.dart';

class BudgetRepository with ChangeNotifier {
  List<BudgetCategory> _categories = [];

  // Singleton pattern to maintain state across the app
  static final BudgetRepository _instance = BudgetRepository._internal();

  factory BudgetRepository() {
    return _instance;
  }

  BudgetRepository._internal() {
    loadPreferences();
  }
Future<void> loadPreferences() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  List<BudgetCategory> loadedCategories = [];

  var categoriesInfo = {
    'needs': {'limitRate': needsLimitRate, 'color': needsColor},
    'wants': {'limitRate': wantsLimitRate, 'color': wantsColor},
    'savings': {'limitRate': savingsLimitRate, 'color': sandicolor},
    'debt': {'limitRate': debtLimitRate, 'color': debtColor},
  };

  categoriesInfo.forEach((key, value) {
    // Safely cast the values from SharedPreferences to double and handle possible nulls
    double rate = (prefs.getDouble('${key}Rate') ?? value['limitRate']) as double;
    double amount = (prefs.getDouble('${key}Amount') ?? updateLimitAmounts(IncomeProvider().getTotalIncome(), rate)) as double;
    
    loadedCategories.add(BudgetCategory(
      title: capitalizeFirstLetter(key),
      type: key,
      limitRate: rate,
      limitAmount: amount,
      BudgetCategoryColor: value['color']as Color,
    ));
  });

  if (loadedCategories.isNotEmpty) {
    _categories = loadedCategories;
    notifyListeners();
  }
}


  Future<void> savePreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var category in _categories) {
      await prefs.setDouble('${category.type}Rate', category.limitRate);
      await prefs.setDouble('${category.type}Amount', category.limitAmount);
    }
  }

  void initializeIfNeeded(BuildContext context) {
    final incomeProvider = Provider.of<IncomeProvider>(context, listen: false);

    if (_categories.isEmpty) {
      loadPreferences().then((_) {
        if (_categories.isEmpty) { // If still empty after load attempt
          initializeCategories(incomeProvider.getTotalIncome(), context);
          Logger().i('Categories initialized with new income values $_categories');
        } else {
          Logger().i('Categories loaded from SharedPreferences $_categories');
        }
      });
    }
  }

  void initializeCategories(double income, BuildContext context) {
    Logger().i('initializeCategories called with income: $income');
    _categories = [
      BudgetCategory(
        title: 'Needs',
        type: 'needs',
        limitRate: needsLimitRate,
        limitAmount: updateLimitAmounts(income, needsLimitRate),
        BudgetCategoryColor: needsColor
      ),
      BudgetCategory(
        title: 'Wants',
        type: 'wants',
        limitRate: wantsLimitRate,
        limitAmount: updateLimitAmounts(income, wantsLimitRate),
        BudgetCategoryColor: wantsColor
      ),
      BudgetCategory(
        title: 'Savings',
        type: 'savings',
        limitRate: savingsLimitRate,
        limitAmount: updateLimitAmounts(income, savingsLimitRate),
        BudgetCategoryColor: sandicolor
      ),
      BudgetCategory(
        title: 'Debt',
        type: 'debt',
        limitRate: debtLimitRate,
        limitAmount: updateLimitAmounts(income, debtLimitRate),
        BudgetCategoryColor: debtColor
      )
    ];
    savePreferences();
    notifyListeners();
  }

  double updateLimitAmounts(double totalIncome, double rate) {
    return double.parse((totalIncome * rate / 100).toStringAsFixed(1));
  }

  void updateCategoryLimitAndRate(String type, double newLimit, BuildContext context) {
    final incomeProvider = Provider.of<IncomeProvider>(context, listen: false);
    double totalIncome = incomeProvider.getTotalIncome();
    int categoryIndex = _categories.indexWhere((category) => category.type == type);
    if (categoryIndex == -1) return;

    double newRate = double.parse((newLimit / totalIncome * 100).toStringAsFixed(1));
    double oldRate = _categories[categoryIndex].limitRate;

    _categories[categoryIndex].limitRate = newRate;
    _categories[categoryIndex].limitAmount = newLimit;

    redistributeRates(categoryIndex, newRate - oldRate, totalIncome);
  }

  void redistributeRates(int excludedIndex, double rateDifference, double totalIncome) {
    double adjustmentPerCategory = -rateDifference / (_categories.length - 1);
    for (int i = 0; i < _categories.length; i++) {
      if (i != excludedIndex) {
        double newRate = _categories[i].limitRate + adjustmentPerCategory;
        _categories[i].limitRate = max(5.0, min(newRate, 95.0));
        _categories[i].limitAmount = updateLimitAmounts(totalIncome, _categories[i].limitRate);
      }
    }
    normalizeRates(excludedIndex, totalIncome);
  }

  void normalizeRates(int excludedIndex, double totalIncome) {
    double totalRate = 0;
    _categories.forEach((category) => totalRate += category.limitRate);
    if (totalRate != 100) {
      double adjustment = (100 - totalRate) / (_categories.length - 1);
      _categories.asMap().forEach((i, category) {
        if (i != excludedIndex) {
          category.limitRate += adjustment;
          category.limitAmount = updateLimitAmounts(totalIncome, category.limitRate);
        }
      });
    }
    notifyListeners();
  }

  List<BudgetCategory> get categories => _categories;

  BudgetCategory? getBudgetCategoryByType(String type) {
    return _categories.firstWhere(
      (category) => category.type == type,
      orElse: () => BudgetCategory(
        title: '',
        type: '',
        limitRate: 0,
        limitAmount: 0,
        BudgetCategoryColor: primaryColor
      )
    );
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1);
  }
}

class BudgetLimits extends ChangeNotifier {
  static double needsLimitRate = 50.0;
  static double wantsLimitRate = 30.0;
  static double savingsLimitRate = 10.0;
  static double debtLimitRate = 10.0;

  static void updateLimitRates({
    required double needs,
    required double wants,
    required double savings,
    required double debt,
  }) {
    needsLimitRate = needs;
    wantsLimitRate = wants;
    savingsLimitRate = savings;
    debtLimitRate = debt;
  }
}
