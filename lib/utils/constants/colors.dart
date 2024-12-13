import 'package:flutter/material.dart';

 
  Color primaryColor =   Color(0xff7400E0);
  // MaterialStateProperty primaryColor2 =   Color(0xffFFFFFF);
  Color secondaryColor = Color.fromARGB(255, 117, 116, 116);
  Color black = Color.fromARGB(255, 0, 0, 0);

  // amber
  Color red = Color(0xffB53600);
  Color white = Colors.white;
  // orange
  Color orange = Colors.orange;

  Color backgroundColor = const Color(0xffF5F5F5);
  Color containerColors = Color.fromARGB(255, 255, 255, 255);
  Color  greencolor = const Color(0xff009A12);
  
   Color categoryColor = const Color.fromARGB(255, 0, 45, 82);
  Color debtColor = Colors.amber;
  Color sandicolor = const Color.fromARGB(255, 255, 81, 0);
  Color wantsColor = const Color.fromARGB(255, 154, 38, 175);
  Color needsColor = Color(0xff2255D9);

  final gradient = <Color>[];
 

  Color getColor(String title) {
    switch (title) {
      case "needs":
        return needsColor;
      case "wants":
        return wantsColor;
      case "debt":
        return debtColor;
      case "savings & investments":
        return sandicolor;
      default:
        return categoryColor;
    }
  }
