 
 import 'package:flutter/material.dart';
import 'package:pocketwise/repository/income.repo.dart';
import 'package:provider/provider.dart';

import '../provider/category_provider.dart';
import '../repository/expense.repo.dart';


// Expense 
ExpenseRepository expenseRepository = ExpenseRepository();
IncomeRepository incomeRepository = IncomeRepository();


class PocketWiseLogo extends StatelessWidget {
  const PocketWiseLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return  Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: 50,
                    height: 50,
                    child: Image.asset('assets/images/logobg.png') ,
                  ),
                );
  }
}