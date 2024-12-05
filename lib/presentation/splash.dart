 
import 'package:flutter/material.dart';

import '../utils/constants/colors.dart';
 
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
   

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor,
    );
  }

   
}
