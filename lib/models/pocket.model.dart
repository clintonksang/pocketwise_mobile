import 'package:flutter/material.dart';

class PocketModel {
  final String cardTitle;
  final String target;
  final String expense;
  final String current_amount;
  final String currency;
  final String date;
  final String fundedStatus;
  final String? category;
  final Color? categoryColor;

  const PocketModel({
    required this.cardTitle,
    required this.target,
    required this.expense,
    required this.current_amount,

    required this.currency,
    required this.date,
    required this.fundedStatus,
    this.category,
    this.categoryColor,
  });
}
