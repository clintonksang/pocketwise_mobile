import 'package:flutter/foundation.dart';

class ExpenseModel {
  final String id;
  final double amount;
  final String date; // Store date as String (e.g., 'yyyy-MM-dd')
  final String title;
  final String pocket;

  ExpenseModel({
    required this.id,
    required this.amount,
    required this.date,
    required this.title,
    required this.pocket,
  });

  // Convert a Transaction object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'date': date,
      'category': title,
      'pocket': pocket,
    };
  }

  // Create a Transaction from a Map
  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      id: map['id'],
      amount: map['amount'],
      date: map['date'],
      title: map['category'],
      pocket: map['pocket'],
    );
  }
}

