import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocketwise/repository/income.repo.dart';
import 'package:provider/provider.dart';

import '../provider/category_provider.dart';
import '../repository/expense.repo.dart';

// Expense
ExpenseRepository expenseRepository = ExpenseRepository();
IncomeRepository incomeRepository = IncomeRepository();

class PocketWiseLogo extends StatelessWidget {
  final bool darkMode;
  const PocketWiseLogo({super.key, required this.darkMode});

  @override
  Widget build(BuildContext context) {
    return !darkMode
        ? Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 50,
              height: 50,
              child: Image.asset('assets/images/logobg.png'),
            ),
          )
        : Align(
            alignment: Alignment.topCenter,
            child: Container(
                width: 70,
                height: 70,
                child: SvgPicture.asset('assets/images/logodarkbg.svg')),
          );
  }
}
