import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pocketwise/utils/constants/colors.dart';
import 'package:pocketwise/utils/constants/defaultPadding.dart';
import 'package:pocketwise/utils/constants/textutil.dart';
import 'package:pocketwise/utils/widgets/pockets/customElevatedButton.dart';

class AuthPageManager extends StatelessWidget {
  final String pagetitle;
  final String buttontext;
  final String pagedescription;
  final VoidCallback onButtonPressed;
  final Widget? children;
  const AuthPageManager({super.key,
  required this.children,
   required this.pagetitle,required this.pagedescription   , this.buttontext = "Continue", required this.onButtonPressed});
 

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(child: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 50),
            // LOGO
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: 50,
                  height: 50,
                  child: Image.asset('assets/images/logobg.png') ,
                ),
              ),
            
            // PageText
                   SizedBox(height: 50),
              Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Align(
            alignment: Alignment.center,
            child: Text(
             pagetitle
            ).largeBold(),
          ),
                ),
           SizedBox(height: 30,),
          
              Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
             pagedescription,
            ).normal(),
          ),
                ), 
                  SizedBox(height: 50),
                 //Children
           children ?? Container(),
                   SizedBox(height: 30,),   
          Align(
            alignment: Alignment.bottomCenter,
            child: Customelevatedbutton(text: buttontext, textcolor: white, onPressed:  onButtonPressed), ),
            ],
          ),
        ),
      )),
    );
  }
}