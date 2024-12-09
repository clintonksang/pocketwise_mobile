import 'package:flutter/material.dart';
import 'package:pockets/presentation/components/expenseCard.dart';

class ExpensePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    bool small = screenWidth < 600; 

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
         children: [
              ExpenseCard(title: '15000', date: '7th dec 2024',small: small),
              ExpenseCard(title: '20,000', date: '7th dec 2024',small: small),
         ],
          
        ),
      ),
    );
  }
}
