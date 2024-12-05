import 'package:flutter/material.dart';

class CategoriesModel {
  final String title; 
  final double total_expense;
  final double current_amount;
  final double limit_amount_rate ; 
  final Color? categoryColor;

  const CategoriesModel({
    required this.title, 
    required this.total_expense,
    required this.current_amount,
    required this.limit_amount_rate,
    required this.categoryColor
 
  });

  void add(CategoriesModel categoriesModel) {}
}
