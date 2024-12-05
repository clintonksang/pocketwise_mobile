import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pockets/utils/constants/defaultPadding.dart';
import 'package:pockets/utils/constants/textutil.dart';
import 'package:pockets/utils/widgets/pockets/cardButtons.dart';

import '../../constants/colors.dart';

class PocketsCard extends StatelessWidget {
  String cardTitle;
  String amount;
  String currency;
  String date;
  String fundedStatus;
  String category;
  Color categoryColor;
    PocketsCard({
    required this.cardTitle,
    required this.amount,
    required this.date,
    required this.fundedStatus,
    required this.currency,
    required this.category,
    required this.categoryColor,
    super.key});
  
   @override
   Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width * .3,
      decoration: ShapeDecoration(
        color: containerColors,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(cardTitle).normal()),
                  
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        
                      Align(
                        alignment: Alignment.topRight,
                      
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '$amount',
                                    style: AppTextStyles.normal.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: ' $currency',
                                    style: AppTextStyles.normal,
                                  ),
                                ],
                              ),
                            ),
                          ),
                           Text(
                             fundedStatus, 
                             
                             style: AppTextStyles.smallLight.copyWith(
                             
                             
                             color: fundedStatus =="funded" ? greencolor : fundedStatus =="unfunded"  ? red : fundedStatus=="payment" ? primaryColor : Colors.black,
                             textBaseline: TextBaseline.ideographic
                           ),),
                    ],
                  ),
                ],
              ),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 CardButtons(
                  cardColor: categoryColor,
                  text: category,
                  small: true,
                 ),

                  Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            date, style: AppTextStyles.smallLight.copyWith(
                            
                            
                            color: secondaryColor,
                            
                          ),)
                          ),
               ],
             )
            ]
            ),
      ),
    );
  }
}
