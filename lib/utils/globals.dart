import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
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

Future<void> saveUserIDToNative(String userID) async {
  const platform = MethodChannel('com.pocketwise.app/simulator');
  Logger().i('simulateExpense called with userID: $userID');
  try {
    final String result =
        await platform.invokeMethod('simulateExpenseSMS', {'USERID': userID});
    Logger().i('Native method result: $result');
  } on PlatformException catch (e) {
    Logger().e('Failed to invoke method: ${e.message}');
    Logger().e('Error details: ${e.details}');
  } catch (e) {
    Logger().e('Unexpected error: $e');
  }
}
