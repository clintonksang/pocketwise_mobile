import 'package:flutter/material.dart';
import 'package:pockets/utils/constants/colors.dart';

class Expensecard extends StatelessWidget {
  const Expensecard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Container(
          color: white,
          child: Text('ola'),
        ),
      ),
    );
  }
}