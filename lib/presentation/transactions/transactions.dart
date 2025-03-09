import 'package:flutter/material.dart';
import 'package:pocketwise/presentation/transactions/chart.dart';

import '../../utils/constants/textutil.dart';
import '../../utils/constants/colors.dart';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TransactionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text('Transactions',
              style: AppTextStyles.normal.copyWith(color: white)),
          automaticallyImplyLeading: false,
        ),
        body: BarChartSample2());
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
        subtitle:
            Text(date, style: TextStyle(fontSize: 14, color: Colors.grey)),
        trailing: Text(amount,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
