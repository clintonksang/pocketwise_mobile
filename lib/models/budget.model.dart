
import 'package:flutter/material.dart';

class BudgetModel {
  List<BudgetCategory> categories;

  BudgetModel({required this.categories});

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    var BudgetCategoryList = json['categories'] as List;
    List<BudgetCategory> categories = BudgetCategoryList.map((i) => BudgetCategory.fromJson(i)).toList();
    return BudgetModel(categories: categories);
  }

  Map<String, dynamic> toJson() {
    return {
      'categories': categories.map((BudgetCategory) => BudgetCategory.toJson()).toList(),
    };
  }
}


class BudgetCategory {
  String type;
  String title;
  double limitRate;
  double limitAmount;
  Color BudgetCategoryColor;

  BudgetCategory({
    required this.type,
    required this.title,
    required this.limitRate,
    required this.limitAmount,
    required this.BudgetCategoryColor,
  });

  factory BudgetCategory.fromJson(Map<String, dynamic> json) {
    return BudgetCategory(
      type: json['type'],
      title: json['details']['title'] ?? '',
      limitRate: json['details']['limit_rate'] ?? 0,
      limitAmount: json['details']['limit_amount'] ?? 0,
      BudgetCategoryColor: json['details']['BudgetCategoryColor'] ?? '#FFFFFF', // Default to white if not provided
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'details': {
        'title': title,
        'limit_rate': limitRate,
        'limit_amount': limitAmount,
        'BudgetCategoryColor': BudgetCategoryColor,
      }
    };
  }
}
