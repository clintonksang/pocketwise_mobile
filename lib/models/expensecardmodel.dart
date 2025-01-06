import 'package:flutter/foundation.dart';

class ExpenseModel {
  final String amount;
  final String
      dateCreated; // Store date as String (e.g., 'yyyy-MM-dd HH:mm:ss')
  final String category;

  final bool hasAdded;
  final String sender;
  final String type;
  final String userId;

  ExpenseModel({
    required this.amount,
    required this.category,
    required this.dateCreated,
    required this.hasAdded,
    required this.sender,
    required this.type,
    required this.userId,
  });

  // Convert an ExpenseModel object to a Map
  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'dateCreated': dateCreated,
      'category': category,
      'hasAdded': hasAdded,
      'sender': sender,
      'type': type,
      'userId': userId,
    };
  }

  // Create an ExpenseModel from a Map
  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      amount: map['amount'].toString(),
      dateCreated: map['dateCreated'],
      category: map['category'],
      hasAdded: map['hasAdded'],
      sender: map['sender'],
      type: map['type'],
      userId: map['userId'],
    );
  }
}
