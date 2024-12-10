import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:pocketwise/models/budget.model.dart';
import 'package:pocketwise/models/categories.model.dart';
import 'package:pocketwise/models/pocket.model.dart';
import 'package:pocketwise/presentation/authentication/phonescreen.dart';
import 'package:pocketwise/presentation/launcherpage.dart';
import 'package:pocketwise/presentation/pockets/add_expense.dart';
import 'package:pocketwise/presentation/pockets/view_expense.dart';
import 'package:pocketwise/utils/widgets/pockets/budget/view_budget.dart';
import '../presentation/authentication/EnterKYCscreen.dart';
import '../presentation/authentication/OTPScreen.dart';
import '../presentation/authentication/login.dart';
import '../presentation/pockets/add_income.dart';
import '../presentation/pockets/pockets.dart';
import '../presentation/pagemanager.dart';
import '../presentation/splash.dart';
import '../utils/widgets/pockets/viewPockets.dart';

class AppRouter {
  static const String initial = "/";
  static const String add_income = "/addIncome";
  static const String viewPocket = "/viewPocket";
  static const String viewCategory = "/viewCategory";
  static const String viewBudget = "/viewBudget";
  static const String addExpense = "/addExpense";
  static const String phone = "/phone";
  static const String login = "/login";
  static const String otpscreen = "/otpscreen";
  static const String kycpage = "/kycpage";
  static const String pagemanager = "/pagemanager";


  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    Logger logger = Logger();
    logger.w("Route Name:\n${settings.name}");

    switch (settings.name) {
      case initial:
        return _slideRoute(Launcher());
      case pagemanager:
        return _slideRoute(PageManager());
      case phone:
        return _slideRoute(PhoneScreen());
      case login:
        return _slideRoute(Login());
    
      case otpscreen:
      return _slideRoute(OtpScreen());
      case kycpage:
      return _slideRoute(EnterKYCPage());
      case add_income:
        return _slideRoute(AddIncome());
      case viewPocket:
        return _slideRoute(ViewPockets( 
          args: args as PocketModel, 
        ));
      case viewCategory:
        return _slideRoute(ViewExpense( 
          categoriesModel: args as CategoriesModel, 
        ));

         case viewBudget:
        return _slideRoute(ViewBudget( 
          categoriesModel: args as BudgetModel, 
        ));
        case addExpense:
        return _slideRoute(
          AddExpense( 
          // categoriesModel: args as CategoriesModel,
        ));
        
      default:
        return _slideRoute(PageManager()); // Fallback to initial route
    }
  }

  static Route _slideRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  static void pop(BuildContext context) {
    Navigator.pop(context);
  }
}