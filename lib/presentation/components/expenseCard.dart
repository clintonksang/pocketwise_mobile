import 'package:flutter/material.dart';

class Expensecard extends StatelessWidget {
  const Expensecard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Extra Page'),
      ),
      body: Center(
        child: Text('Welcome to the Extra Page!'),
      ),
    );
  }
}