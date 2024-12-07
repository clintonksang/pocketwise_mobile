import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pocketwise/utils/constants/colors.dart';
import 'package:pocketwise/utils/constants/textutil.dart';

class CustomAppBar extends StatelessWidget {
  VoidCallback onPressed;
   CustomAppBar({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
   return Container(
      color: backgroundColor,
      width: MediaQuery.of(context).size.width,
      height: 50,
      child:GestureDetector(
        onTap: onPressed,
        child: Align(
          alignment: Alignment.centerLeft, child: Icon(Icons.arrow_back_ios)),
      ),// IconButton(onPressed: onPressed, icon: Image.asset('assets/images/arrow_back.png')),
    );
    // return AppBar(
    //   backgroundColor: backgroundColor,
    //   leading: IconButton(onPressed: onPressed, icon: Image.asset('assets/images/arrow_back.png')),
    // );
  }
}