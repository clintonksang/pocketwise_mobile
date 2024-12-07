import 'package:flutter/material.dart';
import 'package:pockets/utils/constants/colors.dart';

class Expensecard extends StatelessWidget {
  const Expensecard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Container(
        width: 375,
        height: 72,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)
        ),
      )
    );
  }
}