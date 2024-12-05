import 'package:flutter/foundation.dart';

class IncomeModel {
  final String id;
  final double amount;
  final String date; 
  final String income_from;
 
  IncomeModel({
    required this.id,
    this.amount = 0 ,
    required this.date,
    required this.income_from,
    
  });

  // Convert a Transaction object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'date': date,
      'income_from': income_from,
     
    };
  }

  // Create a Transaction from a Map
  factory IncomeModel.fromMap(Map<String, dynamic> map) {
    return IncomeModel(
      id: map['id'],
      amount: map['amount'],
      date: map['date'],
      income_from: map['income_from'], 
    );
  }
}

