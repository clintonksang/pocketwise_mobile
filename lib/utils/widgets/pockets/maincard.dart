import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pockets/utils/constants/textutil.dart';
import 'package:pockets/utils/widgets/pockets/cardButtons.dart';

import '../../constants/colors.dart';
import '../../functions/timeofday.dart';

class MainCard extends StatelessWidget {
  String ? titleText;
  String ? amount;
  String ? currency;
   Color ? buttomColor;
   String ? buttonText;
 
 
    MainCard({
     required this.titleText,
 
     required this.amount,
     required this.buttonText,
     required this.currency,
     required this.buttomColor ,
   
    super.key});

  @override
  Widget build(BuildContext context) {
    return   Container(
  width: MediaQuery.of(context).size.width*.442,
  height: MediaQuery.of(context).size.width*.35,
  decoration: ShapeDecoration(
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
  child: Padding(padding: EdgeInsets.all(15),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,

    children: [
      // top
    Align(
              alignment: Alignment.topLeft,
              child: Text(titleText!).normal(color: secondaryColor)),

    //  amount
    Align(
                    alignment: Alignment.topLeft,

      child: RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: '$amount',
              style: AppTextStyles.largeBold,
            ),
            TextSpan(
              text: ' $currency',
              style: AppTextStyles.normal,
            ),
          ],
        ),
      ),
    ),
    // bottom section

    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Align(
          alignment: Alignment.centerLeft,
          child: CardButtons(
            cardColor: buttomColor,
            text: buttonText!,
            small: false,
          )),
 
      ],
    ),
    ],
  ),
  ),
);
  }
}
