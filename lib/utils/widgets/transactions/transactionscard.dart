import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pockets/utils/constants/defaultPadding.dart';
import 'package:pockets/utils/constants/textutil.dart';
import 'package:pockets/utils/widgets/pockets/cardButtons.dart';

import '../../constants/colors.dart';

      // ignore: must_be_immutable
      class TransactionsCard extends StatelessWidget {
      String cardTitle;
      String amount;
      String currency;
      String date;
      String transactionType;
      TransactionsCard({
      required this.cardTitle,
      required this.amount,
      required this.date,
      required this.transactionType,
      required this.currency,
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
      children: [
      Align(
      alignment: Alignment.topRight,
      child: Text(
      transactionType, style: AppTextStyles.smallLight.copyWith(
      color: transactionType =="withdrawal" ? red : transactionType =="deposit"  ? greencolor : transactionType=="payment" ? primaryColor : Colors.black,
                            textBaseline: TextBaseline.ideographic
                          ),)
                          ),
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
                    ],
                  ),
                ],
              ),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 CardButtons(
                  cardColor: secondaryColor,
                  text: 'entertainment',
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
            ]),
      ),
    );
  }
}
