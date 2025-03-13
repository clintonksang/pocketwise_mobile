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
  Logger().i('Triggering immediate notification for userID: $userID');
  try {
    final String result = await platform.invokeMethod(
        'simulateExpenseSMS', {'USERID': userID, 'triggerImmediate': true});
    Logger().i('Notification triggered successfully: $result');
  } on PlatformException catch (e) {
    Logger().e('Failed to trigger notification: ${e.message}');
    Logger().e('Error details: ${e.details}');
  } catch (e) {
    Logger().e('Unexpected error triggering notification: $e');
  }
}

Future<void> clearUserIDFromNative() async {
  const platform = MethodChannel('com.pocketwise.app/simulator');
  Logger().i('Clearing user ID from native storage');
  try {
    final String result = await platform.invokeMethod('clearUserId', {});
    Logger().i('User ID cleared successfully: $result');
  } on PlatformException catch (e) {
    Logger().e('Failed to clear user ID: ${e.message}');
    Logger().e('Error details: ${e.details}');
  } catch (e) {
    Logger().e('Unexpected error clearing user ID: $e');
  }
}
