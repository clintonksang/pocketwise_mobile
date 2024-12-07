import 'package:flutter/material.dart';

import '../../utils/constants/textutil.dart';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

 

class TransactionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'bills',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ChoiceChip(
                  label: Text('bills'),
                  selected: true,
                ),
                ChoiceChip(
                  label: Text('food'),
                  selected: false,
                ),
                ChoiceChip(
                  label: Text('travel'),
                  selected: false,
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ChoiceChip(
                  label: Text('august'),
                  selected: false,
                ),
                ChoiceChip(
                  label: Text('last 7 days'),
                  selected: true,
                ),
                ChoiceChip(
                  label: Text('all'),
                  selected: false,
                ),
              ],
            ),
            SizedBox(height: 16),
            AspectRatio(
              aspectRatio: 1.3,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      color: Colors.blue,
                      value: 25,
                      title: '',
                      radius: 50,
                      titleStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'bills were 25% of total expenses',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  TransactionItem(title: 'rent', amount: '20,500 KES', date: 'yesterday - 8th Sept 2024'),
                  TransactionItem(title: 'water bill', amount: '3,500 KES', date: 'yesterday - 8th Sept 2024'),
                ],
              ),
            ),
          ],
        ),
      ),
 
    );
  }
}

class TransactionItem extends StatelessWidget {
  final String title;
  final String amount;
  final String date;

  const TransactionItem({
    required this.title,
    required this.amount,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(title, style: TextStyle(fontSize: 18)),
        subtitle: Text(date, style: TextStyle(fontSize: 14, color: Colors.grey)),
        trailing: Text(amount, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
