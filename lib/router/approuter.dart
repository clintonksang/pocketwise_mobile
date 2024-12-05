import 'package:flutter/material.dart';
import 'package:logger/web.dart';

import '../presentation/pockets/create_pocket.dart';
import '../presentation/pockets/pockets.dart';
import '../presentation/pagemanager.dart';
import '../presentation/splash.dart';

class AppRouter {
  static const String initial = "/";
  static const String createPocket = "/createPocket";

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    Logger logger = Logger();
    logger.w("Route Name:\n${settings.name}");

    switch (settings.name) {
      case initial:
        return _slideRoute(PageManager());
      case createPocket:
        return _slideRoute(CreatePocket());
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